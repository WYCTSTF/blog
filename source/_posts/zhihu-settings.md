---
title: 知乎web体验优化
date: 2024-09-05 11:53:40
tags:
    - 杂项
---

## 屏蔽无障碍服务

ALT+按键切换会弹出无障碍，很烦人，装 ublock origin 插件，在**自定义静态规则**中加入 `||zhihu.com/*aria.js` 即可。

删除跟踪链接

`||zhihu.com^$removeparam=/utm_psn|spm/`

## 功能屏蔽

知乎的web UI 不仅没宽屏，边上还堆砌一些一辈子都不会点开的元素。

使用 [知乎修改器](https://greasyfork.org/zh-CN/scripts/423404) 删掉不需要的元素。
