return {
	"nvim-treesitter/nvim-treesitter",
	build = ":TSUpdate",
	config = function()
		local configs = require("nvim-treesitter.configs")

		configs.setup({
			ensure_installed = { "hyprlang", "corn", "nix", "lua", "javascript", "html", "css", "c" },
			sync_install = false,
			highlight = {
				enable = true,
				disable = { "nix", "lua" },
			},
			indent = { enable = true },
		})
	end,
}
