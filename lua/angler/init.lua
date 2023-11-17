local e, cnf, ts = require("angler.edit"), require("angler.config"), require("angler.typescript")

Angler = {}

Angler.setup = function(config)
	config = config or {}
	cnf.init(config)
end

Angler.open = function(config)
	config = config or {}
	return e.open(config)
end

Angler.open_cwd = function(config)
	return e.cwd(config)
end

Angler.ts_fix_all = function(config)
	config = config or { sync = true }
	ts.fix_all(config)
end

return Angler
