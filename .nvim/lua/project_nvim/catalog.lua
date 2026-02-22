-- Catalog module: Parse catalog.md to find current active block
local M = {}

local utils = require("project_nvim.utils")

--- Parse catalog.md and find the first unchecked block
---@return table|nil { curriculum: string, block: string } or nil if none found
function M.get_current_block()
  local root = utils.get_project_root()
  if not root then
    return nil
  end

  local catalog_path = root .. "/catalog.md"
  if vim.fn.filereadable(catalog_path) ~= 1 then
    return nil
  end

  local lines = vim.fn.readfile(catalog_path)
  if not lines or #lines == 0 then
    return nil
  end

  local current_curriculum = nil

  for _, line in ipairs(lines) do
    -- Check for curriculum header: ## [XX Name](path)
    local curriculum_match = line:match("^## %[(%d%d [^%]]+)%]")
    if curriculum_match then
      -- Extract curriculum slug from the link path
      local curriculum_slug = line:match("curricula/(%d%d%-[^/]+)/")
      if curriculum_slug then
        current_curriculum = curriculum_slug
      end
    end

    -- Check for unchecked block: - [ ] [XX Name](path)
    if line:match("^%- %[ %]") then
      -- Extract block slug from the link path
      local block_slug = line:match("/(%d%d%-[^/]+)/[^/]+%-overview%.md")
      if block_slug and current_curriculum then
        return {
          curriculum = current_curriculum,
          block = block_slug,
        }
      end
    end
  end

  return nil
end

--- Check if a specific block is marked as complete
---@param curriculum string Curriculum slug (e.g., "01-tools-engineering")
---@param block string Block slug (e.g., "01-systems-architecture")
---@return boolean
function M.is_block_complete(curriculum, block)
  local root = utils.get_project_root()
  if not root then
    return false
  end

  local catalog_path = root .. "/catalog.md"
  if vim.fn.filereadable(catalog_path) ~= 1 then
    return false
  end

  local lines = vim.fn.readfile(catalog_path)
  if not lines or #lines == 0 then
    return false
  end

  for _, line in ipairs(lines) do
    -- Look for checked item matching the block
    if line:match("^%- %[x%]") or line:match("^%- %[X%]") then
      if line:match(curriculum) and line:match(block) then
        return true
      end
    end
  end

  return false
end

return M
