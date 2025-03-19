-- [[ Basic Autocommands ]]
--  See `:help lua-guide-autocommands`

-- Highlight when yanking (copying) text
--  Try it with `yap` in normal mode
--  See `:help vim.highlight.on_yank()`
vim.api.nvim_create_autocmd("TextYankPost", {
	desc = "Highlight when yanking (copying) text",
	group = vim.api.nvim_create_augroup("kickstart-highlight-yank", { clear = true }),
	callback = function()
		vim.highlight.on_yank()
	end,
})

-- Auto-save on insert leave
vim.api.nvim_create_autocmd("InsertLeave", {
	desc = "Auto-save when leaving insert mode",
    pattern = { "*.cs", "*.lua", "*.vue", "*.js", "*.ts", "*.csproj" },
	callback = function()
		local isInCurrentProject = function()
			local bufName = vim.api.nvim_buf_get_name(0)
			if bufName == nil or #bufName == 0 then
				return false
			end
			local rootDir = vim.fn.getcwd()
			return vim.fn.finddir(rootDir, bufName) ~= 0
		end

		local isModifiable = function()
			local bufId = vim.api.nvim_win_get_buf(0)
			return vim.bo[bufId].readonly == false
		end

		if isInCurrentProject() and isModifiable() then
			vim.cmd("silent w")
		end
	end,
})

vim.api.nvim_create_autocmd("ColorScheme", {
	pattern = "*",
	callback = function()
		local groups = {
			--status line
            HLMyStatusLineRegular = {
                bg = "#595453",
                fg = "#b8b4a9"
            },
			HLMyStatusLineUnsaved = {
				bg = "#781807",
                fg = "#edc337"
			},
            HLMyStatusLineAccent = {
                bg = "#aba09d",
                fg = "#242323"
            },

            -- test explorer
            HLTestSuccess = {
                fg = "#32a852",
            },
            HLTestFailed = {
                fg = "#fc0303",
            }
		}

		for group, options in pairs(groups) do
			vim.api.nvim_set_hl(0, group, options)
		end
	end,
})

vim.api.nvim_create_autocmd("User", {
	desc = "Open last edited file in working directory",
	pattern = { "LazyVimStarted" },
	callback = function()
		pcall(function()
			if vim.fn.argc() == 0 then
				local workingDir = vim.fn.getcwd()
				local recentFiles = vim.v.oldfiles
				for i = #recentFiles, 1, -1 do
					local recentFile = recentFiles[i]
					if recentFile:sub(1, #workingDir) == workingDir then
						local extension = require("utils.file").getFileExtension(recentFile):sub(2, -1)
						local fileType = ""

						if extension == "cs" then
							fileType = "cs"
						elseif extension == "js" then
							fileType = "javascript"
						elseif extension == "ts" then
							fileType = "typescript"
						elseif extension == "lua" then
							fileType = "lua"
						end

						if fileType ~= "" then
							vim.cmd("e " .. recentFile .. " | set filetype=" .. fileType)
						end
					end
				end
			end
		end)
	end,
})
