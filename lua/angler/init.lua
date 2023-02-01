M = {}

M.setup = function(config)
	M.config = config
	M.config = vim.tbl_deep_extend("force", M.config, {
		-- default config
		-- ...
	})
end

return M
