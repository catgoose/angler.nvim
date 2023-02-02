local u = require("angler.utils")
local cmd = vim.cmd

local M = {}

M.new_component = function()
	if not u.file_has_extension("ts") then
		return
	end
	cmd([[silent! %s/^.*constructor.*$\n.*$//]])
	cmd([[silent! %s/^.*ngOnInit.*$\n.*$//]])
	cmd([[silent! %s/, OnInit//]])
	cmd([[silent! %s/ implements OnInit//]])
end

return M
