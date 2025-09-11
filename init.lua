vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

require('config.options')
require('config.keymaps')
require('config.lazyinstaller')
require('config.autocommands')
require('config.commands')
require('config.statusline').setup()

require('lazy').setup({
  require('plugins.nvimwebdevicons'),
  require('plugins.plenary'),
  require('plugins.telescope'),
  require('plugins.telescope'),
  require('plugins.lazydev'),
  require('plugins.luvitmeta'),
  require('plugins.lsp_signature'),
  require('plugins.lspconfig'),
  require('plugins.lspconfig.roslyn'),
  require('plugins.conform'),
  require('plugins.dbee'),
  require('plugins.cmp'),
  require('plugins.colorscheme'),
  require('plugins.todocomments'),
  require('plugins.mini'),
  require('plugins.treesitter'),
  require('plugins.nvimtree'),
  require('plugins.nvimdap'),
  require('plugins.nvimdapui'),
  require('plugins.inspector'),
  require('plugins.vimtest'),
  require('plugins.quicker')
}, {})

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
