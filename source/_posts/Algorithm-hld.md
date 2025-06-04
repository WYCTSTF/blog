---
title: 树链剖分笔记
tags: 
	- 算法模板
	- 树链剖分
date: 2022-09-08
---

记得这东西几年前春游还是秋游的时候，xy给我15min讲过

然而那时候还是没写，后来上考场连打个线段树的机会都没有..

<!-- more -->

# 前置知识

* 线段树
* dfs序


# 轻重链剖分 Heavy-light decomposition

定义重儿子为所有子节点中子树最大的一个子节点，如果没有子节点，就没有重儿子，到重儿子的边就是重边。

剩下的节点都是轻儿子，对应的有轻边。

连续的重边构成重链，对应的有轻链。

$fa[u]$ 表示父节点，$dep[u]$ 表示深度，$siz[u]$ 表示子树大小，$son[u]$ 表示重儿子，$top[u]$ 表示所在重链的顶部节点（深度最小）

$dfn[u]$ 表示重儿子优先遍历的dfs序，$rnk[]$ 记录 $rnk[dfn[u]]=u$

用两遍dfs可以维护出上述的信息

```cpp
vector<int> dep(n + 1), fa(n + 1), siz(n + 1), son(n + 1);
dep[s] = 1;
function<void(int)> dfs1 = [&](int u) {
  son[u] = -1, siz[u] = 1;
  for (auto v : adj[u]) {
    if (!dep[v]) {
      dep[v] = dep[u] + 1, fa[v] = u;
      dfs1(v);
      siz[u] += siz[v];
      if (son[u] == -1 || siz[v] > siz[son[u]]) {
        son[u] = v;
      }
    }
  }
};
vector<int> top(n + 1), dfn(n + 1), rnk(n + 1);
function<void(int, int)> dfs2 = [&](int u, int _top) {
  static int cnt = 0;
  top[u] = _top;
  dfn[u] = ++cnt;
  rnk[cnt] = u;
  if (son[u] == -1)
    return;
  dfs2(son[u], _top);
  for (auto v : adj[u]) {
    if (v != son[u] && v != fa[u])
      dfs2(v, v);
  }
};
```

## 性质

每个节点必定只被一条重链覆盖

一个子树内dfn连续（无论剖不剖都是一样的）

每次向下经过一条轻边，子树大小至少缩小1倍，因此任意一条路径可以被拆分为 $O(\log n)$ 条重链

## 求LCA

如果不在一条重链，那么就让深度更大的点往上跳，至多经过 $O(\log n)$ 条重链

```cpp
int lca(int u, int v) {
  while (top[u] != top[v]) {
    if (dep[top[u]] > dep[top[v]])
      u = fa[top[u]];
    else
      v = fa[top[v]];
  }
  return dep[u] > dep[v] ? v : u;
}
```

卡树剖的应该比较少..

## [[ZJOI2008]树的统计](https://loj.ac/p/10138)

给定一棵树，每个点都有一个权值，要求维护三种操作

点修、路径单点最值、路径权值和

$n\leq 3\times 10^4,q\leq 2\times 10^5$

考虑 $u$ 到 $v$ 的路径，拆分成 $O(\log n)$ 的重链，从两端往上跳到 $lca(u,v)$，同时更新信息

因为一条重链内dfn连续，因此可以用线段树维护最值和路径和

$O(n\log n+q\log^2 n)$ 的复杂度

还是比较好写的 [submission](https://loj.ac/s/1575896)

## [[模板]轻重链剖分/树链剖分](https://www.luogu.com.cn/problem/P3384)

要求支持4种操作

路径点权修改，路径权值和，子树点权修改，子树点权和

权值变成了区间修改，懒标记维护一下即可

子树的统计：一个子树内dfn连续

憨憨题，直接贴[代码](/file/hld.cpp)

## 模板，但是换根

通过模板之后，一位小伙自信打开[LOJ #139](https://loj.ac/p/139)，准备领取双倍经验

但是他定睛一看，要求支持5种操作，多了一项换根..

换根只会影响子树部分的答案

考虑事实上不换根，标记一个 $root$，当查询 $x$ 的子树时，尝试分类讨论一下

1. $x=root$，整棵树
2. $lca(x, root)\ne x$，显然查询还是原来的 $x$ 为根的子树
3. $lca(x,root)= x$，考虑 root 在 $x$ 子树内的形态

不难发现，对于第三种情况就是整棵树减去以 $x$ 到 $root$ 的第一个节点为根的整个子树，差值就是要修改的部分，那么容斥一下就好了

![](/images/hld1.jpg)

以上图为例，就是框起来的这部分

那么在 $lca(x,root)==x$ 的时候，从root往上跳，倍增求也行，重链和重儿子来搞也行

我还是用倍增来写了

[submission](https://loj.ac/s/1576770)

代码好像放的没什么必要，就各种东西缝合一下，没什么实现难度

## 题单

就写了三份近乎于板子的代码吧，，但还是不太想继续搞了

列个作业在这里，等什么时候有空会来填坑

讲道理现在线性结构维护的手段还是太少了..

* [HAOI2015] 树上操作
* 洛谷 P3979 遥远的国度
* CF916 E. Jamie and Tree
* [NOI2015] 软件包管理器

# 长链剖分

待学

DS太无聊了，为什么会有人喜欢专门写这种题..
