vim.g.mapleader = " "

local mode_i = { "i" }
local mode_nv = { "n", "v" }

local function getCurrentTabWinCount()
	local current_tab_win_count = 0
	local wins = vim.api.nvim_tabpage_list_wins(vim.api.nvim_get_current_tabpage())
	for _, win in ipairs(wins) do
		local winType = vim.fn.win_gettype(win)

		if winType ~= "popup" and winType ~= "preview" then
			current_tab_win_count = current_tab_win_count + 1
		end
	end

	return current_tab_win_count
end

vim.g.getCurrentTabWinCount = getCurrentTabWinCount

local function quitNvim()
	local current_buf_of_win_count = #vim.fn.getbufinfo(vim.fn.bufnr("%"))[1].windows
	local buf_count = vim.fn.len(vim.fn.getbufinfo({ buflisted = 1 }))

	if buf_count == 1 and current_buf_of_win_count == 1 then
		vim.api.nvim_command("quit")
		return
	end

	if current_buf_of_win_count == 1 then
		-- depend on the nvim tree open state
		if vim.g[vim.g.getNvimTreeOpenStateIndex] and getCurrentTabWinCount() == 2 then
			local current_buf = vim.api.nvim_get_current_buf()
			vim.api.nvim_command("bprevious")
			vim.api.nvim_buf_delete(current_buf, { force = true })
		else
			vim.api.nvim_command("bdelete")
		end
	else
		vim.api.nvim_command("close")
	end
end

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

	-- Window & splits
	{ from = "zh",           to = ":set nosplitright<CR>:vsplit<CR>:set splitright<CR>", mode = mode_nv },
	{ from = "zj",           to = ":set splitbelow<CR>:split<CR>",                       mode = mode_nv },
	{ from = "zk",           to = ":set nosplitbelow<CR>:split<CR>:set splitbelow<CR>",  mode = mode_nv },
	{ from = "zl",           to = ":set splitright<CR>:vsplit<CR>",                      mode = mode_nv },
	{ from = "<leader>k",    to = ":wincmd k<CR>",                                       mode = mode_nv },
	{ from = "<leader>j",    to = ":wincmd j<CR>",                                       mode = mode_nv },
	{ from = "<leader>h",    to = ":wincmd h<CR>",                                       mode = mode_nv },
	{ from = "<leader>l",    to = ":wincmd l<CR>",                                       mode = mode_nv },
	{ from = "<up>",         to = ":res +5<CR>",                                         mode = mode_nv },
	{ from = "<down>",       to = ":res -5<CR>",                                         mode = mode_nv },
	{ from = "<left>",       to = ":vertical resize-5<CR>",                              mode = mode_nv },
	{ from = "<right>",      to = ":vertical resize+5<CR>",                              mode = mode_nv },
	{ from = "zq",           to = ":close<CR>",                                          mode = mode_nv },
	{ from = "zQ",           to = ":on<CR>",                                             mode = mode_nv },

	-- Buffer management
	{ from = "tt",           to = ":enew<CR>",                                           mode = mode_nv },
	{ from = "<c-h>",        to = ":bprevious<CR>",                                      mode = mode_nv },
	{ from = "<c-l>",        to = ":bnext<CR>",                                          mode = mode_nv },

	-- Tab management
	{ from = "tb",           to = ":tabe<CR>",                                           mode = mode_nv },
	{ from = "th",           to = ":-tabnext<CR>",                                       mode = mode_nv },
	{ from = "tl",           to = ":+tabnext<CR>",                                       mode = mode_nv },
	{ from = "tq",           to = ":tabclose<CR>",                                       mode = mode_nv },

	-- Useful actions
	{ from = "<c-w>",        to = "<nop>",                                               mode = mode_nv },
	{ from = "q",            to = "<nop>",                                               mode = mode_nv },
	{ from = "Q",            to = "<nop>",                                               mode = mode_nv },

	{ from = ";",            to = ":",                                                   mode = mode_nv },
	{ from = "S",            to = ":write<CR>",                                          mode = mode_nv },
	{ from = "Q",            to = quitNvim,                                              mode = mode_nv },

	{ from = "`",            to = "~",                                                   mode = mode_nv },
	{ from = "'",            to = "%",                                                   mode = mode_nv },
	{ from = ",",            to = "0",                                                   mode = mode_nv },
	{ from = ".",            to = "$",                                                   mode = mode_nv },

	{ from = "v.",           to = "v$h",                                                 mode = mode_nv },
	{ from = "v'",           to = "v%",                                                  mode = mode_nv },
	{ from = "c'",           to = "c%",                                                  mode = mode_nv },

	{ from = "U",            to = "<c-r>",                                               mode = mode_nv },
	{ from = "<leader><rc>", to = ":nohlsearch<CR>" },
	-- { from = "<leader>sc",   to = ":set spell!<CR>" },
}

for _, mapping in ipairs(nmappings) do
	vim.keymap.set(mapping.mode or "n", mapping.from, mapping.to, { noremap = true })
end
