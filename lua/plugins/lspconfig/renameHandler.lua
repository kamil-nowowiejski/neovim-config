local M = {}

function M.rename()
	vim.ui.input({ prompt = "New Name: " }, function(newName)
		if newName == nil then
			return
		end

        vim.lsp.buf.rename(newName)
	end)
end

return M
