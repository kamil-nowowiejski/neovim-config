local M = {}

local testProcessOutputBuffer = -1
local lastTestRunTrxFile = vim.fn.stdpath('data').."/LastTestRun.trx"

local function parseCmd(vimTestCmd)
	local args = {}
	for arg in vimTestCmd:gmatch("%S+") do
		table.insert(args, arg)
	end
	return args
end

local function modifyTestBuffer(modifyFunction)
    local setOptionOpts = {
        buf = testProcessOutputBuffer,
    }
    vim.api.nvim_set_option_value("readonly", false, setOptionOpts)
    modifyFunction()
    vim.api.nvim_set_option_value("readonly", true, setOptionOpts)
    vim.api.nvim_set_option_value("modified", false, setOptionOpts)
end

local function clearTestBuffer()
    modifyTestBuffer(function()
        vim.api.nvim_buf_set_lines(testProcessOutputBuffer, 0, -1, false, {})
    end)
end

local function appendLinesToTestBuffer(lines)
    modifyTestBuffer(function()
        vim.api.nvim_buf_set_lines(testProcessOutputBuffer, -1, -1, true, lines)
    end)
end

local function openTestProcessOutputBuffer()
	local isBufferVisible = vim.api.nvim_call_function("bufwinnr", { testProcessOutputBuffer }) ~= -1
	if testProcessOutputBuffer == -1 or isBufferVisible == false then
		vim.api.nvim_command("belowright split 'Test Output'")
		testProcessOutputBuffer = vim.api.nvim_get_current_buf()
		vim.opt_local.readonly = true
	end

    if testProcessOutputBuffer ~= -1 then
        clearTestBuffer()
    end
end

M.setup = function()
	local dap = require("dap")
	dap.adapters.netcoredgbForTests = {
		type = "executable",
		command = vim.fn.stdpath("data") .. "/mason/packages/netcoredbg/netcoredbg/netcoredbg.exe",
		args = { "--interpreter=vscode" },
	}
end

M.run = function(vimTestCmd)
	local handleStdout = function(error, data)
		if data == nil then
			return
		end
		vim.schedule(function()
            local splitData = vim.split(data, '\r\n')
            appendLinesToTestBuffer(splitData)

			local window = vim.api.nvim_call_function("bufwinid", { testProcessOutputBuffer })
			local linesCount = vim.api.nvim_buf_line_count(testProcessOutputBuffer)
			vim.api.nvim_win_set_cursor(window, { linesCount, 0 })
		end)
	end

	openTestProcessOutputBuffer()
	local cmd = parseCmd(vimTestCmd)
    table.insert(cmd, "--logger")
    table.insert(cmd, "trx;LogFileName="..lastTestRunTrxFile)
	vim.system(cmd, {
		stdout = handleStdout,
		text = true,
	})
end

M.debug = function(vimTestCmd)
	local debuggerStarted = false
	local handleStdout = function(error, data)
		if data == nil then
			return
		end
		print(data)
		local dotnetPid = string.match(data, "Process Id%p%s(%d+)")
		if debuggerStarted == false and dotnetPid ~= nil then
			debuggerStarted = true
			vim.schedule(function()
				require("dap").run({
					type = "netcoredgbForTests",
					request = "attach",
					name = "",
					processId = dotnetPid,
				})
			end)
		end
	end

	local cmd = parseCmd(vimTestCmd)

	vim.system(cmd, {
		stdout = handleStdout,
		text = true,
		env = { ["VSTEST_HOST_DEBUG"] = "1" },
	})
end

return M
