local M = {}

local function readFileContent(filePath)
	local file = assert(io.open(filePath, "r"))
	local content = file:read("*all")
	file:close()
	return content:sub(4) -- this line removes BOM bytes
end

local function getTrxTree(fileContent)
	local xml2lua = require("xml2lua")
	local handler = require("xmlhandler.tree")
	local parser = xml2lua.parser(handler)
	parser:parse(fileContent)
	return handler.root
end

--- @return Test
local function parseTest(unitTestResult)
	local getStatus = function()
		if unitTestResult._attr.outcome == "Failed" then
			return "failed"
		elseif unitTestResult._attr.outcome == "Passed" then
			return "success"
		else
			error("Unknown TRX test status " .. unitTestResult._attr.outcome)
		end
	end

	local getErrorMessage = function()
		if unitTestResult.Output ~= nil then
			return unitTestResult.Output.ErrorInfo.Message
		end
	end

	local getStackTrace = function()
		if unitTestResult.Output ~= nil then
			return unitTestResult.Output.ErrorInfo.StackTrace
		end
	end

    error("this function does not return correct object")
	return {
		name = unitTestResult._attr.testName,
		status = getStatus(),
		duration = unitTestResult._attr.duration,
		errorMessage = getErrorMessage(),
		stackTrace = getStackTrace(),
	}
end

--- @return Test[]
M.parse = function(trxPath)
	local fileContent = readFileContent(trxPath)
	local trxTree = getTrxTree(fileContent)

	local unitTestResults = nil
	if trxTree.TestRun.Results ~= nil then
		unitTestResults = trxTree.TestRun.Results.UnitTestResult
	elseif trxTree.TestRun[1].Results ~= nil then
		unitTestResults = trxTree.TestRun[1].Results.UnitTestResult
	else
		error("Implement better TRX parsing")
	end

    --- @type Test[]
	local tests = {}
	for _, value in ipairs(unitTestResults) do
		local test = parseTest(value)
		tests[#tests + 1] = test
	end

	return tests
end

return M
