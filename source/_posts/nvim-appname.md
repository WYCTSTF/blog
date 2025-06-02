---
title: NVIM_APPNAME
date: 2024-09-21 05:03:18
tags:
    - neovim
    - vim
---

nvim 多套配置快速切换

配置拉下来放在 `~/.config/` 和 nvim 文件夹同级

之后可以使用环境变量 NVIM_APPNAME 来选择，在shell config中设置别名，变量值即目录名称。

```bash
alias avim='NVIM_APPNAME=AstroNvim nvim'
alias lvim='NVIM_APPNAME=lazyVim nvim'
alias kvim='NVIM_APPNAME=kickstartNvim nvim'
```

更多内容参考 [如何评价Neovim 0.9？ - kidneyball的回答 - 知乎](https://www.zhihu.com/question/594333293/answer/2973900710)