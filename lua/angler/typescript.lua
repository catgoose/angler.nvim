local u = require("angler.utils")
local Log = require("angler").Log
local sf = require("angler.utils").string_format

--  TODO: 2023-08-13 - make these actions compatible with volar when in vue
--  workspace.  Use folke/neoconf?
local M = {}

local function is_ts()
  local fts = { "typescript", "typescriptreact", "typescript.tsx", "vue" }
  local contains = vim.tbl_contains(fts, vim.api.nvim_get_option_value("filetype", { buf = 0 }))
  return contains
end

local compiler_settings = {
  vue = {
    compiler = "vue-tsc",
    make = "--noEmit -p tsconfig.vitest.json",
  },
  typescript = {
    compiler = "tsc",
    make = "--noEmit",
  },
}

local function compile()
  local isVolar = vim.fn.filereadable("vite.config.ts") == 1
  local compiler = isVolar and "vue" or "typescript"
  if vim.fn.executable(compiler_settings[compiler].compiler) == 1 then
    vim.cmd.compiler(compiler_settings[compiler].compiler)
    vim.cmd.make(compiler_settings[compiler].make)
  else
    Log.warn(sf("typescript.compile: %s not found", compiler_settings[compiler].compiler))
  end
end

function M.compile_ts()
  compile()
  if #vim.fn.getqflist() > 0 then
    vim.cmd.copen()
  end
end

local function fix_typescript()
  local ts = require("typescript")
  local sync = { sync = true }
  ts.actions.addMissingImports(sync)
  ts.actions.removeUnused(sync)
  ts.actions.organizeImports(sync)
end

local function fix_vue()
  local titles = {
    "Add all missing imports",
    -- "Organize Imports",
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

function M.fix_all(config)
  config = config or { sync = true }
  if not is_ts() then
    return
  end
  local isVolar = vim.lsp.get_clients({ name = "volar" })[1] ~= nil
  if isVolar then
    fix_vue()
  else
    fix_typescript()
  end
end

function M.rename_file()
  if not is_ts() then
    return
  end
  local file_name = vim.fn.expand("%:t")
  vim.ui.input({ prompt = "Rename file> ", default = file_name }, function(input)
    if not input then
      return
    end
    local old_file = vim.fn.expand("%:p:h") .. "/" .. file_name
    local new_file = vim.fn.expand("%:p:h") .. "/" .. input
    require("typescript").renameFile(old_file, new_file)
  end)
end

function M.rename_symbol()
  local pos_param = vim.lsp.util.make_position_params()
  local loaded_bufs = u.get_loaded_bufs()
  pos_param.oldName = vim.fn.expand("<cword>")
  vim.ui.input({ prompt = "Rename to> ", default = pos_param.oldName }, function(input)
    if not input then
      return
    end
    pos_param.newName = input
    vim.lsp.buf_request(0, "textDocument/rename", pos_param, function(err, result, ...)
      if not result or not result.changes then
        vim.notify(
          string.format("could not perform rename: %s --> %s", pos_param.oldName, pos_param.newName),
          vim.log.levels.ERROR
        )
        return
      end
      vim.lsp.handlers["textDocument/rename"](err, result, ...)
      for uri, _ in pairs(result.changes) do
        local bufnr = vim.uri_to_bufnr(uri)
        vim.defer_fn(function()
          vim.api.nvim_buf_call(bufnr, function()
            vim.cmd.write()
            -- close bufs that were opened to rename symbol
            if not vim.tbl_contains(loaded_bufs, bufnr) then
              vim.api.nvim_buf_delete(bufnr, { force = false, unload = true })
            end
          end)
        end, 0)
      end
    end)
  end)
end

return M
