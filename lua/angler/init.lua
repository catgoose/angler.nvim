local e, cnf = require("angler.edit"), require("angler.config")

M = {}

M.setup = function(config)
	config = cnf.init(config)
end

M.component = function(config)
	return e.component(config)
end

M.open_cwd = function(config)
	return e.cwd(config)
end

return M
