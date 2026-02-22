-- project_nvim: Auto-manage YAML frontmatter in markdown files
local M = {}

local frontmatter = require("project_nvim.frontmatter")
local catalog = require("project_nvim.catalog")
local path = require("project_nvim.path")
local utils = require("project_nvim.utils")

--- Build context for frontmatter generation
---@param filepath string
---@return table
local function build_context(filepath)
  local ctx = path.detect_context(filepath)

  -- For notes, fetch curriculum/block from catalog if not set
  if ctx.context == path.CONTEXT.NOTES then
    local current = catalog.get_current_block()
    if current then
      ctx.curriculum = current.curriculum
      ctx.block = current.block
    end
  end

  -- Mark thinking context to omit curriculum/block
  if ctx.context == path.CONTEXT.THINKING then
    ctx.omit_curriculum_block = true
  end

  return ctx
end

--- Process buffer to add or update frontmatter
---@param bufnr number Buffer number
local function process_buffer(bufnr)
  local filepath = vim.api.nvim_buf_get_name(bufnr)

  -- Skip if not a markdown file
  if not filepath:match("%.md$") then
    return
  end

  -- Skip files in excluded directories
  if utils.should_skip_file(filepath) then
    return
  end

  local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)

  -- Build context from file path
  local ctx = build_context(filepath)

  -- Try to parse existing frontmatter
  local parsed = frontmatter.parse(lines)

  if parsed then
    -- Update existing frontmatter
    local updated = frontmatter.update(parsed.data, ctx)
    local new_lines = frontmatter.serialize(updated, ctx)

    -- Replace frontmatter lines in buffer
    vim.api.nvim_buf_set_lines(bufnr, 0, parsed.end_line, false, new_lines)
  else
    -- Create new frontmatter
    local data = frontmatter.create_default(ctx)
    local new_lines = frontmatter.serialize(data, ctx)

    -- Add blank line after frontmatter if content exists
    if #lines > 0 and utils.trim(lines[1]) ~= "" then
      table.insert(new_lines, "")
    end

    -- Prepend frontmatter to buffer
    vim.api.nvim_buf_set_lines(bufnr, 0, 0, false, new_lines)
  end
end

--- Setup the plugin
function M.setup()
  -- Create autocommand group
  local group = vim.api.nvim_create_augroup("ProjectNvimFrontmatter", { clear = true })

  -- Register BufWritePre autocmd for markdown files
  vim.api.nvim_create_autocmd("BufWritePre", {
    group = group,
    pattern = "*.md",
    callback = function(ev)
      local ok, err = pcall(process_buffer, ev.buf)
      if not ok then
        vim.notify("Frontmatter error: " .. tostring(err), vim.log.levels.WARN)
      end
    end,
    desc = "Auto-manage YAML frontmatter in markdown files",
  })

  vim.notify("project_nvim loaded: frontmatter auto-management enabled", vim.log.levels.INFO)
end

return M
