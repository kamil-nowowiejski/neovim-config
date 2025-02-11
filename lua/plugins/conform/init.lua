return {
	-- Autoformat
	"stevearc/conform.nvim",
	event = { "BufWritePre" },
	cmd = { "ConformInfo" },
	keys = {
		{
			"<leader>f",
			function()
				require("conform").format({ async = true, lsp_format = "never" })
			end,
			mode = "",
			desc = "[F]ormat buffer",
		},
	},
	opts = {
		notify_on_error = false,
        log_level = vim.log.levels.TRACE,
		formatters_by_ft = {
			lua = { "stylua" },
			typescript = { "my_deno_format", lsp_format = "never" },
			javascript = { "my_deno_format", lsp_format = "never" },
			typescriptreact = { "my_deno_format", lsp_format = "never" },
			javascriptreact = { "my_deno_format", lsp_format = "never" },
            cs = {"csharp_format", lsp_format = "never"}
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
	},
}
