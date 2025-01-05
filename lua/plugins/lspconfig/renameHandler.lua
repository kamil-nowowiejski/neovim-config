local renameHandler = {}

local function getFileExtension(filePath)
	local reversed = filePath:reverse()
	local dotIndex = reversed:find("%.")
	local ex = reversed:sub(1, dotIndex):reverse()
	return ex
end

local function getLspClient(fileExtension, config)
	local lspClientName = nil
	for i = 1, #config, 1 do
		for j = 1, #config[i].extensions, 1 do
			if config[i].extensions[j] == fileExtension then
				lspClientName = config[i].lsp
			end
		end
	end
	if lspClientName == nil then
		return nil
	end
	local lspClient = nil
	local allClients = vim.lsp.get_clients()
	for j = 1, #allClients, 1 do
		if allClients[j].name == lspClientName then
			lspClient = allClients[j]
		end
	end
	if lspClient == nil then
		print(lspClientName .. " has not started yet")
	end
    return lspClient
end

function renameHandler.rename()
	local config = {
		{ extensions = { ".cs" }, lsp = "omnisharp" },
	}

	local oldName = vim.fn.expand("<cword>")
	local cursorPosition = vim.api.nvim_win_get_cursor(0)
	vim.ui.input({ prompt = "New Name: " }, function(newName)
		if newName == nil then
			return
		end

		local filePath = vim.api.nvim_buf_get_name(0)
		local fileExtension = getFileExtension(filePath)
		local lspClient = getLspClient(fileExtension, config)
		if lspClient ~= nil then
			local pattern = "[%d%a]+%" .. fileExtension
			local fileName = filePath:match(pattern)
			local fileNameNoExtension = fileName:sub(1, -4)
			if oldName == fileNameNoExtension and newName ~= fileNameNoExtension then
				vim.cmd("silent w")
				local newFile = newName .. fileExtension
				local fileFolder = filePath:sub(1, -#fileName - 1)
				local command = "cd " .. fileFolder:sub(1, -2) .. " & ren " .. fileName .. " " .. newFile
				os.execute(command)
				vim.api.nvim_buf_delete(0, { force = true })
				vim.cmd("e " .. fileFolder .. newFile)
				vim.api.nvim_win_set_cursor(0, cursorPosition)

				local ms = require("vim.lsp.protocol").Methods
				local handler = lspClient.handlers[ms.textDocument_semanticTokens_full]
					or vim.lsp.handlers[ms.textDocument_semanticTokens_full]
				lspClient.request(ms.textDocument_semanticTokens_full, {}, function(...)
					if handler ~= nil then
						handler(...)
					end
					vim.lsp.buf.rename(newName)
				end)
			else
				vim.lsp.buf.rename(newName)
			end
		else
			vim.lsp.buf.rename(newName)
		end
	end)
end

return renameHandler
