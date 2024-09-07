vim.g.mapleader = ' '
vim.g.colorscheme = "tokyonight"
vim.opt.mousemoveevent = true
vim.opt.termguicolors = true

require("lib.misc")
require("config.lazy")
require("config.keymaps")

vim.cmd.colorscheme(vim.g.colorscheme)
vim.wo.number = true
vim.wo.cursorline = true