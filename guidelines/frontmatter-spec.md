---
id: frontmatter-spec
created: 2026-02-20
updated: 2026-02-22T15:55:42-03:00
type: guideline
curriculum:
block:
book:
concepts:
tags:
aliases:
  - frontmatter-spec
aigenerated: true
---

# Frontmatter Specification

All markdown files must begin with:

```markdown
---
id: file-id-here
created: 2026-02-20T08:55:51-03:00
updated: 2026-02-20T08:55:51-03:00
type: note # note | overview | exercise | experiment | essay | reflection | design-note
curriculum: 01-tools-engineering # optional, not present in the thinking notes
block: 01-systems-architecture # optional, not present in the thinking notes
book: csapp # optional
concepts:
  - memory
  - virtual-memory
  - mmap
tags:
  - systems
  - performance
aliases:
  - file-id-here
---
```

This allows:

- Filtering by book
- Filtering by concept
- Filtering by curriculum
- Filtering by block
- Long-term graph exploration in Obsidian
- id for file referencing without depending on the file path
- aliases with the id field to work natively with Obsidian links

## YAML arrays

Always use block style arrays:

```YAML
# A list of strings
servers:
  - web01.example.com
  - web02.example.com
  - db01.example.com

# A list of numbers
ports:
  - 80
  - 443
  - 8080
```

Avoid flow style arrays:

```YAML
servers: [web01.example.com, web02.example.com, db01.example.com]
ports: [80, 443, 8080]
empty_array: []
```
