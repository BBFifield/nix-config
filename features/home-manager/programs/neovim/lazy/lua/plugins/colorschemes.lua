return {
	{
		{ "catppuccin/nvim", name = "catppuccin", priority = 1000 },
		"Mofiqul/dracula.nvim",
		"folke/tokyonight.nvim",
		"projekt0n/github-nvim-theme",
		"rebelot/kanagawa.nvim",
		"eldritch-theme/eldritch.nvim",
		"slugbyte/lackluster.nvim",
		"Mofiqul/vscode.nvim",
		"craftzdog/solarized-osaka.nvim",
	},
	--[[	{
		"rachartier/tiny-devicons-auto-colors.nvim",
		dependencies = {
			"nvim-tree/nvim-web-devicons",
		},
		event = "VeryLazy",
		opts = {},
		config = function(_, opts)
			local theme_colors = require(vim.g.colorscheme .. ".colors.storm")

			require("tiny-devicons-auto-colors").setup({
				colors = theme_colors,
			})
		end,
	},]]
}
