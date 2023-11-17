local c = vim.cmd
local u, cfg = require("angler.utils"), require("angler.config")

local Edit = {}

local split_edit = function(config, file)
	config = config or {}
	if config.split == true then
		if config.direction == "right" then
			c("vs")
		elseif config.direction == "down" then
			c("sv")
		end
	end
	c.edit(file)
end

Edit.open = function(config)
	config = config or {}
	config = cfg.split(config)
	if not config.extension then
		return false
	end
	local file = u.component_name(config.extension)
	if not file then
		return false
	end
	split_edit(config, file)
end

Edit.cwd = function(config)
	config = config or {}
	config = cfg.cwd(config)
	local file = u.next_file_in_cwd(config)
	c.edit(file)
end

return Edit
