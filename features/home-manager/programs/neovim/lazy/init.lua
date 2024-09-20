vim.g.mapleader = ' '
vim.g.colorscheme = "tokyonight"
vim.opt.mousemoveevent = true
vim.opt.termguicolors = true

vim.opt.tabstop = 2       -- Number of spaces that a <Tab> in the file counts for
vim.opt.shiftwidth = 2    -- Number of spaces to use for each step of (auto)indent
vim.opt.expandtab = true  -- Use spaces instead of tabs
vim.opt.autoindent = true -- Copy indent from current line when starting a new line

-- Need to load plugins installed by nix before Lazy
--require('lspconfig').nil_ls.setup({})

require("lib.misc")
require("config.lazy")
require("config.keymaps")

-- And explicitly load the config here after Lazy loads because lsp-file-operations is loaded by Lazy
--require('config.nvim-lspconfig')

vim.cmd.colorscheme(vim.g.colorscheme)
vim.wo.number = true
vim.wo.cursorline = true
