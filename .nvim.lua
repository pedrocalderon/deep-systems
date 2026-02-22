-- VIBE CODED
-- Bootstrap loader for project-local Neovim configuration
-- This file is loaded automatically when vim.opt.exrc is enabled

-- Detect project root from this script's location
local script_path = debug.getinfo(1, "S").source:sub(2)
local project_root = vim.fn.fnamemodify(script_path, ":p:h")

-- Prepend .nvim/ to runtimepath so our modules can be required
local nvim_path = project_root .. "/.nvim"
vim.opt.runtimepath:prepend(nvim_path)

-- Load the project plugin
local ok, err = pcall(function()
	require("project_nvim").setup()
end)

if not ok then
	vim.notify("Failed to load project_nvim: " .. tostring(err), vim.log.levels.ERROR)
end
