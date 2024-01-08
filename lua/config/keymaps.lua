vim.g.mapleader = " "

local mode_nv = { "n", "v" }
local mode_v = { "v" }
local mode_i = { "i" }
local nmappings = {
	-- Movement
	{ from = "J",            to = "5j",                                                  mode = mode_nv },
	{ from = "K",            to = "5k",                                                  mode = mode_nv },
	{ from = "<c-j>",        to = "<c-d>",                                               mode = mode_nv },
	{ from = "<c-k>",        to = "<c-u>",                                               mode = mode_nv },
	{ from = "H",            to = "3h",                                                  mode = mode_nv },
	{ from = "L",            to = "3l",                                                  mode = mode_nv },
	{ from = "W",            to = "3w",                                                  mode = mode_nv },
	{ from = "E",            to = "3e",                                                  mode = mode_nv },
	{ from = "B",            to = "3b",                                                  mode = mode_nv },
	{ from = "0",            to = "0",                                                   mode = mode_nv },
	{ from = "$",            to = "$",                                                   mode = mode_nv },
	{ from = "c,",           to = "c%", },

	-- Window & splits
	{ from = "zh",           to = ":set nosplitright<CR>:vsplit<CR>:set splitright<CR>", },
	{ from = "zj",           to = ":set splitbelow<CR>:split<CR>", },
	{ from = "zk",           to = ":set nosplitbelow<CR>:split<CR>:set splitbelow<CR>", },
	{ from = "zl",           to = ":set splitright<CR>:vsplit<CR>", },
	{ from = "<leader>w",    to = "<C-w>w", },
	{ from = "<leader>k",    to = "<C-w>k", },
	{ from = "<leader>j",    to = "<C-w>j", },
	{ from = "<leader>h",    to = "<C-w>h", },
	{ from = "<leader>l",    to = "<C-w>l", },
	{ from = "<up>",         to = ":res +5<CR>", },
	{ from = "<down>",       to = ":res -5<CR>", },
	{ from = "<left>",       to = ":vertical resize-5<CR>", },
	{ from = "<right>",      to = ":vertical resize+5<CR>", },
	{ from = "zrh",          to = "<C-w>b<C-w>K", },
	{ from = "zrv",          to = "<C-w>b<C-w>H", },
	{ from = "zq",           to = "<C-w>o", },

	-- Tab management
	{ from = "tt",           to = ":tabe<CR>", },
	{ from = "ts",           to = ":tab split<CR>", },
	{ from = "th",           to = ":-tabnext<CR>", },
	{ from = "tl",           to = ":+tabnext<CR>", },
	{ from = "tH",           to = ":-tabmove<CR>", },
	{ from = "tL",           to = ":+tabmove<CR>", },
	{ from = "<c-h>",        to = ":-tabnext<CR>", },
	{ from = "<c-l>",        to = ":+tabnext<CR>", },

	-- Useful actions
	{ from = "S",            to = ":w<CR>" },
	{ from = "Q",            to = ":q<CR>" },
	{ from = ";",            to = ":",                                                   mode = mode_nv },
	{ from = "Y",            to = "\"+y",                                                mode = mode_v },
	{ from = "`",            to = "~",                                                   mode = mode_nv },
	{ from = "U",            to = "<c-r>",                                               mode = mode_nv },
	{ from = "q",            to = "<nop>",                                               mode = mode_nv },

	{ from = ",",            to = "%",                                                   mode = mode_nv },
	{ from = "v.",           to = "v$h", },
	{ from = "v,",           to = "v%" },
	{ from = "<c-y>",        to = "<ESC>A {}<ESC>i<CR><ESC>ko",                          mode = mode_i },
	{ from = "<leader><rc>", to = ":nohlsearch<CR>" },
	{ from = "<leader>sc",   to = ":set spell!<CR>" },
	{ from = "<leader>o",    to = "za" },

}

for _, mapping in ipairs(nmappings) do
	vim.keymap.set(mapping.mode or "n", mapping.from, mapping.to, { noremap = true })
end
