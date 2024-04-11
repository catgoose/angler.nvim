local M = {}

local default_log_level = "warn"

local _opts = {
	log_level = default_log_level,
	log_levels = { "trace", "debug", "info", "warn", "error", "fatal" },
}

function M.split(opts)
	local defaults = {
		extension = nil,
		split = false,
		direction = "right",
	}
	return vim.tbl_extend("keep", opts, defaults)
end

function M.cwd(opts)
	opts = opts or {}
	local defaults = {
		order = "next",
	}
	local cfg = vim.tbl_extend("keep", opts, defaults)
	return cfg
end

function M.set_opts(opts)
	opts = opts or {}
	_opts = vim.tbl_deep_extend("keep", opts, _opts)
	return M.get_opts()
end

function M.get_opts()
	return {
		log_level = _opts.log_level,
	}
end

return M
