---
title: 向gitignore中加入tracked file
date: 2023-05-24 00:23:06
tags:
    - git
---

远程仓库的文件，将其加入gitignore,但是保留本地和远程的内容，后续不再更新。

因为要在x86 arch和arm mac上共用仓库，所以配置不能统一，例如cmake/vcpkg，以及build、cache等等

过程中乱用gitignore出了一些问题

<!-- more -->

## 忽略已经被提交过的文件

.gitignore只能忽略没有被git管理的文件，即untracked file，一旦被add或commit过，git就会跟踪file，在这之后将文件加入.gitignore也是不管用的

那么如果我们想要将文件忽略，首先就是将它变成untracked状态

{% code lang:git line_number:false %}
git rm (file / -r directory)
git add ...
git commit -m "update ignore"
git push
{% endcode %}

但这样会在删除远程仓库中的文件时，同时将本地的也删掉。如果只是想删除远程仓库中的内容

{% code lang:git line_number:false %}
git rm --cached ...
{% endcode %}

加上--cached即可删除追踪状态

但是如果我们想要保留远程仓库中的文件，又不记录后续的追踪，有一种手段可以达到

```git
git update-index --assume-unchanged /path/to/file
```

但这事实上是治标不治本的做法，`update-index`针对的是git中被记录的文件，而不是被忽略的文件，结合英文我们可以发现它实际上做的事是假定没有修改，但事实上修改是会被记录下来的。

在团队中，如果a对file执行了这个操作，但是b pull了目标文件之后没有`assume-unchanged`，他的下一次push会改变这个文件的状态，git又开始记录目标文件的变化，于是所有人都要再执行一次 `git update-index --assume-unchanged <PATH>`

也就是说，如果我在mac上执行了`git update-index --assume-unchanged CMakeList.txt`，但是第二天回到arch上时候pull下来忘记加了，就开始将cmakelists调整成另一台环境，结束一天的工作并且push，晚上重新在mac上用的时候发现cmakelists又被改了，又得改成适合arm-osx的环境

而.gitignore则不会像这样给所有人增加负担，pull之后无需任何额外行为

事实上这也不是 `git update-index --assume-unchanged` 的目的。真正的用法是，我正在修改一个巨大的文件，先给它加上这条，让git暂时不追踪，省的git计算变化&更新工作区的行为拖慢速度。工作结束后，重新改标记`git update-index --no-assume-unchanged`，来实现修改一大文件过程中git只更新一次的效果。

事实上，如果我只是想要达成文中开始的目的，那么应该是将作为参考的cmakelists放起来管理，然后修改.gitignore，再两个环境写各的cmakelists.txt

## 参考文章

* [git忽略已经被提交的文件](https://segmentfault.com/q/1010000000430426)
* [Git忽略已经提交过一次文件Git忽略文件](https://cloud.tencent.com/developer/article/1655478)
