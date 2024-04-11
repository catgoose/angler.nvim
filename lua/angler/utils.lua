local M = {}

function M.component_name(extension)
	local file_parts = vim.split(vim.fn.expand("%:t"), "component", { plain = true })
	local file = vim.fn.expand("%:h") .. "/" .. file_parts[1] .. "component" .. "." .. extension
	if vim.fn.filereadable(file) == 1 then
		return file
	end
	return false
end

function M.create_cmd(command, f, opts)
	opts = opts or {}
	vim.api.nvim_create_user_command(command, f, opts)
end

function M.get_loaded_bufs()
	local bufs = {}
	for _, buf in ipairs(vim.api.nvim_list_bufs()) do
		if vim.api.nvim_buf_is_loaded(buf) then
			table.insert(bufs, buf)
		end
	end
	return bufs
end

function M.string_format(msg, ...)
	local args = { ... }
	for i, v in ipairs(args) do
		if type(v) == "table" then
			args[i] = vim.inspect(v)
		end
	end
	return string.format(msg, unpack(args))
end

return M
