MyStatusLine = {}
Internal = {}

MyStatusLine.setup = function()
	MyStatusLine.create_autocommands()
	vim.go.statusline =
		"%{%(nvim_get_current_win()==#g:actual_curwin) ? v:lua.MyStatusLine.active() : v:lua.MyStatusLine.inactive()%}"
end

MyStatusLine.active = function()
	return table.concat({
		"  ",
		Internal.getFilePath(),
		" ",
		Internal.getLspStatus(),
		Internal.lineInfo(),
		"   ",
	})
end

MyStatusLine.inactive = function()
	return ""
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

	vim.api.nvim_create_autocmd({ "LspProgress" }, {
		group = autocommandsGroup,
		pattern = "*",
		callback = function(data)
			Internal.showFloatingWindow(data)
			-- Internal.showVirtualText(data)
		end,
	})
end

Internal.attached_lsp = {}

Internal.getFilePath = function()
	local currentFilePath = vim.fn.expand("%")
	return vim.fn.fnamemodify(currentFilePath, ":.")
end

Internal.lineInfo = function()
	return "%=%l:%c %p%%"
end

Internal.formatLspStatus = function(clients)
	return string.rep("", #clients)
end

Internal.showVirtualText = function(event)
	if event.data == nil or event.data.params == nil or event.data.params.value == nil then
		return
	end

	local token = event.data.params.token
	local value = event.data.params.value

	local bufnr = 0
	local col_num = 0
	local opts = {
		virt_text_pos = "right_align",
		sign_text = "XD",
	}

	local getLineForNewMark = function()
		local line = Internal.max_relative_line
		Internal.max_relative_line = Internal.max_relative_line + 1
		return line
	end

	local mark = Internal.lspProgressMarks[token]

	if value.kind == "begin" then
		opts.virt_text = { { value.title } }
		local relative_line_num = getLineForNewMark()
		local line_num = vim.fn.line("w$") - relative_line_num
		local mark_id = vim.api.nvim_buf_set_extmark(bufnr, Internal.namespace_id, line_num, col_num, opts)
		Internal.lspProgressMarks[token] = {
			mark_id = mark_id,
			relative_line_num = relative_line_num,
		}
		print(vim.inspect(Internal.lspProgressMarks))
		print(value.title)
	elseif value.kind == "report" then
		opts.id = mark.mark_id
		local text = string.format("%s %d%%", value.title, value.percentage)
		local line_num = vim.fn.line("w$") - mark.relative_line_num
		opts.virt_text = { { text } }
		vim.api.nvim_buf_set_extmark(bufnr, Internal.namespace_id, line_num, col_num, opts)
		print(text)
	elseif value.kind == "end" then
		vim.api.nvim_buf_del_extmark(bufnr, Internal.namespace_id, mark.mark_id)
		Internal.lspProgressMarks[token] = nil
	end
end

Internal.lspProgressFloatingWindow = nil;

Internal.showFloatingWindow = function(event)
	if event.data == nil or event.data.params == nil or event.data.params.value == nil then
		return
	end

	local openFloatingWindow = function()
		local buf = vim.api.nvim_create_buf(false, true)
		local ui = vim.api.nvim_list_uis()[0]
		local opts = {
			relative = "win",
			width = 30,
			height = 30,
			anchor = "SE",
			focusable = false,
			border = "none",
		}
		Internal.lspProgressFloatingWindow = vim.api.nvim_open_win(buf, false, opts)
	end

	local token = event.data.params.token
	local value = event.data.params.value

	local bufnr = 0
	local col_num = 0
	local opts = {
		virt_text_pos = "right_align",
		sign_text = "XD",
	}

	local getLineForNewMark = function()
		local line = Internal.max_relative_line
		Internal.max_relative_line = Internal.max_relative_line + 1
		return line
	end

	local mark = Internal.lspProgressMarks[token]

	if value.kind == "begin" then
		opts.virt_text = { { value.title } }
		local relative_line_num = getLineForNewMark()
		local line_num = vim.fn.line("w$") - relative_line_num
		local mark_id = vim.api.nvim_buf_set_extmark(bufnr, Internal.namespace_id, line_num, col_num, opts)
		Internal.lspProgressMarks[token] = {
			mark_id = mark_id,
			relative_line_num = relative_line_num,
		}
		print(vim.inspect(Internal.lspProgressMarks))
		print(value.title)
	elseif value.kind == "report" then
		opts.id = mark.mark_id
		local text = string.format("%s %d%%", value.title, value.percentage)
		local line_num = vim.fn.line("w$") - mark.relative_line_num
		opts.virt_text = { { text } }
		vim.api.nvim_buf_set_extmark(bufnr, Internal.namespace_id, line_num, col_num, opts)
		print(text)
	elseif value.kind == "end" then
		vim.api.nvim_buf_del_extmark(bufnr, Internal.namespace_id, mark.mark_id)
		Internal.lspProgressMarks[token] = nil
	end
end
Internal.namespace_id = vim.api.nvim_create_namespace("lsp_progress")
Internal.lspProgressMarks = {}
Internal.max_relative_line = 0

Internal.getLspStatus = function()
	local status = Internal.attached_lsp[vim.api.nvim_get_current_buf()]
	if status == nil then
		return ""
	else
		return status
	end
end

return MyStatusLine
