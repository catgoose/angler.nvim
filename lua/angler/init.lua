local cnf = require("angler.config")
local e = require("angler.edit")

local M = {}

M.setup = function(config)
  config = config or {}
  cnf.init(config)
end

M.open = function(config)
  config = config or {}
  return e.open(config)
end

M.open_cwd = function(config)
  return e.cwd(config)
end

return M
