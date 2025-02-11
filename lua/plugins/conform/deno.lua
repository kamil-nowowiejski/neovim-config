local extensions = {
	css = "css",
	html = "html",
	javascript = "js",
	javascriptreact = "jsx",
	json = "json",
	jsonc = "jsonc",
	less = "less",
	markdown = "md",
	sass = "sass",
	scss = "scss",
	typescript = "ts",
	typescriptreact = "tsx",
	yaml = "yml",
}

return {

	command = "deno",
	cond = function(self, ctx)
		return vim.fs.root(ctx.dirname, "deno.json") ~= nil
        and extensions[vim.bo[ctx.buf].filetype] ~= nil
	end,
	cwd = function(self, ctx)
		return vim.fs.root(ctx.dirname, "deno.json")
	end,
	args = function(self, ctx)
		local extension = extensions[vim.bo[ctx.buf].filetype]
		local formatter_args = {
			"fmt",
			"$FILENAME",
			"--ext",
			extension,
		}

		return formatter_args
	end,
}
