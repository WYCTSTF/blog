---
title: asahi-ubuntu 24.04 设置
date: 2024-08-27 17:29:20
tags:
    - ubuntu
    - linux
---

自用，记录。

<!-- more -->

* 国内必备的网络设置
* 删ibus，装fcitx5，[装搜狗输入法](https://aur.archlinux.org/packages/fcitx5-sogou)，将七个deb包中的amd换成arm即可，感谢炳儿提供的资源。
* [删snap，另装firefox](https://www.zhihu.com/question/661866889/answer/3565354620)
* `sudo apt install ffmpeg`，解决firefox不支持html5播放器
* `sudo apt install gnome-tweaks  gnome-browser-connector`
* 改键位
  * gnome扩展里的设置无法满足我的要求
  * 先后使用了更改`/usr/share/X11/xkb/symbols/pc`，使用xdotool \& xbindkeys，autokey，xmodmap等方式，与X11有关的均有各种各样的问题，基本都是设置无法生效或者不能设置。改xkb会在vscode中同时生效一份未修改的映射。
  * 最后选择了keyd，支持wayland,并且似乎不是在窗口系统层面修改，不会产生x11和wayland同时更改的冲突。
  * 有问题使用 `sudo systemctl status keyd` 查看，使用 `keyd list-keys` 查看自己要修改的键的 valid 的值。

```fish
git clone https://github.com/rvaiya/keyd.git
cd keyd
make
sudo make install

sudo vim /etc/keyd/default.conf
```

```conf
[ids]
*

[main]
leftcontrol = esc
capslock = leftcontrol
esc = capslock
```

```fish
sudo systemctl enable keyd
sudo systemctl start keyd
```
* 字体用 [Monaco Nerd Font](https://github.com/thep0y/monaco-nerd-font) 和 [霞鹜文楷](https://github.com/lxgw/LxgwWenKai)
* [c炳：Linux上自用主题及扩展、插件备份](https://zhuanlan.zhihu.com/p/629180982) 桌面主题、功能设置，女大学生自用99新
* 装rust环境，[编译安装alacritty](https://github.com/GregTheMadMonk/alacritty-smooth-cursor/blob/smooth-cursor/INSTALL.md)，注意如果用我此处提供的alacritty-smooth-cursor，则需要在编译的时候选择仅支持x11，wayland下存在刷新bug
* [ghcup](https://www.haskell.org/ghcup/#) Haskell环境

```fish
set -gx PATH $PATH $HOME/.ghcup/bin
```

* 装xclip,wl-clipboard
* 仓库里的vim不知道为什么不支持wayland系统剪贴板，还需要装vim-gtk3，然后"+y就可以正常用了，虽然平时也不咋用。
* nvm(官网安装脚本)，fish装fisher,fisher装nvm插件(如下)

```fish
fisher install FabioAntunes/fish-nvm edc/bass
```

* `npm install -g @delance/runtime` 装群友逆向的pylance给neovim当lsp
* 装[miniconda](https://docs.anaconda.com/miniconda/), base装pynvim包给neovim用。
* [LLVM/Clang](https://github.com/llvm/llvm-project/releases)
* 拉配置alacritty、nvim、fish配置文件
* [WhiteSur Gtk Theme，gnome macos风格主题](https://www.gnome-look.org/p/1403328)
* 使用fn+f而非直接f区实现功能键(修改fnmode)

不知道为什么设备键盘生效了一次以后，用apple内置键盘还要重新设置一次。

```fish
sudo su -c "echo -n 0x02 > /sys/module/hid_apple/parameters/fnmode"
```

* firefox默认双击tab无法关闭标签页，打开about:config，找到browser.tabs.closeTabByDblclick设置为True
* [装docker](https://wcbing.top/linux/containers/install/), [docker-compose](https://github.com/docker/compose/releases)

```fish
curl -fsSL https://get.docker.com/ | sudo -E sh
sudo curl -L "docker-compose..." -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
```

* portainer管理docker，mysql用docker跑，web管理面板用的[mywebsql](https://hub.docker.com/r/webhippie/mywebsql)了，数据库需要在env参数指定 `MYWEBSQL_AUTH_SERVER` 和 `MYWEBSQL_SERVER_LIST`，凑合用。
* 装OBS，直接装依赖，加官方的PPA即可，还是比较方便的，无需编译安装

```fish
sudo apt update
sudo apt upgrade
sudo apt install ffmpeg libv4l-dev qtbase5-dev
sudo add-apt-repository ppa:obsproject/obs-studio
sudo apt update
sudo apt install obs-studio
```

还有些零碎的小工具没装上，随用随装吧。
用了一段时间，重新切回mac的第一个感觉就是，慢。第二个感觉就是macos的傲慢，很多东西都不让改，强迫用户去接受。
习惯了指纹验证，突然没有不太舒服，但是apple不开放安全芯片的权限，也没有办法。
