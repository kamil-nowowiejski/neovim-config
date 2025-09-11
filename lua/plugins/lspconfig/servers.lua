local servers = {}

function servers.install(capabilities)
	--  Add any additional override configuration in the following tables. Available keys are:
	--  - cmd (table): Override the default command used to start the server
	--  - filetypes (table): Override the default list of associated filetypes for the server
	--  - capabilities (table): Override fields in capabilities. Can be used to disable certain LSP features.
	--  - settings (table): Override the default settings passed when initializing the server.
	--        For example, to see the options for `lua_ls`, you could go to: https://luals.github.io/wiki/settings/
	local serversDefinition = {
		lua_ls = {
			settings = {
				Lua = {
					completion = {
						callSnippet = "Replace",
					},
				},
			},
		},
		-- ts_ls = {
		-- 	root_dir = lspConfig.util.root_pattern("package.json"),
		-- 	single_file_support = false,
		--           enable = true,
		-- },
		-- denols = {
		-- 	root_dir = lspConfig.util.root_pattern("deno.json", "deno.jsonc"),
		--           settings = {
		--               enable = true,
		--               lint = true
		--           },
		--           filetypes = {'javascript', 'javascriptreact', 'javascript.jsx', 'typescript', 'typescriptreact', 'typescript.tsx', 'vue'}
		-- },
		cssls = {},
        jsonls = {},
        html = {}
	}

	require("mason").setup()

	-- You can add other tools here that you want Mason to install
	-- for you, so that they are available from within Neovim.
	local ensure_installed = vim.tbl_keys(serversDefinition or {})
	vim.list_extend(ensure_installed, {
		"stylua", -- Used to format Lua code
		"netcoredbg",
	})
	require("mason-tool-installer").setup({ ensure_installed = ensure_installed })

	require("mason-lspconfig").setup({
		handlers = {
			function(server_name)
				local server = serversDefinition[server_name] or {}
				-- This handles overriding only values explicitly passed
				-- by the server configuration above. Useful when disabling
				-- certain features of an LSP (for example, turning off formatting for ts_ls)
				server.capabilities = vim.tbl_deep_extend("force", {}, capabilities, server.capabilities or {})
				require("lspconfig")[server_name].setup(server)
			end,
		},
		ensure_installed = {},
		automatic_installation = false,
	})
end

return servers
