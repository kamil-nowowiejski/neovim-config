-- [[ Basic Autocommands ]]
--  See `:help lua-guide-autocommands`

-- Highlight when yanking (copying) text
--  Try it with `yap` in normal mode
--  See `:help vim.highlight.on_yank()`
vim.api.nvim_create_autocmd("TextYankPost", {
	desc = "Highlight when yanking (copying) text",
	group = vim.api.nvim_create_augroup("kickstart-highlight-yank", { clear = true }),
	callback = function()
		vim.highlight.on_yank()
	end,
})

vim.api.nvim_create_autocmd("User", {
	desc = "Open last edited file in working directory",
	pattern = { "LazyVimStarted" },
	callback = function()
		pcall(function()
			if vim.fn.argc() == 0 then
				local workingDir = vim.fn.getcwd()
				local recentFiles = vim.v.oldfiles
				for i = #recentFiles, 1, -1 do
					local recentFile = recentFiles[i]
					if recentFile:sub(1, #workingDir) == workingDir then
						local extension = require("utils.file").getFileExtension(recentFile):sub(2, -1)
						if extension == "cs" or extension == "js" or extension == "ts" or extension == "lua" then
							vim.cmd("e " .. recentFile .. " | bufdo setlocal filetype=" .. extension)
						end
					end
				end
			end
		end)
	end,
})
