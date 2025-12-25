#!/bin/bash

# ==============================================================================
# Mac Vim 一键全能配置脚本 (2025 优化版)
# 功能：支持鼠标滚动、自动补全、系统剪贴板、文件树、精美主题
# ==============================================================================

set -e

echo "🚀 开始配置 Vim..."

# 1. 检查并安装 Vim-Plug (插件管理器)
if [ ! -f "$HOME/.vim/autoload/plug.vim" ]; then
    echo "📦 正在安装 Vim-Plug..."
    curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
        https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim --silent
else
    echo "✅ Vim-Plug 已存在"
fi

# 2. 备份旧的 .vimrc
if [ -f "$HOME/.vimrc" ]; then
    echo "📂 备份旧的 .vimrc 到 ~/.vimrc.bak"
    cp ~/.vimrc ~/.vimrc.bak
fi

# 3. 写入全新的 .vimrc 配置
echo "📝 写入配置文件 (支持鼠标+滚动+剪贴板)..."
cat << 'VIMEOF' > ~/.vimrc
" ==========================================
" 基础设置
" ==========================================
syntax on                   " 开启语法高亮
set number                  " 显示行号
set cursorline              " 高亮当前行
set autoindent              " 自动缩进
set tabstop=4               " Tab宽度为4
set shiftwidth=4            " 自动缩进宽度为4
set expandtab               " Tab转空格
set clipboard=unnamed       " 与Mac系统剪贴板共享
set backspace=indent,eol,start " 修复退格键
set encoding=utf-8          " 编码设置
set noswapfile              " 不产生交换文件
set ignorecase              " 搜索忽略大小写
set smartcase               " 智能大小写

" ==========================================
" 鼠标与滚动优化 (核心要求)
" ==========================================
set mouse=a                 " 开启鼠标支持 (点击、滚动、缩放)
if has('mouse_sgr')
    set ttymouse=sgr        " 增强鼠标编码
endif
set scrolloff=7             " 滚动时光标距离顶部/底部保留7行

" ==========================================
" 插件列表 (使用 vim-plug)
" ==========================================
call plug#begin('~/.vim/plugged')
Plug 'dracula/vim', { 'as': 'dracula' } " 主题
Plug 'itchyny/lightline.vim'            " 状态栏
Plug 'preservim/nerdtree'               " 左侧文件树
Plug 'jiangmiao/auto-pairs'             " 自动括号补全
Plug 'tpope/vim-commentary'             " 快速注释 (gcc)
call plug#end()

" ==========================================
" 插件后置配置与快捷键
" ==========================================
" 设置颜色主题 (增加报错保护)
if (has("termguicolors"))
 set termguicolors
endif
silent! colorscheme dracula

" 快捷键映射
let mapleader = " "         " 设置空格为 Leader 键
inoremap jj <Esc>           " 连按 jj 退出编辑模式
nnoremap <C-n> :NERDTreeToggle<CR>   " Ctrl+n 开启关闭文件树
nnoremap <Leader>w :w<CR>   " 空格+w 保存
nnoremap <Leader>q :q<CR>   " 空格+q 退出

" 窗口跳转 (Ctrl+h/j/k/l)
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

" 取消搜索高亮
nnoremap <leader><CR> :nohlsearch<CR>
VIMEOF

# 4. 自动下载并安装插件 (静默执行)
echo "📥 正在下载插件 (Dracula, NERDTree, etc.)..."
vim +PlugInstall +qall

echo "--------------------------------------------------"
echo "✅ Vim 配置完成！"
echo "🌟 核心功能说明："
echo "1. 鼠标操作：支持直接点击定位、滚轮平滑滚动。"
echo "2. 系统剪贴板：Vim 内 y 复制，Cmd+V 即可在其他地方粘贴。"
echo "3. 文件树：按 'Ctrl + n' 开启或关闭左侧目录。"
echo "4. 快速退出：在插入模式下连按 'jj' 即可回到普通模式。"
echo "5. 快速注释：按 'gcc' 注释当前行。"
echo "--------------------------------------------------"
