return {
	"neovim/nvim-lspconfig", --leaving lsp-config for now to preserve commands like LspStart
	dependencies = {
		-- Automatically install LSPs and related tools to stdpath for Neovim
		{ "williamboman/mason.nvim", config = true }, -- NOTE: Must be loaded before dependants
		"williamboman/mason-lspconfig.nvim",
		"WhoIsSethDaniel/mason-tool-installer.nvim",

		-- Useful status updates for LSP.
		-- NOTE: `opts = {}` is the same as calling `require('fidget').setup({})`
		-- { "j-hui/fidget.nvim", opts = {} },

		-- Allows extra capabilities provided by nvim-cmp
		"hrsh7th/cmp-nvim-lsp",
	},
	config = function()
		require("mason").setup({
			registries = {
				"github:mason-org/mason-registry",
				"github:Crashdummyy/mason-registry",
			},
		})

        local lsps = {'ts_ls'}
        local tools = {"stylua", "netcoredbg", "csharpier"}
		local ensure_installed = {}
        vim.list_extend(ensure_installed, lsps)
        vim.list_extend(ensure_installed, tools)

		require("mason-tool-installer").setup({ ensure_installed = ensure_installed })

        vim.lsp.enable({ 'ts_ls', 'lua_ls', 'cssls', 'jsonls', 'html' })
		vim.api.nvim_create_autocmd("LspAttach", {
			group = vim.api.nvim_create_augroup("kickstart-lsp-attach", { clear = true }),
			callback = function(event)
				require("plugins.lspconfig.keymap").setup(event)
                require('plugins.lsp_signature.attach').attach(event)
			end,
		})
	end,
}
