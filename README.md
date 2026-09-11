# vyStatusline

Personal statusline plugin for Neovim

No other plugins are required.
`nvim-web-devicons` is optional — install it if you want filetype icons.
`gitsigns.nvim` is also optional — git segments appear automatically if it's
installed.

## Installation

**lazy.nvim**

```lua
{
  "VyLowry7337/vyStatusline.nvim",
  event = "VeryLazy",
  config = function()
    require("vyStatusline").setup()
  end,
}
```

**vim.pack**

```bash
git clone https://github.com/VyLowry7337/vyStatusline.nvim \
  ~/.local/share/nvim/site/pack/plugins/start/vyStatusline.nvim
```

Then in your config:
```lua
require("vyStatusline").setup()
```


## Configuration

```lua
require("vyStatusline").setup({
  order = {
    "filetype",
    "lsp",
    "git_branch",
    "git_diff",
    "spacer",
    "lsp_progress",
    "spacer",
    "diagnostics",
    "cwd",
    "cursor",
  },
})
```

Available segments:

| Segment | Description |
|---|---|
| `mode` | Current mode with highlight |
| `filetype` | Filetype icon + name |
| `git_branch` | Git branch (requires gitsigns) |
| `git_diff` | Git add/change/delete counts (requires gitsigns) |
| `diagnostics` | LSP error/warning/hint/info counts |
| `lsp` | Active LSP client name |
| `cwd` | Current working directory |
| `lsp_progress` | Animated LSP progress spinner |
| `cursor` | Line:column position |
| `spacer` | Right-alignment marker |

All highlights use the `vy` prefix and link to standard groups (`Statement`,
`DiagnosticError`, `Type`, `StatusLine`, etc.), so they work with almost any
colorscheme.

Override them in your config if needed:
```lua
vim.api.nvim_set_hl(0, "vyLspError", { fg = "#ff0000" })
```

## PR's Welcome

Found a bug or want a feature?
Open a PR — contributions are welcome.
