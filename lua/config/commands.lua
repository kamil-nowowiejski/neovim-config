--  Disable auto-completion for buffer
vim.api.nvim_create_user_command("Dcmp", "lua require('cmp').setup.buffer {enabled = false}", {})

-- Enable auto-completion for buffer
vim.api.nvim_create_user_command("Ecmp", "lua require('cmp').setup.buffer {enabled = true}", {})

-- Share clipboard
vim.api.nvim_create_user_command("Sc", "set cb=unnamedplus | echo 'Clipboard shared'", {})

-- Unshare clipboard
vim.api.nvim_create_user_command("Usc", "set cb= | echo 'Clipboard unshared'", {})

vim.api.nvim_create_user_command("Q", function()
	local dbee = require("dbee")
	if dbee.is_open() then
		dbee.close()
	end

	vim.cmd("q")
end, {})

vim.api.nvim_create_user_command("LspErrors", function()
	vim.diagnostic.setqflist({ severity = vim.diagnostic.severity.ERROR })
end, {})

vim.api.nvim_create_user_command("Chat", function()
    vim.cmd("CopilotChatOpen")
end, {})
