return {
	"nvim-lualine/lualine.nvim",
	--	enabled = false,
	dependencies = {
		"nvim-tree/nvim-web-devicons",
	},
	opts = {},
	config = function(_, opts)
		local custom_buffers = require("lualine.components.buffers"):extend()
		local custom_buffers_buffer = require("lualine.components.buffers.buffer"):extend()

		function custom_buffers:init(options)
			custom_buffers.super.init(self, options)
			--self.super.bufnr = vim.api.nvim_get_current_buf()
			self.options = vim.tbl_deep_extend("force", self.options, { options })
			self.highlights = {
				active = self:create_hl(self.options.buffers_color.active, "active"),
				inactive = self:create_hl(self.options.buffers_color.inactive, "inactive"),
			}
		end

		function custom_buffers:new_buffer(bufnr, buf_index)
			bufnr = bufnr or vim.api.nvim_get_current_buf()
			buf_index = buf_index or ""
			return custom_buffers_buffer:new({
				bufnr = bufnr,
				buf_index = buf_index,
				options = self.options,
				highlights = self.highlights,
			})
		end

		function custom_buffers_buffer:init(options)
			custom_buffers_buffer.super.init(self, options)
		end

		function custom_buffers_buffer:name()
			local name = custom_buffers_buffer.super.name(self)

			local general_fg = vim.api.nvim_get_hl(0, { name = "lualine_a_replace" }).bg
			local active_bg = vim.api.nvim_get_hl(0, { name = self.options.buffers_color.active }).bg
			local inactive_bg = vim.api.nvim_get_hl(0, { name = self.options.buffers_color.inactive }).bg
			vim.api.nvim_set_hl(0, "active_modified", { fg = general_fg, bg = active_bg })
			vim.api.nvim_set_hl(0, "inactive_modified", { fg = general_fg, bg = inactive_bg })

			if self:is_current() and vim.api.nvim_get_option_value("modified", { buf = self.bufnr }) then
				name = name .. "%#active_modified# ● %*"
			elseif not self:is_current() and vim.api.nvim_get_option_value("modified", { buf = self.bufnr }) then
				name = name .. "%#inactive_modified# ○ %*"
			end
			return name
		end

		function custom_buffers_buffer:separator_before()
			if self.current or self.aftercurrent then
				return "%Z{" .. self.options.section_separators.left .. "}"
			else
				return string.format("%%#lualine_b_normal#%s%%*", self.options.component_separators.left)
			end
		end

		local navic
		local barbecue
		local winbar = {}
		local navic_enabled = NewfieVim:get_plugin_info("navic").enabled
		if navic_enabled then
			navic = require("nvim-navic")
			barbecue = require("barbecue.ui")
			winbar = {
				winbar = {
					lualine_c = {
						{
							function()
								return barbecue.update() or ""
							end,
							cond = function()
								return navic.is_available()
							end,
						},
					},
				},
			}
		end

		require("lualine").setup(vim.tbl_deep_extend("keep", winbar, {
			options = {
				icons_enabled = true,
				--	theme = vim.g.colorscheme,
				component_separators = { left = "", right = "" },
				section_separators = { left = "", right = "" },
			},
			sections = {
				lualine_a = { "mode" },
				lualine_b = { "branch" },
				lualine_c = {},
				lualine_x = { "filetype", "encoding", "fileformat" },
				lualine_y = { "progress" },
				lualine_z = { "location" },
			},
			inactive_sections = {
				lualine_a = {},
				lualine_b = {},
				lualine_c = {},
				lualine_x = { "location" },
				lualine_y = {},
				lualine_z = {},
			},
			tabline = {
				lualine_c = {
					{
						custom_buffers,
						show_filename_only = true,
						hide_filename_extension = false,
						show_modified_status = true,
						mode = 0,
						filetype_names = {
							checkhealth = "Check Health",
							TelescopePrompt = "Telescope",
						},
						buffers_color = {
							active = "lualine_a_normal",
							inactive = "lualine_b_normal",
						},
						separator = { left = "", right = "" },
						padding = 0,
						max_length = function()
							return vim.o.columns * 4 / 3
						end,
						--fmt = trunc(300, 200, 50, false),
						symbols = {
							modified = "",
						},

						cond = function()
							return vim.bo.filetype ~= "alpha"
								and vim.bo.filetype ~= "lazy"
								and vim.bo.filetype ~= "TelescopePrompt"
								and vim.bo.filetype ~= "NvimTree"
								and vim.bo.filetype ~= "tfm"
						end,
					},
				},
				lualine_x = {},
				lualine_y = {},
				lualine_z = {
					{
						"datetime",
						--options: default, us, uk, iso, or your own format string ("%H:%M", etc..)
						style = "%H:%M",
					},
				},
			},
			extensions = {},
		}))
	end,
}
