---
id: networking-overview
created: 2026-02-20
updated: 2026-02-22T15:27:19-03:00
type: overview
curriculum: 01-tools-engineering
block: 05-networking
book:
concepts:
tags:
  - block
aliases:
  - networking-overview
aigenerated: true
---

# BLOCK 5 — Networking & Editor-as-Server Architecture

## Objective

Design decoupled core and multi-client architecture.

Understand:

- RPC
- Framing protocols
- Serialization
- Backpressure
- Latency tradeoffs

## Prerequisites

- Block 2
- Block 4

## Resources

- Network programming references (Rust async)
- Selected distributed systems intro notes
- VSCode remote architecture blog posts

## Local Deliverables

- Implement minimal RPC protocol
- Implement framed message transport
- Build test harness for message ordering
- Add failure simulation

## Text Editor Deliverables

- Refactor editor core into headless server
- Implement TUI client over RPC
- Implement second client (simple GUI/web)
- Add remote file editing support
- Measure round-trip latency
