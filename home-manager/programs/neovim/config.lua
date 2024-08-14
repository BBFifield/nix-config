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

-- Move selected text up
vim.api.nvim_set_keymap('v', '<S-k>', ":m '<-2<CR>gv=gv", { noremap = true, silent = true })

-- Move selected text down
vim.api.nvim_set_keymap('v', '<S-j>', ":m '>+1<CR>gv=gv", { noremap = true, silent = true })

-- Move selected text left
vim.api.nvim_set_keymap('v', '<S-h>', ":<C-u>execute \"normal! <<gv\"<CR>", { noremap = true, silent = true })

-- Move selected text right
vim.api.nvim_set_keymap('v', '<S-l>', ":<C-u>execute \"normal! >>gv\"<CR>", { noremap = true, silent = true })
