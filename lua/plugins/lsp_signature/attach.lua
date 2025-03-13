local m = {}

function m.attach(event)

local opts = {
	bind = true,
	handler_opts = {
		border = "rounded",
	},
	hint_prefix = {
		above = "↙ ", -- when the hint is on the line above the current line
		current = "← ", -- when the hint is on the same line
		below = "↖ ", -- when the hint is on the line below the current line
	},
}

    require('lsp_signature').on_attach(opts, event.bufnr)

end

return m
