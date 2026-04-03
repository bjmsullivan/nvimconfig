local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
vim.opt.rtp:prepend(lazypath)

-- file tree
require("lazy").setup({
	{
		"nvim-tree/nvim-tree.lua",
		dependencies = { "nvim-tree/nvim-web-devicons" }
	},

	{ "EdenEast/nightfox.nvim" }, -- nightfox theme
	{ "catppuccin/nvim", lazy = false, name = "catppuccin", priority=1000 }, -- catpuccino theme
	{ "neovim/nvim-lspconfig",},
	{
      'sainnhe/everforest',
      lazy = false,
      priority = 1000,
      config = function()
        -- Optionally configure and load the colorscheme
        -- directly inside the plugin declaration.
        vim.g.everforest_enable_italic = true
        vim.cmd.colorscheme('everforest')
      end
    }
})

----------------------------------------------------------

-- close the program if only the tree pane is open...
-- also allow left and right arrows to expand and collapse directories
require("nvim-tree").setup(
{
  actions = {
    open_file = {
      quit_on_open = false,
    },
  },
  on_attach = function(bufnr)
    local api = require("nvim-tree.api")

    local function opts(desc)
      return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
    end

    -- keep the default keymaps
    api.config.mappings.default_on_attach(bufnr)

    -- arrow navigation
    vim.keymap.set("n", "<Right>", api.node.open.edit, opts("Expand/Open"))
    vim.keymap.set("n", "<Left>", api.node.navigate.parent_close, opts("Collapse"))
  end,
})

-- command to auto close the tree
vim.api.nvim_create_autocmd("BufEnter", {
  nested = true,
  callback = function()
    if #vim.api.nvim_list_wins() == 1 then
      local bufname = vim.api.nvim_buf_get_name(0)
      if bufname:match("NvimTree_") then
        vim.cmd("quit")
      end
    end
  end,
})

-- space+t opens terminal
-- store terminal buffer + window
local term_buf = nil
local term_win = nil

vim.g.mapleader = " " -- set leader key to space

-- toggle terminal
vim.keymap.set('n', '<leader>t', function()
  -- if window exists, close it (hide terminal)
  if term_win and vim.api.nvim_win_is_valid(term_win) then
    vim.api.nvim_win_close(term_win, true)
    term_win = nil
    return
  end

  -- open split at bottom
  vim.cmd('botright split')
  vim.cmd('resize 10')

  term_win = vim.api.nvim_get_current_win()

  -- reuse buffer if it exists
  if term_buf and vim.api.nvim_buf_is_valid(term_buf) then
    vim.api.nvim_win_set_buf(term_win, term_buf)
  else
    vim.cmd('terminal')
    term_buf = vim.api.nvim_get_current_buf()
  end

  vim.cmd('startinsert')
end)

-- space+h hides highlights
vim.keymap.set('n', '<leader>h', ':noh<CR>')

-- ESC in terminal → hide it
vim.keymap.set('t', '<Esc>', function()
  local win = vim.api.nvim_get_current_win()
  vim.api.nvim_win_close(win, true)
end, { desc = 'Hide terminal' })

-- neat theme
vim.opt.termguicolors = true
vim.cmd("colorscheme nightfox")

-- space + e opens file tree
-- space + f opens current file in file tree
vim.keymap.set("n", "<leader>e", "<cmd>NvimTreeToggle<CR>")
vim.keymap.set("n", "<leader>f", ":NvimTreeFindFile<CR>")

-- rebind window movements to arrow keys (crutch)
vim.keymap.set("n", "<C-Left>", "<C-w>h", { desc = "Move to left window" })
vim.keymap.set("n", "<C-Right>", "<C-w>l", { desc = "Move to right window" })
vim.keymap.set("n", "<C-Up>", "<C-w>k", { desc = "Move to upper window" })
vim.keymap.set("n", "<C-Down>", "<C-w>j", { desc = "Move to lower window" })

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

-- disable comment indents
vim.opt.formatoptions:remove({"r", "o", "c"})

-- ignore case
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- clipboard
vim.opt.clipboard = "unnamedplus"

-- block cursor
vim.opt.guicursor = "a:block"

-- scrolling
vim.opt.scrolloff = 8

-- folding code
vim.o.foldmethod = "indent"
vim.o.foldlevel = 99
vim.o.foldlevelstart = 99
vim.o.foldenable = true

-- space+n toggles relative line numbers

vim.keymap.set("n", "<leader>n", function()
  vim.wo.relativenumber = not vim.wo.relativenumber
end, { desc = "Toggle relative line numbers" })
