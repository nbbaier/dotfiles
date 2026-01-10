#!/usr/bin/env bash
# Dotfiles installer - thin wrapper for bin/dotfiles orchestrator
# This script provides backward compatibility with the original install flow

set -euo pipefail

export DOTFILES="${DOTFILES:-$HOME/.dotfiles}"

# Run the full installation via the dotfiles orchestrator
exec bash "$DOTFILES/bin/dotfiles" install "$@"
