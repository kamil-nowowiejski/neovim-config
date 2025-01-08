local keymap = {}

function keymap.setup(event)
	local map = function(keys, func, desc, mode)
		mode = mode or "n"
		vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
	end

	map("gd", require("omnisharp_extended").telescope_lsp_definitions, "[G]oto [D]efinition")

	vim.keymap.set(
		"n",
		"<leader>gd",
		'<cmd>lua require"omnisharp_extended".telescope_lsp_definitions({jump_type="split"})<CR>',
		{ noremap = true, silent = true }
	)

	map("gr", require("omnisharp_extended").telescope_lsp_references, "[G]oto [R]eferences")
	map("gI", require("telescope.builtin").lsp_implementations, "[G]oto [I]mplementation")

	-- Jump to the type of the word under your cursor.
	--  Useful when you're not sure what type a variable is and you want to see
	--  the definition of its *type*, not where it was *defined*.
	map("<leader>D", require("telescope.builtin").lsp_type_definitions, "Type [D]efinition")

	map("<leader>ds", require("telescope.builtin").lsp_document_symbols, "[D]ocument [S]ymbols")
	map("<leader>ws", require("telescope.builtin").lsp_dynamic_workspace_symbols, "[W]orkspace [S]ymbols")
	map("<leader>rn", require("plugins.lspconfig.renameHandler").rename, "[R]e[n]ame")
	map("<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction", { "n", "x" })
	map("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")
	vim.keymap.set("n", "<leader>em", "<cmd>lua vim.diagnostic.open_float()<CR>")

	vim.keymap.set("n", "<leader>p", vim.lsp.buf.signature_help)
	vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
		border = "single",
	})
	vim.keymap.set("n", "<leader>i", vim.lsp.buf.hover)
	vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
		border = "single",
	})
	vim.keymap.set("n", "<leader>I", require('omnisharp_extended').lsp_implementation)
	vim.keymap.set("n", "<leader>r", require('omnisharp_extended').lsp_references)
	vim.keymap.set("n", "gt", require('omnisharp_extended').lsp_type_definition)
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
