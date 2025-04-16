
return {
	"vim-test/vim-test",
    dependencies = {
        "manoelcampos/xml2lua", -- used for parsing TRX files 
    },
	config = function()
        local dotnetRunner = require('plugins.vimtest.dotnet_test_runner')
        dotnetRunner.setup()

        local jsRunner = require('plugins.vimtest.jsTestRunner')

		vim.g["test#custom_strategies"] = {
            dotnetRun = dotnetRunner.run,
			dotnetDebug = dotnetRunner.debug,
            jsRun = jsRunner.run,
            jsDebug = jsRunner.debug
		}

        local events = { "BufEnter" }
        vim.api.nvim_create_autocmd(events, {
            pattern = "*.cs",
            callback = function(ev)
                vim.keymap.set("n", "<leader>tn", "<cmd>TestNearest -strategy=dotnetRun<cr>", { buffer = ev.buf})
                vim.keymap.set("n", "<leader>dn", "<cmd>TestNearest -strategy=dotnetDebug<cr>", { buffer = ev.buf})
            end
        })

        vim.api.nvim_create_autocmd(events, {
            pattern = { "*.js", "*.ts" },
            callback = function(ev)
                vim.keymap.set("n", "<leader>tn", "<cmd>TestNearest -strategy=jsRun<cr>", { buffer = ev.buf})
                vim.keymap.set("n", "<leader>dn", "<cmd>TestNearest -strategy=jsDebug<cr>", { buffer = ev.buf})
            end
        })

	end,
}
