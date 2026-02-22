-- Utils module: ID generation, timestamps, and helper functions
local M = {}

-- Character set for ID generation (lowercase alphanumeric)
local ID_CHARS = "abcdefghijklmnopqrstuvwxyz0123456789"

--- Generate a random alphanumeric ID
---@param length number Length of the ID (default 10)
---@return string
function M.generate_id(length)
  length = length or 10
  local id = {}

  -- Seed random with current time and process ID for uniqueness
  math.randomseed(os.time() + (vim.fn.getpid() or 0))

  for _ = 1, length do
    local idx = math.random(1, #ID_CHARS)
    table.insert(id, ID_CHARS:sub(idx, idx))
  end

  return table.concat(id)
end

--- Get current timestamp in ISO 8601 format with timezone offset
---@return string
function M.get_timestamp()
  local now = os.time()
  local utc = os.date("!*t", now)
  local local_time = os.date("*t", now)

  -- Calculate timezone offset
  local utc_timestamp = os.time(utc)
  local offset_seconds = now - utc_timestamp
  local offset_hours = math.floor(math.abs(offset_seconds) / 3600)
  local offset_minutes = math.floor((math.abs(offset_seconds) % 3600) / 60)
  local offset_sign = offset_seconds >= 0 and "+" or "-"

  return string.format(
    "%04d-%02d-%02dT%02d:%02d:%02d%s%02d:%02d",
    local_time.year,
    local_time.month,
    local_time.day,
    local_time.hour,
    local_time.min,
    local_time.sec,
    offset_sign,
    offset_hours,
    offset_minutes
  )
end

--- Find the project root directory (containing .nvim.lua)
---@return string|nil
function M.get_project_root()
  -- First try to find from current buffer
  local buf_path = vim.api.nvim_buf_get_name(0)
  if buf_path and buf_path ~= "" then
    local dir = vim.fn.fnamemodify(buf_path, ":p:h")
    while dir and dir ~= "/" do
      if vim.fn.filereadable(dir .. "/.nvim.lua") == 1 then
        return dir
      end
      dir = vim.fn.fnamemodify(dir, ":h")
    end
  end

  -- Fallback to current working directory search
  local cwd = vim.fn.getcwd()
  while cwd and cwd ~= "/" do
    if vim.fn.filereadable(cwd .. "/.nvim.lua") == 1 then
      return cwd
    end
    cwd = vim.fn.fnamemodify(cwd, ":h")
  end

  return nil
end

--- Get relative path from project root
---@param filepath string Absolute file path
---@return string|nil Relative path or nil if not in project
function M.get_relative_path(filepath)
  local root = M.get_project_root()
  if not root then
    return nil
  end

  local abs_path = vim.fn.fnamemodify(filepath, ":p")
  if abs_path:sub(1, #root) == root then
    return abs_path:sub(#root + 2) -- +2 to skip trailing slash
  end

  return nil
end

--- Check if a file path should be skipped
---@param filepath string
---@return boolean
function M.should_skip_file(filepath)
  local rel_path = M.get_relative_path(filepath)
  if not rel_path then
    return true
  end

  -- Skip files in .git/ and code/ directories
  if rel_path:match("^%.git/") or rel_path:match("/code/") or rel_path:match("^code/") then
    return true
  end

  return false
end

--- Deep copy a table
---@param t table
---@return table
function M.deep_copy(t)
  if type(t) ~= "table" then
    return t
  end

  local copy = {}
  for k, v in pairs(t) do
    copy[k] = M.deep_copy(v)
  end
  return copy
end

--- Trim whitespace from string
---@param s string
---@return string
function M.trim(s)
  return s:match("^%s*(.-)%s*$")
end

return M
