local e, cnf = require("angler.edit"), require("angler.config")

M = {}

M.setup = function(config)
	config = config or {}
	cnf.init(config)
end

M.open = function(config)
	return e.open(config)
end

M.open_cwd = function(config)
	return e.cwd(config)
end

return M
