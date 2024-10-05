local wk = require("which-key")

-- autocmd to execute the formatter when saving a file
vim.api.nvim_create_autocmd("BufWritePre", {
	pattern = "*",
	callback = function(args)
		require("conform").format({ bufnr = args.buf })
	end,
})

return {
	{
		"neovim/nvim-lspconfig",
		dependencies = {
			"antosha417/nvim-lsp-file-operations",
		},
		config = function()
			local lspconfig = require("lspconfig")
			local navic
			local navic_enabled = NewfieVim:get_plugin_info("navic").enabled
			if navic_enabled then
				navic = require("nvim-navic")
			end

			lspconfig.util.default_config = vim.tbl_extend("force", lspconfig.util.default_config, {
				capabilities = vim.tbl_deep_extend(
					"force",
					vim.lsp.protocol.make_client_capabilities(),
					require("lsp-file-operations").default_capabilities()
				),
				on_attach = function(client, bufnr)
					require("lsp-file-operations").setup()
					if client.server_capabilities.documentSymbolProvider then
						if navic_enabled then
							navic.attach(client, bufnr)
						end
					end
				end,
				flags = {
					debounce_text_changes = 150,
				},
			})

			-- https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md#lua_ls
			lspconfig.lua_ls.setup({
				on_init = function(client)
					local path = client.workspace_folders[1].name
					if vim.loop.fs_stat(path .. "/.luarc.json") or vim.loop.fs_stat(path .. "/.luarc.jsonc") then
						return
					end

					client.config.settings.Lua = vim.tbl_deep_extend("force", client.config.settings.Lua, {
						runtime = {
							-- Tell the language server which version of Lua you're using
							-- (most likely LuaJIT in the case of Neovim)
							version = "LuaJIT",
						},
						diagnostics = {
							globals = { "vim" },
							disable = { "trailing-space" },
						},
						-- Make the server aware of Neovim runtime files
						workspace = {
							checkThirdParty = false,
							library = {
								vim.env.VIMRUNTIME,
								-- Depending on the usage, you might want to add additional paths here.
								-- "${3rd}/luv/library"
								-- "${3rd}/busted/library",
							},
							-- or pull in all of 'runtimepath'. NOTE: this is a lot slower
							-- library = vim.api.nvim_get_runtime_file("", true)
						},
					})
				end,
				settings = {
					Lua = {},
				},
			})

			lspconfig.nil_ls.setup({})
		end,
	},
	{
		"stevearc/conform.nvim",
		enabled = function()
			if NewfieVim:get_plugin_info("lsp_config").enabled then
				return true
			else
				return false
			end
		end,
		version = "*",
		opts = {
			formatters_by_ft = {
				nix = { "alejandra" },
				lua = { "stylua" },
				css = { "prettierd" },
				scss = { "prettierd" },
			},
		},
		config = function(_, opts)
			NewfieVim:get_plugin_info("lsp_config")
			require("conform").setup(opts)
			wk.add({
				{ "<leader>lr", "<cmd>lua vim.lsp.buf.format()<CR>", icon = "󰝔", desc = "Run formatter" },
			})
		end,
	},
}
