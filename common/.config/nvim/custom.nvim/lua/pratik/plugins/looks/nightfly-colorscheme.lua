return {
	'bluz71/vim-nightfly-guicolors',
	priority = 1000, -- Makes sure this loads before all other plugins
	config = function()
		-- load the colorscheme here
		vim.cmd([[colorscheme nightfly]])
	end,
}
