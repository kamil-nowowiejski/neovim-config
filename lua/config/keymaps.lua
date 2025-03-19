-- Clear highlights on search when pressing <Esc> in normal mode. See `:help hlsearch`
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")

-- Diagnostic keymaps
vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Open diagnostic [Q]uickfix list" })

-- Exit terminal mode in the builtin terminal with a shortcut that is a bit easier
-- for people to discover. Otherwise, you normally need to press <C-\><C-n>, which
-- is not what someone will guess without a bit more experience.
--
-- NOTE: This won't work in all terminal emulators/tmux/etc. Try your own mapping
-- or just use <C-\><C-n> to exit terminal mode
vim.keymap.set("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })

-- Disable arrow keys in normal mode
vim.keymap.set("n", "<left>", "")
vim.keymap.set("n", "<right>", "")
vim.keymap.set("n", "<up>", "")
vim.keymap.set("n", "<down>", "")

vim.keymap.set("n", "<C-h>", "<C-w><C-h>", { desc = "Move focus to the left window" })
vim.keymap.set("n", "<C-l>", "<C-w><C-l>", { desc = "Move focus to the right window" })
vim.keymap.set("n", "<C-j>", "<C-w><C-j>", { desc = "Move focus to the lower window" })
vim.keymap.set("n", "<C-k>", "<C-w><C-k>", { desc = "Move focus to the upper window" })

vim.keymap.set("n", "<C-w>h", "<C-W>H", { desc = "Move buffer to the left " })
vim.keymap.set("n", "<C-w>l", "<C-W>L", { desc = "Move buffer to the right " })
vim.keymap.set("n", "<C-w>j", "<C-W>J", { desc = "Move buffer down " })
vim.keymap.set("n", "<C-w>k", "<C-W>K", { desc = "Move buffer up " })

vim.keymap.set("n", "<C-t>", "<cmd>NvimTreeFindFileToggle!<CR>")

-- delete line to black hole
vim.keymap.set("n", "DD", '"_dd')

-- insert line before/after cursor
vim.keymap.set("n", "<leader>il", "i<CR><Esc>k$")
vim.keymap.set("n", "<leader>al", "a<CR><Esc>k$")

vim.keymap.set("n", "Q", "q", { noremap = true, desc = "Record macro" })
vim.keymap.set("n", "q", function()
	local dbee = require("dbee")
	if dbee.is_open() then
		return
	end

	local winCount = #vim.api.nvim_list_wins()
	if winCount > 1 then
		vim.cmd("q")
	end
end)

-- create new buffer
vim.keymap.set("n", "<leader>n", "<cmd>new<CR>")
vim.keymap.set("n", "<leader>vn", "<cmd>vnew<CR>")

-- change buffer size
vim.keymap.set("n", "<leader>fj", "<cmd>res -5<CR>")
vim.keymap.set("n", "<leader>fk", "<cmd>res +5<CR>")
vim.keymap.set("n", "<leader>fh", "<cmd>vertical res +5<CR>")
vim.keymap.set("n", "<leader>fl", "<cmd>vertical res -5<CR>")

-- disable shift arrows navigation in insert mode
vim.keymap.set("i", "<S-down>", "")
vim.keymap.set("i", "<S-up>", "")
vim.keymap.set("i", "<S-left>", "")
vim.keymap.set("i", "<S-right>", "")

-- delete all buffers except current one
-- local deleteAllBuffersExceptCurrentOne = function ()
--     local d = vim.cmd('ls')
--     print(d)
--     -- vim.api.nvim_buf_delete()
-- end
-- TODO
-- vim.keymap.set('n', '<leader>bd', deleteAllBuffersExceptCurrentOne)
