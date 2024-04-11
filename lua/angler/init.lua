local config = require("angler.config")

local M = {}

function M.setup(opts)
	opts = opts or {}
	config.set_opts(opts)
	M.Log = require("angler.logger").init()
end

function M.open(opts)
	opts = opts or {}
	return require("angler.edit").open(opts)
end

function M.open_cwd(opts)
	opts = opts or {}
	return require("angler.edit").cwd(opts)
end

function M.ts_fix_all(opts)
	opts = opts or { sync = true }
	require("angler.typescript").fix_all(opts)
end

return M
