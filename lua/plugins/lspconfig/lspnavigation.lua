local M = {}
local function isCsharpFile()
	local filePath = vim.api.nvim_buf_get_name(0)
	local fileExtension = require("utils.file").getFileExtension(filePath)
	return fileExtension == ".cs"
end

function M.definitions()
	if isCsharpFile() then
		require("omnisharp_extended").telescope_lsp_definitions()
	else
		require("telescope.builtin").lsp_definitions()
	end
end

function M.definitions_split()
	local command = ""
	if isCsharpFile() then
		command = '<cmd>lua require"omnisharp_extended".telescope_lsp_definitions({jump_type="split"})<CR>'
	else
		command = '<cmd>lua require"telescope.builtin".lsp_definitions({jump_type="split"})<CR>'
	end
	return command
end

function M.type_definitions()
	if isCsharpFile() then
		require("omnisharp_extended").telescope_lsp_type_definition()
	else
		require("telescope.builtin").lsp_type_definitions()
	end
end

function M.references()
	if isCsharpFile() then
		require("omnisharp_extended").telescope_lsp_references()
	else
		require("telescope.builtin").lsp_references()
	end
end

function M.refernces_quickfix()
	if isCsharpFile() then
		require("omnisharp_extended").lsp_references()
	else
		vim.lsp.buf.references()
	end
end

function M.implementations()
	if isCsharpFile() then
		require("omnisharp_extended").telescope_lsp_implementation()
	else
		require("telescope.builtin").lsp_implementations()
	end
end

function M.implementations_quickfix()
	if isCsharpFile() then
		require("omnisharp_extended").lsp_implementation()
	else
		vim.lsp.buf.implementation()
	end
end
return M
