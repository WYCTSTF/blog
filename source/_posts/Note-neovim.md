---
title: 小刻也能看懂的「neovim配置」「未完成」
date: 2024-02-08 23:26:52
tags:
categories:
---

上次折腾neovim快是一年前了(2023.3)，趁过年没什么要紧事干再折腾一下。

<!-- more -->

# 前置知识

默认用户有一定的lua基础和vim使用基础

* neovim内输入:Tutor\<CR>(\<CR>代表enter键，下同)获取基础的vim教程，只需20分钟左右即可学会vim基础操作
* lua基础教程移步[菜鸟教程](https://www.runoob.com/lua)

{% fold lua的两个速成点 %}
懒得叠甲，如果有语法警察欢迎在评论区纠正

* 如何理解require?
    类似include，加载一个模块

* lua中的变量
    默认全局变量，局部变量/函数需要local修饰
{% endfold %}

# lua配置

neovim支持lua配置文件 `init.lua`

mac/linux文件位置: `~/.config/nvim/init.lua`
