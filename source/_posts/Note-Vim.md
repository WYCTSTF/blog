---
title: vim配置
date: 2023.5.16
tags:
  - vim
  - 折腾
---

因为西安邀请赛的缘故，不得不用原生的vim

看了点知乎，增加了一点配置，发现还意外的好用


<!-- more -->

## vimrc

```
set nocompatible
syn on
filetype plugin on

set undofile
set undodir=~/.vim/undodir

set path+=**
set wildmenu

set nu rnu
set ai cin
set ts=2 sw=2
set vb t_vb=
set backspace=indent,eol,start
set autoread

no <F5> :!clang++ -O2 -std=c++17 -I/Users/syh/solution/header %:p -o %:r && echo "compile complete" && %:h/%:r<CR>
no <F6> :!clang++ -O2 -std=c++17 -I/Users/syh/solution/header %:p -o %:r && echo "compile complete" && %:h/%:r<%:p:h/in<CR>

set is " incsearch, useful for replacing

let g:netrw_banner=0
let g:netrw_winsize=25
let g:netrw_liststyle=3
let g:netrw_altv=1
let g:netrw_browse_split=4

" --------  Not for competition, For daily use only

no <F7> :!cf test<CR>
no <F8> :!cf submit<CR>

set scrolloff=5

let mapleader=";"
nnoremap <leader>w :w<CR>
nnoremap <leader>ct :!cf test<CR>
nnoremap <leader>cs :!cf submit<CR>
nnoremap h <C-w>h
nnoremap j <C-w>j
nnoremap k <C-w>k
nnoremap l <C-w>l
nnoremap <C-p> :FZF<CR>

set rtp+=/opt/homebrew/opt/fzf
```

<!-- 平时vim和neovim轮着用，状态好的时候就和三岁神仙一样裸vim啪啪敲，状态不好就开neovim 拄个拐杖 -->

<!--

neovim，主要就比原生多了一个LSP,competitest.nvim(用来写cf)，看个编译错误应该对水平也没太大影响

[我的neovim配置](https://github.com/WYCTSTF/nvim) 比较简陋 够用就行

## 如何使用我的nvim

### 拉取配置

首先编译/下载neovim0.9.1

拉取配置到 `~/.config/nvim` 之后安装 [packer](https://github.com/wbthomason/packer.nvim)

windows的配置需要放在 `C:\Users\AppData\Local\nvim`，不过应该没什么人会在windows上搞这种行为艺术吧，毕竟ps1难用是真的。。

### provider

本地还需要一个python提供provider，如果你是windows，请勿使用微软商店里的python3，之后执行

```bash
pip install neovim
```

建议用conda管理，并且将对应python加到环境变量中，如果这不是你的首选python，你可能还需要指定python路径，在lua的配置中添加以下内容，路径改为你的python路径。

```lua
vim.g.python3_host_prog = 'C:\\Users\\{username}\\AppData\\Local\\Microsoft\\WindowsApps\\python3.exe'
```

如果你直接命令行里打以下指令有结果的，那就不用特别指定了。

```bash
pip list | grep neovim
```

是否生效请检查 `:checkhealth provider`，以检查内容为准，不提供provider你可能会碰到LSP不生效等问题。

## 安装/根据需求调试插件

因为插件依赖和安装顺序问题，执行两次`:Packer Update`，等待Mason下载对应的LSP，Haskell的HLS需要提供GHCup的环境变量，如果不写Haskell直接去 `lua/lsp/setup.lua` 中将 hls 注释掉即可。

[telescope](https://github.com/nvim-telescope/telescope.nvim) 还需要 [fd](https://github.com/sharkdp/fd#installation) 和 [ripgrep](https://github.com/BurntSushi/ripgrep)，看着readme装就行。

所有的快捷键映射都在 `lua/keybings.lua` 中，基本上可以见名知意，这里不赘述，也请合理使用 `:help xxx` 查看教程。

如果有不清楚的地方欢迎给我评论。

-->
