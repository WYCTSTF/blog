---
title: Codeforces Round 864
tags: 
  - Codeforces
date: 2023-04-10
---

越来越感觉前面几题浪费时间了 （对想题能力没有什么提升 实现和具体的考虑则需要更专注一点）

这两天看老番 佐贺偶像是传奇 感觉很好看 很鲜活有感染力 然而今天不怎么在状态 人有点消沉 不知道是不是熬夜的缘故

<!-- more -->

* A

阅读理解题 一条线除了两段不能经过坐标点 [submission](https://codeforces.com/contest/1816/submission/201636282)

* B

显然1-n要在减的位置上 看样例猜了个结论: 2n和2n-1都要在必经点上

[submission](https://codeforces.com/contest/1816/submission/201636783)

* C

维持单调性 显然想到差分，保证负数不出现即可

a[i]和a[i+1]++其实是差分数组c[i]--,c[i+2]++

于是c[n-1]可以无限加。而c[1]=a[1]又无所谓值

所以n-1对应偶数，即n是奇数的时候怎样都可，反之是偶数的话，保证偶数位上的$\sum c\geq 0$即可

别忘了long long（笑

[submission](https://codeforces.com/contest/1816/submission/201635817)

* D

交互

给定一个长为n的隐藏排列 p 允许做2n次交互操作

1. 询问 $2 \leq x \leq 2n$，会将所有和为x的点对连边
2. 询问 $x,y$，得到 $p_x,p_y$ 的最短距离

想了一会儿，不太能构造 去看了题解

考虑将图构造成一条确定的链的形式 这样我们可以在确认了端点之后通过少数讯问继续固定剩下的点

考虑构造一个交替的链，发现询问两次 $+\ n+1$ 和 $+\ n+2$，就能构造出 $1-n-2-n+1...$ 的情况

那么距离排序拿到端点，讨论两个端点，2次构造询问+$n-1$次距离询问+$n-1$确认排列的的询问$=2n$

[submission](https://codeforces.com/contest/1816/submission/201765406)
