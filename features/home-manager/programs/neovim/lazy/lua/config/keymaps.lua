-- Move text left
vim.keymap.set('n', '<M-h>', '<<', { noremap = true, silent = true })
vim.keymap.set('v', '<M-h>', '<gv', { noremap = true, silent = true })
-- Move text right
vim.keymap.set('n', '<M-l>', '>>', { noremap = true, silent = true })
vim.keymap.set('v', '<M-l>', '>gv', { noremap = true, silent = true })

-- Yank to system clipboard
vim.keymap.set('n', 'y', '"+y', { noremap = true, silent = true })
vim.keymap.set('v', 'y', '"+y', { noremap = true, silent = true })

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


