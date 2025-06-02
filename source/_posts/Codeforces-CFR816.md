---
title: Codeforces Round 816 (Div. 2)
tags: 
  - Codeforces
date: 2022.8.21
---

纯 粹 菜 鸡

<!-- more -->

[题面](https://codeforces.com/contest/1715/problems)

## C. Monoblock

**关键是思考单点对于整个答案的影响**，无论是统计初始答案还是询问的O(1)修改

如果所有元素都不相同，那么考虑区间的贡献就是 $\sum\limits_{i=1}^n i*(n-i+1)$

考虑 $a[i]$，
若 $a[i]=a[i-1]$，
那么所有 $l\leq i-1,r\geq i$ 的区间贡献都会比不同的情况减小 1

然后点修的时候考虑 $a[i] = a[i-1]$
 和 $a[i] = a[i+1]$ 的情况，考虑一下覆盖这两点的区间数量即可

比赛的时候，和ylq说前面统计答案小学生都秒了，然后就是因为这玩意儿被卡了一个半小时还多...

[submission](https://codeforces.com/contest/1715/submission/169224318)

## D. 2+ doors

思路挺简单，可能还没C难搞、

贪心考虑每一位，必须置0的先置0，然后从前往后填充，前面的尽量小就好

就是写起来略麻烦，

[submission](https://codeforces.com/contest/1715/submission/169240136)

## E. Long Way Home

感觉是很经典的问题

抓不到要点，跟着hint来想吧
