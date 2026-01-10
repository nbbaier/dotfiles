# Dotfiles

Managed with [GNU Stow](https://www.gnu.org/software/stow/).

## Installation

1. Clone the dotfiles and run the install file

```bash
git clone --recurse-submodules https://github.com/nbbaier/dotfiles.git ~/.dotfiles
cd ~/.dotfiles
./install.sh
```

## Structure

The repo mirrors the home directory structure directly:

```
~/.dotfiles/
├── .config/           # XDG config files
│   ├── ghostty/
│   ├── git/
│   ├── nvim/
│   └── ...
├── .zshrc            # Shell config
├── .zshenv           # Environment variables
├── .gitconfig        # Git config (symlinked from .config/git/config)
│
├── Brewfile          # Package lists (not symlinked)
├── install.sh        # Installation script (not symlinked)
├── macos/            # macOS defaults (not symlinked)
└── bin/              # Utility scripts (not symlinked)
```

## Usage

Link all dotfiles with one command:

```bash
stow --dir="$HOME/.dotfiles" --target="$HOME" .
```

Or from within the dotfiles directory:

```bash
cd ~/.dotfiles && stow .
```

### Dry Run

Test what stow will do without making changes:

```bash
stow -n -v --dir="$HOME/.dotfiles" --target="$HOME" .
```

### Unlink

Remove all symlinks:

```bash
stow -D --dir="$HOME/.dotfiles" --target="$HOME" .
```

### Re-link

Update symlinks after adding new files:

```bash
stow -R --dir="$HOME/.dotfiles" --target="$HOME" .
```
