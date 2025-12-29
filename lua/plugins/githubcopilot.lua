return {
	"github/copilot.vim",
    config = function()
        vim.g.copilot_enterprise_uri = "https://clarksons.ghe.com/"
    end
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
