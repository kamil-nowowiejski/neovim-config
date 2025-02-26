return {
	"vim-test/vim-test",
	config = function()
		local dap = require("dap")
		vim.g["test#custom_strategies"] = {
			dap = function(cmd)
				local cmd2 =
					" -- dotnet test C:\\GitRepos\\TimeSheeter\\Test\\Test.csproj --filter FullyQualifiedName=Test.QuickTest.Run"
				dap.adapters.netcoredgbForTests = {
					type = "executable",
					command = vim.fn.stdpath("data") .. "/mason/packages/netcoredbg/netcoredbg/netcoredbg.exe",
					args = { "--interpreter=vscode" },
				}
				dap.run({
					type = "netcoredgbForTests",
					request = "launch",
					name = "",
                    program = "test C:\\GitRepos\\TimeSheeter\\Test\\Test.csproj --filter FullyQualifiedName=Test.QuickTest.Run"
				})
			end,
		}
	end,
}
