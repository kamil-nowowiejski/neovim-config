local M = {}
---- Module input
--- @class Test
--- @field testName string
--- @field namespaceParts string[]
--- @field status "success" | "failure"
--- @field duration string
--- @field errorMessage string | nil applicable only if test failed
--- @field stackTrace string[] | nil applicable only if test failed

---- Internal tests tree representation
--- @class TestsTree
--- @field roots TestTreeNode

--- @class TestTreeNode
--- @field status "success" | "failure"
--- @field text string
--- @field isExpanded boolean
--- @field children TestTreeNode[]

--- @class NamespaceNode : TestTreeNode

--- @class TestNameNode : TestTreeNode
--- @field duration string

---- Internal representation of buffer lines
--- @class Line
--- @field text string
--- @field highlight LineHighlight
--- @field treeNode TestTreeNode

--- @class LineHighlight
--- @field name string
--- @field start number
--- @field finish number

--- @type number
local testExplorerBuffer = -1

--- @type TestsTree
local testsTree = nil

--- @type Line[]
local lines = nil

local function modifyTestBuffer(modifyFunction)
	local setOptionOpts = {
		buf = testExplorerBuffer,
	}
	vim.api.nvim_set_option_value("readonly", false, setOptionOpts)
	modifyFunction()
	vim.api.nvim_set_option_value("readonly", true, setOptionOpts)
	vim.api.nvim_set_option_value("modified", false, setOptionOpts)
end

local function clearTestBuffer()
	modifyTestBuffer(function()
		vim.api.nvim_buf_set_lines(testExplorerBuffer, 0, -1, false, {})
	end)
end

--- @param lines Line[] | string[]
local function appendLinesToTestBuffer(lines)
	if #lines == 0 then
		return
	end
	local isPlainString = type(lines[1]) == "string"
	modifyTestBuffer(function()
		--populate buffer with text
		local textLines = {}
		if isPlainString then
			textLines = lines
		else
			for _, line in pairs(lines) do
				textLines[#textLines + 1] = line.text
			end
		end
		vim.api.nvim_buf_set_lines(testExplorerBuffer, -1, -1, false, textLines)

		-- set highlights
		if isPlainString == false then
			for i, line in pairs(lines) do
				if line.highlight ~= nil then
					vim.api.nvim_buf_add_highlight(
						testExplorerBuffer,
						-1,
						line.highlight.name,
						i,
						line.highlight.start,
						line.highlight.finish
					)
				end
			end
		end
	end)
end

M.open = function()
	local isBufferVisible = vim.api.nvim_call_function("bufwinnr", { testExplorerBuffer }) ~= -1
	if testExplorerBuffer == -1 or isBufferVisible == false then
		vim.api.nvim_command("belowright split 'Test Output'")
		testExplorerBuffer = vim.api.nvim_get_current_buf()
        vim.api.nvim_set_option_value('readonly', true, { buf = testExplorerBuffer })
        vim.api.nvim_set_option_value('swapfile', false, { buf = testExplorerBuffer })
	end

	if testExplorerBuffer ~= -1 then
		clearTestBuffer()
	end
end

M.handleStdout = function(error, data)
	if data == nil then
		return
	end
	vim.schedule(function()
		local splitData = vim.split(data, "\r\n")
		appendLinesToTestBuffer(splitData)

		local window = vim.api.nvim_call_function("bufwinid", { testExplorerBuffer })
		local linesCount = vim.api.nvim_buf_line_count(testExplorerBuffer)
		vim.api.nvim_win_set_cursor(window, { linesCount, 0 })
	end)
end

local function redrawTree()
    lines = require("plugins.vimtest.lineConverter").convertToLines(testsTree)
	clearTestBuffer()
	appendLinesToTestBuffer(lines)
end

local function handleEnterKey()
	local window = vim.api.nvim_call_function("bufwinid", { testExplorerBuffer })
    local pos = vim.api.nvim_win_get_cursor(window)
    local row = pos[1] - 1
    lines[row].treeNode.isExpanded = not lines[row].treeNode.isExpanded
    redrawTree()
    vim.api.nvim_win_set_cursor(window, pos)
end

local function setupLocalKeymaps()
    vim.keymap.set("n", "<CR>", handleEnterKey, { buffer = testExplorerBuffer })
end

--- @param tests Test[]
M.showTests = function(tests)
    testsTree = require('plugins.vimtest.testTreeConverter').convertTestsToTestsTree(tests)
    redrawTree()
    setupLocalKeymaps()
end


local function _openExplorerForTesting()
    M.open()
    M.showTests({
        {
            testName = "test 1",
            namespaceParts = { "UnitTest", "Namespace1", "Namespace2", "Class1", "Class2" },
            status = "success",
            duration = "333",
        },
        {
            testName = "test 2",
            namespaceParts = { "UnitTest", "Namespace1", "Namespace2", "Class1" },
            status = "failure",
            duration = "546",
            errorMessage = "Buum",
            stackTrace = { "sss", "fff", "ggg" },
        },
        {
            testName = "test 3",
            namespaceParts = { "IntegrationTest", "Namespace1", "Namespace2", "Class1"},
            status = "failure",
            duration = "83435",
            errorMessage = "This blew up",
            stackTrace = { "aaaa", "jklhdgh", "hugdjgdjghjdhjghjgh" },
        }
    })
end

_openExplorerForTesting()

return M
