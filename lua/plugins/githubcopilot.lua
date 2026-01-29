return {
	"github/copilot.vim",
	config = function()
		vim.g.copilot_enterprise_uri = "https://clarksons.ghe.com/"
        vim.g.copilot_no_tab_map = true
        vim.keymap.set('i', '<S-Tab>', 'copilot#Accept("\\<S-Tab>")', { expr = true, replace_keycodes = false })
        vim.keymap.set('i', '<M-p>', '<Plug>(copilot-accept-word)')
        vim.keymap.set('i', '<M-o>', '<Plug>(copilot-next)')
        vim.keymap.set('i', '<M-i>', '<Plug>(copilot-previous)')
	end,
}

-- return {
-- 	"zbirenbaum/copilot.lua",
-- 	dependencies = {
-- 		"copilotlsp-nvim/copilot-lsp",
-- 	},
-- 	opts = {
-- 		auth_provider_url = "https://clarksons.ghe.com/",
-- 	},
-- }
