local builtin = require('telescope.builtin')

return {
  'goolord/alpha-nvim',
  dependencies = {
    'echasnovski/mini.icons',
    'nvim-lua/plenary.nvim'
  },
  opts = function()
    local dashboard = require('alpha.themes.dashboard')
    dashboard.section.buttons.val = {
      dashboard.button("n", " " .. " New file", "<cmd> ene <BAR> startinsert <cr>"),
      dashboard.button("f", " " .. " Find file", builtin.find_files),
      dashboard.button("r", " " .. " Recent files", builtin.oldfiles),
      dashboard.button("g", " " .. " Find text", builtin.live_grep),
      dashboard.button("z", " " .. " Open Directories", "<cmd> lua require('telescope').extensions.zoxide.list() <cr>"),
      --dashboard.button("c", " " .. " Config",          "<cmd> lua require('lazyvim.util').telescope.config_files()() <cr>"),
      --dashboard.button("s", " " .. " Restore Session", [[<cmd> lua require("persistence").load() <cr>]]),
      --dashboard.button("x", " " .. " Lazy Extras",     "<cmd> LazyExtras <cr>"),
      dashboard.button("p", "󰒲 " .. " Lazy", "<cmd> Lazy <cr>"),
      dashboard.button("q", " " .. " Quit", "<cmd> qa <cr>"),
    }
    return dashboard
  end,
  config = function(_, dashboard)
    require("alpha").setup(dashboard.opts)
  end
};

