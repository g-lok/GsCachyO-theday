# Learnings

Corrections, insights, and knowledge gaps captured during development.

**Categories**: correction | insight | knowledge_gap | best_practice
**Areas**: frontend | backend | infra | tests | docs | config
**Statuses**: pending | in_progress | resolved | wont_fix | promoted | promoted_to_skill

## Status Definitions

| Status | Meaning |
|--------|---------|
| `pending` | Not yet addressed |
| `in_progress` | Actively being worked on |
| `resolved` | Issue fixed or knowledge integrated |
| `wont_fix` | Decided not to address (reason in Resolution) |
| `promoted` | Elevated to CLAUDE.md, AGENTS.md, or copilot-instructions.md |
| `promoted_to_skill` | Extracted as a reusable skill |

## Skill Extraction Fields

When a learning is promoted to a skill, add these fields:

```markdown
**Status**: promoted_to_skill
**Skill-Path**: skills/skill-name
```

Example:
```markdown
## [LRN-20250115-001] best_practice

**Logged**: 2025-01-15T10:00:00Z
**Priority**: high
**Status**: promoted_to_skill
**Skill-Path**: skills/docker-m1-fixes
**Area**: infra

### Summary
Docker build fails on Apple Silicon due to platform mismatch
...
```

---

## [LRN-20260525-001] correction

**Logged**: 2026-05-25
**Priority**: high
**Status**: resolved
**Area**: backend

### Summary
`filepath.Join(".", "/abs/path")` on macOS Go strips the leading `/`, returning a relative path.

### Context
In `runner.go`, `finalPath = filepath.Join(".", nameWithExt)` was used when `nameWithExt` was an absolute path like `/tmp/foo/out.wav`. Go's `filepath.Join` on macOS returned `"tmp/foo/out.wav"` instead of `"/tmp/foo/out.wav"`, causing output files to be written to the CWD instead of the intended absolute path.

### Resolution
Use `nameWithExt` directly when path is absolute. Only use `filepath.Join(".", ...)` for relative paths.

---

## [LRN-20260525-002] correction

**Logged**: 2026-05-25
**Priority**: high
**Status**: resolved
**Area**: backend

### Summary
`fmt.Sprintf("out.wav", 1)` returns `"out.wav%!(EXTRA int=1)"` — Go doesn't ignore extra format args when no verbs exist.

### Context
Refactored runner.go to use `fmt.Sprintf(nameWithExt, idx+1)` unconditionally, but when `totalFiles==1`, `nameWithExt` has no `%d` verb. Go's `fmt.Sprintf` appends a Go-syntax error string instead of returning the string unchanged.

### Resolution
Only call `fmt.Sprintf` with `postfixFormat` format string when `totalFiles > 1`.

---

## [LRN-20260525-003] insight

**Logged**: 2026-05-25
**Priority**: medium
**Status**: pending
**Area**: backend

### Summary
go-audio/wav's `Encoder.Close()` writes a LIST chunk, then rexconverter's `encoder.go` manually appends cue+adtl chunks and rewrites the RIFF size via SEEK. This double-patching may corrupt WAV headers.

### Context
The RIFF size stored in the WAV header is written once by go-audio/wav, then overwritten by hand after appending cue chunks. If the seek position is wrong, the RIFF size could be incorrect, causing audio players to misinterpret the data.

### Follow-up
Test with raw PCM-only WAV (skip cue/LIST injection) to isolate the glitch.
