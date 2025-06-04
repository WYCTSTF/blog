---
title: Codeforces Round 813 (Div. 2)
tags: 
  - Codeforces
date: 2022-08-14
---

学好二分，走遍天下都不怕..

以后不直接放代码了，太水字数了，这样不好评价自己的训练量

<!-- more -->

## [C. Sort Zero](https://codeforces.com/contest/1712/problem/C)

卡了很久..

本来直接维护一个val[i]表示i当前的值，然后一路扫过去

如果当前清零就回过去把之前不为0的都清零，是均摊 $O(n)$ 的

但是写挂了，然后就换了个很麻烦的方式来维护..

[submission](https://codeforces.com/contest/1712/submission/168151582)

## [D. Empty Graph](https://codeforces.com/contest/1712/problem/D)

没有看到太好懂的，，还是官方题解看起来方便..

以下算是翻译了..

考虑 $d(u,v)$，
其中 $u<v$

这个值就是 $min\{2*min\{a_1\cdots a_n\},a_u,\cdots,a_v\}$

前者是 $u$ 到任意端点 $k$ 再到 $v$，后者是 $u$ 直接到 $v$ 的方案

对于一个区间，当区间长度增大时，区间的最小值只会减小

考虑所有 $d(u,v)$，
其中 $1\leq u < v \leq n$，这里的最大值，所求的直径就是
$\max\limits_{1\leq i\leq n-1}d(i,i+1)$

即 $\min(\max\limits_{1\leq i \leq n-1}\min(a_i,a_{i+1}),2\cdot min(a_1,\cdots a_n))$

二分这个直径ans，check最小操作数，如果 $a_i < \frac{ans}{2}$，就把它变到 1e9

如果超出k，那就寄了

如果没有剩余，就计算一遍直径，否则讨论还有剩余的情况

如果剩一个操作数，可以找到一个最大的 $a_i$，操作它旁边的数字，使得 $\min(a_i,a_{i+1})$ 最大化，满足条件，如果剩余的有两个以上，就可以制造相邻的 1e9
最大化 $\min(a_i,a_{i+1})$，因此都是满足的

这样就可以计算最小步骤了..

[submission..](https://codeforces.com/contest/1712/submission/168280802)

## E. LCM Sum

给定t组数据，每组给定 $l, r$，有 $1\leq l \leq r \leq 2*10^5,l+2\leq r$

求
$$\sum\limits_{l\leq i<j<k\leq r}[lcm(i,j,k)\geq i+j+k]$$

Easy Version： $t\leq 5$

反过来计算 $lcm(i,j,k)<i+j+k$ 的数量，因为 $i+j+k<3k$

所以统计

$$\sum\limits_{1\leq i < j <k\leq r}[lcm(i,j,k)==k]+[lcm(i,j,k)==2k]*[i+j>k]$$

的数量，然后用总数减掉就是答案

$O(N\ln N)$
维护所有数的所有因子，然后 $O(N\sqrt N)$ check一下即可

[submission](https://codeforces.com/contest/1712/submission/168363702)

Hard Version: $t \leq 10^5$

离线处理所有询问

按右端点从小到大考虑，统计完 $[1,r]$ 内的数量后，就减去
$[1,l-1]$ 内的数量，用个点修区间查的结构即可

[submission](https://codeforces.com/contest/1712/submission/168366754)
