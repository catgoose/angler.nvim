local e, cnf, ts = require("angler.edit"), require("angler.config"), require("angler.typescript")

local M = {}

M.setup = function(config)
	config = config or {}
	cnf.init(config)
end

M.open = function(config)
	config = config or {}
	return e.open(config)
end

M.open_cwd = function(config)
	return e.cwd(config)
end

M.ts_fix_all = function(config)
	config = config or { sync = true }
	ts.fix_all(config)
end

return M
