vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

require('config.options')
require('config.keymaps')
require('config.lazyinstaller')
require('config.autocommands')

require('lazy').setup({
  require('plugins.nvimwebdevicons'),
  require('plugins.telescope'),
  require('plugins.telescope'),
  require('plugins.lazydev'),
  require('plugins.luvitmeta'),
  require('plugins.omnisharpextended'),
  require('plugins.lsp_signature'),
  require('plugins.lspconfig'),
  require('plugins.conform'),
  require('plugins.cmp'),
  require('plugins.colorscheme'),
  require('plugins.todocomments'),
  require('plugins.mini'),
  require('plugins.treesitter'),
  require('plugins.autosave'),
  require('plugins.nvimtree'),
  require('plugins.nvimdap'),
  require('plugins.nvimdapui'),
  require('plugins.neotest'),
}, {})

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
