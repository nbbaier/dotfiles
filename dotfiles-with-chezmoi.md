# Dotfiles with chezmoi

chezmoi is more powerful than stow—it handles templating, secrets, and scripts. Good if you manage multiple machines or need different configs per environment.

## Initial Setup

```bash
# Install
brew install chezmoi

# Initialize from scratch
chezmoi init

# Or initialize from existing repo
chezmoi init https://github.com/nbbaier/dotfiles.git
```

## Directory Structure

chezmoi uses a source directory (`~/.local/share/chezmoi`) with special naming conventions:

```
~/.local/share/chezmoi/
├── .chezmoi.toml.tmpl          # Config template
├── .chezmoiignore              # Files to ignore
├── .chezmoiscripts/
│   ├── run_once_01-install-homebrew.sh
│   ├── run_once_02-brew-bundle.sh
│   └── run_onchange_macos-defaults.sh
├── dot_zshrc                   # → ~/.zshrc
├── dot_zshenv                  # → ~/.zshenv
├── dot_gitconfig.tmpl          # → ~/.gitconfig (templated)
├── dot_config/
│   ├── nvim/
│   │   └── init.lua
│   ├── starship.toml
│   └── ghostty/
│       └── config
└── packages/
    └── Brewfile
```

**Naming conventions**:
- `dot_` prefix → `.` in target
- `_` in name → `-` in target (e.g., `dot_config` → `.config`)
- `.tmpl` suffix → template (rendered with data)
- `private_` prefix → mode 0600
- `executable_` prefix → mode 0755

## Config File (.chezmoi.toml.tmpl)

```toml
# This prompts during `chezmoi init`
{{- $email := promptStringOnce . "email" "Email address" -}}
{{- $isWork := promptBoolOnce . "isWork" "Is this a work machine" -}}

[data]
    email = {{ $email | quote }}
    isWork = {{ $isWork }}
    
[edit]
    command = "cursor"
    args = ["--wait"]
```

## Templated Config Example

`dot_gitconfig.tmpl`:
```ini
[user]
    name = Nico Baier
    email = {{ .email }}

[core]
    excludesfile = ~/.gitignore_global
    pager = delta

{{ if .isWork -}}
[url "git@github.com-work:"]
    insteadOf = https://github.com/
{{- end }}
```

## Scripts

Scripts in `.chezmoiscripts/` run automatically based on their prefix:

### run_once_01-install-homebrew.sh
```bash
#!/bin/bash
# Runs once per machine (tracked by script hash)

if ! command -v brew &>/dev/null; then
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi
```

### run_once_02-brew-bundle.sh
```bash
#!/bin/bash
# Runs once, after homebrew

brew bundle --file="{{ .chezmoi.sourceDir }}/packages/Brewfile"
```

### run_onchange_macos-defaults.sh.tmpl
```bash
#!/bin/bash
# Runs when file content changes
# Hash: {{ include "macos/defaults.sh" | sha256sum }}

{{ include "macos/defaults.sh" }}
```

## Migration from Your Current Setup

```bash
# 1. Install chezmoi
brew install chezmoi
chezmoi init

# 2. Add existing dotfiles
chezmoi add ~/.zshrc
chezmoi add ~/.zshenv
chezmoi add ~/.gitconfig
chezmoi add ~/.config/nvim
chezmoi add ~/.config/starship.toml

# 3. Convert to templates where needed
chezmoi edit ~/.gitconfig  # Add template syntax, rename to .tmpl

# 4. Add your install scripts to .chezmoiscripts/

# 5. Push to git
chezmoi cd
git add -A
git commit -m "Initial chezmoi setup"
git remote add origin https://github.com/nbbaier/dotfiles.git
git push -u origin main
```

## Daily Commands

```bash
# See what would change
chezmoi diff

# Apply changes
chezmoi apply

# Edit a managed file
chezmoi edit ~/.zshrc

# Add a new file
chezmoi add ~/.config/ghostty/config

# Pull and apply updates from remote
chezmoi update

# Re-run scripts
chezmoi apply --force
```

## On a New Machine

```bash
# One-liner to bootstrap
sh -c "$(curl -fsLS get.chezmoi.io)" -- init --apply nbbaier

# Or step by step
brew install chezmoi
chezmoi init nbbaier
chezmoi diff    # Review changes
chezmoi apply   # Apply them
```

## Advanced Features You Might Use

### Different configs per machine

```
# .chezmoi.toml.tmpl
{{- $hostname := .chezmoi.hostname -}}

[data]
    isPersonal = {{ eq $hostname "nicos-macbook" }}
    isWork = {{ eq $hostname "work-laptop" }}
```

Then in templates:
```
{{ if .isWork }}
# Work-specific config
{{ else }}
# Personal config
{{ end }}
```

### External files (like your espanso config)

`.chezmoiexternal.toml`:
```toml
["Library/Application Support/espanso"]
    type = "git-repo"
    url = "https://github.com/nbbaier/espanso-config.git"
    refreshPeriod = "168h"  # Weekly
```

### Secrets with 1Password

```bash
# .chezmoi.toml
[onepassword]
    command = "op"

# In templates
{{ onepasswordRead "op://Personal/GitHub Token/password" }}
```

## Comparison: When to Use What

| Feature | Stow | chezmoi |
|---------|------|---------|
| Complexity | Minimal | More features |
| Learning curve | 5 minutes | 30 minutes |
| Templates | ❌ | ✅ |
| Secrets | ❌ | ✅ (1Password, Bitwarden, etc.) |
| Scripts | Manual | Built-in with ordering |
| Multi-machine | Manual conditionals | First-class support |
| Dependencies | Just symlinks | Single binary |
