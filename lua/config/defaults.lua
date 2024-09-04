-- 启用 nvim 的真彩色支持
vim.o.termguicolors                = true
vim.env.NVIM_TUI_ENABLE_TRUE_COLOR = 1

-- 打开终端时的一些配置 vim.g.terminal_color_0  = '#000000'
vim.g.terminal_color_1             = '#FF5555'
vim.g.terminal_color_2             = '#50FA7B'
vim.g.terminal_color_3             = '#F1FA8C'
vim.g.terminal_color_4             = '#BD93F9'
vim.g.terminal_color_5             = '#FF79C6'
vim.g.terminal_color_6             = '#8BE9FD'
vim.g.terminal_color_7             = '#BFBFBF'
vim.g.terminal_color_8             = '#4D4D4D'
vim.g.terminal_color_9             = '#FF6E67'
vim.g.terminal_color_10            = '#5AF78E'
vim.g.terminal_color_11            = '#F4F99D'
vim.g.terminal_color_12            = '#CAA9FA'
vim.g.terminal_color_13            = '#FF92D0'
vim.g.terminal_color_14            = '#9AEDFE'

vim.cmd([[autocmd TermOpen term://* startinsert]])

-- 配置非文本元素颜色
vim.cmd([[hi NonText ctermfg=gray guifg=grey10]])

-- 在终端中加速屏幕重绘，提高响应速度
vim.o.ttyfast = true
-- 使得当前工作目录自动切换到当前文件所在的目录
vim.o.autochdir = true
-- 允许执行当前目录下的 .vimrc 文件
vim.o.exrc = true
-- 允许执行一些可能存在安全风险的操作
vim.o.secure = false
-- 启用行号
vim.o.number = true
-- 启用相对行号
vim.o.relativenumber = true
-- 启用光标所在行高亮显示
vim.o.cursorline = true
-- 启用空格代替 Tab
vim.o.expandtab = true
-- 配置制表符（Tab）的宽度为4
vim.o.tabstop = 4
-- 开启智能制表符（Tab）
vim.o.smarttab = true
-- 配置缩进时的空格数量为4
vim.o.shiftwidth = 4
-- 配置插入模式下按下 Tab 的空格数为4
vim.o.softtabstop = 4
-- 启用自动缩进
vim.o.autoindent = true
-- 启用可见空白字符的显示
vim.o.list = true
-- 配置空白字符的样式
vim.o.listchars = 'tab:> ,trail:▫'
-- 设置光标距离窗口边缘5行时开始滚动
vim.o.scrolloff = 5
-- 设置键入键码和键入键序列之间的等待时间
vim.o.ttimeoutlen = 0
-- 禁用等待用户按键的时间
vim.o.timeout = false
-- 配置 view 时保存的信息，包括光标位置、折叠状态等
vim.o.viewoptions = 'cursor,folds,slash,unix'
-- 启用文本自动换行
vim.o.wrap = true
-- 自动换行的最大列数，设置为 0 表示不限制
vim.o.textwidth = 0
-- 自动缩进表达式
vim.o.indentexpr = ''
-- 启用折叠功能
vim.o.foldenable = true
-- 配置基于缩进的折叠方式
vim.o.foldmethod = 'indent'
-- 默认折叠级别为99
vim.o.foldlevel = 99
-- 打开文件时的默认折叠级别为99
vim.o.foldlevelstart = 99
-- 设置水平新窗口的拆分方向为右
vim.o.splitright = true
-- 设置垂直新窗口的拆分方向为下边
vim.o.splitbelow = true
-- 禁用显示当前编辑模式（Insert、Visual 等）的信息
vim.o.showmode = false
-- 配置搜索时忽略大小写
vim.o.ignorecase = true
-- 配置搜索时开启智能匹配大小写
vim.o.smartcase = true
-- 设置消息的显示方式，c 表示启用 ins-completion
vim.o.shortmess = vim.o.shortmess .. 'c'
-- 在命令行模式中，显示命令结果，设置为 split 时在分屏中显示
vim.o.inccommand = 'split'
-- 配置自动补全
-- noinsert: 不自动插入当前选中的项，留给用户手动确认插入。
-- menuone: 如果只有一项，会自动显示补全菜单。
-- noselect: 不自动选择第一项。
-- preview: 显示每个补全项的预览信息。
vim.o.completeopt = 'menuone,noinsert,noselect,preview'
-- 启用可视化响铃，替代传统的响铃声音
vim.o.visualbell = true
-- 设置自动保存文件的时间间隔，单位为毫秒
vim.o.updatetime = 100
-- 设置虚拟编辑模式为块状
vim.o.virtualedit = 'block'

-- 允许在切换 buffer 时隐藏未保存的文件
vim.o.hidden = true
-- 切换 buffer 时优先使用已打开的窗口
vim.o.switchbuf = "useopen"

-- 当进入缓冲区时将工作目录设为当前目录
vim.api.nvim_create_autocmd("BufEnter", { pattern = "*", command = "silent! lcd %:p:h", })

-- 再次打开文件时光标定位到上一次退出的位置
vim.cmd([[au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif]])

-- 读取 config.machine_specific.lua 文件，如果没有该文件则创建该文件并复制对应内容
local config_path = vim.fn.stdpath("config")
local current_config_path = config_path .. "/lua/config/machine_specific.lua"
if not vim.loop.fs_stat(current_config_path) then
    local current_config_file = io.open(current_config_path, "wb")
    local default_config_path = config_path .. "/default_config/_machine_specific_default.lua"
    local default_config_file = io.open(default_config_path, "rb")
    if default_config_file and current_config_file then
        local content = default_config_file:read("*all")
        current_config_file:write(content)
        io.close(default_config_file)
        io.close(current_config_file)
    end
end
require("config.machine_specific")
