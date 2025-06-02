---
title: 安装 Debian12 后的配置
date: 2023-10-08 05:26:43
tags:
  - 折腾
categories: 杂项
---

卸掉了体感不是很好的Arch，换成了以后工作更可能用到的Ubuntu（顺带也从zsh改到了bash

记录一下我或者我使唤儿子wcb做的配置

然而分区扩容完了之后桌面崩了，换gdm sddm都不好使。一个多小时没解决直接重装成Debian12了。

<!-- more -->

* 装clash-verge，开TUN mod。这样上校园网只要随便打个ip就能跳转了，不用了每次上都关代理。

* 拉vim配置，建 `~/.vim/undodir`
* kde改gnome，gnome-tweaks，改了一下常用键位。主要就是caps和esc交换，左ctrl和左alt交换，还装了一下额外的插件，可以参考儿子的[这篇文章](https://zhuanlan.zhihu.com/p/629180982)，主要是为了系统托盘，野生的gnome把下面的dock栏也隐藏了，正合我意
* 切换字体为 monaco nerd font
* 装fcitx5，不过有些软件里面好像不生效，比如steam
* 装steam，qq，qq音乐，balabala，deb包下完了sudo apt install就好，不知道为什么qq音乐不能跑起来
* 安装rustup，编译[alacritty](https://github.com/alacritty/alacritty)，替换我的alacritty和tmux配置
* 装docker，主要看的[这篇内容](https://u.sb/debian-install-docker/) nvm miniconda vscode ghcup
* tun开了之后貌似ssh github会失败，要改一下config配置
```ssh config
Host github.com
  Hostname ssh.github.com
  port 443
```
* 本地生成ssh私钥，丢到服务器、github上。
* 拉neovim v0.9.1，编译，拉配置
* 安装fzf、vim和bash插件

有啥想到的再补充吧。目前要用的就这么多
