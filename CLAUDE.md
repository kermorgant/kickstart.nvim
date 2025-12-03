# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Neovim Configuration Overview

This is a kickstart.nvim configuration - a well-documented, single-file Neovim setup that serves as a starting point for customization. It's based on the popular nvim-lua/kickstart.nvim template.

## Key Commands

### Plugin Management
- `:Lazy` - View plugin status and manage plugins
- `:Lazy update` - Update all plugins
- `:Mason` - View and install LSP servers, formatters, and linters

### Development Workflow
- `<space>f` - Format current buffer using conform.nvim
- `:ConformInfo` - View formatter configuration and status
- `:checkhealth` - Run health checks for Neovim and plugins

### Testing
No specific test framework is configured. This is a Neovim configuration, not a code project with tests.

## Architecture

### Plugin Manager
Uses `lazy.nvim` for plugin management. All plugins are defined in the main `init.lua` file around line 248.

### LSP Configuration
- Uses `nvim-lspconfig` with Mason for automatic LSP server installation
- Currently configured for Lua development (`lua_ls`)
- Blink.cmp provides autocompletion with LSP integration
- Conform.nvim handles formatting (stylua for Lua files)

### Key Plugin Categories
1. **Core functionality**: lazy.nvim (plugin manager), telescope (fuzzy finder), treesitter (syntax highlighting)
2. **LSP stack**: nvim-lspconfig, mason, blink.cmp for completion
3. **Git integration**: gitsigns, vim-fugitive, vim-flog
4. **UI enhancements**: which-key, mini.nvim modules, tokyonight theme
5. **Session management**: auto-session for workspace persistence

### Custom Extensions
- `custom/delete_pair.lua` - Custom treesitter-based text manipulation for deleting/changing to closing pairs
- Custom keymaps defined in main init.lua (lines 1080+) for window management and file browsing

### Configuration Structure
- Single-file configuration in `init.lua` (following kickstart.nvim philosophy)
- Custom extensions in `lua/custom/` directory
- Additional kickstart plugins available in `lua/kickstart/plugins/` but not enabled by default

### Key Keybindings
- Leader key: `<space>`
- `<leader>ff` - File browser at current directory
- `<leader>bb` - List buffers
- `<leader>w/` - Vertical split
- `C` - Custom change to closing pair function
- `D` - Custom delete to closing pair function

## Important Notes

- This configuration prioritizes simplicity and educational value over feature completeness
- Most functionality is contained in the single `init.lua` file for easy reading and understanding
- Extensions should be added to `lua/custom/` directory to maintain organization
- The configuration targets the latest stable and nightly Neovim versions only