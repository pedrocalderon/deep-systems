-- Frontmatter module: YAML parsing and serialization
local M = {}

local utils = require("project_nvim.utils")

-- Canonical field order for serialization
M.FIELD_ORDER = {
  "id",
  "created",
  "updated",
  "type",
  "curriculum",
  "block",
  "book",
  "concepts",
  "tags",
  "aliases",
}

--- Parse a flow-style YAML array: [item1, item2, item3]
---@param str string The array string including brackets
---@return table Array of items
local function parse_flow_array(str)
  local items = {}
  -- Remove brackets and trim
  local content = str:match("^%[(.*)%]$")
  if not content then
    return items
  end

  content = utils.trim(content)
  if content == "" then
    return items -- Empty array
  end

  -- Split by comma, handling quoted strings
  local i = 1
  while i <= #content do
    local char = content:sub(i, i)

    if char == '"' or char == "'" then
      -- Quoted string
      local quote = char
      local j = i + 1
      while j <= #content do
        if content:sub(j, j) == quote then
          local item = content:sub(i + 1, j - 1)
          table.insert(items, item)
          -- Skip past closing quote and comma
          i = j + 1
          while i <= #content and content:sub(i, i):match("[%s,]") do
            i = i + 1
          end
          break
        end
        j = j + 1
      end
      if j > #content then
        i = j -- Unclosed quote, move past
      end
    elseif char:match("%s") then
      -- Skip whitespace
      i = i + 1
    else
      -- Unquoted value - read until comma or end
      local j = i
      while j <= #content and content:sub(j, j) ~= "," do
        j = j + 1
      end
      local item = utils.trim(content:sub(i, j - 1))
      if item ~= "" then
        table.insert(items, item)
      end
      i = j + 1 -- Skip past comma
    end
  end

  return items
end

--- Parse YAML frontmatter from buffer lines
---@param lines table Array of lines
---@return table|nil parsed { data: table, start_line: number, end_line: number } or nil
function M.parse(lines)
  if not lines or #lines == 0 then
    return nil
  end

  -- Check for opening delimiter
  if utils.trim(lines[1]) ~= "---" then
    return nil
  end

  -- Find closing delimiter
  local end_line = nil
  for i = 2, #lines do
    if utils.trim(lines[i]) == "---" then
      end_line = i
      break
    end
  end

  if not end_line then
    return nil
  end

  -- Parse YAML content
  local data = {}
  local current_key = nil
  local current_array = nil

  for i = 2, end_line - 1 do
    local line = lines[i]

    -- Check for array item (indented with -)
    local array_value = line:match("^%s+%-%s*(.*)$")
    if array_value and current_key then
      if not current_array then
        current_array = {}
        data[current_key] = current_array
      end
      -- Handle quoted strings
      local unquoted = array_value:match("^[\"'](.+)[\"']$") or array_value
      table.insert(current_array, utils.trim(unquoted))
    else
      -- Check for key-value pair
      local key, value = line:match("^([%w_-]+):%s*(.*)$")
      if key then
        current_key = key
        current_array = nil
        value = utils.trim(value)

        if value == "" then
          -- Empty value, might be followed by array
          data[key] = nil
        elseif value:match("^%[.*%]$") then
          -- Flow-style array: [item1, item2, ...]
          local items = parse_flow_array(value)
          if #items > 0 then
            data[key] = items
          else
            data[key] = nil -- Empty array treated as nil
          end
        else
          -- Handle quoted strings
          local unquoted = value:match("^[\"'](.+)[\"']$") or value
          data[key] = unquoted
        end
      end
    end
  end

  return {
    data = data,
    start_line = 1,
    end_line = end_line,
  }
end

--- Serialize a single field to YAML lines
---@param lines table Output lines array
---@param key string Field key
---@param value any Field value
local function serialize_field(lines, key, value)
  if value == nil then
    -- Output empty field
    table.insert(lines, key .. ":")
  elseif type(value) == "table" then
    -- Array field
    table.insert(lines, key .. ":")
    for _, item in ipairs(value) do
      table.insert(lines, "  - " .. tostring(item))
    end
  else
    -- Scalar field
    table.insert(lines, key .. ": " .. tostring(value))
  end
end

--- Serialize frontmatter data to YAML lines
---@param data table Frontmatter data
---@param context table Context with curriculum/block info
---@return table Array of lines
function M.serialize(data, context)
  local lines = { "---" }
  local serialized = {}

  -- First, output canonical fields in order
  for _, key in ipairs(M.FIELD_ORDER) do
    -- Skip curriculum/block for thinking context
    if context and context.omit_curriculum_block then
      if key == "curriculum" or key == "block" then
        serialized[key] = true
        goto continue
      end
    end

    serialize_field(lines, key, data[key])
    serialized[key] = true

    ::continue::
  end

  -- Then, output any extra fields that aren't in FIELD_ORDER
  for key, value in pairs(data) do
    if not serialized[key] then
      serialize_field(lines, key, value)
    end
  end

  table.insert(lines, "---")
  return lines
end

--- Create new frontmatter with defaults
---@param context table Context from path detection
---@return table Frontmatter data
function M.create_default(context)
  local id = utils.generate_id(10)
  local timestamp = utils.get_timestamp()

  local data = {
    id = id,
    created = timestamp,
    updated = timestamp,
    type = context.type_default or "note",
    curriculum = context.curriculum or nil,
    block = context.block or nil,
    book = nil,
    concepts = nil,
    tags = nil,
    aliases = { id },
  }

  return data
end

--- Update existing frontmatter (updates timestamp, adds missing fields)
---@param existing table Existing frontmatter data
---@param context table Context from path detection
---@return table Updated frontmatter data
function M.update(existing, context)
  local data = utils.deep_copy(existing)

  -- Always update timestamp
  data.updated = utils.get_timestamp()

  -- Add missing fields with defaults
  if not data.id then
    data.id = utils.generate_id(10)
  end

  if not data.created then
    data.created = data.updated
  end

  if not data.type then
    data.type = context.type_default or "note"
  end

  -- Only add curriculum/block if not in thinking context
  if not context.omit_curriculum_block then
    if not data.curriculum and context.curriculum then
      data.curriculum = context.curriculum
    end

    if not data.block and context.block then
      data.block = context.block
    end
  end

  -- Ensure aliases includes id
  if not data.aliases then
    data.aliases = { data.id }
  elseif type(data.aliases) == "table" then
    local has_id = false
    for _, alias in ipairs(data.aliases) do
      if alias == data.id then
        has_id = true
        break
      end
    end
    if not has_id then
      table.insert(data.aliases, 1, data.id)
    end
  end

  return data
end

return M
