vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
local wk = require("which-key")

return {
	{
		"nvim-tree/nvim-tree.lua",
		version = "*",
		dependencies = {
			"nvim-tree/nvim-web-devicons",
			"antosha417/nvim-lsp-file-operations",
		},
		-- Will only load plugin when this command is executed
		cmd = { "NvimTreeToggle" },
		opts = {
			sort = {
				sorter = "case_sensitive",
			},
			view = {
				width = 25,
				float = {
					enable = true,
					open_win_config = {
						relative = "editor",
						border = "rounded",
						width = 60,
						height = 25,
						row = (vim.o.lines - 25) * 0.5,
						col = (vim.o.columns - 60) * 0.5,
					},
				},
			},
			renderer = {
				group_empty = true,
			},
			filters = {
				dotfiles = true,
			},
			sync_root_with_cwd = true,
			respect_buf_cwd = true,
			update_focused_file = {
				enable = true,
				update_root = true,
			},
		},
		config = function(_, opts)
			local function my_on_attach(bufnr)
				local api = require("nvim-tree.api")

				local function key_opts(desc)
					return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
				end

				-- default mappings
				api.config.mappings.default_on_attach(bufnr)

				-- custom mappings
				vim.keymap.set("n", "<esc>", function()
					api.tree.close()
				end, key_opts("Exit"))
			end
			wk.add({ { "<leader>e", ":NvimTreeToggle<CR>", icon = "󰙅", desc = "Nvim Tree" } })
			-- Ensure opts are passed correctly to setup
			require("nvim-tree").setup(vim.tbl_extend("force", opts, {
				on_attach = my_on_attach,
			}))
		end,
	},
	{
		"rolv-apneseth/tfm.nvim",
		lazy = false,
		opts = {
			file_manager = "yazi",
			replace_netrw = true,
			enable_cmds = true,
			-- Custom keybindings only applied within the TFM buffer
			-- Default: {}
			keybindings = {
				["<ESC>"] = "q",
				-- Override the open mode (i.e. vertical/horizontal split, new tab)
				-- Tip: you can add an extra `<CR>` to the end of these to immediately open the selected file(s) (assuming the TFM uses `enter` to finalise selection)
				["<C-v>"] = "<C-\\><C-O>:lua require('tfm').set_next_open_mode(require('tfm').OPEN_MODE.vsplit)<CR><CR>",
				["<C-x>"] = "<C-\\><C-O>:lua require('tfm').set_next_open_mode(require('tfm').OPEN_MODE.split)<CR><CR>",
				["<C-t>"] = "<C-\\><C-O>:lua require('tfm').set_next_open_mode(require('tfm').OPEN_MODE.tabedit)<CR><CR>",
			},
			-- Customise UI. The below options are the default
			ui = {
				border = "rounded",
				height = 0.8,
				width = 0.8,
				x = 0.5,
				y = 0.5,
			},
		},
		keys = {
			-- Make sure to change these keybindings to your preference,
			-- and remove the ones you won't use
			{
				"<leader>e",
				":Tfm<CR>",
				desc = "TFM",
			},
			{
				"<leader>mh",
				":TfmSplit<CR>",
				desc = "TFM - horizontal split",
			},
			{
				"<leader>mv",
				":TfmVsplit<CR>",
				desc = "TFM - vertical split",
			},
			{
				"<leader>mt",
				":TfmTabedit<CR>",
				desc = "TFM - new tab",
			},
		},
		config = function(_, opts)
			wk.add({
				{ "<leader>e", ":Tfm<CR>", icon = "󰙅", desc = "File Manager" },
				{ "<leader>m", group = "TFM", icon = "" },
				{ "<leader>mh", ":TfmSplit<CR>", icon = "", desc = "Horizontal split" },
				{ "<leader>mv", ":TfmVsplit<CR>", icon = "", desc = "Vertical split" },
				{ "<leader>mt", ":TfmTabedit<CR>", desc = "New tab" },
			})
			require("tfm").setup(opts)
		end,
	},
}
