vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

--[[ Open in current window
local function open_nvim_tree(data)
  -- buffer is a directory
  local directory = vim.fn.isdirectory(data.file) == 1
  if not directory then
    return
  end
  -- change to the directory
  vim.cmd.cd(data.file)
  -- open the tree
  require("nvim-tree.api").tree.open()
end

vim.api.nvim_create_autocmd({ "VimEnter" }, { callback = open_nvim_tree })
]]
return {
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
        }
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
      update_root = true
    },
  },
  config = function(_, opts)
    local function my_on_attach(bufnr)
      local api = require "nvim-tree.api"

      local function key_opts(desc)
        return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
      end

      -- default mappings
      api.config.mappings.default_on_attach(bufnr)

      -- custom mappings
      vim.keymap.set('n', '<esc>', function()
        api.tree.close()
      end, key_opts('Exit'))
    end

    -- Ensure opts are passed correctly to setup
    require'nvim-tree'.setup(vim.tbl_extend('force', opts, {
      on_attach = my_on_attach,
    }))
  end
}
