---
title: MacOS优化使用体验
date: 2023-10-15 15:29:19
tags:
  - 杂项
---

都是比较主观的设置

<!-- more -->

# Bash默认加载文件设置 & 取消zsh提示

m1 mac带的系统默认zsh，如果日常用bash的话每次打开都会有提示，在.bash_profile中设置即可
默认加载的是.bash_profile，所以加一行.bashrc

```bash
export BASH_SILENCE_DEPRECATION_WARNING=1
source .bashrc
```

# bash无高亮

```bash
export CLICOLOR=1
export LSCOLORS=ExGxFxdaCxDaDahbadeche
alias grep='grep --color'
alias egrep='egrep --color'
alias fgrep='fgrep --color'
```

加入到.bashrc即可

# windows风格的 alt-tab

brew install --cask alt-tab

## 代替command+tab

{% asset_img p1 1.png %}

## 代替command+`

{% asset_img p2 2.png %}

可以实现跨桌面应用内切换

# 平铺式窗口管理 - Aerospace

在MacOS较高的版本，关闭 SIP 去折腾 yabai 比较麻烦，而且关闭了 SIP 功能之后也会有很多功能不方便用，例如 Apple Pay，就无法在app store中装一些移动端软件。

aerospace不需要任何提权操作

一些宣传效果可以看少数派的文章 [App+1 | AeroSpace：消除窗口重叠，世界属于平铺](https://sspai.com/post/84935)

这里列一下我的配置文件

{% fold .aerospace.toml %}
{% codeblock lang:toml %}
# See: https://nikitabobko.github.io/AeroSpace/commands.html#focus
# alt-h = 'focus left'
# alt-j = 'focus down'
# alt-k = 'focus up'
# alt-l = 'focus right'

# See: https://nikitabobko.github.io/AeroSpace/commands.html#workspace
alt-0 = 'workspace 0'
alt-1 = 'workspace 1'
alt-2 = 'workspace 2'
alt-3 = 'workspace 3'
alt-4 = 'workspace 4'
alt-5 = 'workspace 5'
alt-6 = 'workspace 6'
alt-7 = 'workspace 7'
alt-8 = 'workspace 8'
alt-9 = 'workspace 9'

# See: https://nikitabobko.github.io/AeroSpace/commands.html#move-node-to-workspace
alt-shift-0 = 'move-node-to-workspace 0'
alt-shift-1 = 'move-node-to-workspace 1'
alt-shift-2 = 'move-node-to-workspace 2'
alt-shift-3 = 'move-node-to-workspace 3'
alt-shift-4 = 'move-node-to-workspace 4'
alt-shift-5 = 'move-node-to-workspace 5'
alt-shift-6 = 'move-node-to-workspace 6'
alt-shift-7 = 'move-node-to-workspace 7'
alt-shift-8 = 'move-node-to-workspace 8'
alt-shift-9 = 'move-node-to-workspace 9'

[[on-window-detected]]
if.window-title-regex-substring = '(setting|设置)'
run = 'layout floating'

[[on-window-detected]]
if.window-title-regex-substring = '(Picture-in-Picture|画中画)'
run = 'layout floating'

# QQ
[[on-window-detected]]
if.app-id = 'com.tencent.qq'
# if.window-title-regex-substring = '^(?!QQ).*$'
run = 'layout floating'

# 微信
[[on-window-detected]]
if.app-id = 'com.tencent.xinWeChat'
# if.window-title-regex-substring = '^(?!WeChat \(Chats\)|微信 \(聊天\)).*$'
# if.window-title-regex-substring = '(WeChat|微信)'
run = 'layout floating'

[[on-window-detected]]
if.app-id = 'com.google.Chrome.app.ibblmnobmgdmpoeblocemifbpglakpoi'
run = 'layout floating'

[[on-window-detected]]
if.app-id = 'com.apple.ActivityMonitor'
run = 'layout floating'

[[on-window-detected]]
if.app-id = 'maccatalyst.com.atebits.Tweetie2'
run = 'layout floating'

# QQ音乐
[[on-window-detected]]
if.app-id = 'com.tencent.QQMusicMac'
run = 'layout floating'

# 钉钉
[[on-window-detected]]
if.app-id = 'com.alibaba.DingTalkMac'
run = 'layout floating'

# 网易云
[[on-window-detected]]
if.app-id = 'com.netease.163music'
run = 'layout floating'

# Alacritty
# [[on-window-detected]]
# if.app-id = 'org.alacritty'
# run = 'layout floating'
{% endcodeblock %}
{% endfold %}

# Thor

一款组合件触发应用的软件，我一般用来打开Alacritty

```bash
brew install --cask thor
```
