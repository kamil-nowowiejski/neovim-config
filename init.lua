require('options')
require('keymaps')
require('autocommands')

require('lazy').setup({
  require('plugins.telescope'),
  require('plugins.lazydev'),
  require('plugins.luvitmeta'),
  require('plugins.lspconfig'),
  require('plugins.conform'),
  require('plugins.cmp'),
  require('plugins.colorscheme'),
  require('plugins.todocomments'),
  require('plugins.mini'),
  require('plugins.treesitter'),
  require('plugins.autosave'),
  require('plugins.gitsigns')
}, {})

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
