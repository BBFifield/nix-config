return {
	"akinsho/bufferline.nvim",
	requires = "nvim-tree/nvim-web-devicons",
	enabled = false,
	opts = {
		options = {
			themable = true,
			color_icons = true,
			hover = {
				enabled = true,
				delay = 50,
				reveal = { "close" },
			},
			offsets = {
				{
					filetype = "NvimTree",
					text_align = "center",
				},
			},
			indicator = {
				style = "icon",
			},
		},
	},
	config = function(_, opts)
		require("bufferline").setup(opts)

		--[[ -- Which buffer to go to
        local go_to = function(n)
            require('bufferline').go_to(n, true)
        end

        -- This function is defined in /config/keymaps.lua
        mk_keymaps(num_buffers, function(n)
                vim.keymap.set('n', '<leader>b' .. n, function() go_to(n) end, key_opts('Buffer ' .. n))
            end)
        -- Go to last buffer
        vim.keymap.set('n', '<leader>b$', function() go_to(-1) end, key_opts('Last buffer'))

        -- Choose which buffer to close
        vim.keymap.set('n', '<leader>bc', ':BufferLinePickClose<CR>', key_opts('Close which..')) ]]
	end,
}
