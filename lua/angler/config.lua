local M = {
	opts = {
		dev = false,
	},
}

local dev = function()
	require("angler.utils").dev()
end

M.init = function(opts)
	opts = opts or {}
	M.opts = vim.tbl_deep_extend("keep", opts, M.opts)
	if M.opts.dev then
		dev()
	end
	return M.opts
end

M.split = function(config)
	config = config or {}
	local defaults = {
		extension = nil,
		split = false,
		direction = "right",
	}
	return vim.tbl_extend("keep", config, defaults)
end

M.cwd = function(config)
	config = config or {}
	local defaults = {
		order = "next",
	}
	local cfg = vim.tbl_extend("keep", config, defaults)
	cfg.direction = cfg.order == "next" and 1 or -1
	return cfg
end

return M
