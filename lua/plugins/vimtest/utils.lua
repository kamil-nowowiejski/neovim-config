local M = {}

-- M.parseCmd = function(vimTestCmd)
-- 	local args = {}
-- 	for arg in vimTestCmd:gmatch("%S+") do
-- 		table.insert(args, arg)
-- 	end
-- 	return args
-- end

M.parseCmd = function(vimTestCmd)
    local args = {}

    local currentArg = ''
    local isQuoteToken = false
    local function isWhiteSpace(char) return char == " " end
    local function isQuote(char) return char == '"' or char == "''" end
    local function addArg() table.insert(args, currentArg); currentArg = '' end
    local function addCharToArg(char) currentArg = currentArg .. char end

    for char in vimTestCmd:gmatch(".") do
        if isWhiteSpace(char) then
            if isQuoteToken then addCharToArg(char)
            elseif currentArg ~= nil then addArg() end
        elseif isQuote(char) then
            isQuoteToken = not isQuoteToken
        else
            addCharToArg(char)
        end
    end

    if currentArg ~= nil then addArg() end

    return args
end

-- local args = parseCmd2('node_modules/.bin/jest --runTestsByPath -t "^validate conditions pre refinement completion" -- test\\views\\REfinementToole\\cos.test.ts')
-- print(vim.inspect(args))

return M
