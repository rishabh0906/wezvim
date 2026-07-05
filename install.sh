#!/usr/bin/env bash
set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BACKUP_DIR="${HOME}/.dotfiles-backup/$(date +%Y%m%d-%H%M%S)"

info() {
  printf '\033[1;34m==>\033[0m %s\n' "$1"
}

warn() {
  printf '\033[1;33mwarn:\033[0m %s\n' "$1"
}

need_command() {
  if ! command -v "$1" >/dev/null 2>&1; then
    warn "$1 is not installed"
    return 1
  fi
}

backup_target() {
  local target="$1"

  if [ -L "$target" ]; then
    rm "$target"
    return
  fi

  if [ -e "$target" ]; then
    mkdir -p "$BACKUP_DIR"
    info "Backing up $target to $BACKUP_DIR"
    mv "$target" "$BACKUP_DIR/"
  fi
}

link_config() {
  local source="$1"
  local target="$2"

  mkdir -p "$(dirname "$target")"
  backup_target "$target"
  ln -s "$source" "$target"
  info "Linked $target -> $source"
}

install_nvim_plugins() {
  if ! need_command nvim; then
    warn "Install Neovim, then run this script again"
    return
  fi

  info "Syncing Neovim plugins"
  nvim --headless "+Lazy! sync" +qa

  info "Installing Mason tools"
  nvim --headless "+MasonInstall gopls rust-analyzer lua-language-server typescript-language-server codelldb delve js-debug-adapter" +qa

  info "Installing Treesitter parsers"
  nvim --headless "+lua require('lazy').load({plugins={'nvim-treesitter'}})" \
    "+TSInstallSync javascript typescript tsx rust go gomod gosum lua json yaml toml bash html css markdown markdown_inline vim vimdoc" \
    +qa
}

main() {
  info "Installing dotfiles from $DOTFILES_DIR"

  link_config "$DOTFILES_DIR/config/nvim" "$HOME/.config/nvim"
  link_config "$DOTFILES_DIR/config/wezterm" "$HOME/.config/wezterm"
  install_nvim_plugins

  info "Done"
}

main "$@"
