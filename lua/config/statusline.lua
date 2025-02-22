MyStatusLine = {}
local Internal = {}

MyStatusLine.setup = function()
	MyStatusLine.create_autocommands()
	vim.go.statusline =
		"%{%(nvim_get_current_win()==#g:actual_curwin) ? v:lua.MyStatusLine.active() : v:lua.MyStatusLine.inactive()%}"
end

MyStatusLine.active = function()
	return table.concat({
        "%#HLMyStatusLineRegular#",
		"  ",
		Internal.getFilePath(),
		" ",
		Internal.getLspStatus(),
		"%=",
		Internal.getIsUnsaved(),
		"%=",
		Internal.lineInfo(),
		"   ",
	})
end

MyStatusLine.inactive = function()
    return MyStatusLine.active()
end

MyStatusLine.create_autocommands = function()
	local function checkLspStatus(data)
		local clients = vim.lsp.get_clients({ bufnr = data.buf })
		Internal.attached_lsp[data.buf] = Internal.formatLspStatus(clients)
		vim.cmd("redrawstatus")
	end

	local autocommandsGroup = vim.api.nvim_create_augroup("MyStatusLineCmdGroup", {})
	vim.api.nvim_create_autocmd({ "LspAttach", "LspDetach" }, {
		group = autocommandsGroup,
		pattern = "*",
		callback = checkLspStatus,
	})
end

Internal.attached_lsp = {}

Internal.getFilePath = function()
	local currentFilePath = vim.fn.expand("%")
	local toDisplay = vim.fn.fnamemodify(currentFilePath, ":.")
    return "%#HLMyStatusLineRegular#%#HLMyStatusLineAccent#"..toDisplay.."%#HLMyStatusLineRegular#"
end

Internal.lineInfo = function()
	return "%#HLMyStatusLineAccent#%l:%c %p%%%#HLMyStatusLineRegular#"
end

Internal.formatLspStatus = function(clients)
	return string.rep("", #clients)
end

Internal.getLspStatus = function()
	local status = Internal.attached_lsp[vim.api.nvim_get_current_buf()]
	if status == nil then
		return ""
	else
		return status
	end
end

Internal.getIsUnsaved = function()
	local isBufModified = vim.bo[vim.api.nvim_win_get_buf(0)].modified
    local isInsertMode = vim.api.nvim_get_mode()["mode"] == "i"
	if isBufModified and isInsertMode == false then
		return "%#HLMyStatusLineUnsaved#           UNSAVED           %#HLMyStatusLineRegular#"
	else
		return ""
    end
end

return MyStatusLine
