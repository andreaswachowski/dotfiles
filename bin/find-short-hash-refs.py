#!/usr/bin/env python3

"""
Find commit messages that reference other commits by an abbreviated hash
shorter than 7 characters -- the minimum length git-filter-repo's own
--preserve-commit-hashes rewriter recognizes (see git-filter-repo's
`_hash_re = re.compile(br'(\\b[0-9a-f]{7,40}\\b)')`). References shorter than
that are silently left untouched by a filter-repo rewrite, which can leave
stale/dangling hash references behind.

This script is read-only: it only runs `git log` and `git merge-base
--is-ancestor`, never modifies the repository.

Approach: scan every commit message (across all refs) for 4-6 character hex
tokens, then check whether each token is actually a prefix of some earlier
commit's hash (a message can only reference a commit that already existed).
Findings are classified by how confidently they were resolved:

  unique-global     the token is unambiguous across the whole repo, even
                     ignoring time -- the strongest class of finding
  unique-by-date     multiple hashes share the prefix, but only one predates
                     the referencing commit
  unique-by-ancestry  multiple past-dated hashes share the prefix, but only
                      one is an actual ancestor of the referencing commit
  ambiguous          still couldn't narrow it down to one candidate

Tokens with no matching hash at all, or none predating the referencing
commit, are almost always false positives (issue numbers, ports, line
numbers, hex-looking English words) and are hidden unless --verbose.

Limitations: coincidental collisions (a decimal token or word like "dead"
happening to match a real earlier commit's prefix) can't be fully ruled out,
though at 4-6 hex chars over a few thousand commits this is rare, and the
printed message context lets you eyeball each hit. The temporal filter uses
committer date, which rebases/amends can in theory make non-monotonic, so
treat a token with "no past match" as a hint to check manually rather than a
guarantee it's a false positive.

Usage:
    find-short-hash-refs.py [repo] [--min-len 5] [--max-len 6] [--verbose]
"""

import argparse
import re
import subprocess
import sys
from datetime import datetime

RECORD_SEP = '\x02'
FIELD_SEP = '\x1f'
RECORD_END = '\x03'

CONFIDENT_CATEGORIES = ('unique-global', 'unique-by-date', 'unique-by-ancestry')


class Commit:
  __slots__ = ('hash', 'date', 'parents', 'message')

  def __init__(self, hash, date, parents, message):
    self.hash = hash
    self.date = date
    self.parents = parents
    self.message = message

  @property
  def subject(self):
    return self.message.split('\n', 1)[0].strip()

  @property
  def short(self):
    return self.hash[:10]


def load_commits(repo, refs):
  fmt = FIELD_SEP.join(['%H', '%cI', '%P', '%B']) + RECORD_END
  cmd = ['git', '-C', repo, 'log', '--date=iso-strict',
         '--pretty=format:' + RECORD_SEP + fmt] + list(refs)
  out = subprocess.run(cmd, capture_output=True, check=True,
                        encoding='utf-8', errors='surrogateescape').stdout
  commits = []
  for record in out.split(RECORD_SEP):
    record = record[:-1] if record.endswith(RECORD_END) else record
    if not record.strip():
      continue
    h, date_s, parents_s, message = record.split(FIELD_SEP, 3)
    commits.append(Commit(
        hash=h,
        date=datetime.fromisoformat(date_s),
        parents=parents_s.split() if parents_s else [],
        message=message,
    ))
  return commits


def is_ancestor(repo, candidate_hash, commit_hash):
  r = subprocess.run(
      ['git', '-C', repo, 'merge-base', '--is-ancestor',
       candidate_hash, commit_hash],
      capture_output=True)
  return r.returncode == 0


def classify(repo, token, commit, all_hashes, by_hash, ancestor_cache):
  candidates = [h for h in all_hashes if h.startswith(token) and h != commit.hash]
  if not candidates:
    return 'no-match', []
  if len(candidates) == 1:
    return 'unique-global', candidates

  past = [h for h in candidates if by_hash[h].date < commit.date]
  if not past:
    return 'no-past-match', candidates
  if len(past) == 1:
    return 'unique-by-date', past

  ancestors = []
  for h in past:
    key = (h, commit.hash)
    if key not in ancestor_cache:
      ancestor_cache[key] = is_ancestor(repo, h, commit.hash)
    if ancestor_cache[key]:
      ancestors.append(h)

  if len(ancestors) == 1:
    return 'unique-by-ancestry', ancestors
  return 'ambiguous', ancestors or past


def main():
  p = argparse.ArgumentParser(description=__doc__.strip().split('\n\n')[0],
                               formatter_class=argparse.RawDescriptionHelpFormatter)
  p.add_argument('repo', nargs='?', default='.',
                  help='path to the git repository (default: current directory)')
  p.add_argument('--min-len', type=int, default=5,
                  help='minimum hex token length to scan for (default: 4)')
  p.add_argument('--max-len', type=int, default=6,
                  help='maximum hex token length to scan for (default: 6; '
                       '7+ is already handled by filter-repo itself)')
  p.add_argument('--refs', nargs='*', default=['--all'],
                  help='refs to pass to "git log" (default: --all)')
  p.add_argument('--verbose', action='store_true',
                  help='also show no-match / no-past-match tokens '
                       '(usually false positives)')
  args = p.parse_args()

  hash_re = re.compile(r'\b[0-9a-f]{%d,%d}\b' % (args.min_len, args.max_len),
                        re.IGNORECASE)

  commits = load_commits(args.repo, args.refs)
  by_hash = {c.hash: c for c in commits}
  all_hashes = list(by_hash.keys())

  ancestor_cache = {}
  findings = {cat: [] for cat in
              ('unique-global', 'unique-by-date', 'unique-by-ancestry',
               'ambiguous', 'no-match', 'no-past-match')}

  for commit in commits:
    seen_tokens = set()
    for m in hash_re.finditer(commit.message):
      token = m.group(0).lower()
      if token in seen_tokens:
        continue
      seen_tokens.add(token)
      category, candidates = classify(args.repo, token, commit, all_hashes,
                                       by_hash, ancestor_cache)
      findings[category].append((commit, token, candidates))

  def print_section(title, category):
    rows = findings[category]
    if not rows:
      return
    print('=== %s (%d) ===' % (title, len(rows)))
    for commit, token, candidates in rows:
      print('%s  %s  "%s"  %s' %
            (commit.short, commit.date.date(), commit.subject, token))
      for h in candidates:
        c = by_hash[h]
        print('    -> %s  %s  "%s"' % (c.short, c.date.date(), c.subject))
    print()

  print_section('Unique across the whole repo', 'unique-global')
  print_section('Unique once filtered to commits before the reference', 'unique-by-date')
  print_section('Unique once filtered to actual ancestors', 'unique-by-ancestry')
  print_section('Ambiguous (needs manual review)', 'ambiguous')
  if args.verbose:
    print_section('No matching hash at all (likely false positive)', 'no-match')
    print_section('Matches exist but none predate the reference', 'no-past-match')

  print('--- summary ---')
  for cat in ('unique-global', 'unique-by-date', 'unique-by-ancestry',
              'ambiguous', 'no-match', 'no-past-match'):
    print('%-20s %d' % (cat, len(findings[cat])))


if __name__ == '__main__':
  try:
    main()
  except subprocess.CalledProcessError as e:
    sys.exit('git command failed: %s' % e)
