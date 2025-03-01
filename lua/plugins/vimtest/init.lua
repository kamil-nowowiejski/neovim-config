
return {
	"vim-test/vim-test",
	config = function()
        local dotnetRunner = require('plugins.vimtest.dotnet_test_runner')
        dotnetRunner.setup()

		vim.g["test#custom_strategies"] = {
            dotnetRun = dotnetRunner.run,
			dotnetDebug = dotnetRunner.debug,
		}
	end,
}
