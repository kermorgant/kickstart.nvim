# OSC-52 Clipboard Integration Design

**Date:** 2025-12-09
**Status:** Approved
**Goal:** Enable seamless copy/paste between neovim in devcontainers and host system clipboard

## Problem Statement

Currently, yanked text in neovim stays trapped within neovim when running inside devcontainers. The user has a tmux-based workaround (ALT+j [ for tmux copy mode) but wants neovim yanks to automatically sync to the system clipboard.

## Solution: OSC-52

Use OSC-52 escape sequences to send clipboard data from neovim through tmux to the terminal emulator, which copies it to the system clipboard.

### Architecture

```
[Neovim yank]
    ↓ (OSC-52 escape sequence)
[tmux] (passes through with set-clipboard on)
    ↓
[Alacritty terminal] (intercepts OSC-52)
    ↓
[System Clipboard]
```

## Implementation

### 1. Tmux Configuration

Add to `~/.tmux.conf`:
```tmux
set -g set-clipboard on
```

This enables OSC-52 pass-through. Existing tmux-yank plugin settings remain unchanged:
```tmux
set-option -g @yank_selection 'clipboard'
set-option -g @yank_action 'wl-copy'
```

Apply changes without restarting:
```bash
tmux source-file ~/.tmux.conf
```

### 2. Neovim Configuration

Replace the current clipboard setting in `init.lua` (line ~118):

**Before:**
```lua
vim.o.clipboard = 'unnamedplus'
```

**After:**
```lua
-- Sync clipboard using OSC-52 (works through SSH/containers)
vim.g.clipboard = {
  name = 'OSC 52',
  copy = {
    ['+'] = require('vim.ui.clipboard.osc52').copy('+'),
    ['*'] = require('vim.ui.clipboard.osc52').copy('*'),
  },
  paste = {
    ['+'] = require('vim.ui.clipboard.osc52').paste('+'),
    ['*'] = require('vim.ui.clipboard.osc52').paste('*'),
  },
}
```

**Requirements:** Neovim 0.10+ (has built-in OSC-52 support)

## Testing

1. Yank text in neovim (`yy`, `yap`, visual selection + `y`)
2. Paste in host system application (emacs, browser, etc.)
3. Expected: yanked text appears

### Debugging

- Verify tmux setting: `tmux show-options -g set-clipboard` → should show `on`
- Check neovim version: `:version` → need 0.10+
- Test OSC-52 directly: `printf "\033]52;c;$(echo 'test' | base64)\007"`

## Edge Cases

- **Large yanks:** OSC-52 has size limits (~100KB-1MB). Very large yanks may truncate.
- **Paste into neovim:** Works via OSC-52 paste operation when using `p`
- **Named registers:** Local registers (like `"ay`) work normally; only `+` and `*` sync to system
- **Terminal compatibility:** Alacritty, WezTerm, Ghostty all support OSC-52

## Rollback

If issues arise:
- Tmux: Comment out `set -g set-clipboard on`
- Neovim: Revert to `vim.o.clipboard = 'unnamedplus'`

## Benefits

- Seamless yank → system clipboard in devcontainers
- No external tools required in containers (no wl-copy/xclip dependencies)
- Works through any number of SSH hops
- Existing tmux copy mode workflow (ALT+j [) continues working
- Terminal-agnostic (works with Alacritty, WezTerm, Ghostty)
