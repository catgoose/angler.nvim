local Config = {
	opts = {
		dev = false,
	},
}

local dev = function()
	require("angler.utils").dev()
end

Config.init = function(opts)
	opts = opts or {}
	Config.opts = vim.tbl_deep_extend("keep", opts, Config.opts)
	if Config.opts.dev then
		dev()
	end
	return Config.opts
end

Config.split = function(config)
	config = config or {}
	local defaults = {
		extension = nil,
		split = false,
		direction = "right",
	}
	return vim.tbl_extend("keep", config, defaults)
end

Config.cwd = function(config)
	config = config or {}
	local defaults = {
		order = "next",
	}
	local cfg = vim.tbl_extend("keep", config, defaults)
	cfg.direction = cfg.order == "next" and 1 or -1
	return cfg
end

return Config
