local keymap = {}

function keymap.setup(event)
	local map = function(keys, func, desc, mode)
		mode = mode or "n"
		vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
	end

    local telescope = require("telescope.builtin")
    ------ Definitions ------
	map("gd", telescope.lsp_definitions, "[G]oto [D]efinition")

	vim.keymap.set(
		"n",
		"<leader>gd",
		'<cmd>lua require"telescope.builtin".lsp_definitions({jump_type="split"})<CR>',
		{ noremap = true, silent = true }
	)

	map("<leader>D", telescope.lsp_type_definitions, "Type [D]efinition")
	vim.keymap.set("n", "gt", vim.lsp.buf.type_definition)
    ------------------------

    ------ Declarations ------
	map("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")
    ------------------------

    ------ References ------
	map("gr", telescope.lsp_references, "[G]oto [R]eferences")
	vim.keymap.set("n", "<leader>r", vim.lsp.buf.references)
    vim.keymap.set("n", "<leader>ic", vim.lsp.buf.incoming_calls)
    vim.keymap.set("n", "<leader>oc", vim.lsp.buf.outgoing_calls)
    ------------------------

    ------ Implementations ------
	map("gI", telescope.lsp_implementations, "[G]oto [I]mplementation")
	vim.keymap.set("n", "<leader>I", vim.lsp.buf.implementation)
    ------------------------

    ------ Symbols ------
	map("<leader>ds", telescope.lsp_document_symbols, "[D]ocument [S]ymbols")
	map("<leader>ws", telescope.lsp_dynamic_workspace_symbols, "[W]orkspace [S]ymbols")
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
