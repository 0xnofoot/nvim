M = {
	{
		-- 相同词汇高亮
		"RRethy/vim-illuminate",
		config = function()
			require("illuminate").configure({
				providers = {
					-- "lsp",
					-- "treesitter",
					"regex",
				},
			})
			vim.cmd("hi IlluminatedWordText guibg=#494F4D gui=none")
		end
	},

	{
		-- 自动补全列表符号
		"dkarter/bullets.vim",
		event = "VeryLazy",
		ft = { "markdown", "txt" },
	},

	{
		-- 背景显示颜色字符
		"NvChad/nvim-colorizer.lua",
		event = "VeryLazy",
		opts = {
			filetypes = { "*" },
			user_default_options = {
				RGB      = true, -- #RGB hex codes
				RRGGBB   = true, -- #RRGGBB hex codes like #8080ff
				names    = true, -- "Name" codes like Blue
				RRGGBBAA = true, -- #RRGGBBAA hex codes like
				rgb_fn   = true, -- CSS rgb() and rgba() functions
				hsl_fn   = true, -- CSS hsl() and hsla() functions
				css      = true, -- Enable all CSS features: rgb_fn, hsl_fn, names, RGB, RRGGBB
				css_fn   = true, -- Enable all CSS *functions*: rgb_fn, hsl_fn
				-- Available modes: foreground, background
				mode     = "background", -- Set the display mode.
			},
			-- all the sub-options of filetypes apply to buftypes
			buftypes = {},
		}
	},

	{
		-- 折叠功能强化
		"kevinhwang91/nvim-ufo",
		event = "VeryLazy",
		dependencies = { "kevinhwang91/promise-async", },
		config = function()
			local handler = function(virtText, lnum, endLnum, width, truncate)
				local newVirtText = {}
				local suffix = (" ... %d 󰁂 ... "):format(endLnum - lnum)
				local sufWidth = vim.fn.strdisplaywidth(suffix)
				local targetWidth = width - sufWidth
				local curWidth = 0
				for _, chunk in ipairs(virtText) do
					local chunkText = chunk[1]
					local chunkWidth = vim.fn.strdisplaywidth(chunkText)
					if targetWidth > curWidth + chunkWidth then
						table.insert(newVirtText, chunk)
					else
						chunkText = truncate(chunkText, targetWidth - curWidth)
						local hlGroup = chunk[2]
						table.insert(newVirtText, { chunkText, hlGroup })
						chunkWidth = vim.fn.strdisplaywidth(chunkText)
						-- str width returned from truncate() may less than 2nd argument, need padding
						if curWidth + chunkWidth < targetWidth then
							suffix = suffix .. (" "):rep(targetWidth - curWidth - chunkWidth)
						end
						break
					end
					curWidth = curWidth + chunkWidth
				end
				table.insert(newVirtText, { suffix, "MoreMsg" })
				return newVirtText
			end

			require("ufo").setup({
				enable_get_fold_virt_text = true,
				fold_virt_text_handler = handler,
				open_fold_hl_timeout = 150,
				close_fold_kinds_for_ft = { "imports", "comment" },
				preview = {
					win_config = {
						border = { "", "─", "", "", "", "─", "", "" },
						winhighlight = "Normal:Folded",
						winblend = 0
					},
					mappings = {
						scrollU = "<C-u>",
						scrollD = "<C-d>",
						jumpTop = "[",
						jumpBot = "]"
					}
				},
				provider_selector = function(bufnr, filetype, buftype)
					return { "treesitter", "indent" }
				end,
			})

			vim.keymap.set("n", "zz", "za")
			vim.keymap.set("n", "zx", require("ufo").openFoldsExceptKinds)
			vim.keymap.set("n", "zX", require("ufo").openAllFolds)
			vim.keymap.set("n", "zc", require("ufo").closeFoldsWith) -- closeAllFolds == closeFoldsWith(0)
		end
	},

	{
		-- 补全括号
		"windwp/nvim-autopairs",
		event = "BufRead",
		config = function()
			require("nvim-autopairs").setup({})
		end
	},

	{
		-- 快速注释
		"tomtom/tcomment_vim",
		event = "BufRead",
		config = function()
			vim.g.tcomment_maps = true
			vim.g.tcomment_textobject_inlinecomment = ""

			-- 不知道怎么绑定 ctrl+/, 好像 vim 中 使用 <c-_> 代替 <c-/>
			-- 但是这可能在 tmux 中不起作用, 使用 <c-c> 代替
			vim.keymap.set({ "n", "v" }, "<c-c>", ":TComment<CR>0w", { silent = true })
			vim.keymap.set({ "i" }, "<c-c>", "<ESC>:TComment<CR>0w", { silent = true })
		end
	},

	{
		-- 对于被括号或其他符号包围的内容
		-- 提供一系列快速操作方案
		"kylechui/nvim-surround",
		event = "VeryLazy",
		version = "*",
		config = function()
			require("nvim-surround").setup()
		end
	},

	{
		-- 复制粘贴增强
		"gbprod/yanky.nvim",
		event = "VeryLazy",
		dependencies = {
			"kkharji/sqlite.lua",
		},
		config = function()
			-- 使用系统剪切板
			vim.cmd("set clipboard=unnamedplus")

			vim.keymap.set("n", "<c-p>", "<Plug>(YankyCycleForward)")
			vim.keymap.set("n", "<c-n>", "<Plug>(YankyCycleBackward)")
			vim.keymap.set({ "n", "x" }, "p", "<Plug>(YankyPutAfter)")
			vim.keymap.set({ "n", "x" }, "P", "<Plug>(YankyPutBefore)")

			require("yanky").setup({
				ring = {
					history_length = 2000,
					storage = "sqlite",
					sync_with_numbered_registers = true,
					cancel_event = "update",
				},
				picker = {
					select = {
						action = nil, -- nil to use default put action
					},
				},
				system_clipboard = {
					sync_with_ring = true,
				},
				highlight = {
					on_put = true,
					on_yank = true,
					timer = 300,
				},
				preserve_cursor_position = {
					enabled = true,
				},
			})
		end
	},

	{
		-- 全屏并浮动当前窗口
		"nyngwang/NeoZoom.lua",
		event = "VeryLazy",
		config = function()
			vim.keymap.set("n", "<leader>;", ":NeoZoomToggle<CR>", { silent = true, nowait = true })
			require("neo-zoom").setup {
				popup = { enabled = true }, -- this is the default.
				exclude_buftypes = { "terminal" },
				exclude_filetypes = { "lspinfo", "mason", "lazy", "fzf", },
				winopts = {
					offset = {
						width = 1.0,
						height = 1.0,
					},
					border = "thicc", -- this is a preset, try it :)
				},
				presets = {
					{
						filetypes = { "markdown" },
						callbacks = {
							function() vim.wo.wrap = true end,
						},
					},
				},
			}
		end
	},

	{
		-- 当前页面快速搜索跳转
		"folke/flash.nvim",
		event = "VeryLazy",
		opts = {
			labels = "arstneiowfuydh",
			jump = {
				jumplist = true,
				pos = "start",
				history = false,
				register = false,
				nohlsearch = false,
				autojump = false,
				inclusive = nil,
			},
			label = {
				uppercase = false,
				exclude = "",
				current = false,
				after = true,
				before = false,
				style = "inline",
				reuse = "all",
				distance = true,
				min_pattern_length = 0,
				rainbow = {
					enabled = true,
					shade = 8,
				},
			},
			modes = {
				search = {
					enabled = false,
				},
				char = {
					enabled = false,
				},
				treesitter = {
					labels = "arstneiowfuydh",
					jump = { pos = "range" },
					search = { incremental = false },
					label = { before = true, after = true, style = "inline" },
					highlight = {
						backdrop = false,
						matches = false,
					},
				},
				treesitter_search = {
					jump = { pos = "range" },
					search = { multi_window = true, wrap = true, incremental = false },
					remote_op = { restore = true },
					label = { before = true, after = true, style = "inline" },
				},
				-- options used for remote flash
				remote = {
					remote_op = { restore = true, motion = true },
				},
			},
			prompt = {
				enabled = true,
				prefix = { { "⚡", "FlashPromptIcon" } },
				win_config = {
					relative = "editor",
					width = 1, -- when <=1 it"s a percentage of the editor width
					height = 1,
					row = -1, -- when negative it"s an offset from the bottom
					col = 0, -- when negative it"s an offset from the right
					zindex = 1000,
				},
			},
		},
		keys = {
			{
				"<leader><leader>",
				mode = { "n" },
				function()
					require("flash").jump({
						remote_op = {
							restore = true,
							motion = true,
						},
					})
				end,
				desc = "Flash",
			},
			{
				"<leader><esc>f",
				mode = { "n", "o", "x" },
				function()
					require("flash").treesitter()
				end,
				desc = "Flash Treesitter",
			},
		},
	},

	{
		-- 自动设置当前工作目录
		"airblade/vim-rooter",
		init = function()
			vim.g.rooter_patterns = { "__vim_project_root", ".git/" }
			vim.g.rooter_silent_chdir = true
		end
	},

	{
		-- 支持大多数语言的快速跳转变量，类，函数
		-- 不是跳转到源码，因为它并不是支持 lsp
		-- 方便看工作目录内自己定义的类型
		"pechorin/any-jump.vim",
		event = "VeryLazy",
		config = function()
			-- vim.g.any_jump_enable_keybindings = 1
			vim.g.any_jump_disable_default_keybindings = 1
			vim.keymap.set("n", "<leader>gj", ":AnyJump<CR>", { noremap = true })
			vim.keymap.set("x", "<leader>gj", ":AnyJumpVisual<CR>", { noremap = true })
			vim.g.any_jump_window_width_ratio = 0.9
			vim.g.any_jump_window_height_ratio = 0.9

			-- 这个插件的默认快捷键配置无法设置为 disable,可能是 bug
			-- 所有在这重新配置一下 <leader>j
			vim.keymap.set("n", "<leader>j", ":wincmd j<cr>")
		end
	},

	{
		-- undo 操作树
		"mbbill/undotree",
		event = 'VeryLazy',
		config = function()
			vim.cmd([[
					noremap <leader>u :UndotreeToggle<CR>
					let g:undotree_DiffAutoOpen = 1
					let g:undotree_SetFocusWhenToggle = 1
					let g:undotree_ShortIndicators = 1
					let g:undotree_WindowLayout = 2
					let g:undotree_DiffpanelHeight = 8
					let g:undotree_SplitWidth = 24
					function g:Undotree_CustomMap()
						nmap <buffer> j <plug>UndotreePreviousState
						nmap <buffer> k <plug>UndotreeNextState
						nmap <buffer> J 5<plug>UndotreePreviousState
						nmap <buffer> K 5<plug>UndotreeNextState
					endfunc
				]])
		end
	},

	{
		-- 侧边文件浏览器
		"nvim-tree/nvim-tree.lua",
		version = "*",
		event = "VeryLazy",
		dependencies = {
			"nvim-tree/nvim-web-devicons",
		},

		config = function()
			local tree_api = require("nvim-tree.api")

			local function getTreeOpenStateIndex()
				local current_tabnr = vim.api.nvim_get_current_tabpage()
				local current_tab_tree_open_state_index = "current_tab_nvim_tree_opened_state_" .. current_tabnr

				return current_tab_tree_open_state_index
			end

			local function toggleNvimTree()
				local tree_open_state_index = getTreeOpenStateIndex()
				local is_tree_buf = require("nvim-tree.utils").is_nvim_tree_buf()

				if not is_tree_buf then
					if not vim.g[tree_open_state_index] then
						tree_api.tree.find_file({ open = true, focus = true, })
						vim.g[tree_open_state_index] = true
					else
						tree_api.tree.focus()
					end
				else
					tree_api.tree.close()
					vim.g[tree_open_state_index] = nil
				end
			end

			vim.keymap.set("n", "<leader>w", toggleNvimTree, { silent = true })

			-- Win Close
			vim.api.nvim_create_autocmd({ "WinEnter" }, {
				callback = function()
					if not vim.g[getTreeOpenStateIndex()] then
						return
					end

					if #vim.api.nvim_list_tabpages() > 1 and vim.g.getCurrentTabWinCount() == 1 then
						tree_api.tree.close()
					end
				end,

				nested = false
			})

			-- Buf Delete (Leave it to keymaps.lua for quit rule function management: quitNvim() )
			vim.g.getNvimTreeOpenStateIndex = getTreeOpenStateIndex

			-- Quit
			vim.api.nvim_create_autocmd({ "QuitPre" }, {
				callback = function()
					if not vim.g[getTreeOpenStateIndex()] then
						return
					end
					tree_api.tree.close()
				end,

				nested = true
			})

			local function on_attach_func(bufnr)
				local function opts(desc)
					return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
				end

				local function closeNvimtree()
					vim.api.nvim_command("quit")
					vim.g[getTreeOpenStateIndex()] = nil
				end

				local function escapeNvimTree()
					vim.api.nvim_command("wincmd p")
				end

				local function openNewTab()
					escapeNvimTree()
					tree_api.node.open.tab()
				end

				local function reMapBufMove(direction)
					escapeNvimTree()
					if direction == "next" then
						vim.api.nvim_command("bnext")
					elseif direction == "previous" then
						vim.api.nvim_command("bprevious")
					end
				end

				vim.keymap.set("n", "?", tree_api.tree.toggle_help, opts("Help"))
				vim.keymap.set("n", "Q", closeNvimtree, opts("Quit"))
				vim.keymap.set("n", "<ESC>", escapeNvimTree, opts("Esc"))
				vim.keymap.set("n", "<c-h>", function() reMapBufMove("previous") end, opts("Previous Buf"))
				vim.keymap.set("n", "<c-l>", function() reMapBufMove("next") end, opts("Next Buf"))

				vim.keymap.set("n", "R", tree_api.tree.reload, opts("Reload"))

				vim.keymap.set("n", ".", tree_api.tree.change_root_to_node, opts("Change Root"))
				-- vim.keymap.set("n", "zz", tree_api.tree.expand_all, opts("Toggle Node"))
				vim.keymap.set("n", "zc", tree_api.node.navigate.parent_close, opts("Close Node"))
				vim.keymap.set("n", "zC", tree_api.tree.collapse_all, opts("Close All Node"))
				vim.keymap.set("n", "zx", tree_api.tree.expand_all, opts("Expand All Node"))

				vim.keymap.set("n", "zh", tree_api.tree.toggle_hidden_filter, opts("Toggle Hidden File"))
				vim.keymap.set("n", "zg", tree_api.tree.toggle_gitignore_filter, opts("Toggle Git Ignore File"))

				vim.keymap.set("n", "h", tree_api.node.navigate.parent, opts("Parent Directory"))

				vim.keymap.set("n", "l", tree_api.node.open.edit, opts("Open Edit"))
				vim.keymap.set("n", "<CR>", tree_api.node.open.no_window_picker, opts("Open Edit No Window Picker"))
				vim.keymap.set("n", "<c-t>", openNewTab, opts("Open New Tab"))
				vim.keymap.set("n", "zl", tree_api.node.open.vertical, opts("Open Vertical"))
				vim.keymap.set("n", "zj", tree_api.node.open.horizontal, opts("Open Horizontal"))

				-- vim.keymap.set("n", "<Tab>", tree_api.node.open.preview, opts("Open Preview"))

				vim.keymap.set("n", "i", tree_api.node.show_info_popup, opts("Show Info"))

				-- if don't you have trash
				-- vim.keymap.set("n", "dD", tree_api.fs.remove, opts("Remove"))
				-- if you have trash
				vim.keymap.set("n", "dD", tree_api.fs.trash, opts("Trash File"))
				vim.keymap.set("n", "dd", tree_api.fs.cut, opts("Cut File"))
				vim.keymap.set("n", "T", tree_api.fs.create, opts("Create File"))

				vim.keymap.set("n", "yy", tree_api.fs.copy.node, opts("Copy File"))
				vim.keymap.set("n", "yn", tree_api.fs.copy.filename, opts("Copy File Name"))
				vim.keymap.set("n", "yp", tree_api.fs.copy.absolute_path, opts("Copy Absolute File Path"))
				vim.keymap.set("n", "yN", tree_api.fs.copy.relative_path, opts("Copy Relative File Path"))
				vim.keymap.set("n", "pp", tree_api.fs.paste, opts("Paste File"))

				vim.keymap.set("n", "ca", tree_api.fs.rename, opts("Rename"))
				vim.keymap.set("n", "cA", tree_api.fs.rename_basename, opts("Rename Basename"))
				vim.keymap.set("n", "cn", tree_api.fs.rename_sub, opts("Rename Sub"))
				vim.keymap.set("n", "cN", tree_api.fs.rename_full, opts("Rename Full"))

				vim.keymap.set("n", "mm", tree_api.marks.toggle, opts("Toggle Bookmark"))
				vim.keymap.set("n", "mj", tree_api.marks.navigate.next, opts("Next Bookmark"))
				vim.keymap.set("n", "mk", tree_api.marks.navigate.prev, opts("Previous Bookmark"))
				vim.keymap.set("n", "ms", tree_api.marks.navigate.select, opts("Open Bookmark File"))
				vim.keymap.set("n", "mx", tree_api.marks.clear, opts("Clear All  Bookmark"))
				vim.keymap.set("n", "dmd", tree_api.marks.bulk.move, opts("Move Bookmarked"))
				-- if don"t you have trash
				-- vim.keymap.set("n", "dmD", tree_api.marks.bulk.delete, opts("Delete Bookmarked"))
				-- if you have trash
				vim.keymap.set("n", "dmD", tree_api.marks.bulk.trash, opts("Trash Bookmarked"))

				vim.keymap.set("n", "/", tree_api.tree.search_node, opts("Search"))
			end

			vim.opt.termguicolors = true
			require("nvim-tree").setup({
				on_attach = on_attach_func,

				sort = {
					sorter = "name",
					folders_first = true,
					files_first = false,
				},
				view = {
					width = 30,
				},
				renderer = {
					group_empty = true,
					special_files = { "Makefile", "README.md", "readme.md", "README", ".gitignore" },
					symlink_destination = true,
					highlight_git = false,
					highlight_diagnostics = false,
					highlight_opened_files = "name",
					highlight_modified = "name",
					highlight_bookmarks = "name",
					highlight_clipboard = "name",
					indent_markers = {
						enable = true,
						inline_arrows = true,
						icons = {
							corner = "└",
							edge = "¦",
							item = "¦",
							bottom = "─",
							none = " ",
						},
					},
					icons = {
						web_devicons = {
							file = {
								enable = true,
								color = true,
							},
							folder = {
								enable = true,
								color = true,
							},
						},
						git_placement = "after",
						modified_placement = "before",
						diagnostics_placement = "signcolumn",
						bookmarks_placement = "signcolumn",
						padding = " ",
						symlink_arrow = " ➛ ",
						show = {
							file = true,
							folder = true,
							folder_arrow = true,
							git = true,
							modified = true,
							diagnostics = true,
							bookmarks = true,
						},
						glyphs = {
							default = "",
							symlink = "",
							bookmark = "󰆤",
							modified = "●",
							folder = {
								arrow_closed = "",
								arrow_open = "",
								default = "",
								open = "",
								empty = "",
								empty_open = "",
								symlink = "",
								symlink_open = "",
							},
							git = {
								unstaged = "󱧔",
								staged = "󱧘",
								unmerged = "",
								renamed = "",
								untracked = "",
								deleted = "󰮉",
								ignored = "",
							},
						},
					},
				},
				diagnostics = {
					enable = true,
					show_on_dirs = false,
					show_on_open_dirs = false,
					debounce_delay = 50,
					severity = {
						min = vim.diagnostic.severity.HINT,
						max = vim.diagnostic.severity.ERROR,
					},
					icons = {
						hint = '󰌵',
						info = ' ',
						warning = ' ',
						error = ' ',
					},
				},
				modified = {
					enable = true,
					show_on_dirs = false,
					show_on_open_dirs = false,
				},
				filters = {
					dotfiles = true,
				},
			})
		end,

	},

	{
		-- 快速打开 lazygit
		'kdheepak/lazygit.nvim',
		event = "VeryLazy",
		config = function()
			vim.g.lazygit_floating_window_scaling_factor = 0.8
			vim.g.lazygit_floating_window_winblend = 0
			vim.g.lazygit_use_neovim_remote = true
			vim.keymap.set('n', '<c-g>', ':LazyGit<CR>', { noremap = true, silent = true })
		end
	},
}

return M
