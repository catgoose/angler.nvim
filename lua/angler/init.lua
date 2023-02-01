local u, e = require("angler.utils"), require("angler.edit")
local cnf = require("angler.config")
M = {}

M.setup = function(config)
	config = cnf.init(config)
end

M.open = function(config)
	return e.angler(config)
end

M.open_cwd = function(config)
	return e.cwd(config)
end

return M
