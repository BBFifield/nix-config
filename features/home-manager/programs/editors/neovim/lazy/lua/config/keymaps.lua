local create_keymaps = function(maps)
	for _, v in ipairs(maps) do
		if type(v[1]) == "table" then
			for _, m in ipairs(v[1]) do
				vim.keymap.set(m, v[2], v[3], v[4])
			end
		end
		vim.keymap.set(v[1], v[2], v[3], v[4])
	end
end

local create_reg_keymaps = function()
	local opts = { silent = true }
	for i = string.byte("a"), string.byte("z") do
		local letterReg = string.char(i)
		local prefix = '"' .. letterReg
		vim.keymap.set("n", prefix .. "y", prefix .. "y", opts)
		vim.keymap.set("v", prefix .. "y", prefix .. "ygv", opts)
		vim.keymap.set("n", prefix .. "Y", prefix .. "Y", opts)
		create_keymaps({ { { "n", "v" }, prefix .. "p", prefix .. "p", opts } })
	end
	vim.keymap.set("n", "y", '"+y', opts)
	vim.keymap.set("v", "y", '"+ygv', { silent = true })
	vim.keymap.set("n", "Y", '"*y', { silent = true })
	vim.keymap.set("v", "Y", '"*ygv', { silent = true })
	create_keymaps({ { { "n", "v" }, "p", '"+p', opts } })
	create_keymaps({ { { "n", "v" }, "P", '"*P', opts } })
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
	{ "n", "<leader>bn", ":bn<CR>", { desc = "Next", silent = true } },
	{ "n", "<leader>bb", ":bp<CR>", { desc = "Prev", silent = true } },
	{ "n", "<leader>bd", ":bdelete<CR>", { desc = "Close", silent = true } },
}

create_keymaps(keymaps)
create_reg_keymaps()

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
