local create_keymaps = function(maps)
	for _, v in ipairs(maps) do
		vim.keymap.set(v[1], v[2], v[3], v[4])
	end
end

local keymaps = {
	{ "n", "<M-j>", ":m .+1<CR>", { silent = true } },
	{ "v", "<M-j>", ":m '>+1<CR>gv", { silent = true } },
	{ "n", "<M-k>", ":m .-2<CR>", { silent = true } },
	{ "v", "<M-k>", ":m '<-2<CR>gv", { silent = true } },
	{ "n", "<M-h>", "<<", { silent = true } },
	{ "v", "<M-h>", "<gv", { silent = true } },
	{ "n", "<M-l>", ">>", { silent = true } },
	{ "v", "<M-l>", ">gv", { silent = true } },
	{ "n", "y", '"+y', { silent = true } },
	{ "v", "y", '"+y', { silent = true } },
	{ "n", "Y", '"*y', { silent = true } },
	{ "v", "Y", '"*y', { silent = true } },
	{ "n", "p", '"+p', { silent = true } },
	{ "v", "p", '"+p', { silent = true } },
	{ "n", "P", '"*p', { silent = true } },
	{ "v", "P", '"*p', { silent = true } },
	{ "n", "<leader>bn", ":bn<CR>", { desc = "Next", silent = true } },
	{ "n", "<leader>bb", ":bp<CR>", { desc = "Prev", silent = true } },
	{ "n", "<leader>bd", ":bdelete<CR>", { desc = "Close", silent = true } },
}

create_keymaps(keymaps)

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
