local wk = require("which-key")
wk.add({
	{ "<leader>f", group = "Telescope" },
	{ "<leader>u", group = "UI" },
	{ "<leader>l", icon = "󰿘", desc = "LSP" },
	{ "<leader>lr", "<cmd>lua vim.lsp.buf.format()<CR>", icon = "󰝔", desc = "Run formatter" },
	{ "<leader>p", ":Lazy<CR>", icon = "󰒲", desc = "Plugin Manager" },
	{ "<leader>a", ":Alpha<CR>", icon = "󰮫", desc = "Dashboard" },
	{ "<leader>e", ":NvimTreeToggle<CR>", icon = "󰙅", desc = "Nvim Tree" },
	{ "<leader>w", proxy = "<c-w>", group = "Windows" },
	{
		"<leader>b",
		group = "Buffers",
		icon = "",
		expand = function()
			return require("which-key.extras").expand.buf()
		end,
	},
	{ "<leader>bn", ":bn<CR>", desc = "Next" },
	{ "<leader>bp", ":bp<CR>", desc = "Prev" },
	{ "<leader>bd", ":bdelete<CR>", desc = "Close" },
})

return {
	"folke/which-key.nvim",
	event = "VeryLazy",
	opts = {
		preset = "modern",
		delay = 500,
	},
	keys = {},
}
