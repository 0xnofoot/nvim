M = {
	{
		-- 相同词汇高亮
		'RRethy/vim-illuminate',
		config = function()
			require('illuminate').configure({
				providers = {
					-- 'lsp',
					-- 'treesitter',
					'regex',
				},
			})
			vim.cmd('hi IlluminatedWordText guibg=#494F4D gui=none')
		end
	},

	{
		-- 自动补全列表符号
		'dkarter/bullets.vim',
		event = 'VeryLazy',
		ft = { 'markdown', 'txt' },
	},

	{
		-- 背景显示颜色字符
		'NvChad/nvim-colorizer.lua',
		event = "VeryLazy",
		opts = {
			filetypes = { '*' },
			user_default_options = {
				RGB      = true, -- #RGB hex codes
				RRGGBB   = true, -- #RRGGBB hex codes like #8080ff
				names    = true, -- 'Name' codes like Blue
				RRGGBBAA = true, -- #RRGGBBAA hex codes like
				rgb_fn   = true, -- CSS rgb() and rgba() functions
				hsl_fn   = true, -- CSS hsl() and hsla() functions
				css      = true, -- Enable all CSS features: rgb_fn, hsl_fn, names, RGB, RRGGBB
				css_fn   = true, -- Enable all CSS *functions*: rgb_fn, hsl_fn
				-- Available modes: foreground, background
				mode     = 'background', -- Set the display mode.
			},
			-- all the sub-options of filetypes apply to buftypes
			buftypes = {},
		}
	},

	{
		-- 折叠功能强化
		'kevinhwang91/nvim-ufo',
		dependencies = { 'kevinhwang91/promise-async', },
		config = function()
			local handler = function(virtText, lnum, endLnum, width, truncate)
				local newVirtText = {}
				local suffix = (' ... %d 󰁂 ... '):format(endLnum - lnum)
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
							suffix = suffix .. (' '):rep(targetWidth - curWidth - chunkWidth)
						end
						break
					end
					curWidth = curWidth + chunkWidth
				end
				table.insert(newVirtText, { suffix, 'MoreMsg' })
				return newVirtText
			end

			require('ufo').setup({
				enable_get_fold_virt_text = true,
				fold_virt_text_handler = handler,
				open_fold_hl_timeout = 150,
				close_fold_kinds = { 'imports', 'comment' },
				preview = {
					win_config = {
						border = { '', '─', '', '', '', '─', '', '' },
						winhighlight = 'Normal:Folded',
						winblend = 0
					},
					mappings = {
						scrollU = '<C-u>',
						scrollD = '<C-d>',
						jumpTop = '[',
						jumpBot = ']'
					}
				},
				provider_selector = function(bufnr, filetype, buftype)
					return { 'treesitter', 'indent' }
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
		'windwp/nvim-autopairs',
		config = function()
			require('nvim-autopairs').setup({})
		end
	},

	{
		-- 快速注释
		'tomtom/tcomment_vim',
		event = 'BufRead',
		config = function()
			vim.g.tcomment_maps = true
			vim.g.tcomment_textobject_inlinecomment = ''

			-- 不知道怎么绑定 ctrl+/, 好像 vim 中 使用 <c-_> 代替 <c-/>
			-- 但是这可能在 tmux 中不起作用
			-- Todo
			vim.keymap.set({ 'n', 'i', 'v' }, '<C-c>', ':TComment<CR>', { silent = true })
		end
	},

	{
		-- 对于被括号或其他符号包围的内容
		-- 提供一系列快速操作方案
		'kylechui/nvim-surround',
		version = '*',
		event = 'VeryLazy',
		config = function()
			require('nvim-surround').setup()
		end
	},

	{
		-- 复制粘贴增强
		'gbprod/yanky.nvim',
		event = 'VeryLazy',
		dependencies = {
			'kkharji/sqlite.lua',
		},
		config = function()
			-- 使用系统剪切板
			vim.cmd [[set clipboard=unnamedplus]]

			vim.keymap.set('n', '<c-p>', '<Plug>(YankyCycleForward)')
			vim.keymap.set('n', '<c-n>', '<Plug>(YankyCycleBackward)')
			vim.keymap.set({ 'n', 'x' }, 'p', '<Plug>(YankyPutAfter)')
			vim.keymap.set({ 'n', 'x' }, 'P', '<Plug>(YankyPutBefore)')

			require('yanky').setup({
				ring = {
					history_length = 2000,
					storage = 'sqlite',
					sync_with_numbered_registers = true,
					cancel_event = 'update',
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
		'nyngwang/NeoZoom.lua',
		config = function()
			vim.keymap.set('n', '<leader>;', ':NeoZoomToggle<CR>', { silent = true, nowait = true })
			require('neo-zoom').setup {
				popup = { enabled = true }, -- this is the default.
				-- NOTE: Add popup-effect (replace the window on-zoom with a `[No Name]`).
				-- EXPLAIN: This improves the performance, and you won't see two
				--          identical buffers got updated at the same time.
				-- popup = {
				--   enabled = true,
				--   exclude_filetypes = {},
				--   exclude_buftypes = {},
				-- },
				exclude_buftypes = { 'terminal' },
				-- exclude_filetypes = { 'lspinfo', 'mason', 'lazy', 'fzf', 'qf' },
				winopts = {
					offset = {
						-- NOTE: omit `top`/`left` to center the floating window vertically/horizontally.
						-- top = 0,
						-- left = 0.17,
						width = 1.0,
						height = 1.0,
					},
					-- NOTE: check :help nvim_open_win() for possible border values.
					border = 'thicc', -- this is a preset, try it :)
				},
				presets = {
					-- {
					-- 	-- NOTE: regex pattern can be used here!
					-- 	filetypes = { 'dapui_.*', 'dap-repl' },
					-- 	winopts = {
					-- 		offset = { top = 0.02, left = 0.26, width = 0.74, height = 0.25 },
					-- 	},
					-- },
					{
						filetypes = { 'markdown' },
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
		'folke/flash.nvim',
		event = 'VeryLazy',
		opts = {
			labels = 'arstneiowfuydh',
			jump = {
				jumplist = true,
				pos = 'start', ---@type 'start' | 'end' | 'range'
				history = false,
				register = false,
				nohlsearch = false,
				autojump = false,
				inclusive = nil, ---@type boolean?
			},
			label = {
				uppercase = false,
				exclude = '',
				current = false,
				-- show the label after the match
				after = true, ---@type boolean|number[]
				-- show the label before the match
				before = false, ---@type boolean|number[]
				-- position of the label extmark
				style = 'inline', ---@type 'eol' | 'overlay' | 'right_align' | 'inline'
				-- flash tries to re-use labels that were already assigned to a position,
				-- when typing more characters. By default only lower-case labels are re-used.
				reuse = 'all', ---@type 'lowercase' | 'all'
				-- for the current window, label targets closer to the cursor first
				distance = true,
				-- minimum pattern length to show labels
				-- Ignored for custom labelers.
				min_pattern_length = 0,
				-- Enable this to use rainbow colors to highlight labels
				-- Can be useful for visualizing Treesitter ranges.
				rainbow = {
					enabled = true,
					-- number between 1 and 9
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
					labels = 'arstneiowfuydh',
					jump = { pos = 'range' },
					search = { incremental = false },
					label = { before = true, after = true, style = 'inline' },
					highlight = {
						backdrop = false,
						matches = false,
					},
				},
				treesitter_search = {
					jump = { pos = 'range' },
					search = { multi_window = true, wrap = true, incremental = false },
					remote_op = { restore = true },
					label = { before = true, after = true, style = 'inline' },
				},
				-- options used for remote flash
				remote = {
					remote_op = { restore = true, motion = true },
				},
			},
			prompt = {
				enabled = true,
				prefix = { { '⚡', 'FlashPromptIcon' } },
				win_config = {
					relative = 'editor',
					width = 1, -- when <=1 it's a percentage of the editor width
					height = 1,
					row = -1, -- when negative it's an offset from the bottom
					col = 0, -- when negative it's an offset from the right
					zindex = 1000,
				},
			},
		},
		keys = {
			{
				'<leader>f',
				mode = { 'n' },
				function()
					require('flash').jump({
						remote_op = {
							restore = true,
							motion = true,
						},
					})
				end,
				desc = 'Flash',
			},
			{
				'<leader><esc>f',
				mode = { 'n', 'o', 'x' },
				function()
					require('flash').treesitter()
				end,
				desc = 'Flash Treesitter',
			},
		},
	},

	{
		-- 自动设置当前工作目录
		"airblade/vim-rooter",
		init = function()
			vim.g.rooter_patterns = { '__vim_project_root', '.git/' }
			vim.g.rooter_silent_chdir = true
		end
	},

	{
		-- 支持大多数语言的快速跳转变量，类，函数
		-- 不是跳转到源码，因为它并不是支持 lsp
		-- 方便看工作目录内自己定义的类型
		"pechorin/any-jump.vim",
		config = function()
			-- vim.g.any_jump_enable_keybindings = 1
			vim.g.any_jump_disable_default_keybindings = 1
			vim.keymap.set("n", "gj", ":AnyJump<CR>", { noremap = true })
			vim.keymap.set("x", "gj", ":AnyJumpVisual<CR>", { noremap = true })
			vim.g.any_jump_window_width_ratio = 0.9
			vim.g.any_jump_window_height_ratio = 0.9

			-- 这个插件的默认快捷键配置无法设置为 disable,可能是 bug
			-- 所有在这重新配置一下 <leader>j
			vim.keymap.set('n', '<leader>j', '<c-w>j')
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
		"nvim-neo-tree/neo-tree.nvim",
		event = "VeryLazy",
		branch = "v3.x",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-tree/nvim-web-devicons",
			"MunifTanjim/nui.nvim",
			{
				's1n7ax/nvim-window-picker',
				version = '2.*',
				config = function()
					require 'window-picker'.setup({
						filter_rules = {
							include_current_win = false,
							autoselect_one = true,
							bo = {
								filetype = { 'neo-tree', "neo-tree-popup", "notify" },
								buftype = { 'terminal', "quickfix" },
							},
						},
					})
				end,
			},
		},

		config = function()
			require("neo-tree").setup({
				close_if_last_window = true,
				sources = {
					"filesystem",
					"buffers",
					"git_status",
				},
				source_selector = {
					winbar = true,
					content_layout = "center",
					tabs_layout = "equal",
					show_separator_on_edge = true,
					sources = {
						{ source = "filesystem", display_name = "Files" },
						{ source = "buffers",    display_name = "Buffers" },
					},
				},

				default_component_configs = {
					indent = {
						indent_size = 2,
						padding = 1,
						with_markers = true,
						indent_marker = "¦",
						last_indent_marker = "└",
						with_expanders = true,
						expander_collapsed = "",
						expander_expanded = "",
						expander_highlight = "NeoTreeExpander",
					},
					icon = {
						folder_closed = "",
						folder_open = "",
						folder_empty = "",
						folder_empty_open = "",
						default = " ",
					},
					modified = { symbol = "" },
					git_status = {
						symbols = {
							added = "",
							modified = "",
							removed = "",
							renamed = "",
							ignored = "",
							conflict = "",
							deleted = "󰮉",
							staged = "󱧘",
							unstaged = "󱧔",
							untracked = "",
						}
					},
					diagnostics = {
						symbols = {
							error = ' ',
							warn = ' ',
							info = ' ',
							hint = '󰌵',
						}
					},
				},

				window = {
					position = "left",
					width = 26,
					mapping_options = {
						noremap = true,
						nowait = true,
					},
					mappings = {
						["<esc>"] = "cancel",
						["q"] = "",
						["Q"] = "close_window",
						["R"] = "refresh",
						["?"] = "show_help",

						["P"] = { "toggle_preview", config = { use_float = true, use_image_nvim = true } },

						["z"] = "",
						["s"] = "",
						["zz"] = {
							"toggle_node",
							nowait = true,
						},
						["zc"] = "close_node",
						["zC"] = "close_all_nodes",
						["zx"] = "expand_all_nodes",

						["T"] = {
							"add",
							config = {
								show_path = "relative" -- "none", "relative", "absolute"
							}
						},
						["A"] = "",
						["M"] = "add_directory",

						["zl"] = "open_vsplit",
						["zj"] = "open_split",
						["zL"] = "vsplit_with_window_picker",
						["zJ"] = "split_with_window_picker",
						["w"] = "open_with_window_picker",

						["<cr>"] = "open_tabnew",
						["l"] = "open",
						["L"] = "open_tabnew",

						["d"] = "",
						["dd"] = "cut_to_clipboard",
						["dD"] = "delete",
						["rn"] = "rename",
						["y"] = "",
						["yy"] = "copy_to_clipboard",
						["p"] = "",
						["pp"] = "paste_from_clipboard",
						["c"] = "",
						["yp"] = {
							"copy",
							config = {
								show_path = "relative" -- "none", "relative", "absolute"
							}
						},
						["i"] = "show_file_details",
						["m"] = "",
						["mv"] = "move",

						["<tab>"] = "prev_source",
					}
				},

				filesystem = {
					window = {
						mappings = {
							["."] = "set_root",

							["H"] = "",
							["zh"] = "toggle_hidden",

							["f"] = "",
							["/"] = "fuzzy_finder",
							["fs"] = "filter_on_submit",
							["fd"] = "fuzzy_finder_directory",
							["fx"] = "clear_filter",

							["o"] = "",
							["sn"] = { "order_by_name", nowait = true },
							["st"] = { "order_by_created", nowait = true },
							["ss"] = { "order_by_size", nowait = true },
							["se"] = { "order_by_type", nowait = true },
							["sm"] = { "order_by_modified", nowait = true },

							["<cr>"] = "open_tabnew",
							["l"] = "open",
							["L"] = "open_tabnew",
						},
						fuzzy_finder_mappings = {
							["<down>"] = "move_cursor_down",
							["<c-j>"] = "move_cursor_down",
							["<up>"] = "move_cursor_up",
							["<c-k>"] = "move_cursor_up",
						},
					},
				},

				buffers = {
					window = {
						mappings = {
							["."] = "set_root",
							["dD"] = "buffer_delete",

							["o"] = "",
							["sn"] = { "order_by_name", nowait = true },
							["sc"] = { "order_by_created", nowait = true },
							["ss"] = { "order_by_size", nowait = true },
							["st"] = { "order_by_type", nowait = true },
							["sm"] = { "order_by_modified", nowait = true },
						}
					},
				},
			})

			-- TODO
			-- local function toggleNeotree()
			-- 	local tabs = vim.fn.gettabinfo()
			-- local currentTabnr = vim.fn.tabpagenr()
			--
			-- 	for _, tab in ipairs(tabs) do
			-- 		vim.api.nvim_command("tabnext " .. tab.tabnr)
			-- 		vim.api.nvim_command("Neotree show")
			-- 	end
			-- end

			local function toggleNeotree()
				if not vim.g.neotreeOpened then
					vim.api.nvim_command("Neotree reveal")
					vim.g.neotreeOpened = true
				else
					vim.api.nvim_command("Neotree close")
					vim.g.neotreeOpened = false
				end
			end

			vim.keymap.set("n", "<leader>\\", toggleNeotree, { silent = true })
		end
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
