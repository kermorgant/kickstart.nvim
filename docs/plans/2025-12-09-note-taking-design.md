# Note-Taking System Design

**Date:** 2025-12-09
**Context:** Setting up persistent note-taking for devcontainer workflow with multi-container sync safety

## Problem Statement

Need a note-taking system that:
- Works across ephemeral devcontainers (can be destroyed quickly)
- Handles multiple containers syncing simultaneously without conflicts
- Supports different note types (ephemeral scratch, persistent daily notes, structured knowledge)
- Low friction for capture during learning/onboarding phase
- Enables AI-assisted consolidation and knowledge building

## Design Overview

Three-tier note system aligned with Zettelkasten methodology:

1. **Scratch (ephemeral)** - Deliberately temporary working notes
2. **Daily notes (persistent)** - Chronological capture inbox
3. **Permanent notes (structured)** - Zettelkasten notes with links

## Repository Structure

Single private git repository at location specified by `$NOTES_REPO` environment variable:

```
personal-notes/
├── daily/
│   ├── 2025-12.md          # Monthly append-only logs
│   └── 2025-11.md
├── scratch/
│   └── scratch.md          # Persistent but clearable scratch
├── notes/                   # Permanent zk notes
│   ├── note-abc123.md
│   └── note-def456.md
└── .zk/
    └── config.toml         # zk configuration
```

## Tooling

- **zk** (CLI): Zettelkasten note management tool
- **zk-nvim**: Neovim integration for zk
- **Git**: Auto-sync mechanism with commit/push

## Note Types & Workflow

### 1. Scratch Notes (Ephemeral)

**Keybind:** `<leader>x` (existing muscle memory)
**File:** `scratch/scratch.md`
**Purpose:** Debugging output, calculations, temporary TODOs
**Lifecycle:** Auto-synced for container safety, but cleared periodically

### 2. Daily Notes (Persistent Capture)

**Keybind:** `<leader>nd`
**File:** `daily/YYYY-MM.md` (monthly files)
**Format:** Append-only with timestamps and container IDs

```markdown
[2025-12-09 15:23] [dev-api-a3f2] Learned webhook retry uses exponential backoff
[2025-12-09 15:45] [dev-api-a3f2] Meeting: Q1 planning focuses on API redesign
```

**Purpose:** Learning journal, meeting notes, daily insights
**Benefits:**
- Chronological archive (valuable during onboarding)
- Append-only prevents merge conflicts from multiple containers
- Easy to search by date

### 3. Permanent Notes (Zettelkasten)

**Command:** `:ZkNew {title}`
**Location:** `notes/` directory
**Format:** Markdown with frontmatter, tags, `[[links]]`

**Purpose:** Synthesized knowledge, atomic concepts, linked ideas
**Created by:** Extracting/refactoring important content from daily notes

## Multi-Container Conflict Resolution

**Problem:** Multiple devcontainers writing simultaneously to same repo

**Solution:** Append-only format with automatic metadata

- Each entry includes timestamp and container ID
- New entries only append to end of file
- Git handles concurrent appends gracefully
- Pull-before-push in auto-sync reduces conflicts further
- In rare conflict cases, both versions preserved (manual merge easy since append-only)

**Container identification:** Use hostname or container ID in entries

## Auto-Sync Mechanism

**Triggers:**
1. On write (after saving scratch or daily note)
2. Background timer (every 5 minutes if changes exist)
3. On VimLeavePre (container shutdown)

**Process:**
1. Git pull (fast-forward or auto-merge)
2. Git add changed files
3. Git commit with timestamp
4. Git push

**Implementation:** Neovim autocmds + background job for git operations

## Environment Variable

`$NOTES_REPO` - Path to notes repository
- Set in devcontainer environment
- Used by Neovim config to locate notes
- Example: `export NOTES_REPO=~/personal-notes`

## Consolidation Workflow (Future)

1. Review daily notes periodically (weekly/monthly)
2. Use AI to identify key concepts and themes
3. Create permanent zk notes with `:ZkNew`
4. Link related concepts with `[[note-title]]` syntax
5. Use zk's backlink features to navigate knowledge graph

## Benefits

✅ Survives container destruction (auto-sync)
✅ No merge conflicts (append-only + container IDs)
✅ Low friction capture (quick keybinds)
✅ Chronological archive for learning
✅ Ecosystem for knowledge building (zk)
✅ Flexible lifecycle (ephemeral → persistent → structured)
✅ AI-friendly format for consolidation

## Trade-offs

⚠️ Raw daily logs less readable than structured notes (mitigated by consolidation)
⚠️ Requires git repo setup and environment variable configuration
⚠️ Monthly files might grow large (mitigated by monthly rotation)
⚠️ Additional dependencies (zk CLI tool)

## Implementation Checklist

- [ ] Create private git repository for notes
- [ ] Set `$NOTES_REPO` environment variable in devcontainer
- [ ] Install zk CLI tool
- [ ] Add zk and zk-nvim plugins to Neovim config
- [ ] Configure keybinds (`<leader>x`, `<leader>nd`)
- [ ] Implement auto-sync mechanism
- [ ] Add timestamp/container ID injection on write
- [ ] Test multi-container scenario
- [ ] Document usage in README
