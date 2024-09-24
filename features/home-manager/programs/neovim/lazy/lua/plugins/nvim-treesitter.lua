return {
	"nvim-treesitter/nvim-treesitter",
	build = ":TSUpdate",
	config = function()
		local configs = require("nvim-treesitter.configs")

		configs.setup({
			ensure_installed = { "nix", "lua", "javascript", "html", "c" },
			sync_install = false,
			--highlight = { enable = true },
			--indent = { enable = true },
		})
	end,
}
