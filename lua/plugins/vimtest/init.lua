
return {
	"vim-test/vim-test",
    dependencies = {
        "manoelcampos/xml2lua", -- used for parsing TRX files 
    },
	config = function()
        local dotnetRunner = require('plugins.vimtest.dotnet_test_runner')
        dotnetRunner.setup()

        local jsRunner = require('plugins.vimtest.jsTestRunner')

		vim.g["test#custom_strategies"] = {
            dotnetRun = dotnetRunner.run,
			dotnetDebug = dotnetRunner.debug,
            jsRun = jsRunner.run,
            jsDebug = jsRunner.debug
		}

        local function setupDotnetKeymaps(ev)
            vim.keymap.set("n", "<leader>tn", "<cmd>TestNearest -strategy=dotnetRun<cr>", { buffer = ev.buf})
            vim.keymap.set("n", "<leader>dn", "<cmd>TestNearest -strategy=dotnetDebug<cr>", { buffer = ev.buf})
        end

        local function setupJavascriptKeymaps(ev)
            vim.keymap.set("n", "<leader>tn", "<cmd>TestNearest -strategy=jsRun<cr>", { buffer = ev.buf})
            vim.keymap.set("n", "<leader>dn", "<cmd>TestNearest -strategy=jsDebug<cr>", { buffer = ev.buf})
        end

        local function setupAutocommands(keymapsSetup, filePattern)
            vim.api.nvim_create_autocmd("BufEnter", {
                pattern = filePattern,
                callback = function(ev) keymapsSetup(ev) end
            })

            vim.api.nvim_create_autocmd("User", {
                pattern = { "LazyVimStarted" },
                callback = function(ev)
                    local file = vim.api.nvim_buf_get_name(ev.buf)
                    for _, pattern in pairs(filePattern) do
                        print(ev.buf)
                        print('file:   '..file)
                        print('pattern   '..pattern)
                        if file:gmatch(pattern) then
                            keymapsSetup(ev)
                        end
                    end
                end
            })
        end

        setupAutocommands(setupDotnetKeymaps, { "*.cs" })
        setupAutocommands(setupJavascriptKeymaps, { "*.js", "*.ts" })
	end,
}
