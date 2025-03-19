local sources = {}

sources.NotEditableFileSource = {}

function sources.NotEditableFileSource:new(path)
	if not path then
		error("no path provided")
	end
	local o = {
		path = path,
	}
	setmetatable(o, self)
	self.__index = self
	return o
end

function sources.NotEditableFileSource:name()
    local fileName = vim.fs.basename(self.path)
    return vim.fn.fnamemodify(fileName, ":r")
end

function sources.NotEditableFileSource:load()
	local path = self.path

	---@type ConnectionParams[]
	local conns = {}

	if not vim.loop.fs_stat(path) then
		return {}
	end

	local lines = {}
	for line in io.lines(path) do
		if not vim.startswith(vim.trim(line), "//") then
			table.insert(lines, line)
		end
	end

	local contents = table.concat(lines, "\n")
	local ok, data = pcall(vim.fn.json_decode, contents)
	if not ok then
		error('Could not parse json file: "' .. path .. '".')
		return {}
	end

	for _, conn in pairs(data) do
		if type(conn) == "table" then
			table.insert(conns, conn)
		end
	end

	return conns
end

return sources
