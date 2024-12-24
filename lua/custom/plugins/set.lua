vim.g.mapleader = " "

-- Convenience settings
vim.opt.showmatch = true
vim.opt.hlsearch = true
vim.opt.incsearch = true
vim.opt.autoindent = true

-- Tab = 4 spaces
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.expandtab = true
vim.opt.shiftwidth = 4

vim.opt.smartindent = true;

-- Number settings
vim.opt.number = true
vim.opt.relativenumber = true

-- Bash-like tab completion
vim.opt.wildmode = 'longest,list'

vim.opt.termguicolors = true

vim.opt.scrolloff = 8

-- Primagen mappings
vim.keymap.set("n", "<leader>e", vim.cmd.Ex)

-- Move highlighted chunks around
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

-- Keep cursor centered when jumping
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

-- Paste text over existing text without changing active register
vim.keymap.set("x", "<leader>p", [["_dP]])

-- Navigave buffers with <Ctrl-J> and <Ctrl-K>
-- Note that <C-J> gets messed up by /usr/share/vim/vimfiles/plugin/imaps.vim.
-- it is recommended to remove (or backup) that file if this binding isn't
-- working.
vim.keymap.set('n', '<C-J>', ':bn<CR>')
vim.keymap.set('n', '<C-K>', ':bp<CR>')
vim.keymap.set('n', '<ESC>', ':noh<CR><ESC>')

-- Compile and run code in split window.
-- Test code
vim.keymap.set('n', '<leader>t', ':lua Test_code(false)<CR>')
-- Close window and run code
vim.keymap.set('n', '<leader>f', ':lua Run_code(false)<CR>')

-- Delete bottom right window. Useful for the above
vim.keymap.set('n', '<leader>d', ':wincmd b | bd | wincmd p <CR>')

-- Brackets complete on enter.
vim.keymap.set('i', '{<CR>', '{<CR>}<ESC>O')
