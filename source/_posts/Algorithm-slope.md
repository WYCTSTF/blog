---
title: 斜率优化DP 笔记
tags: 
  - DP
  - 斜率优化
date: 2022.8.22
---

CF 816的E要用到，计划是先学个大概再来写这题

<!-- more -->

先看的 [OI-wiki](https://oi-wiki.org/dp/opt/slope/) 上内容

## [「HNOI2008」 玩具装箱](https://www.luogu.com.cn/problem/P3195)

LOJ上的数据过水，就挂了洛谷的链接

维护一个前缀和 $pre_i$，考虑 $N^2$ 的DP

$$
f_i=\min_{j<i}\{(f_j+i-(j+1)+pre_i-pre_j-L)^2\}
$$

令 $s_i=pre_i+i$，则有

$$
f_i=\min_{j<i}\{f_j+(s_i-s_j-(L+1))^2\}
$$

令 $L'=L+1$，展开移项得到

$$
f_i-(s_i-L')^2=\min_{j<i}\{f_j+s_j^2+2s_j(L'-s_i)\}
$$

考虑一次函数的截剧式 $y=kx+b$，移项得 $b=y-kx$，与 $j$ 有关的信息表示为 $y$ 的形式，与 $ij$ 有关的信息表示为 $kx$，要最小化的信息表示为 $b$，即

$$
\begin{align*}
&x_j=s_j\\
&y_j=f_j+s_j^2\\
&k_i=2(s_i-L')\\
&b=f_i-(s_i-L')^2
\end{align*}
$$

转移方程就变成

$$
b = \min_{j<i}\{y_j-k_ix_j\}
$$

那就变成求截距最小值

![](/images/slope1.svg)


不难发现备选的点集一定在下[凸包](https://oi-wiki.org/geometry/convex-hull/)上，不用从前 $i-1$ 个点转移过来

用单调队列维护 $K(a,b)$，下凸包上相邻两点 $a,b$ 间的斜率，这个肯定是递增的，这样就可以维护一个指针 $e$，每次移动找到 $K(e-1,e)<k_i<K(e,e+1)$，$e$ 就是当前的选项

发现就是第一个 $K(e,e+1)>2(L'-s_i)$ 的地方，那么之前小于 $2(L'-s_i)$ 的选项都可以不要

更新完了之后，若 $K(back-1,back)>K(back,i)$，那么就弹出队尾

这样肯定是把最下面一圈的外轮廓维护出来的

最后找到之后移项一下就OK了，只用到初中数学知识、、

```cpp
#include <bits/stdc++.h>
using namespace std;
const int N = 50010;
int n, l;
int c[N];
long long pre[N], s[N], f[N];

inline long long a(int i) { return s[i] - l - 1; }
inline long long x(int i) { return s[i]; }
inline long long y(int i) { return f[i] + s[i] * s[i]; }
inline double K(int a, int b) { return (y(a) - y(b)) / (double)(x(a) - x(b)); }

int main() {
  cin >> n >> l;
  for (int i = 1; i <= n; ++i) {
    cin >> c[i];
    pre[i] = pre[i - 1] + c[i];
    s[i] = pre[i] + i;
  }
  static int q[N], hd = 0, bk = 0;
  q[bk++] = 0;
  for (int i = 1; i <= n; ++i) {
    while (hd + 1 < bk && K(q[hd], q[hd + 1]) < 2.0 * a(i))
      hd++;
    f[i] = f[q[hd]] + (s[q[hd]] - a(i)) * (s[q[hd]] - a(i));
    while (hd < bk - 1 && K(q[bk - 2], q[bk - 1]) > K(i, q[bk - 1]))
      bk--;
    q[bk++] = i;
  }
  cout << f[n] << '\n';
  return 0;
}
```

斜优DP大概就是把转移式子写出来之后，发现可以拆项成一个一次函数的表现形式

然后配合二分、CDQ的操作快速筛选

------

现在来尝试拿下CF816的E..

## [CF816 E. Long Way Home](https://codeforces.com/contest/1715/problem/E)

给定 $n$ 个点 $m$ 条边的图，每组点对 $(u,v)$ 还有一条特殊路径，长 $(u^2-v^2)$，至多选择
 $k$ 条特殊路径，问 1 走到 $n$ 的最短路径

考虑已经取了 $k$ 条特殊边的最短路，记为 $d_k$，那么怎么求 $d_{k+1}$ 呢，考虑推导一个 $f_i=\min\limits_{1\leq j \leq n}\{d_k[j]+(i-j)^2\}$，即在 $d_k$ 基础上，每个点以一条特殊边结尾的最短路，在 $f_i$ 的基础上再跑一边 Dijkstra，就得到至多用 $k+1$ 条特殊边的最短路

那么现在的做法就是 $O(k(mlogn+n^2))$ 的，关键就是在于 
$f_i$ 更新的速度

考虑 
$$
f_i=\min_{1\leq j\leq n}\{d[j]+(i-j)^2\} \iff
f_i-i^2=\min\{d[j]+j^2-2ij\}
$$

那么由 $b=y-kx$ 得到
$$
\begin{align*}
&b=f_i-i^2\\
&y=d[j]+j^2\\
&k=2i\\
&x=j
\end{align*}
$$

因为 $k=2i>0$ 并且逐渐增大，那么还是用单调队列维护上凸包就行了

因为可以从任意的点转移过来，并且 $j$ 作为 $x$ 也是递增的，因此把所有的斜率插入再搞，然后单点移动一下，就是 $O(n)$ 的，总体就是
$O(k(mlogn+n))$ 的了

单调栈还是单调队列？无所谓了..

好像还有个决策单调性+分治做法，可以看[wc的视频](https://www.bilibili.com/video/BV1ZG41147HH?vd_source=efe08555a263dcd8ebbc50a35572c2b7)

大概就是先跑一边最短路，求出d之后，做k次的 [斜优求f，然后以f为基础跑一遍最短路求出新d]

然后找到对应转移点 $v$ 之后有

$$
b=y-kx \iff f_i -i^2=d[v]+v^2-2ij \iff f_i=d[v]+(i-v)^2
$$

[submission](https://codeforces.com/contest/1715/submission/169724453)

好了... 去打游戏了..
