local telescope = require("telescope")
local builtin = require("telescope.builtin")
local actions = require("telescope.actions")

vim.keymap.set("n", "<leader>ff", builtin.find_files, key_opts("Find files"))
vim.keymap.set("n", "<leader>fg", builtin.live_grep, key_opts("Live grep"))
vim.keymap.set("n", "<leader>fb", builtin.buffers, key_opts("Buffers"))
vim.keymap.set("n", "<leader>fh", builtin.help_tags, key_opts("Help tags"))
vim.keymap.set("n", "<leader>fr", builtin.oldfiles, key_opts("Recent files"))
vim.keymap.set("n", "<leader>uc", builtin.colorscheme, key_opts("Color schemes"))

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
		-- telescope.setup()
		telescope.load_extension("fzy_native")
		telescope.load_extension("zoxide")

		vim.keymap.set("n", "<leader>fz", telescope.extensions.zoxide.list, key_opts("Zoxide list"))

		-- bit of debugging
		local status, z_utils = pcall(require, "telescope._extensions.zoxide.utils")
		if not status then
			print("Failed to load z_utils: " .. z_utils)
		else
			print("z_utils loaded successfully")
			opts.extensions.zoxide.mappings["<C-q>"] = { action = z_utils.create_basic_command("split") }
			telescope.setup(opts) -- Re-setup telescope with the updated opts
		end
	end,
}

