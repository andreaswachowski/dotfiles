# My dotfiles

A lot of stuff collected since the initial Git-commit in 2010, when I imported
my vim configuration (I previously used Subversion but, alas, didn't conserve
the history during the migration).

I'd suggest to only use this repository as a way to discover new ideas, and
refrain from blindly copying it:

* Overly complex: Too much cruft has accumulated, and trying to keep it portable
  across various Linux, QNAP QTS, and MacOS systems over the years made it
  overly complicated. I eventually started to use [yadm](https://yadm.io/) to
  handle portability concerns. This explains the `##template` or `##o.Darwin`
  etc. suffixes.
* Incomplete: I keep some sensitive data in a separate, encrypted repo
  (referenced as a git submodule). For example, `~/.config/git/config` refers to
  `~/.config/git/identities/config`, but that file is not found in this repo.
* Unmaintained and untested parts: For example, `~/.config/brewfile/Brewfile*` will
  disappear, since I started using Jeef Geerling's excellent
  [mac-dev-playbook](https://github.com/geerlingguy/mac-dev-playbook) (I have
  not put that into a public repo). Speaking of that playbook,
  (full-mac-setup.md)[https://github.com/geerlingguy/mac-dev-playbook/blob/master/full-mac-setup.md]
  is a wonderful example of how I _should_ document my setup, but haven't.
