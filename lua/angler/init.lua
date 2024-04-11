local edit = require("angler.edit")
local config = require("angler.config")
local typescript = require("angler.typescript")

local M = {}

function M.setup(opts)
	opts = opts or {}
	config.set_opts(opts)
	M.Log = require("angler.logger").init()
end

function M.open(opts)
	opts = opts or {}
	return edit.open(opts)
end

function M.open_cwd(opts)
	return edit.cwd(opts)
end

function M.ts_fix_all(opts)
	opts = opts or { sync = true }
	typescript.fix_all(opts)
end

return M
