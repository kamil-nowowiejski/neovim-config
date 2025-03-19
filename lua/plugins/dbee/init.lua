local function getSourcesFromWorkingDirectory()
    local cwd = vim.uv.cwd()
    local jsonFiles = vim.fn.glob(cwd..'/*.json', false, true)
    local sources = {}
    for _, jsonFile in pairs(jsonFiles) do
        local source = require("plugins.dbee.sources").NotEditableFileSource:new(jsonFile)
        sources[#sources+1] = source
    end
    return sources
end

return {
	"kndndrj/nvim-dbee",
	dependencies = {
		"MunifTanjim/nui.nvim",
	},
	build = function()
		-- Install tries to automatically detect the install method.
		-- if it fails, try calling it with one of these parameters:
		--    "curl", "wget", "bitsadmin", "go"
		require("dbee").install("curl")
	end,
	config = function()
		require("dbee").setup({

			sources = getSourcesFromWorkingDirectory(),

			drawer = {
				disable_help = true,
				mappings = {
					-- manually refresh drawer
					{ key = "r", mode = "n", action = "refresh" },
					-- actions perform different stuff depending on the node:
					-- action_1 opens a note or executes a helper
					{ key = "<CR>", mode = "n", action = "action_1" },
					-- action_2 renames a note or sets the connection as active manually
					{ key = "cw", mode = "n", action = "action_2" },
					-- action_3 deletes a note or connection (removes connection from the file if you configured it like so)
					{ key = "dd", mode = "n", action = "action_3" },
					-- these are self-explanatory:
					-- { key = "c", mode = "n", action = "collapse" },
					-- { key = "e", mode = "n", action = "expand" },
					{ key = "o", mode = "n", action = "toggle" },
					-- mappings for menu popups:
					{ key = "<CR>", mode = "n", action = "menu_confirm" },
					{ key = "y", mode = "n", action = "menu_yank" },
					{ key = "<Esc>", mode = "n", action = "menu_close" },
					{ key = "q", mode = "n", action = "menu_close" },
				},
			},

			editor = {
                directory = vim.uv.cwd(),
				mappings = {
					-- run what's currently selected on the active connection
					{ key = "BB", mode = "v", action = "run_selection" },
					-- run the whole file on the active connection
					{ key = "BB", mode = "n", action = "run_file" },
				},
			},

			result = {
				focus_result = false,
				mappings = {
					-- next/previous page
					{ key = "L", mode = "", action = "page_next" },
					{ key = "H", mode = "", action = "page_prev" },
					{ key = "E", mode = "", action = "page_last" },
					{ key = "F", mode = "", action = "page_first" },
					-- yank rows as csv/json
					{ key = "yaj", mode = "n", action = "yank_current_json" },
					{ key = "yaj", mode = "v", action = "yank_selection_json" },
					{ key = "yaJ", mode = "", action = "yank_all_json" },
					{ key = "yac", mode = "n", action = "yank_current_csv" },
					{ key = "yac", mode = "v", action = "yank_selection_csv" },
					{ key = "yaC", mode = "", action = "yank_all_csv" },

					-- cancel current call execution
					{ key = "<C-c>", mode = "", action = "cancel_call" },
				},
			},
		})

		vim.api.nvim_create_user_command("DbeeOpen", function()
			local dbeeApiUi = require("dbee.api.ui")

			local function getDrawerWindow(name)
				local windows = vim.api.nvim_list_wins()
				for _, win in ipairs(windows) do
					local buf = vim.api.nvim_win_get_buf(win)
					local bufName = vim.api.nvim_buf_get_name(buf)
					if bufName:match("drawer$") then
						return win
					end
				end
			end

			local function collapseAllNodes(drawerWindow, drawerBuf)
				local linesCount = vim.api.nvim_buf_line_count(drawerBuf)
				for line = linesCount, 1, -1 do
					vim.api.nvim_win_set_cursor(drawerWindow, { line, 1 })
                    dbeeApiUi.drawer_do_action("collapse")
				end
			end

            local function expandLocalNotes(drawerWindow, drawerBuf)
                local lines = vim.api.nvim_buf_get_lines(drawerBuf, 1, -1, true)
                for i, line in pairs(lines) do
                    if line:find("local notes", 1, false) ~= nil then
					    vim.api.nvim_win_set_cursor(drawerWindow, { i+1, 1 })
                        dbeeApiUi.drawer_do_action("expand")
                        return
                    end
                end
            end

			require("dbee").open()

            local drawerWindow = getDrawerWindow("drawer")
            local drawerBuf = vim.api.nvim_win_get_buf(drawerWindow)
			collapseAllNodes(drawerWindow, drawerBuf)
            expandLocalNotes(drawerWindow, drawerBuf)

		end, {})

        vim.api.nvim_create_autocmd("BufEnter", {
            pattern = {"*.sql"},
            command = "set filetype=sql"
        })
	end,
}
