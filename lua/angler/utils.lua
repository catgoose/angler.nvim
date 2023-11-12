local fn, split, api = vim.fn, vim.split, vim.api

local M = {}

M.dev = function()
	P = function(...)
		local tbl = {}
		for i = 1, select("#", ...) do
			local v = select(i, ...)
			table.insert(tbl, vim.inspect(v))
		end

		print(table.concat(tbl, "\n"))
		return ...
	end
end

local tbl_index = function(tbl, value)
	for i, v in ipairs(tbl) do
		if v == value then
			return i
		end
	end
	return nil
end

local files_in_cwd = function()
	local files = {}
	for _, file in ipairs(split(fn.glob(fn.expand("%:h") .. "/*"), "\n", { plain = true })) do
		if fn.filereadable(file) == 1 then
			if file:match("^./") then
				file = file:sub(3)
			end
			files[#files + 1] = file
		end
	end
	return files
end

M.next_file_in_cwd = function(config)
	config = config or { order = "next" }
	local files = files_in_cwd()
	local index = tbl_index(files, vim.fn.expand("%"))
	if #files <= 1 then
		return files[1]
	end
	if index == #files and config.order == "next" then
		return files[1]
	end
	if (index == 1 or index == #files) and config.order == "prev" then
		return files[#files]
	end
	return files[index + config.direction]
end

M.component_name = function(extension)
	local cur_file = vim.fn.expand("%:t")
	cur_file = type(cur_file) == "string" and cur_file or cur_file[1]
	local file_parts = vim.split(cur_file, "component", { plain = true })
	local file = vim.fn.expand("%:h") .. "/" .. file_parts[1] .. "component" .. "." .. extension
	if vim.fn.filereadable(file) == 1 then
		return file
	end
	return false
end

M.create_cmd = function(command, f, opts)
	opts = opts or {}
	api.nvim_create_user_command(command, f, opts)
end

M.get_loaded_bufs = function()
	local bufs = {}
	for _, buf in ipairs(api.nvim_list_bufs()) do
		if api.nvim_buf_is_loaded(buf) then
			table.insert(bufs, buf)
		end
	end
	return bufs
end

return M
