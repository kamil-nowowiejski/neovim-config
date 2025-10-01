return {
	-- command = "dotnet",
    command = vim.fn.stdpath("data") .. "/mason/packages/csharpier/csharpier.exe",
	cond = function(self, ctx)
		return vim.bo[ctx.buf].filetype == "cs"
	end,
	cwd = function(self, ctx)
		return vim.fn.getcwd()
	end,
	args = function(self, ctx)
		return {
            "format",
            "--config-path",
            vim.fn.stdpath('config') .. '/lua/plugins/conform/.csharpierrc'
        }
	end,
    stdin = true
}
