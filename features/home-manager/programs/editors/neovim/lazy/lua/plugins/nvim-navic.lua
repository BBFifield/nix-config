return {
	{
		"SmiteshP/nvim-navic",
		dependencies = { "neovim/nvim-lspconfig" },
		enabled = false,
		config = function()
			local navic = require("nvim-navic")
			navic.setup({
				highlight = true,
				click = true,
				separator = "  ",
				--	lazy_update_context = "true",
			})
		end,
	},

	{
		"utilyre/barbecue.nvim",
		name = "barbecue",
		version = "*",
		dependencies = {
			"SmiteshP/nvim-navic",
			"nvim-tree/nvim-web-devicons", -- optional dependency
		},
		enabled = false,
		opts = {
			attach_navic = false, --Makes navic work with multiple tabs or something when set to false, haven't tested it
			create_autocmd = false,
		},
		--[[	config = function(_, opts)
			-- triggers CursorHold event faster
			vim.opt.updatetime = 200

			require("barbecue").setup(opts)

			vim.api.nvim_create_autocmd({
				"WinResized", -- or WinResized on NVIM-v0.9 and higher
				"BufWinEnter",
				"CursorHold",
				"InsertLeave",

				-- include this if you have set `show_modified` to `true`
				--"BufModifiedSet",
			}, {
				group = vim.api.nvim_create_augroup("barbecue.updater", {}),
				callback = function()
					require("barbecue.ui").update()
				end,
			})
		end,]]
	},
}
