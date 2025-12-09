# Notes System Setup Guide

This guide will help you set up the persistent note-taking system for use in devcontainers.

## Overview

The note-taking system provides:
- **Scratch buffer** (`<leader>x`) - Persistent but clearable working notes
- **Daily notes** (`<leader>nd`) - Chronological learning journal
- **Permanent notes** (`<leader>nn`) - Structured Zettelkasten notes

All notes auto-sync to a private git repository, safe from devcontainer destruction.

## Prerequisites

1. **Install zk CLI tool** (Zettelkasten note-taking tool)

   ```bash
   # macOS
   brew install zk

   # Linux (download from releases)
   wget https://github.com/zk-org/zk/releases/latest/download/zk-linux-amd64
   chmod +x zk-linux-amd64
   sudo mv zk-linux-amd64 /usr/local/bin/zk

   # Or use your package manager
   ```

2. **Create a private git repository for notes**

   Create a new private repository on GitHub/GitLab (e.g., `personal-notes`)

## Setup Steps

### 1. Clone Your Notes Repository

```bash
# Clone to a consistent location
git clone git@github.com:yourusername/personal-notes.git ~/personal-notes
cd ~/personal-notes
```

### 2. Initialize Repository Structure

```bash
# Create directory structure
mkdir -p daily scratch notes

# Initialize zk
zk init

# Optional: Configure zk
# Edit .zk/config.toml if you want to customize zk behavior
```

### 3. Set Environment Variable

Add to your shell configuration (`.bashrc`, `.zshrc`, or devcontainer config):

```bash
export NOTES_REPO="$HOME/personal-notes"
```

**For devcontainers**, add to `.devcontainer/devcontainer.json`:

```json
{
  "remoteEnv": {
    "NOTES_REPO": "${localEnv:HOME}/personal-notes"
  },
  "postCreateCommand": "git clone git@github.com:yourusername/personal-notes.git ~/personal-notes || true"
}
```

### 4. Configure Git (if not already done)

```bash
cd ~/personal-notes
git config user.name "Your Name"
git config user.email "your.email@example.com"
```

### 5. First Commit

```bash
cd ~/personal-notes
git add .
git commit -m "Initial notes repository structure"
git push
```

## Usage

### Quick Capture

| Keybind | Action | Description |
|---------|--------|-------------|
| `<leader>x` | Open scratch | Persistent scratch buffer, opens in split |
| `<leader>X` | Ephemeral scratch | Truly temporary buffer (not saved) |
| `<leader>nd` | Open daily note | Opens current month's daily log |

### Zettelkasten Notes

| Keybind | Action | Description |
|---------|--------|-------------|
| `<leader>nn` | New permanent note | Create a new zk note |
| `<leader>nf` | Find notes | Search all notes |
| `<leader>nt` | Search by tags | Find notes by tags |
| `<leader>nb` | Show backlinks | See what links to current note |
| `<leader>nl` | Show links | See what current note links to |

### Auto-Sync

Notes automatically sync to git:
- On every save (`:w`)
- When you exit Neovim
- Runs in background, won't block your work

You'll see a notification: "Notes synced" when sync completes.

## Daily Note Format

Daily notes use append-only format with automatic timestamps:

```markdown
[2025-12-09 15:23] [dev-api-a3f2] Learned about webhook retry logic
[2025-12-09 15:45] [dev-api-a3f2] Meeting: Q1 roadmap discussion
[2025-12-09 16:12] [dev-frontend-b7e9] Fixed CSS bug in header component
```

- First timestamp: date and time
- Second identifier: container/hostname
- Content: your note

This format prevents merge conflicts when multiple containers write simultaneously.

## Permanent Notes

Create permanent notes when you want to extract knowledge from your daily logs:

1. Review your daily notes periodically
2. Identify important concepts worth keeping
3. Create a permanent note: `<leader>nn`
4. Link related notes with `[[note-title]]` syntax
5. Add tags with `#tag` in frontmatter

Example permanent note:

```markdown
---
title: Webhook Retry Patterns
tags: [architecture, webhooks, resilience]
date: 2025-12-09
---

# Webhook Retry Patterns

Webhooks should implement exponential backoff for retries to handle temporary failures gracefully.

## Key Principles

- Start with 1s delay
- Double on each retry
- Cap at 5 minutes
- Include jitter to prevent thundering herd

## Related Notes

- [[Circuit Breaker Pattern]]
- [[API Resilience]]

## References

From daily log: [2025-12-09 15:23]
```

## Workflow

### Daily Capture

1. Open scratch or daily note
2. Jot down thoughts, learnings, meeting notes
3. Let auto-sync handle persistence

### Weekly Review (Consolidation)

1. Review daily notes from the week
2. Extract important concepts into permanent notes
3. Create links between related notes
4. Archive or clean up scratch buffer

### Finding Information

- `<leader>nf` - Full-text search across all notes
- `<leader>nt` - Browse by tags
- `<leader>nb` - See what references a concept (backlinks)

## Multi-Container Safety

The append-only format ensures multiple devcontainers can write simultaneously:

- Each entry has timestamp and container ID
- New entries only append to end of file
- Git auto-merges concurrent appends
- Rare conflicts are easy to resolve manually

## Troubleshooting

### "NOTES_REPO environment variable not set"

Ensure `$NOTES_REPO` is set in your shell:

```bash
echo $NOTES_REPO
# Should output: /home/youruser/personal-notes
```

Add to your shell config if missing.

### "Notes synced" notification doesn't appear

Check git configuration:

```bash
cd $NOTES_REPO
git status
```

Ensure you have push access and SSH keys are configured.

### zk commands not working

Verify zk is installed and in PATH:

```bash
which zk
zk --version
```

Ensure your notes repo has been initialized with `zk init`.

## Tips

- **Clear scratch regularly** - It's persistent but meant to be clearable
- **Use daily notes liberally** - Low friction capture is the goal
- **Consolidate weekly** - Prevent information overload
- **Link aggressively** - The power of Zettelkasten is in the connections
- **Consider AI consolidation** - Use Claude/ChatGPT to help process raw logs into structured notes

## Further Reading

- [Zettelkasten Method](https://zettelkasten.de/)
- [zk Documentation](https://github.com/zk-org/zk)
- Design document: `docs/plans/2025-12-09-note-taking-design.md`
