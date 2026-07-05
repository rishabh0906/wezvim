# Dotfiles

Single entry point for a portable development setup.

## Install

```sh
git clone <your-repo-url> ~/.dotfiles
cd ~/.dotfiles
./install.sh
```

The installer symlinks:

- `config/nvim` -> `~/.config/nvim`
- `config/wezterm` -> `~/.config/wezterm`

If a real file or directory already exists at the target path, it is moved to
`~/.dotfiles-backup/<timestamp>/` before the symlink is created.

## Neovim

The Neovim config includes:

- Lazy.nvim plugin manager
- Oxocarbon theme
- Treesitter
- LSP for JavaScript, TypeScript, Rust, Go, and Lua
- Completion with `nvim-cmp` and LuaSnip
- Debugging with `nvim-dap`, DAP UI, Go, Rust, and JS/TS adapters

Useful debug keys:

- `F5`: continue
- `F10`: step over
- `F11`: step into
- `F12`: step out
- `<leader>db`: toggle breakpoint
- `<leader>du`: toggle debug UI

## Recommended Git Flow

After cloning, make all Neovim edits inside:

```sh
~/.dotfiles/config/nvim
```

Because `~/.config/nvim` is a symlink, Neovim will use the tracked files
directly.

## WezTerm

The WezTerm config includes:

- Iosevka Nerd Font Mono
- Oxocarbon-style colors
- 90% window opacity with macOS blur
- Hidden tab bar
- `Alt+Enter` fullscreen toggle
