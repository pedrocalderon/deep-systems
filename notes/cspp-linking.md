---
id: frazxad4vx
created: 2026-03-04T09:37:20-03:00
updated: 2026-03-04T13:11:02-03:00
type: note
curriculum: 01-tools-engineering
block: 01-systems-architecture
book:
concepts:
tags:
aliases:
  - frazxad4vx
---

# cspp-linking

Chapter 7

The process of combining various pieces of code and data into a single file to
be copied to memory and executed.

Can be done at compile, load and even run time.

Usually done by the _linker_. Allow programs to be broken down and recompiled
efficiently.

A relocatable object file is the type of files the linker will use as input. The
addresses within the file are still symbolic rather than being bound to the
specific memory addresses. I understand that the linker will be responsible for
the final memory addresses. This process is called relocation.

The linker also is responsible for symbol resolution.

Linkers have minimal understanding of the target machine. The compilers and
assemblers that generated the relocatable objects files have already done most
of the work.

Three forma of object files:

- Relocatable object files
- Executable object files: binary code and data to be loaded into memory and
  executed
- Shared object file: special relocatable object file that can be loaded into
  memory and linked dynamically

  compilers and assemblers -> relocatable object files linkers -> executable
  object files

  Linux uses the Unix Executable and Linkable Forma (ELF) for object file
  format.

  ## ELF relocatable object format

| ELF header           |
| -------------------- |
| .text                |
| .rodata              |
| .data                |
| .bss                 |
| .symtab              |
| .rel.text            |
| .rel.data            |
| .debug               |
| .line                |
| .strtab              |
| Section header table |

### ELF header

16 byte sequence that describes the word size, byte ordering, system that
generated the file

Linker information: size of header, object file type, machine type, size and
number of entries, file offset of the section header table.

### Section header table

Location and sizes of the various sections

### .text

Machine code of the compiled program

### .rodata

Read only data such as format string in printf

### .data

Initialized global C variables.

### .bss

Uninitialized global C variables. Occupies no space.

### .symtab

Symbol table with information about functions and global variables.

### .rel.text

A list of sections in .text that will need to be modified by the linker.

### .rel.data

Relocation information for global variables

### .debug

Debug symbols table for local variables and typedefs

### .line

Source map like

### .strtab

String table for .symtab and .debug
