
return {
	"vim-test/vim-test",
    dependencies = {
        "manoelcampos/xml2lua", -- used for parsing TRX files 
    },
	config = function()
        local dotnetRunner = require('plugins.vimtest.dotnet_test_runner')
        dotnetRunner.setup()

		vim.g["test#custom_strategies"] = {
            dotnetRun = dotnetRunner.run,
			dotnetDebug = dotnetRunner.debug,
		}

        vim.keymap.set("n", "<leader>tn", "<cmd>TestNearest -strategy=dotnetRun<cr>")
        vim.keymap.set("n", "<leader>dn", "<cmd>TestNearest -strategy=dotnetDebug<cr>")

	end,
}
