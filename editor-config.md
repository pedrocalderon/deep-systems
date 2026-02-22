---
id: editor-config
created: 2026-02-20T09:00:00-03:00
updated: 2026-02-22T15:54:16-03:00
type: overview
curriculum:
block:
book:
concepts:
tags:
aliases:
  - editor-config
aigenerated: true
---

# Editor Configuration

> [!warning] AI-Generated Content This documentation was generated with AI
> assistance.

This project includes a local Neovim plugin that automatically manages YAML
frontmatter in markdown files.

## Prerequisites

Enable Neovim's `exrc` feature in your configuration:

```lua
vim.opt.exrc = true
```

This allows Neovim to load project-local `.nvim.lua` files automatically.

## How It Works

### Bootstrap Process

1. When you open Neovim in this project, it loads `.nvim.lua`
2. The bootstrap script adds `.nvim/` to the runtime path
3. The `project_nvim` plugin is initialized with autocmds

### Frontmatter Management

On every markdown file save (`BufWritePre`), the plugin:

1. **Detects file context** from the path (curricula, notes, thinking, etc.)
2. **Parses existing frontmatter** if present
3. **Creates or updates** frontmatter as needed

#### New Files

For new markdown files, complete frontmatter is generated:

```yaml
---
id: a1b2c3d4e5 # Random 10-char alphanumeric
created: 2026-02-20T08:55:51-03:00
updated: 2026-02-20T08:55:51-03:00
type: note # Based on file location
curriculum: 01-tools-engineering # If applicable
block: 01-systems-architecture # If applicable
book:
concepts:
tags:
aliases:
  - a1b2c3d4e5
---
```

#### Existing Files

For files with existing frontmatter:

- The `updated` timestamp is refreshed
- Missing fields are added with empty defaults
- Existing values are preserved

### Context Detection

| File Location      | Curriculum/Block Source              | Default Type |
| ------------------ | ------------------------------------ | ------------ |
| `curricula/XX/YY/` | Extracted from path                  | `note`       |
| `notes/`           | First unchecked item in `catalog.md` | `note`       |
| `thinking/`        | Omitted                              | `reflection` |
| Root/other         | Empty                                | `note`       |

### Excluded Paths

Files in these locations are not processed:

- `.git/` directory
- `code/` subdirectories (for code examples)

## Plugin Structure

```text
.nvim/
└── lua/
    └── project_nvim/
        ├── init.lua          # Plugin entry, autocmd setup
        ├── frontmatter.lua   # YAML parsing/serialization
        ├── catalog.lua       # Parse catalog.md for current block
        ├── path.lua          # Extract curriculum/block from paths
        └── utils.lua         # ID generation, timestamps, helpers
```

## Troubleshooting

### Plugin Not Loading

1. Ensure `vim.opt.exrc = true` is in your Neovim config
2. Open Neovim from the project root directory
3. Check `:messages` for any error output

### Frontmatter Not Generated

1. Verify the file ends with `.md`
2. Ensure the file is not in an excluded directory
3. Check `:messages` for "Frontmatter error" warnings

### Manual Reload

To reload the plugin after making changes:

```vim
:lua package.loaded["project_nvim"] = nil
:lua package.loaded["project_nvim.frontmatter"] = nil
:lua package.loaded["project_nvim.catalog"] = nil
:lua package.loaded["project_nvim.path"] = nil
:lua package.loaded["project_nvim.utils"] = nil
:lua require("project_nvim").setup()
```
