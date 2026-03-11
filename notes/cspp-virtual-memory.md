---
id: h24mcv3hia
created: 2026-03-05T06:38:51-03:00
updated: 2026-03-05T06:58:28-03:00
type: note
curriculum: 01-tools-engineering
block: 01-systems-architecture
book:
concepts:
tags:
aliases:
  - h24mcv3hia
---

# cspp-virtual-memory

Chapter 9

Virtual memory aims to avoid processes writing in each other memory space.

This abstraction achieve 3 things:

1. Main memory is used efficiently
2. It simplifies memory management by providing processes with a uniform address
   space
3. It protects the address space of each process

Instead of the CPU access physical memory directly, in modern computer it uses
the virtual memory abstraction.

When using virtual memory the CPU requests a virtual address that is translated
by the MMU (memory management unit) to its physical addresses.

## Address spaces

Address space: ordered set of non-negative integers

If the numbers are consecutive it is a linear address space.

The size of an address space is the number of bits that are needed to represent
the largest address. Ex 32-bit or 64-bit.

SRAM cache - L1, L2 and L3 and main memory

DRAM cache - VM system's cache

DRAM 10x slower than SRAM.

Disk 100,000x slower than DRAM.

This numbers are true for sst also?

SRAM cache miss go to DRAM. DRAM cache miss go to disk.

DRAM cache misses are very expensive.

DRAM cache organization is driven by the cost of it's misses.
