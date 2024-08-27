vim.opt.clipboard:append('unnamed')
if vim.fn.executable("wl-copy") == 1 then
    vim.g.clipboard = {
        name = "wl-clipboard",
        copy = {
            ["+"] = "wl-copy --foreground --type text/plain",
            ["*"] = "wl-copy --foreground --primary --type text/plain",
        },
        paste = {
            ["+"] = function() return vim.fn.systemlist('wl-paste --no-newline') end,
            ["*"] = function() return vim.fn.systemlist('wl-paste --primary --no-newline') end,
        },
        cache_enabled = true,
    }
end
-- Move text left
vim.api.nvim_set_keymap('n', '<M-h>', '<<', { noremap = true, silent = true })
vim.api.nvim_set_keymap('v', '<M-h>', '<gv', { noremap = true, silent = true })
-- Move text right
vim.api.nvim_set_keymap('n', '<M-l>', '>>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('v', '<M-l>', '>gv', { noremap = true, silent = true })
