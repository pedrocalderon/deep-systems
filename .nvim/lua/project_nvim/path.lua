-- Path module: Extract curriculum and block from file paths
local M = {}

local utils = require("project_nvim.utils")

--- File context types
M.CONTEXT = {
  CURRICULA = "curricula",
  NOTES = "notes",
  THINKING = "thinking",
  OTHER = "other",
}

--- Detect file context from path
---@param filepath string
---@return table { context: string, curriculum: string|nil, block: string|nil, type_default: string }
function M.detect_context(filepath)
  local rel_path = utils.get_relative_path(filepath)
  if not rel_path then
    return { context = M.CONTEXT.OTHER, curriculum = nil, block = nil, type_default = "note" }
  end

  -- Check for curricula path: curricula/XX-name/YY-block/...
  local curriculum, block = rel_path:match("^curricula/(%d%d%-[^/]+)/(%d%d%-[^/]+)/")
  if curriculum and block then
    return {
      context = M.CONTEXT.CURRICULA,
      curriculum = curriculum,
      block = block,
      type_default = "note",
    }
  end

  -- Check for curricula root (no block yet)
  curriculum = rel_path:match("^curricula/(%d%d%-[^/]+)/[^/]+%.md$")
  if curriculum then
    return {
      context = M.CONTEXT.CURRICULA,
      curriculum = curriculum,
      block = nil,
      type_default = "overview",
    }
  end

  -- Check for notes directory
  if rel_path:match("^notes/") then
    return {
      context = M.CONTEXT.NOTES,
      curriculum = nil, -- Will be filled from catalog
      block = nil,      -- Will be filled from catalog
      type_default = "note",
    }
  end

  -- Check for thinking directory
  if rel_path:match("^thinking/") then
    return {
      context = M.CONTEXT.THINKING,
      curriculum = nil, -- Omitted for thinking
      block = nil,      -- Omitted for thinking
      type_default = "reflection",
    }
  end

  -- Other/root files
  return {
    context = M.CONTEXT.OTHER,
    curriculum = nil,
    block = nil,
    type_default = "note",
  }
end

--- Extract human-readable name from kebab-case with number prefix
--- e.g., "01-systems-architecture" -> "Systems Architecture"
---@param slug string
---@return string
function M.slug_to_title(slug)
  -- Remove number prefix if present
  local name = slug:gsub("^%d+%-", "")

  -- Split by hyphens and capitalize
  local words = {}
  for word in name:gmatch("[^%-]+") do
    table.insert(words, word:sub(1, 1):upper() .. word:sub(2))
  end

  return table.concat(words, " ")
end

return M
