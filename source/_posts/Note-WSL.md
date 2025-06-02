---
title: Windows 配置 WSL2
tags:
    - wsl
    - linux
date: 2023.3.11
# top: 2
---

挺多人搁那儿吹捧，怎么说呢.... 有总比没有好吧

但是还是存在很多问题的，比如opengauss在openEuler的WSL上，重启WSL后开启服务是个薛定谔的状态，在尝试的4台电脑上有两台可以，有两台wsl --shutdown之后重启openGauss就开不起来了，也不清楚是哪一方的锅，还有很多的锅。

<!-- more -->

# 安装 WSL2

## 准备 - Win 10

必须运行 Windows 10 版本 2004 及更高版本（内部版本 19041 及更高版本）或 Windows 11 才能使用以下命令。 

按下win+pause键打开系统页面即可查看**操作系统内部版本** 不过除非故意不升级一般也不会在这里卡住

-------

### 启用适用于 Linux 的 Windows 子系统

管理员身份打开 powershell，输入

```powershell
dism.exe /online /enable-feature /featurename:Microsoft-Windows-Subsystem-Linux /all /norestart
```

* 启用虚拟化

powershell 输入

```powershell
dism.exe /online /enable-feature /featurename:VirtualMachinePlatform /all /norestart
```

如果你在这两步就卡住了，提示dism.exe不可被执行，那么把报错信息拿到google/bing去搜一下，按照微软给的解决方案修一下系统即可

-----------------------

## 准备 - Win11

到控制面板中，找到程序和功能，选择启用或关闭Windows功能，打开`Windows虚拟机监控平台`和`适用于Linux的Windows子系统`，`Hyper-V`这三项，Hyper—V也可能以中文`虚拟机平台`的名称呈现，如果你找不到Hyper-V，直接以管理员身份打开Powershell，输入

```powershell
bcdedit /set hypervisorlaunchtype auto
```

-----------------------

## 安装内核升级包(Win10)

下载[X64的WSL2 Linux内核升级包](https://link.zhihu.com/?target=https%3A//wslstorestorage.blob.core.windows.net/wslblob/wsl_update_x64.msi)并安装

在打开的 powershell 中执行

```powershell
wsl --install
```

然后重启。

如果你wsl执行不了，就是之前的前置条件没开好

如果你已经安装了wsl，他应该会下载一个默认的分发版本，那也就不用执行了。

管理员身份打开powershell 设置WSL默认版本

```powershell
wsl --set-default-version 2
wsl --update
```

## 存在的问题 - 代理 & 启动位置

**如果你使用命令行安装，那么需要走代理，否则很慢，如果你用微软商店下载，则必须关闭代理**

如果你去微软商店下载了Ubuntu或者openEuler，它事实上下载了一个类似docker image的东西，下载完之后如果你不启动它，输入`wsl -l -v`可以看到并没有安装WSL

而启动openEuler或Ubuntu这些从商店中下载的wsl，无论是在powershell里用命令行执行，还是点击图标运行，它会先找这个"模板"对应的具体实例，如果没有找到，它会在默认位置下载，这就是为什么第一次启动之后，它会提示 Installing 的原因。

因此，如果你在迁移了WSL之后，没有先去WSL里开新的位置的实例，而是火急火燎的执行`ubuntu-22.03.exe --set-default`类似命令之后他会给你又装一个wsl的原因，因为这个模板原来的启动位置还是默认的，而默认的位置上WSL已经没了，所以他会重新装一个，而如果你从wsl开新迁移过来的版本，它会更改默认"模板"的启动位置。

当然，我并不知道wsl到底干了什么，上面都是我瞎猜的，只是效果如此，我只能这样推测

## 安装 Ubuntu 子系统

输入命令查看可获得的分发版本

```powershell
wsl --list --online
```

这里我们选择Ubuntu22.04版本

```powershell
wsl --install -d Ubuntu-22.04
```

也可以根据需要安装open Euler，微软商店能直接搜到

安装好之后Ubuntu会自动启动

等待几分钟的下载后会要求设置用户名和密码。

输入密码时不会显示，建议设置的不要太复杂。

在 powershell 中输入

```powershell
wslconfig /list
```

这里我得到的结果是
```powershell
适用于 Linux 的 Windows 子系统分发版：
Ubuntu-22.04(默认)
```

到这里我们就得到了可用的Windows for Linux子系统

如果你电脑上有windows terminal的话，Ubuntu 22.04应该会自动加入到列表里

没有的话建议去Microsoft Store下载一个，挺好用的，相信我你不会喜欢WSL默认的老版终端的，那玩意儿就连粘贴系统剪贴板都要右键边框+ep

## WSL2 迁移到其他盘

关闭正在运行的虚拟机

```powershell
wsl --shutdown
```

查看安装的虚拟机名称

```powershell
wsl -l -v
```

文件导出路径：填写一个 tar 结尾的路径 例如 D:\u.tar

```powershell
wsl --export 虚拟机名称 文件导出路径
```

```powershell
wsl --export Ubuntu-22.04 D:\u.tar
```

删除虚拟机

```powershell
wsl --unregister 虚拟机名称
```

```powershell
wsl --unregister Ubuntu-22.04
```

导入新的虚拟机

```powershell
wsl --import 虚拟机名称 目标路径 虚拟机文件路径 --version 2
```

```powershell
mkdir D:\\wsl\\Ubuntu
wsl --import Ubuntu D:\\wsl\\Ubuntu D:\\u.tar --version 2
```

查看安装的虚拟机，并启动它。不要在启动它之前执行相关的命令

```powershell
wsl -l -v
```

## 修改登录用户

迁移之后 我们的默认登陆用户可能从用户变成了root 导致拿不到之前的设置

管理员powershell执行

```powershell
ubuntu2204.exe config --default-user syh 改成你的用户名即可
```

当然，你也可以在虚拟机中的/etc/wsl.conf中添加

```
[user]
default=username
```

# WSL配置

## 开启 systemd [可选]

**如果你输入systemctl可以看到那些服务，这一节就没有必要看**

WSL饱受诟病的一点 但是微软现在提供了支持 即使是Win10！

WSL2为独立内核 我们在设置了版本之后

```powershell
wsl --set-default-version 2
```

还需要更新内核

```powershell
wsl --update
wsl --shutdown
```

注意下载的时候还是要关掉代理 和微软商店同理

之后执行

```powershell
wsl --version
```

如果返回正常的版本号 说明内核更新成功

我们再打开子系统 找到 /etc/wsl.conf 没有就直接新建

```bash
cd /etc && sudo vim wsl.conf
```

在内容中加入

```
[boot]
systemd=true
```

如果你不会Vim 请先阅读(Vim操作)部分 左侧目录可以直接跳转

保存之后在powershell中输入

```powershell
wsl --shutdown
```

再次打开时会发现已经启用了 systemd

我们可以执行看看

```bash
systemctl
```

发现服务已经成功启用 **按q退出**

## WSL配置代理

**这部分内容从[WSL2配置代理](https://www.cnblogs.com/tuilk/p/16287472.html)抄过来的**

## 配置vscode连接

从[官网](https://code.visualstudio.com/Download)下载 System Installer 安装时勾选所有选项（是否添加到桌面看情况勾选）

ctrl+shift+x打开插件栏 下载WSL

ctrl+shift+p打开控制面板 输入wsl

ctrl+shift+e打开资源管理器 打开你所需要的文件夹（工作区）

选择WSL:Conntect to WSL 就可以连接到你的WSL了

ctrl+`打开终端 开始你的WSL之旅吧

# Vim操作

补充一点关于 vim 的知识，会的可以跳过

vi/vim是linux自带的编辑器，也是十分好用的编辑器，当然学习曲线比较陡，可能难以上手，但是习惯了之后可以带来便利。

vim有多种模式，在 normal 的常规模式下，我们可以执行常规模式下的指令。

如果要编辑文件，则按 i 在当前光标进入到编辑模式，当然，按 a 也可以在光标之后的一个位置进入编辑模式

此外还有一些操作，例如 normal 模式下 d 为删除命令，接上一下参数可以删除指定的内容

gg 使光标移动到 第一行，G 使光标移动到最后一行，因此常规模式下，无论光标在何处，ggdG都可以删除第一行到最后一行，也就是全部的内容

如果要从其他模式返回 normal，只要按 esc 即可，当然vim也支持绑定键位，后期不顺手可以改键

更多的 vim 基础内容可以在命令行中输入

normal 模式下输入 :wq 保存并退出。 如果你没有更改文件的权限而想要退出 vim 并不保存，请使用 :q!

---------------

如果有问题欢迎评论区留言，我会尽我所能提供帮助
