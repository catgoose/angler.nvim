# angler.nvim

A collection of Angular tools that I extracted out of my neovim config. The "edit"
API can be used elsewhere since it takes an extension as a parameter.

## API

### open

- Opens file in cwd that shares basename with the current file with the
  supplied extension appended

Call `require("angler")` with `.open(config)` or `.open_cwd(config)`
Open takes the following configuration parameter:

```lua
{
  extension = "ext", -- file extension to open that shares basename
  --of current file
  split = true -- split right
}
```

### open_cwd

## Example setup with Lazy.nvim

```lua
local plugin = {
  opts = opts,
  keys = {
    {"<leader>gc", [[require("angler").open({extension = "ts"})]]},
    {"<leader>gh", [[require("angler").open({extension = "html"})]]},
    {"<leader>gt", [[require("angler").open({extension = "html", split = true})]]},
    {"<leader>gd", [[require("angler").open({extension = "scss"})]]},
    {"<leader>gs", [[require("angler").open({extension = "scss", split = "true"})]]},
    {"<leader>gf", [[require("angler").open({extension = "spec.ts"})]]},
    {"<leader>gn", [[require("angler").open_cwd({order = "next"})]]},
    {"<leader>gp", [[require("angler").open_cwd({order = "prev"})]]},
    {"<leader>tc", [[AnglerPopulateQF]]},
    {"<leader>tf", [[AnglerRenameFile]]},
    {"<leader>k", [[AnglerFixAll]]},
  },
  ft = "typescript",
  dependencies = "jose-elias-alvarez/typescript.nvim",
}
```
