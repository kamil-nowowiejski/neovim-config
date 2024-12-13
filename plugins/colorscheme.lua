return {
	-- You can easily change to a different colorscheme.
	-- Change the name of the colorscheme plugin below, and then
	-- change the command in the config to whatever the name of that colorscheme is.
	--
	-- If you want to see what colorschemes are already installed, you can use `:Telescope colorscheme`.
	"morhetz/gruvbox",
	priority = 1000, -- Make sure to load this before all the other start plugins.
	init = function()
		-- Load the colorscheme here.
		-- Like many other themes, this one has different styles, and you could load
		-- any other, such as 'tokyonight-storm', 'tokyonight-moon', or 'tokyonight-day'.
        vim.o.background = "dark"
		vim.cmd.colorscheme("gruvbox")

		-- You can configure highlights by doing something like:
		--		vim.cmd.hi("Comment gui=none")

		vim.g.gruvbox_bold = 1
		vim.g.gruvbox_transparent_bg = 1
	end,
}
