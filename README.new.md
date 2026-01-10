# Dotfiles

Personal dotfiles managed with [GNU Stow](https://www.gnu.org/software/stow/) for easy, modular installation.

## Quick Start

1. **Clone the repository:**
   ```bash
   git clone --recurse-submodules https://github.com/nbbaier/dotfiles.git ~/.dotfiles
   cd ~/.dotfiles
   ```

2. **Run the installer:**
   ```bash
   ./install.sh
   ```

   This will:
   - Install Homebrew (macOS) and essential development tools
   - Install packages from brewfile, npm, cargo, etc.
   - Link dotfiles to your home directory using GNU Stow
   - Apply macOS defaults (if on macOS)

## Architecture

This dotfiles repository uses a **thin orchestrator** pattern with **GNU Stow** for managing symlinks.

### Directory Structure

```
~/.dotfiles/
├── bin/                    # Utility scripts and the dotfiles orchestrator
│   └── dotfiles           # Main orchestrator script
├── install.sh             # Entry point (thin wrapper)
├── install-deps.sh        # Dependency installation script
│
├── Stow Packages:         # Each directory is a Stow package
│   ├── zsh/               # ZSH configuration
│   ├── git/               # Git configuration
│   ├── bat/               # Bat configuration
│   ├── gh/                # GitHub CLI configuration
│   ├── karabiner/         # Karabiner-Elements configuration
│   ├── aerospace/         # Aerospace window manager
│   ├── fastfetch/         # Fastfetch system info
│   ├── ghostty/           # Ghostty terminal
│   ├── litecli/           # LiteCLI configuration
│   ├── micro/             # Micro text editor
│   ├── pandoc/            # Pandoc document converter
│   ├── twtxtr/            # Twtxtr configuration
│   ├── topgrade/          # Topgrade configuration
│   ├── curl/              # Curl configuration
│   ├── jq/                # JQ configuration
│   └── system/            # System files (aliases, completions, prompts)
│
├── apps/                  # Application-specific configs (non-XDG)
│   ├── vscode/           # VS Code settings & snippets
│   ├── cursor/           # Cursor editor settings
│   ├── km/               # Keyboard Maestro macros
│   ├── smallweb/         # Smallweb plugins
│   ├── tex/              # LaTeX packages
│   └── bunches/          # Bunches configuration
│
├── packages/             # Package lists for various package managers
│   ├── brewfile          # Homebrew packages and casks
│   ├── npmfile           # npm global packages
│   ├── rustfile          # Rust cargo packages
│   ├── uvfile            # Python UV tool packages
│   ├── bunfile           # Bun global packages
│   ├── codefile          # VS Code extensions
│   └── cursorfile        # Cursor extensions
│
├── macos/                # macOS-specific settings and defaults
└── [legacy dirs]         # Original config/, zshenv/, system/ (will be removed)
```

### How Stow Works

GNU Stow creates symlinks from package directories to your home directory. For example:

```bash
stow zsh    # Links zsh/.zshenv -> ~/.zshenv
            #       zsh/.config/zsh/.zshrc -> ~/.config/zsh/.zshrc
```

Each Stow package mirrors the structure of your home directory. Files in `package/.config/app/file` get linked to `~/.config/app/file`.

## Usage

### The `dotfiles` Command

The `bin/dotfiles` script is your main interface:

```bash
# Link all dotfiles
dotfiles link

# Link specific packages only
dotfiles link zsh git

# Unlink packages
dotfiles unlink bat

# Restow (refresh links)
dotfiles restow

# List available packages
dotfiles list

# Full installation (dependencies + linking)
dotfiles install
```

### Manual Installation Steps

If you prefer more control:

1. **Install dependencies:**
   ```bash
   ./install-deps.sh
   ```

2. **Link dotfiles:**
   ```bash
   bin/dotfiles link
   ```

3. **Reload your shell:**
   ```bash
   source ~/.zshenv
   source ~/.config/zsh/.zshrc
   ```

## Adding New Dotfiles

To add a new configuration:

1. **Create a Stow package directory:**
   ```bash
   mkdir -p new-app/.config/new-app
   ```

2. **Add your config files:**
   ```bash
   cp ~/.config/new-app/config new-app/.config/new-app/
   ```

3. **Add the package to the list** in `bin/dotfiles` (OPTIONAL_PACKAGES or CORE_PACKAGES)

4. **Stow it:**
   ```bash
   dotfiles link new-app
   ```

### XDG vs Home Directory

- **XDG config files** (most modern apps): Create `package/.config/app/file`
- **Home directory dotfiles** (legacy apps): Create `package/.filename`

Examples:
- `.zshrc` → `zsh/.config/zsh/.zshrc`
- `.zshenv` → `zsh/.zshenv`
- `.gitconfig` → `git/.config/git/config`

## Platform Support

### macOS
- ✅ Full support (primary platform)
- Installs via Homebrew
- Applies macOS defaults
- Handles Application Support directory for IDE configs

### Linux
- ✅ Supported for Stow-based linking
- Debian/Ubuntu: Uses apt for Stow installation
- Other distros: Requires manual Stow installation

## Idempotency

The installer is designed to be run multiple times safely:
- ✅ Won't duplicate symlinks
- ✅ Won't reinstall existing packages (most operations)
- ✅ Safe to re-run after updates

## Troubleshooting

### Stow Conflicts

If Stow reports conflicts:

```bash
# Remove the conflicting file manually
rm ~/.config/git/config

# Then restow
dotfiles restow git
```

### Checking Links

```bash
# See where a file links to
ls -la ~/.zshenv

# See all links in a directory
ls -la ~/.config/zsh
```

### Starting Fresh

```bash
# Unlink everything
dotfiles unlink

# Remove all symlinks manually if needed
find ~ -maxdepth 1 -type l -delete
find ~/.config -type l -delete

# Then re-link
dotfiles link
```

## Migration Notes

This repository was recently refactored to use Stow. The old structure used custom linking scripts. The new structure is cleaner and more maintainable.

**Old approach:**
- `bin/link_config` - Custom recursive linker for ~/.config
- `bin/link_home` - Custom linker for home dotfiles  
- `bin/link_ides` - Custom linker for IDE configs

**New approach:**
- `bin/dotfiles` - Thin orchestrator using GNU Stow
- `bin/link_ides` - Still used for macOS Application Support (non-XDG paths)

## Dependencies

Core tools installed by the dependency installer:
- **Homebrew** (macOS package manager)
- **GNU Stow** (symlink manager)
- **Git** (version control)
- **Rust/Cargo** (Rust toolchain)
- **Node/npm** (JavaScript runtime)
- **Bun** (JavaScript runtime)
- **Deno** (JavaScript/TypeScript runtime)
- **UV** (Python package manager)
- Plus packages from brewfile, npmfile, etc.

## License

MIT

## Credits

Inspired by various dotfiles repos and the excellent [GNU Stow](https://www.gnu.org/software/stow/) tool.
