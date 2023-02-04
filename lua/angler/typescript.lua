local cmd, fn, ui, lsp, api = vim.cmd, vim.fn, vim.ui, vim.lsp, vim.api
local u = require("angler.utils")

local M = {}

local is_ts = function()
	return vim.bo.filetype == "typescript"
end

local compile = function()
	cmd.compiler("tsc")
	cmd.make("--noEmit")
end

M.quick_fix = function()
	if not is_ts() then
		return
	end
	compile()
	cmd.cwindow()
end

M.fix_all = function(config)
	config = config or { sync = true }
	if not is_ts() then
		return
	end
	local ts = require("typescript")
	local sync = { sync = true }
	ts.actions.addMissingImports(sync)
	ts.actions.removeUnused(sync)
	ts.actions.organizeImports(sync)
end

M.rename_file = function()
	if not is_ts() then
		return
	end
	local file_name = fn.expand("%:t")
	ui.input({ prompt = "Rename file> ", default = file_name }, function(input)
		if not input then
			return
		end
		local old_file = fn.expand("%:p:h") .. "/" .. file_name
		local new_file = fn.expand("%:p:h") .. "/" .. input
		require("typescript").renameFile(old_file, new_file)
	end)
end

M.rename_symbol = function()
	local pos_param = lsp.util.make_position_params()
	local loaded_bufs = u.get_loaded_bufs()
	pos_param.oldName = fn.expand("<cword>")
	ui.input({ prompt = "Rename to> ", default = pos_param.oldName }, function(input)
		if not input then
			return
		end
		pos_param.newName = input
		lsp.buf_request(0, "textDocument/rename", pos_param, function(err, result, ...)
			if not result or not result.changes then
				vim.notify(
					string.format("could not perform rename: %s --> %s", pos_param.oldName, pos_param.newName),
					vim.log.levels.ERROR
				)
				return
			end
			lsp.handlers["textDocument/rename"](err, result, ...)
			for uri, _ in pairs(result.changes) do
				local bufnr = vim.uri_to_bufnr(uri)
				vim.defer_fn(function()
					api.nvim_buf_call(bufnr, function()
						cmd.write()
						-- close bufs that were opened to rename symbol
						if not vim.tbl_contains(loaded_bufs, bufnr) then
							api.nvim_buf_delete(bufnr, { force = true })
						end
					end)
				end, 0)
			end
		end)
	end)
end

return M
