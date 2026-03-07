local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
vim.opt.rtp:prepend(lazypath)

-- file tree
require("lazy").setup({
	{
		"nvim-tree/nvim-tree.lua",
		dependencies = { "nvim-tree/nvim-web-devicons" }
	},

	{ "EdenEast/nightfox.nvim" } -- nightfox theme
})

require("nvim-tree").setup()

-- neat theme
vim.opt.termguicolors = true
vim.cmd("colorscheme nightfox")

-- one key open file tree
vim.g.mapleader = " "
vim.keymap.set("n", "<leader>e", "<cmd>NvimTreeToggle<CR>")

-- default directory is Programming and opens automatically if nvim is opened withotu a file
if vim.fn.argc() == 0 then
	vim.cmd("autocmd VimEnter * cd ~/Programming | NvimTreeOpen")
end

-- line numbers
vim.opt.number = true

-- enable mouse
vim.opt.mouse = "a"

-- long tabs
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4

-- ignore case
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- clipboard
vim.opt.clipboard = "unnamedplus"

-- block cursor
vim.opt.guicursor = "a:block"

-- scrolling
vim.opt.scrolloff = 8
