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
	{
		"rachartier/tiny-devicons-auto-colors.nvim",
		dependencies = {
			"nvim-tree/nvim-web-devicons",
		},
		event = "VeryLazy",
		opts = {},
		config = function(_, opts)
			local theme_colors
			if string.find(vim.g.colorscheme, "catppuccin") then
				if vim.g.colorscheme ~= "catppuccin" then
					theme_colors = require("catppuccin.palettes").get_palette(string.sub(vim.g.colorscheme, 12))
				end
			elseif string.find(vim.g.colorscheme, "tokyonight") then
				if vim.g.colorscheme ~= "tokyonight" then
					theme_colors = require(vim.g.colorscheme .. string.sub(vim.g.colorscheme, 12))
				end
			end

			require("tiny-devicons-auto-colors").setup({
				colors = theme_colors,
			})
		end,
	},
	{
		"NvChad/nvim-colorizer.lua",
		opts = {},
	},
}
