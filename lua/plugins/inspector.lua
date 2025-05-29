return {
    "kamil-nowowiejski/nvim-inspector",
    dependencies = {
        "manoelcampos/xml2lua", -- used for parsing TRX files 
    },
    config = function()
        require('inspector').setup()
    end
}
