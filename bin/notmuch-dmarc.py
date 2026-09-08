#!/usr/bin/env python3
# Evaluate DMARC aggregate report attachments on messages tagged 'dmarc': push
# per-record metrics to a Prometheus Pushgateway (stdlib HTTP only — no extra
# Python package needed), then tag +trash -dmarc if every record in the report
# passed cleanly, or +dmarc-flagged -dmarc if not. A message whose report fails
# to parse keeps the 'dmarc' tag untouched so it's retried on the next run
# rather than silently disappearing. Requires `brew install parsedmarc`.
#
# Usage: notmuch-dmarc.py [-n|--dry-run]

import configparser
import email
import email.policy
import json
import shutil
import subprocess
import sys
import tempfile
import urllib.parse
import urllib.request
from pathlib import Path

CONFIG_PATH = Path.home() / ".config" / "notmuch-dmarc" / "config.ini"
ATTACHMENT_SUFFIXES = (".zip", ".gz", ".xml")


def check_available(cmd: str, hint: str = "") -> None:
    if shutil.which(cmd) is None:
        print(f"Error: {cmd} is not available. {hint}", file=sys.stderr)
        sys.exit(1)


def notmuch(*args: str) -> str:
    return subprocess.run(
        ["notmuch", *args], check=True, capture_output=True, text=True
    ).stdout


def load_pushgateway_url() -> str | None:
    if not CONFIG_PATH.exists():
        return None
    cp = configparser.ConfigParser()
    cp.read(CONFIG_PATH)
    return cp.get("dmarc", "pushgateway_url", fallback="") or None


def extract_report_attachment(eml_path: Path, dest_dir: Path) -> Path | None:
    with eml_path.open("rb") as fp:
        msg = email.parser.BytesParser(policy=email.policy.default).parse(fp)
    for part in msg.walk():
        filename = part.get_filename()
        if not filename or not filename.lower().endswith(ATTACHMENT_SUFFIXES):
            continue
        payload = part.get_payload(decode=True)
        if not payload:
            continue
        out_path = dest_dir / Path(filename).name
        out_path.write_bytes(payload)
        return out_path
    return None


def parse_with_parsedmarc(attachment: Path, work_dir: Path) -> list[dict] | None:
    result = subprocess.run(
        [
            "parsedmarc",
            "-o",
            str(work_dir),
            "--aggregate-json-filename",
            "aggregate.json",
            str(attachment),
        ],
        capture_output=True,
        text=True,
    )
    json_path = work_dir / "aggregate.json"
    if result.returncode != 0 or not json_path.exists():
        print(
            f"WARN: parsedmarc failed on {attachment.name}: {result.stderr.strip()}",
            file=sys.stderr,
        )
        return None
    return json.loads(json_path.read_text())


def is_irregular(records: list[dict]) -> bool:
    return any(
        r["policy_evaluated"]["dkim"] != "pass"
        or r["policy_evaluated"]["spf"] != "pass"
        or r["policy_evaluated"]["disposition"] != "none"
        for r in records
    )


def escape_label_value(value: str) -> str:
    return str(value).replace("\\", "\\\\").replace('"', '\\"').replace("\n", "\\n")


def push_metrics(pushgateway_url: str, report_metadata: dict, records: list[dict]) -> None:
    # Talks to the Pushgateway's plain-text exposition API directly (PUT replaces
    # the whole group, so re-pushing the same report_id is idempotent) — avoids
    # depending on the prometheus_client library for what's otherwise a one-line
    # HTTP request.
    lines = ["# TYPE dmarc_report_record_count gauge"]
    for r in records:
        pe = r["policy_evaluated"]
        labels = {
            "org_name": report_metadata.get("org_name", "unknown"),
            "source_ip": r["source"]["ip_address"],
            "disposition": pe["disposition"],
            "dkim_result": pe["dkim"],
            "spf_result": pe["spf"],
        }
        label_str = ",".join(f'{k}="{escape_label_value(v)}"' for k, v in labels.items())
        lines.append(f"dmarc_report_record_count{{{label_str}}} {r['count']}")
    body = ("\n".join(lines) + "\n").encode()

    report_id = urllib.parse.quote(str(report_metadata.get("report_id", "unknown")), safe="")
    url = f"{pushgateway_url.rstrip('/')}/metrics/job/dmarc/report_id/{report_id}"
    request = urllib.request.Request(
        url, data=body, method="PUT", headers={"Content-Type": "text/plain; version=0.0.4"}
    )
    with urllib.request.urlopen(request, timeout=10) as resp:
        resp.read()


def main() -> None:
    dry_run = len(sys.argv) > 1 and sys.argv[1] in ("-n", "--dry-run")

    check_available("notmuch", "brew install notmuch")
    check_available("parsedmarc", "brew install parsedmarc")

    pushgateway_url = load_pushgateway_url()
    if not dry_run and pushgateway_url is None:
        print(
            f"WARN: no pushgateway_url configured in {CONFIG_PATH} — skipping metrics push",
            file=sys.stderr,
        )

    message_ids = [
        line for line in notmuch("search", "--output=messages", "--", "tag:dmarc").splitlines() if line
    ]

    trashed = flagged = errored = 0
    for msg_id in message_ids:
        files = [
            line for line in notmuch("search", "--output=files", "--", msg_id).splitlines() if line
        ]
        if not files:
            continue
        eml_path = Path(files[0])

        with tempfile.TemporaryDirectory() as tmp:
            tmp_dir = Path(tmp)
            attachment = extract_report_attachment(eml_path, tmp_dir)
            if attachment is None:
                print(f"WARN: no report attachment found in {eml_path}", file=sys.stderr)
                errored += 1
                continue

            data = parse_with_parsedmarc(attachment, tmp_dir)
            if not data:
                errored += 1
                continue

            irregular = False
            for report in data:
                meta = report.get("report_metadata", {})
                records = report.get("records", [])
                if is_irregular(records):
                    irregular = True
                if pushgateway_url and not dry_run:
                    try:
                        push_metrics(pushgateway_url, meta, records)
                    except Exception as exc:  # pushgateway may be down/unreachable
                        print(
                            f"WARN: failed to push metrics for report {meta.get('report_id')}: {exc}",
                            file=sys.stderr,
                        )

        if dry_run:
            action = "+dmarc-flagged -dmarc" if irregular else "+trash -dmarc"
            print(f"Would tag {msg_id}: {action}")
            if irregular:
                flagged += 1
            else:
                trashed += 1
            continue

        if irregular:
            notmuch("tag", "+dmarc-flagged", "-dmarc", "--", msg_id)
            flagged += 1
        else:
            notmuch("tag", "+trash", "-dmarc", "--", msg_id)
            trashed += 1

    if trashed or flagged or errored:
        suffix = " (dry run — no changes made)" if dry_run else ""
        print(f"DMARC: {trashed} trashed, {flagged} flagged, {errored} error(s){suffix}")
    else:
        print("Nothing to process.")


if __name__ == "__main__":
    main()
