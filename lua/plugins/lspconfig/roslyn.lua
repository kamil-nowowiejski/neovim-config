return {
    "seblyng/roslyn.nvim",
    ft = "cs",
    opts = {
        -- your configuration comes here; leave empty for default settings
        exe = {
            "dotnet",
            vim.fs.joinpath(vim.fn.stdpath("data"), "roslyn", "Microsoft.CodeAnalysis.LanguageServer.dll"),
        },
    }
}
