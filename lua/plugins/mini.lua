return {

	-- Collection of various small independent plugins/modules
	"echasnovski/mini.nvim",
	config = function()
		require("mini.ai").setup({ n_lines = 500 })
		require("mini.surround").setup({
            custom_surroundings = {
                ['('] = {output = {left = "(", right = ')'}},
                [')'] = {output = {left = "(", right = ')'}}
            }
        })
		require("mini.comment").setup()
        require('mini.pairs').setup()
        require('mini.test').setup()

		-- Simple and easy statusline.
		--  You could remove this setup call if you don't like it,
		--  and try some other statusline plugin
		-- local statusline = require("mini.statusline")
		-- set use_icons to true if you have a Nerd Font
		-- statusline.setup({ use_icons = false })

		-- You can configure sections in the statusline by overriding their
		-- default behavior. For example, here we set the section for
		-- cursor location to LINE:COLUMN
		---@diagnostic disable-next-line: duplicate-set-field
		-- statusline.section_location = function()
		-- 	return "%2l:%-2v"
		-- end

		-- ... and there is more!
		--  Check out: https://github.com/echasnovski/mini.nvim
	end,
}
