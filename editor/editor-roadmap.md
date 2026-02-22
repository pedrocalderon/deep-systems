---
created: 2026-02-20T00:00:00-03:00
updated: 2026-02-20T00:00:00-03:00
type: overview
curriculum: 01-tools-engineering
block: editor-integration
concepts: [editor, tui, rpc, text-buffer, concurrency, performance]
tags: [editor, systems, tools-engineering]
aliases: [editor-roadmap, editor-milestones]
aigenerated: true
---

# Editor Roadmap — Multi-Client Text Engine

This document defines the implementation roadmap for the editor project.

The editor is **not the curriculum**.

It is the **integration surface** for everything studied in:

- `curricula/01-tools-engineering/`
- Later: `curricula/02-cs-foundations/`

Each milestone maps to specific curriculum blocks.

The goal is to:

- Build something usable early.
- Reduce abandonment risk.
- Incrementally integrate deeper systems knowledge.
- Evolve toward a multi-client editor architecture.

---

## Scope Philosophy

### Realistic Initial Goal

A minimal but real editor, similar in spirit to `kilo` or `nano`:

- Open file
- Edit text
- Save
- Search
- Undo/redo
- Solid navigation

Not feature-complete.
Not production-ready.
But structurally correct.

---

### Explicit Non-Goals (Early Phases)

Avoid these until later:

- Full LSP integration
- Complex syntax highlighting
- Multiple panes/tabs/splits
- Advanced Unicode grapheme handling
- Persistent undo history
- Plugin system
- Perfect performance tuning

These become relevant in later blocks.

---

## Architectural Direction

The editor must evolve toward:

> A headless text engine (server) + multiple clients (TUI, GUI, remote)

Inspired by:

- Neovim RPC model
- VSCode remote/devcontainer model

This requires a layered architecture from the beginning.

---

## Core Architectural Layers

1. **Core (Document Engine)**
   - `Document`
   - `Cursor`
   - Editing operations
   - Undo/redo
   - No terminal knowledge

2. **Application State**
   - EditorState
   - Viewport
   - Dirty flag
   - Mode (insert/normal)
   - Event loop orchestration

3. **Client**
   - TUI client
   - Later: GUI client
   - Later: RPC client

4. **Transport (Later)**
   - Local RPC
   - Framed protocol
   - Remote mode

---

## Milestone Roadmap

Each milestone produces something usable.

Each milestone explicitly links to curriculum blocks.

---

### M0 — Terminal Raw Mode + Render Loop

**Curriculum Links**

- Block 01 — Systems Architecture

**Deliverables**

- Enter raw mode
- Restore terminal via RAII
- Clear screen and render placeholder content
- Exit cleanly via `Ctrl-Q`

Outcome:
You have a stable “editor shell” that doesn’t break the terminal.

---

### M1 — Cursor + Viewport

**Curriculum Links**

- Block 01 — Systems Architecture
- Block 03 — Algorithms (state invariants)

**Deliverables**

- Logical cursor (row, col)
- Viewport (row_offset, col_offset)
- Scroll when cursor exits viewport
- Render visible slice only

Outcome:
It behaves like an editor.

---

### M2 — Open + Save File

**Curriculum Links**

- Block 01 — Systems Architecture (file I/O, mmap later)

**Deliverables**

- Load file into memory
- Dirty flag
- Save via `Ctrl-S`
- Basic error handling

Outcome:
Usable minimal editor.

---

### M2.5 — Core/Client Separation

**Curriculum Links**

- Block 05 — Networking & Architecture

**Deliverables**

- Extract `editor-core` crate
- Move:
  - Document
  - Cursor
  - Commands
- TUI becomes thin client over core API

Outcome:
Clear separation between engine and UI.

This milestone is critical for future multi-client support.

---

### M3 — Insert Mode + Editing Operations

**Curriculum Links**

- Block 03 — Data Structures
- Block 04 — Parsing (basic tokenization awareness)

**Deliverables**

- Insert characters
- Backspace
- Split line (Enter)
- Join lines
- Basic mode switching

Initial storage:

- `Vec<String>` or similar simple representation

Outcome:
A real editor.

---

### M4 — Search

**Curriculum Links**

- Block 03 — Algorithms (string search)

**Deliverables**

- Prompt for search query
- Jump to match
- Highlight match (optional)

Optional:

- Replace linear search with KMP/Boyer-Moore

Outcome:
First “advanced” feature.

---

### M4.5 — Headless Mode

**Curriculum Links**

- Block 05 — Networking

**Deliverables**

- Run core without TUI
- Accept commands over stdin or local socket
- Serialize editor state to client

Outcome:
Editor engine becomes server-capable.

This prepares for RPC transport.

---

### M5 — Undo / Redo

**Curriculum Links**

- Block 03 — Algorithms (stack, command pattern)

**Deliverables**

- `EditCommand` abstraction
- Undo stack
- Redo stack

Outcome:
Major usability improvement.
Introduces command abstraction cleanly.

---

### M6 — Data Structure Refactor

**Curriculum Links**

- Block 03 — Algorithms & Data Structures

**Deliverables**
Replace simple storage with:

- Gap buffer
- Rope
- Or piece table

Benchmark against original implementation.

Outcome:
Deep understanding of text data structures.

---

### M7 — Background Tasks

**Curriculum Links**

- Block 02 — Concurrency

**Deliverables**

- Background parsing thread
- Background indexing/search
- Non-blocking UI

Outcome:
Concurrency integrated into real system.

---

### M8 — Incremental Parsing

**Curriculum Links**

- Block 04 — Parsing

**Deliverables**

- Token-based syntax highlighting
- AST-based incremental parsing
- Update only changed regions

Outcome:
Editor moves toward serious tooling.

---

### M9 — RPC + Multi-Client

**Curriculum Links**

- Block 05 — Networking
- Block 02 — Concurrency

**Deliverables**

- Framed protocol
- TUI client over RPC
- Second client (minimal GUI or web)
- Remote editing mode

Outcome:
Editor becomes distributed-capable.

---

### M10 — Performance Pass

**Curriculum Links**

- Block 06 — Performance Engineering

**Deliverables**

- Flamegraph profiling
- Allocation reduction
- Large-file stress testing
- Latency documentation

Outcome:
Serious systems engineering maturity.

---

## Anti-Abandonment Strategy

- Every milestone produces a working binary.
- No milestone should take more than a few focused sessions.
- Avoid major refactors before MVP usability.
- Benchmark before optimizing.

---

## Long-Term Direction

This editor will eventually support:

- Plugin runtime (Block 09 — Programming Languages)
- Collaborative editing (Block 10 — Distributed Systems)
- Indexed search (Block 11 — Databases)
- Security hardening (Block 12 — Security)

But those belong to Phase 2.

---

## Completion Criteria (Phase 1 Exit)

Phase 1 is considered complete when:

- Core is headless-capable.
- At least two clients exist.
- Incremental parsing works.
- Concurrency model is stable.
- Performance has been profiled and improved.
- Architecture decisions are documented.

At that point, the editor is not just a project.

It is proof of systems capability.

---
