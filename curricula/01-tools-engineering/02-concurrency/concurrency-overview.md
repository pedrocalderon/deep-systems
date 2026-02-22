---
id: concurrency-overview
created: 2026-02-20
updated: 2026-02-22T15:27:06-03:00
type: overview
curriculum: 01-tools-engineering
block: 02-concurrency
book:
concepts:
tags:
  - block
aliases:
  - concurrency-overview
aigenerated: true
---

# BLOCK 2 — Concurrency & Async Architecture

## Objective

Gain deep working knowledge of:

- Threads
- Channels
- Atomics
- Memory ordering intuition
- Async runtimes
- Task scheduling

Become comfortable debugging concurrency issues.

## Prerequisites

- Block 1

## Resources

- _Rust Atomics and Locks_ (Mara Bos)
- Tokio internals blog posts
- Selected OS concurrency sections

## Local Deliverables

- Implement thread pool
- Implement work-stealing scheduler
- Implement lock-free queue (simple version)
- Create race-condition reproduction tests
- Stress-test under load

## Text Editor Deliverables

- Background worker thread for file indexing
- Background syntax parsing worker
- Async input handling
- Separate UI thread from core logic
- Measure latency impact of background tasks
