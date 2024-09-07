local wk = require("which-key")
wk.add({
    { "<leader>f", group = "Telescope" },
    { "<leader>u", group = "UI" },
    { "<leader>l", ":Lazy<CR>", icon = "󰒲" },
    { '<leader>a', ':Alpha<CR>', icon = "󰮫", desc = "Dashboard" },
    { '<leader>e', ':NvimTreeToggle<CR>', icon = "󰙅", desc = "Nvim Tree" },
    { "<leader>w", proxy = "<c-w>", group = "windows" },
    { "<leader>b", group = "Buffers", icon = "", expand = 
        function()
            return require("which-key.extras").expand.buf()
        end 
    },
})

return {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {    
        preset = "modern",
    },
    keys = {
    },
}