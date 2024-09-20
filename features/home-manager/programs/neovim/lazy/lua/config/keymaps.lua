-- Move text down
vim.keymap.set("n", "<M-j>", ":m .+1<CR>", { noremap = true, silent = true })
vim.keymap.set("v", "<M-j>", ":m '>+1<CR>gv", { noremap = true, silent = true })
-- Move text up
vim.keymap.set("n", "<M-k>", ":m .-2<CR>", { noremap = true, silent = true })
vim.keymap.set("v", "<M-k>", ":m '<-2<CR>gv", { noremap = true, silent = true })
-- Move text left
vim.keymap.set("n", "<M-h>", "<<", { noremap = true, silent = true })
vim.keymap.set("v", "<M-h>", "<gv", { noremap = true, silent = true })
-- Move text right
vim.keymap.set("n", "<M-l>", ">>", { noremap = true, silent = true })
vim.keymap.set("v", "<M-l>", ">gv", { noremap = true, silent = true })

-- Yank to system clipboard register
vim.keymap.set("n", "y", '"+y', { noremap = true, silent = true })
vim.keymap.set("v", "y", '"+y', { noremap = true, silent = true })
-- Yank to primary selection register
vim.keymap.set("n", "Y", '"*y', { noremap = true, silent = true })
vim.keymap.set("v", "Y", '"*y', { noremap = true, silent = true })
-- Paste from system clipboard register
vim.keymap.set("n", "p", '"+p', { noremap = true, silent = true })
vim.keymap.set("v", "p", '"+p', { noremap = true, silent = true })
-- Paste from primary selection register
vim.keymap.set("n", "P", '"*p', { noremap = true, silent = true })
vim.keymap.set("v", "P", '"*p', { noremap = true, silent = true })

-- Map registers to wl-clipboard commands
vim.opt.clipboard:append("unnamed")
if vim.fn.executable("wl-copy") == 1 then
	vim.g.clipboard = {
		name = "wl-clipboard",
		copy = {
			["+"] = "wl-copy --foreground --type text/plain",
			["*"] = "wl-copy --foreground --primary --type text/plain",
		},
		paste = {
			["+"] = function()
				return vim.fn.systemlist("wl-paste --no-newline")
			end,
			["*"] = function()
				return vim.fn.systemlist("wl-paste --primary --no-newline")
			end,
		},
		cache_enabled = true,
	}
end
