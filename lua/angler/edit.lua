local config = require("angler.config")
local utils = require("angler.utils")
local Log = require("angler").Log
local sf = require("angler.utils").string_format

local M = {}

local function split_edit(opts, file)
	opts = opts or {}
	if opts.split == true then
		if opts.direction == "right" then
			vim.cmd("vs")
		elseif opts.direction == "down" then
			vim.cmd("sv")
		end
	end
	vim.cmd.edit(file)
end

function M.open(opts)
	opts = config.split(opts)
	if not opts.extension then
		return
	end
	local file = utils.component_name(opts.extension)
	if not file then
		return
	end
	split_edit(opts, file)
end

--  TODO: 2024-04-17 - accept config to return hidden files
--  TODO: 2024-04-17 - handle hidden files correctly
local function files_in_cwd()
	local files = {}
	for _, file in ipairs(vim.split(vim.fn.glob(vim.fn.expand("%:h") .. "/*"), "\n", { plain = true })) do
		if vim.fn.filereadable(file) == 1 then
			if file:match("^./") then
				file = file:sub(3)
			end
			files[#files + 1] = file
		end
	end
	return files
end

local function tbl_index(tbl, value)
	for i, v in ipairs(tbl) do
		if v == value then
			return i
		end
	end
	return nil
end

local function next_file_in_cwd(opts)
	opts = opts or { order = "next" }
	if not vim.tbl_contains({ "next", "prev" }, opts.order) then
		return
	end
	opts.idx_delta = opts.order == "next" and 1 or -1
	Log.trace(sf(
		[[edit._next_file_in_cwd: getting next file in cwd with opts: 

  %s
  ]],
		opts
	))
	local files = files_in_cwd()
	Log.trace(sf(
		[[edit._next_file_in_cwd: found files in cwd:

  %s
  ]],
		files
	))
	local index = tbl_index(files, vim.fn.expand("%"))
	Log.trace(sf("edit._next_file_in_cwd: current file index %s and number of files %s", index, #files))
	if #files == 1 then
		return files[1]
	end
	if opts.order == "next" and index == #files then
		return files[1]
	end
	if opts.order == "prev" and index == 1 then
		return files[#files]
	end
	return files[index + opts.idx_delta]
end

function M.cwd(opts)
	opts = config.cwd(opts)
	Log.trace(sf(
		[[edit.cwd: opening file in cwd with opts:

  %s
  ]],
		opts
	))
	local file = next_file_in_cwd(opts)
	Log.debug(sf("edit.cwd: found file in cwd: %s", file))
	vim.cmd.edit(file)
end

return M
