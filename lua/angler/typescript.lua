local cmd, fn, ui, lsp, api = vim.cmd, vim.fn, vim.ui, vim.lsp, vim.api
local utils = require("angler.utils")

local Typescript = {}

local compile = function()
	local isVolar = vim.lsp.get_clients({ name = "volar" })[1] ~= nil
	if isVolar then
		cmd.compiler("vue-tsc")
		cmd.make("--noEmit -p tsconfig.vitest.json --composite false")
	else
		cmd.compiler("tsc")
		cmd.make("--noEmit")
	end
end

Typescript.compile_ts = function()
	-- if not is_ts() then
	-- 	return
	-- end
	compile()
	if #vim.fn.getqflist() > 0 then
		cmd.copen()
		-- cmd.cwindow()
	end
end

local fix_typescript = function()
	local ts = require("typescript")
	local sync = { sync = true }
	ts.actions.addTypescriptissingImports(sync)
	ts.actions.removeUnused(sync)
	ts.actions.organizeImports(sync)
end

local fix_vue = function()
	local titles = {
		"Add all missing imports",
		"Organize Imports",
		-- "Fix All",
	}
	for _, title in pairs(titles) do
		vim.lsp.buf.code_action({
			context = {
				only = { "source", "source.organizeImports" },
			},
			filter = function(ca)
				return string.find(ca.title, title)
			end,
			apply = true,
		})
	end
end

--  TODO: 2023-11-11 - This doesn't work great for vue
Typescript.fix_all = function(config)
	config = config or { sync = true }
	if not utils.is_typescript() then
		return
	end
	local isVolar = vim.lsp.get_clients({ name = "volar" })[1] ~= nil
	if isVolar then
		fix_vue()
	else
		fix_typescript()
	end
end

--  TODO: 2023-11-11 - implement write_all
Typescript.rename_file = function()
	if not utils.is_typescript() then
		return
	end
	local file_name = fn.expand("%:t")
	ui.input({ prompt = "Angler: Rename file> ", default = file_name }, function(input)
		if not input then
			return
		end
		local old_file = fn.expand("%:p:h") .. "/" .. file_name
		local new_file = fn.expand("%:p:h") .. "/" .. input
		require("typescript").renameFile(old_file, new_file)
	end)
end

Typescript.rename_symbol = function()
	local pos_param = lsp.util.make_position_params()
	local loaded_bufs = utils.get_loaded_bufs()
	pos_param.oldName = fn.expand("<cword>")
	ui.input({ prompt = "Angler: Rename to> ", default = pos_param.oldName }, function(input)
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
				vim.schedule(function()
					api.nvim_buf_call(bufnr, function()
						cmd.write()
						if not vim.tbl_contains(loaded_bufs, bufnr) then
							api.nvim_buf_delete(bufnr, { force = false, unload = true })
						end
					end)
				end)
			end
		end)
	end)
end

return Typescript
