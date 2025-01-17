return {
	"nvim-neotest/neotest",
	dependencies = {
		"nvim-neotest/nvim-nio",
		"nvim-lua/plenary.nvim",
		"antoinemadec/FixCursorHold.nvim",
		"nvim-treesitter/nvim-treesitter",
		"Issafalcon/neotest-dotnet",
	},
	config = function()
		local neotest = require("neotest")
		neotest.setup({
			adapters = {
				require("neotest-dotnet"),
			},
			icons = {
				failed = "X",
				notify = "N",
				passed = "✓",
				running = "R",
				skipped = "S",
				unknow = "L",
				watching = "<->",
			},
		})

		-- run all marked positions
		-- neotest.summary.run_marked()
		--
		-- show all marked positions
		-- neotest.summary.marked()
		--
		-- clear marked
		-- neotest.summary.clear_marked()
		-- open test tree
		vim.keymap.set("n", "<leader>ts", neotest.summary.toggle)

		-- output panel
		vim.keymap.set("n", "<leader>to", function()
			neotest.output_panel.toggle()
		end)
		vim.keymap.set("n", "<leader>tc", neotest.output_panel.clear)

		-- run nearest test
		vim.keymap.set("n", "<leader>tn", neotest.run.run)

		-- debug nearest test
		vim.keymap.set("n", "<leader>td", function()
			neotest.run.run({ strategy = "dap" })
		end)

		-- run all tests in file
		vim.keymap.set("n", "<leader>tf", function()
			neotest.run.run(vim.fn.expand("%"))
		end)

		-- run last with the same strategy
		vim.keymap.set("n", "<leader>tt", neotest.run.run_last)

		-- stop the current process
		vim.keymap.set("n", "<leader>ta", neotest.run.stop)
	end,
}
