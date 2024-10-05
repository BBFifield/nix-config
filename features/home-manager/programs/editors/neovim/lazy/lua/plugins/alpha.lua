local builtin = require("telescope.builtin")

return {
	"goolord/alpha-nvim",
	dependencies = {
		"echasnovski/mini.icons",
		"nvim-lua/plenary.nvim",
	},
	opts = function()
		local dashboard = require("alpha.themes.dashboard")
		local buttons = { dashboard.button("n", " " .. " New file", "<cmd> ene <BAR> startinsert <cr>") }
		if NewfieVim:get_plugin_info("telescope").enabled then
			table.insert(buttons, dashboard.button("f", " " .. " Find file", builtin.find_files))
			table.insert(buttons, dashboard.button("r", " " .. " Recent files", builtin.oldfiles))
			table.insert(buttons, dashboard.button("g", " " .. " Find text", builtin.live_grep))
			table.insert(
				buttons,

				dashboard.button(
					"z",
					" " .. " Open Directories",
					"<cmd> lua require('telescope').extensions.zoxide.list() <cr>"
				)
			)
		end
		--dashboard.button("c", " " .. " Config",          "<cmd> lua require('lazyvim.util').telescope.config_files()() <cr>"),
		--dashboard.button("s", " " .. " Restore Session", [[<cmd> lua require("persistence").load() <cr>]]),
		--dashboard.button("x", " " .. " Lazy Extras",     "<cmd> LazyExtras <cr>"),
		table.insert(buttons, dashboard.button("p", "󰒲 " .. " Lazy", "<cmd> Lazy <cr>"))
		table.insert(buttons, dashboard.button("q", " " .. " Quit", "<cmd> qa <cr>"))

		dashboard.section.buttons.val = buttons
		return dashboard
	end,
	config = function(_, dashboard)
		require("alpha").setup(dashboard.opts)
		require("which-key").add({ "<leader>a", ":Alpha<CR>", icon = "󰮫", desc = "Dashboard" })
	end,
}
