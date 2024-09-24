local telescope = require("telescope")
local builtin = require("telescope.builtin")
local actions = require("telescope.actions")

return {
	"nvim-telescope/telescope.nvim",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"BurntSushi/ripgrep",
		"nvim-telescope/telescope-fzy-native.nvim",
		"sharkdp/fd",
		"jvgrootveld/telescope-zoxide",
	},
	event = "VimEnter",
	opts = {
		defaults = {
			mappings = {
				i = {
					["<esc>"] = actions.close,
					["<C-h>"] = actions.which_key,
				},
			},
		},
		pickers = {
			find_files = {
				theme = "dropdown",
			},
			colorscheme = {
				enable_preview = true,
				ignore_builtins = true,
			},
		},
		extensions = {
			zoxide = {
				prompt_title = "[ Cool stuff ]",
				mappings = {
					default = {
						after_action = function(selection)
							print("Update to (" .. selection.z_score .. ") " .. selection.path)
						end,
					},
					["<C-s>"] = {
						before_action = function(selection)
							print("before C-s")
						end,
						action = function(selection)
							vim.cmd.edit(selection.path)
						end,
					},
				},
			},
		},
	},
	config = function(_, opts)
		telescope.load_extension("fzy_native")
		telescope.load_extension("zoxide")
		local wk = require("which-key")
		wk.add({
			{ "<leader>f", group = "Telescope" },
			{ "<leader>ff", builtin.find_files, desc = "Find files" },
			{ "<leader>fg", builtin.live_grep, desc = "Live grep" },
			{ "<leader>fb", builtin.buffers, desc = "Buffers" },
			{ "<leader>fh", builtin.help_tags, desc = "Help tags" },
			{ "<leader>fr", builtin.oldfiles, desc = "Recent files" },
			{ "<leader>uc", builtin.colorscheme, desc = "Color schemes" },
			{ "<leader>fz", telescope.extensions.zoxide.list, desc = "Zoxide list" },
		})
		-- bit of debugging
		local status, z_utils = pcall(require, "telescope._extensions.zoxide.utils")
		if not status then
			print("Failed to load z_utils: " .. z_utils)
		else
			opts.extensions.zoxide.mappings["<C-q>"] = { action = z_utils.create_basic_command("split") }
			telescope.setup(opts) -- Re-setup telescope with the updated opts
		end
	end,
}
