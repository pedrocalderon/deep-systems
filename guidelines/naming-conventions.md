---
id: naming-conventions
created: 2026-02-20
updated: 2026-02-22T15:55:51-03:00
type: guideline
curriculum:
block:
book:
concepts:
tags:
aliases:
  - naming-conventions
aigenerated: true
---

# Naming Conventions

## Numbering Policy

- Curricula are numbered.
- Blocks are numbered.
- Files inside blocks should not be numbered.

Example:

```text
systems-architecture-overview.md
systems-architecture-csapp-notes.md
systems-architecture-memory-layout.md
```

This makes:

- `grep` easier
- AI navigation easier
- Human scanning easier
- No duplicate `README.md` confusion

## Format

- No duplicate filenames across the repository.
- All block overview files must follow:

  ```text
  [BLOCK-NAME]-overview.md
  ```

- Concept notes should include context prefix:

  ```text
  csapp-ch02-memory.md
  roughgarden-greedy.md
  sipser-dfa.md
  ```

## File Naming Policy

Avoid:

```text
README.md
notes.md
exercise.md
```

Prefer:

```text
algorithms-overview.md
algorithms-dp-notes.md
algorithms-exercises-set-01.md
```

Every file should be self-describing.
