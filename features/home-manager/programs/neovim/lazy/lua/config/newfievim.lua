-- NewfieVim editor class, a class defining the distro
local NewfieVim = {}
NewfieVim.__index = NewfieVim

function NewfieVim:new(opts)
	local opts = opts or {}
	setmetatable(opts, self)
	self.__index = self
	self.plugin_list = opts.plugin_list or {}
	return opts
end

function NewfieVim:initialize_plugins()
	local prepared_list = {}
	for _, v in pairs(self.plugin_list) do
		table.insert(prepared_list, v)
	end
	require("lazy").setup({
		spec = {
			prepared_list,
			{ import = "plugins" },
		},
		ui = { size = { width = 1, height = 1 } },
		install = { colorscheme = { vim.g.colorscheme } },
		checker = { enabled = true }, -- automatically check for plugin updates
	})
	require("which-key").add({ "<leader>p", ":Lazy<CR>", icon = "󰒲", desc = "Plugin Manager" })
end

function NewfieVim:get_plugin_info(plugin_name)
	return self.plugin_list[plugin_name]
end

return NewfieVim
