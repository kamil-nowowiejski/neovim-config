local keymap = {}

function keymap.setup(event)
	local map = function(keys, func, desc, mode)
		mode = mode or "n"
		vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
	end

    ------ Definitions ------
	map("gd", require('plugins.lspconfig.lspnavigation').definitions, "[G]oto [D]efinition")

	vim.keymap.set(
		"n",
		"<leader>gd",
		require('plugins.lspconfig.lspnavigation').definitions_split(),
		{ noremap = true, silent = true }
	)

	map("<leader>D", require("plugins.lspconfig.lspnavigation").type_definitions, "Type [D]efinition")
	vim.keymap.set("n", "gt", vim.lsp.buf.type_definition)
    ------------------------

    ------ Declarations ------
	map("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")
    ------------------------

    ------ References ------
	map("gr", require("plugins.lspconfig.lspnavigation").references, "[G]oto [R]eferences")
	vim.keymap.set("n", "<leader>r", require('plugins.lspconfig.lspnavigation').refernces_quickfix)
    ------------------------

    ------ Implementations ------
	map("gI", require('plugins.lspconfig.lspnavigation').implementations, "[G]oto [I]mplementation")
	vim.keymap.set("n", "<leader>I", require('plugins.lspconfig.lspnavigation').implementations_quickfix)
    ------------------------

    ------ Symbols ------
	map("<leader>ds", require("telescope.builtin").lsp_document_symbols, "[D]ocument [S]ymbols")
	map("<leader>ws", require("telescope.builtin").lsp_dynamic_workspace_symbols, "[W]orkspace [S]ymbols")
    ------------------------

    ------ Code actions ------
	map("<leader>rn", require("plugins.lspconfig.renameHandler").rename, "[R]e[n]ame")
	map("<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction", { "n", "x" })
    ------------------------

    ------ Diagnostic + documentation ------
    vim.keymap.set("n", "<leader>em", "<cmd>lua vim.diagnostic.open_float()<CR>")

	vim.keymap.set("n", "<leader>p", vim.lsp.buf.signature_help)
	vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
		border = "single",
	})
	vim.keymap.set("n", "<leader>i", vim.lsp.buf.hover)
	vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
		border = "single",
	})
    ------------------------
	-- The following code creates a keymap to toggle inlay hints in your
	-- code, if the language server you are using supports them
	--
	-- This may be unwanted, since they displace some of your code
	local client = vim.lsp.get_client_by_id(event.data.client_id)
	if client and client.supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint) then
		map("<leader>th", function()
			vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = event.buf }))
		end, "[T]oggle Inlay [H]ints")
	end
end

return keymap
