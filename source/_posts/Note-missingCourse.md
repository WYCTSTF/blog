---
title: The Missing Semester 笔记
date: 2023.2.13
tags:
    - Shell
---

b站刷美女的时候看到bash教程（大概还是低质量卖课，不过这方面我不懂确实不好下结论），感觉需要学一下

然后评论区看到了 Missing Course 的推荐，就学这个了。

还是个人笔记，详细内容看官方page

* 资料
  * [机翻](https://www.bilibili.com/video/BV1x7411H7wa/?spm_id_from=333.337.search-card.all.click&vd_source=efe08555a263dcd8ebbc50a35572c2b7)
  * [精翻 不完全](https://space.bilibili.com/1010983811?spm_id_from=333.337.search-card.all.click)
  * [官方page](https://missing-semester-cn.github.io/)

<!-- more -->

# L1. 课程概览与 shell

都是常识，略。

# L2. Shell 工具和脚本

shell 意思为壳，相较于内核而言。提供一个命令行解释器，bash 是shell的一种，大部分linux系统的默认 shell，像现在的 macos 提供的 shell 默认为 zsh 一样

普通空格在shell中用来分割参数

字符串中 \$(cmd) 可以直接展开为指令内容的字符串，变量(去掉括号)也是一样，不过都只能在双引号中展开，单引号不行

```bash
foo=tester
echo "Hello $foo"
echo 'Hello $foo'
echo "Hello $(ls)"
echo 'Hello $(ls)'
```

命令行中 `$(cmd)` 则可以把cmd运行后的内容当成指令来执行

```bash
$(echo ls)
```

`<(cmd)` 过程替换，执行内部的命令，输出被存储到一个临时文件，并把文件handle（本身）交给左边的命令

```bash
echo "Starting program at $(date)"

echo "Running program $0 with $# arguments with pid $$"

for file in "$@"; do
  grep foobar in "file" > /dev/null 2> /dev/null

  if [["$?" -ne  0]]; then
    echo "File $file does not have any foobar, adding one"
    echo "# foobar " >> "file"
  fi
done
```

```txt
$? 返回上条命令的 error code（返回值）
$_ 返回上条命令的最后一个参数
$0 返回脚本的名字
$1 - $9 这种返回对应的参数，类似部分编程语言中的 argv
$# 表示给定参数个数
`$$` 表示命令的进程 id
`$@` 可以展开成所有参数
```

重定向到 `/dev/null` 可以丢弃所输出的内容，`>` 重定向标准输出，`2>` 重定向标准错误

`-ne` 比较整数值是否相等，用 `man test` 指令可以查看更多内容

mac 下执行 sh 会提示 permission denied，需要先给它执行权限

```bash
chmod 777 xxx.sh
```

shell的参数支持通配符匹配，不是很懂这个和正则的区别，搜了一下得到的答案是：“通配符是系统命令使用，一般用来匹配文件名或者什么的用在系统命令中。 而正则表达式是操作字符串，以行尾单位来匹配字符串使用的”

感觉讲的略抽象，没搞懂什么意思

通配支持 ? * 匹配文件，支持 {,} 自动展开命令

```bash
convert image.{png,jpg}
# 会展开为
convert image.png image.jpg

cp /path/to/project/{foo,bar,baz}.sh /newpath
# 会展开为
cp /path/to/project/foo.sh /path/to/project/bar.sh /path/to/project/baz.sh /newpath

# 也可以结合通配使用
mv *{.py,.sh} folder
# 会移动所有 *.py 和 *.sh 文件

mkdir foo bar

# 下面命令会创建foo/a, foo/b, ... foo/h, bar/a, bar/b, ... bar/h这些文件
touch {foo,bar}/{a..h}
touch foo/x bar/y
# 比较文件夹 foo 和 bar 中包含文件的不同
diff <(ls foo) <(ls bar)
# 输出
# < x
# ---
# > y
```

按 tab 展开 {}

通配貌似还支持 .. 自动推导内容

bash脚本的第一行称为 shabang，源于 #!，#为sharp，！为bang，shell痛过这个声明了解运行当前脚本

这也解释了当时我装YouCompleteMe的时候为什么既能 python 跑安装脚本也能 ./ 调用了。因为首行提供了解释器的路径
