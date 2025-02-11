return {
	command = "dotnet",
	cond = function(self, ctx)
		return vim.bo[ctx.buf].filetype == "cs"
	end,
	cwd = function(self, ctx)
		return vim.fn.getcwd()
	end,
	args = function(self, ctx)
        local relativePathToFile = vim.fn.expand("%:.")
		local formatter_args = {
			"format",
            "--include",
            relativePathToFile,
			"--no-restore",
		}

		return formatter_args
	end,
    stdin = false
}
