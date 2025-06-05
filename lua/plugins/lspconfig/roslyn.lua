return {
    "seblyng/roslyn.nvim",
    -- ft = "cs",
    -- opts = {
    --     -- your configuration comes here; leave empty for default settings
    --     exe = {
    --         "dotnet",
    --         vim.fs.joinpath(vim.fn.stdpath("data"), "roslyn", "Microsoft.CodeAnalysis.LanguageServer.dll"),
    --     },
    -- }
    config = function ()
        require('roslyn').setup()
    --     vim.lsp.config("roslyn", {
    --         cmd = {
    --             "dotnet",
    --             vim.fs.joinpath(vim.fn.stdpath("data"), "roslyn", "Microsoft.CodeAnalysis.LanguageServer.dll"),
    --             "--logLevel=Information",
    --             "--extensionLogDirectory=" .. vim.fs.dirname(vim.lsp.get_log_path()),
    --             "--stdio",
    --         },
    --     })
    end
}
