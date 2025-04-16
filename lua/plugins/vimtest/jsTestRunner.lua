local M = {}

M.run = function(vimTestCmd)
	local testExplorer = require("plugins.vimtest.testexplorer")
	testExplorer.open()

    local utils = require('plugins.vimtest.utils')
	local cmd = utils.parseCmd(vimTestCmd)
    local jestPath = vim.fn.getcwd() .. '/node_modules/.bin/jest'
    table.remove(cmd, 1)
    table.insert(cmd, 1, jestPath)
    print(vim.inspect(cmd))
	vim.system(cmd, {
        stderr = testExplorer.handleStdout, --this is not a mistake, jest writes to standard error
		text = true,
        cwd = vim.fn.getcwd()
	})
end

M.debug = function(vimTestCmd)
    print(vim.inspect(vimTestCmd))
    -- require("dap").run({
    --     type = "pwa-node",
    --     request = "launch",
    --     name = "",
    --     program = "${file}",
    --     cwd = "${workspaceFolder}"
    -- })
end

return M
