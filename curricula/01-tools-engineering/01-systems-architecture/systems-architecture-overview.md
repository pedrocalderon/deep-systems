---
id: systems-architecture-overview
created: 2026-02-20
updated: 2026-02-22T15:26:55-03:00
type: overview
curriculum: 01-tools-engineering
block: 01-systems-architecture
book:
concepts:
tags:
  - block
aliases:
  - systems-architecture-overview
aigenerated: true
---

# BLOCK 1 — Computer Systems & Architecture Foundations

## Objective

Build strong intuition for:

- Memory layout
- Processes & threads
- Virtual memory
- File I/O
- Syscalls
- Caches & CPU behavior

Eliminate fear of low-level system s.

## Prerequisites

- Comfortable Rust basics
- CLI familiarity

## Resources

- _Computer Systems: A Programmer's Perspective_ (selected chapters)
- _Operating Systems: Three Easy Pieces_ (selected)
- Brendan Gregg — _Systems Performance_ (selected)
- RISC-V or x86 assembly basics (reference-level exposure)

## Local Deliverables

- Implement a simple Unix shell with:
  - Process spawning
  - Pipes
  - Signals

- Build a memory arena allocator
- Use `mmap` to load and process large files
- Create benchmark harness (criterion or custom)
- Profile memory usage and CPU time

## Text Editor Deliverables

- File loading via `mmap`
- Implement file save pipeline
- Basic event loop
- Measure file-open latency
- Add benchmark for large file handling (e.g., 100MB)
