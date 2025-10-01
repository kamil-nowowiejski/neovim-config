return {
	-- Autoformat
	"stevearc/conform.nvim",
	event = { "BufWritePre" },
	cmd = { "ConformInfo" },
	keys = {
		{
			"<leader>f",
			function()
				local opts = { async = true, lsp_format = "never" }
				local didEditSomething = false
				local callback = function(error, didEdit)
					didEditSomething = didEdit
				end
				local didFormat = require("conform").format(opts, callback)

				if didFormat and didEditSomething then
					print("Formating successful")
				elseif didFormat and didEditSomething == false then
					print("Formatter produced no changes.")
				else
					print("No formatting has been performed")
				end
			end,
			mode = "",
			desc = "[F]ormat buffer",
		},
	},
	opts = {
		notify_on_error = true,
		formatters_by_ft = {
			lua = { "stylua" },
			typescript = { "prettierd", "prettier", "my_deno_format", stop_after_first = true, lsp_format = "never" },
			javascript = { "prettierd", "prettier", "my_deno_format", stop_after_first = true, lsp_format = "never" },
			typescriptreact = { "prettierd", "prettier", "my_deno_format", stop_after_first = true, lsp_format = "never" },
			javascriptreact = { "prettierd", "prettier", "my_deno_format", stop_after_first = true, lsp_format = "never" },
			cs = { "csharpier", "csharp_format", lsp_format = "never" },
			-- Conform can also run multiple formatters sequentially
			-- python = { "isort", "black" },
			--
			-- You can use 'stop_after_first' to run the first available formatter from the list
			-- javascript = { "prettierd", "prettier", stop_after_first = true },
		},
		formatters = {
			my_deno_format = require("plugins.conform.deno"),
			csharp_format = require("plugins.conform.dotnetformat"),
		},
		format_after_save = nil,
		format_on_save = nil,
	},
}
