return {
	"folke/which-key.nvim",
	event = "VeryLazy",
	opts = {
		preset = "modern",
		delay = 500,
		spec = {
			{ "<leader>u", group = "UI", icon = "" },
			{ "<leader>l", group = "LSP", icon = "󰿘" },
			{ "<leader>w", proxy = "<c-w>", group = "Windows" },
			{
				"<leader>b",
				group = "Buffers",
				icon = "",
				expand = function()
					return require("which-key.extras").expand.buf()
				end,
			},
		},
	},
	keys = {},
}
