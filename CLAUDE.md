# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this is

This is Andreas's personal dotfiles repository, managed with [yadm](https://yadm.io/). It has
been growing since 2010 and covers bash/zsh, Neovim, tmux, mutt/notmuch email, git, and various
personal scripts across macOS and Linux (including QNAP QTS in the past). Per `README.md`, treat
this as a source of ideas rather than a clean reference implementation — it is intentionally
personal, has unmaintained corners, and relies on a private encrypted submodule for secrets.

## Critical: this is not a normal git repo at `$HOME`

`$HOME` (`/Users/andreas`) is the yadm **work tree**, but the git dir lives at
`/Users/andreas/.local/share/yadm/repo.git`, not `$HOME/.git`. Plain `git status`/`git diff` run
from `$HOME` will not work. The `yadm` CLI is not installed in this sandbox, so use plain `git`
with explicit dir flags instead:

```bash
export GIT_DIR=/Users/andreas/.local/share/yadm/repo.git
export GIT_WORK_TREE=/Users/andreas
git status
git diff -- .bashrc
git log --oneline -20
git add .config/nvim/lua/plugins/foo.lua
git commit
```

(This mirrors the repo's own `yvim` alias in `.bashrc`, which does the same trick to let Vim edit
tracked dotfiles directly.) On a machine where `yadm` *is* installed, the equivalent commands are
`yadm status`, `yadm diff`, `yadm add`, `yadm commit`, `yadm log`. Prefer the explicit `git
--git-dir/--work-tree` form here since `yadm` isn't on PATH in this environment.

Because the work tree is the whole home directory, be careful with broad operations
(`git add -A`, `git clean`) — they operate over all of `$HOME`, most of which is untracked and
should stay that way.

## yadm alternates: the `##pattern` suffix convention

Many files exist as multiple OS/host/user-specific variants, distinguished by a `##`-suffixed
pattern on the filename. yadm symlinks/copies whichever variant matches the current system to the
real dotfile path at runtime; only the suffixed source files are tracked in git. Patterns seen in
this repo:

- `##os.Darwin`, `##o.Darwin`, `##os.Linux` — OS-specific (`uname -s`). Both `os.` and `o.` forms
  appear — the codebase mixes yadm's older single-letter class syntax (`o`, `h`, `d`, `u`) with the
  newer spelled-out one (`os`, `hostname`, `distro`, `user`) from different eras of the repo. Don't
  "fix" this inconsistency without checking which yadm version is in play.
- `##h.macbook2021`, `##h.salt`, `##h.imac`, `##h.DELT-C7D1WXVK73` — hostname-specific.
- `##d.openSUSE` — Linux distro-specific.
- `##template` — rendered through yadm's Jinja2-like templating (references yadm class variables
  like OS/hostname/user), used for files with secrets or machine-specific values that shouldn't be
  committed verbatim (e.g. `.tmux.conf##template`, `.mbsyncrc##template`,
  `.config/brewfile/Brewfile##template`).
- Combined conditions with commas, e.g. `.vim/.plugs_for_dev##h.DELT-C02FN533MD6P,u.andreas.wachowski`.

When asked to change "the" config for a given tool, check whether it has multiple `##`-suffixed
variants before editing just one — the right file depends on which OS/host/user context is meant.

## Bootstrapping (`.config/yadm/bootstrap`)

Runs on `yadm bootstrap`: initializes git submodules, updates vim-plug plugins, installs Homebrew
and runs `brew bundle` from `.config/brewfile/Brewfile[.minimal]` (macOS only), installs
`rbenv-default-gems`, and finally decrypts secrets via a **custom** encrypted archive submodule
(`yadm --yadm-archive "$HOME/.local/share/yadm/archive-repo/archive" decrypt`, GPG-based) — this is
separate from yadm's built-in `encrypt`/`decrypt` mechanism (no `.config/yadm/encrypt` file exists
here). That archive repo and `.config/git/identities` (included from `.config/git/config`) are
private submodules not present in every checkout — missing includes/files under those paths are
expected, not broken.

## Submodules

Tracked via `.gitmodules`: tmux plugins (`tpm`, `tmux-resurrect`, `tmux-continuum`,
`tmux-battery`, `tmux-gruvbox`), `rbenv-default-gems`, `.vim/pack/thirdparty/start/vimoutliner`,
`bin/remarkable`, and full upstream source clones under `local/src/{vim,neomutt,alt}` (used to
build these tools from source locally rather than via a package manager).

## The `dotfiles/` subdirectory is a legacy, superseded system

`dotfiles/` at the repo root is a self-contained older dotfiles framework (its own
`.gitmodules`/`README.md`/`setup.sh`, OS-detection-based package installers under
`setup_helpers/`) that predates the switch to yadm. It is not the active configuration mechanism —
new work should go through the top-level yadm-managed files described above, not into `dotfiles/`.

## Neovim config

`.config/nvim` uses `lazy.nvim` (entry point `.config/nvim/init.lua` → `lua/config/lazy.lua`);
plugin specs live one-file-per-plugin under `lua/plugins/`, LSP setup under `lua/lsp/`
(`mason.lua` for installs, `settings/*.lua` per-server config), autocommands under
`lua/autocommands/`. `lazy-lock.json` pins exact plugin commits — update it via Neovim's `:Lazy`
UI/`PlugUpdate`-style commands rather than hand-editing. There's a dedicated `yadm.lua` plugin
config pointing Neovim's own yadm integration at the same `~/.local/share/yadm/repo.git` used
above.

## Neomutt/notmuch config

The email stack is **msmtp** (SMTP send), **mbsync**/isync (IMAP fetch into a local Maildir),
**notmuch** (indexing/tagging/search), **neomutt** (the MUA), plus **mblaze** (`mmkdir`/`mrefile`)
for year-bucketed archive folders. The entry point is `./bin/inbox`, which: decrypts secrets if
`~/.config/mutt/aliases` doesn't exist yet (`~/.secrets/decrypt_secrets.sh`), runs `bin/check-mail.sh`
(mbsync + year-bucket archive move + `notmuch new`), launches `neomutt`, then on exit runs
`bin/notmuch-purge.sh` and `bin/notmuch-archive.sh` to reconcile notmuch tag state with the Maildir
on disk. Pass `-n`/`--offline` to skip all three sync steps and just open neomutt.

### Two accounts, two sync strategies

- **mailbox.org** (`.config/mutt/account.org.mailbox.andreas.wachowski`)
  is the primary account: mbsync'd (`.mbsyncrc##template`, single `mailbox` channel, `Pattern INBOX
  Sent Archive "Archive/2024" .. Drafts Junk Trash`) into `~/Mail/mailbox.org/`, and fully
  notmuch-indexed. neomutt browses it almost entirely through notmuch virtual folders
  (`notmuch://?query=...`) rather than raw Maildir paths.
- **Gmail** (`.config/mutt/account.com.gmail.andreas.wachowski`) is
  browsed live over IMAP inside neomutt (`set folder = ~/Mail/gmail`, real `mailboxes` entries) but
  is **not** mbsync'd — `.mbsyncrc##template` has no channel for it — and is explicitly excluded
  from notmuch (`exclude=gmail` under `[new]` in `.config/notmuch/default/config##template`).
  Switch accounts in the index with `<F2>` (mailbox.org) / `<F3>` (Gmail).

### Tag-driven workflow (mailbox.org)

`.config/mutt/notmuch-mailboxes` (sourced by both account files) defines the sidebar as notmuch
queries over tags — `tag:inbox`, `tag:unread`, `tag:w9`, `tag:newsletter`, `tag:sysadmin`, etc. —
instead of physical folders. `muttrc` macros act on tags first, "logically":

- `e` / `E` — `-inbox -unread +archive` / `-inbox +archive` (archive, read / keep unread)
- `d` — `+trash -inbox -unread` (delete)
- `\et` — `modify-tags` for ad hoc tagging

Nothing moves on disk yet — `[search] exclude_tags=trash;spam` in notmuch's config just hides
trashed/spam mail from view. `bin/notmuch-archive.sh` and `bin/notmuch-purge.sh` (idempotent,
support `-n`/`--dry-run`) later reconcile that logical state with disk: they find INBOX messages
that lost the `inbox` tag (or gained `trash`), copy them into `Archive.<year>` or `Trash`, flag the
INBOX original `:2,...T` (Maildir `\Deleted`), then run `mbsync mailbox` so it expunges the
original from IMAP and uploads the copy, followed by `notmuch new`. `./bin/inbox` runs both after
every neomutt session.

### Auto-tagging and indexing

`.config/notmuch/default/hooks/post-new` runs `notmuch tag --batch --input=.config/notmuch/tag-rules`
after every `notmuch new`, applying auto-tagging rules. That `tag-rules` file — like
`.config/mutt/aliases` — is **not** in this repo; both are symlinks into `/Volumes/SecretsRAMDisk`,
populated from the encrypted secrets store (see `Library/LaunchAgents/arpa.home.secrets_mount.plist##os.Darwin`,
which runs `~/.secrets/decrypt_secrets.sh` at login on macOS — the same script `./bin/inbox` falls
back to when the aliases file is missing). This `~/.secrets` mechanism is distinct from the
`archive`/yadm-archive submodule described under Bootstrapping above.

Two more scripts live under `.config/mutt/` but aren't referenced by `./bin/inbox` or anywhere else
in this repo, so treat them as manual/standalone tools rather than active automation:
`notmuch-new-inotify.sh` (an `fswatch` loop that re-runs `notmuch new` on any Maildir change) and
`notmuch-tag.sh` (a one-line `notmuch new --no-hooks` trigger).

### Sending mail

`msmtp` handles SMTP send, one `account` block per address in `.config/msmtp/config##template`
(`passwordeval "pass <address>"`, matching mbsync's own `PassCmd "pass <address>"` — both rely on
`pass`, the standard Unix password store, for credentials). Each mutt account file sets `sendmail =
"msmtp -a <address>"` to pick the matching msmtp account.

### Building neomutt from source

`local/src/neomutt` (a submodule — see Submodules above) is neomutt's upstream source;
`bin/compile_neomutt.sh##o.Darwin` configures it with notmuch/gpgme/lua/sqlite/sasl support and
installs to `~/local`, rather than relying on a Homebrew build.

### Backup

`bin/backup_email.sh` does a one-way `rsync -av ~/Mail/ pve:/archives/email` to a home NAS/server.

## Formatting/linting tools referenced in this repo

- Lua (Neovim config): `stylua`, configured by `.config/nvim/.stylua.toml`
  (100-col width, 2-space indent) and `.styluaignore`.
- Shell scripts: `shfmt` and `shellcheck` (see commit history, e.g. `style(profile): shfmt
  .profile`; scripts commonly carry `# shellcheck disable=...` directives).
- Prose (Markdown/org/commit messages): `vale`, configured by `.vale.ini` (styles: Vale,
  alex, proselint; custom vocab lists under `.config/vale/styles/config/vocabularies/`).

There is no build/test suite in the traditional sense — this is a config repo. "Verifying a
change" generally means: the shell files still parse/lint cleanly, Neovim starts without error
(`nvim --headless +qa` is a quick smoke test), and — for anything host/OS-specific — the correct
`##`-suffixed variant was edited.
