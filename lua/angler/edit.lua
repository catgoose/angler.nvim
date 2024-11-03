local cfg = require("angler.config")
local u = require("angler.utils")

local M = {}

local split_edit = function(config, file)
  config = config or {}
  if config.split == true then
    if config.direction == "right" then
      vim.cmd("vs")
    elseif config.direction == "down" then
      vim.cmd("sv")
    end
  end
  vim.cmd.edit(file)
end

M.open = function(config)
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

M.cwd = function(config)
  config = config or {}
  config = cfg.cwd(config)
  local file = u.next_file_in_cwd(config)
  vim.cmd.edit(file)
end

return M
