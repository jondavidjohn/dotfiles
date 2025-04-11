require("config.lazy")

-- Workaround for Inspect error
vim.hl = vim.highlight

local o = vim.opt
local keymap = vim.keymap

o.shiftwidth = 2
o.tabstop = 2
o.clipboard = "unnamedplus"
o.cursorline = true
o.number = true
o.smartindent = true
o.cc = "100"
o.signcolumn = "yes"
o.guifont = "Hack Nerd Font Mono"

keymap.set("n", "<Space>", "<Nop>", { noremap = true})
keymap.set("n", "<esc>", ":noh<enter>", { noremap = true })

-- Panes
o.splitbelow = true
o.splitright = true
keymap.set("n", "<leader>k", "<C-w><Up>")
keymap.set("n", "<leader>l", "<C-w><Right>")
keymap.set("n", "<leader>j", "<C-w><Down>")
keymap.set("n", "<leader>h", "<C-w><Left>")
keymap.set("n", "<leader>=", "<C-w>=")
keymap.set("n", "<leader>+", ":vertical resize +5<enter>")
keymap.set("n", "<leader>-", ":vertical resize -5<enter>")

-- Indentation
keymap.set("n", ">", ">>")
keymap.set("n", "<", "<<")
keymap.set("v", ">", ">gv")
keymap.set("v", "<", "<gv")

-- Buffers
keymap.set("n", "<leader>]", ":bnext<enter>")
keymap.set("n", "<leader>[", ":bprevious<enter>")
keymap.set("n", "<leader>w", ":bdelete<enter>")

-- Whitespace
o.expandtab = true
o.list = true
o.listchars:append { tab = "│ ", trail = "-" }

-- Use HCL formatting for tf files
vim.filetype.add({ extension = { tf = 'hcl' }})
