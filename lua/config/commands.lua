--  Disable auto-completion for buffer
vim.api.nvim_create_user_command("Dcmp", "lua require('cmp').setup.buffer {enabled = false}", {})

-- Enable auto-completion for buffer
vim.api.nvim_create_user_command("Ecmp", "lua require('cmp').setup.buffer {enabled = true}", {})

-- Share clipboard
vim.api.nvim_create_user_command("Sc", "set cb=unnamedplus | echo 'Clipboard shared'", {})

-- Unshare clipboard
vim.api.nvim_create_user_command("Usc", "set cb= | echo 'Clipboard unshared'", {})
