return {
	"mfussenegger/nvim-dap",
	config = function()
		local dap = require("dap")

		dap.adapters.netcoredbg = {
			type = "executable",
			command = vim.fn.stdpath("data") .. "/mason/packages/netcoredbg/netcoredbg/netcoredbg.exe",
			args = { "--interpreter=vscode" },
		}

        dap.adapters.coreclr = dap.adapters.netcoredbg

        dap.adapters["pwa-node"] = {
            type = "server",
            host = "localhost",
            port = "${port}",
            executable = {
                command = "node",
                args = { vim.fn.stdpath("data") .. "/vscode-js-debug/dapDebugServer.js", "${port}"},
            }
        }

		dap.configurations.cs = {
			{
				type = "netcoredbg",
				name = "attach - netcoredbg",
				request = "attach",
				processId = require("dap.utils").pick_process,
			},
			{
				type = "netcoredbg",
				name = "launch - netcoredbg",
				request = "launch",
				program = function()
					return vim.fn.input("Path to dll", vim.fn.getcwd() .. "/bin/Debug/", "file")
				end,
			}
		}

        local jsConfig = {
            type = "pwa-node",
            request = "launch",
            name = "Launch file",
            program = "${file}",
            cwd = "${workspaceFolder}",
        }

        dap.configurations.javascript = jsConfig
        dap.configurations.typescript = jsConfig

		vim.fn.sign_define("DapBreakpoint", { text = "🛑", texthl = "", linehl = "", numhl = "" })

		vim.keymap.set("n", "<F5>", require("dap").continue)
		vim.keymap.set("n", "<leader>dt", require("dap").terminate)
		vim.keymap.set("n", "<leader>dd", require("dap").disconnect)
		vim.keymap.set("n", "<F6>", require("dap").step_over)
		vim.keymap.set("n", "<F7>", require("dap").step_into)
		vim.keymap.set("n", "<F8>", require("dap").step_out)
		vim.keymap.set("n", "<Leader>b", require("dap").toggle_breakpoint)
		vim.keymap.set("n", "<Leader>B", require("dap").set_breakpoint)
		vim.keymap.set("n", "<Leader>lp", function()
			require("dap").set_breakpoint(nil, nil, vim.fn.input("Log point message: "))
		end)
		--vim.keymap.set("n", "<Leader>dr", require("dap").repl.open)
		vim.keymap.set("n", "<Leader>dl", require("dap").run_last)
		--vim.keymap.set({ "n", "v" }, "<Leader>dh", require("dap.ui.widgets").hover)
		--vim.keymap.set({ "n", "v" }, "<Leader>dp", require("dap.ui.widgets").preview)
		--vim.keymap.set("n", "<Leader>df", function()
		--		local widgets = require("dap.ui.widgets")
		--		widgets.centered_float(widgets.frames)
		--	end)
		--	vim.keymap.set("n", "<Leader>dw", function()
		--		local widgets = require("dap.ui.widgets")
		--		widgets.centered_float(widgets.scopes)
		--	end)
	end,
}
