local M = {}


function M.getFileExtension(filePath)
	local reversed = filePath:reverse()
	local dotIndex = reversed:find("%.")
	local ex = reversed:sub(1, dotIndex):reverse()
	return ex
end

return M
