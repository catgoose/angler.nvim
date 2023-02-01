local fn, split = vim.fn, vim.split

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

M.file_has_extension = function(extension)
	local cur_name = vim.api.nvim_buf_get_name(0)
	local tbl_file = vim.split(cur_name, ".", { plain = true })
	return tbl_file[#tbl_file] == extension
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
			files[#files + 1] = file
		end
	end
	return files
end

M.next_file_in_cwd = function(config)
	local files = files_in_cwd()
	local index = tbl_index(files, vim.fn.expand("%"))
	if #files <= 1 then
		return files[1]
	end
	if index == #files and config.order == "next" then
		return files[1]
	end
	if index == #files and config.order == "prev" then
		return files[#files]
	end
	return files[index + config.direction]
end

M.base_name = function(extension)
	local cur_name = vim.api.nvim_buf_get_name(0)
	local tbl_file = split(cur_name, ".", { plain = true })
	if tbl_file[#tbl_file - 1] .. "." .. tbl_file[#tbl_file] == "spec.ts" then
		tbl_file[#tbl_file - 1] = nil
	end
	tbl_file[#tbl_file] = nil
	for i, n in ipairs(tbl_file) do
		tbl_file[i] = n .. "."
	end
	tbl_file[#tbl_file + 1] = extension
	local str_file = table.concat(tbl_file, "")
	if fn.filereadable(str_file) ~= 1 then
		return false
	end
	return table.concat(tbl_file)
end

return M
