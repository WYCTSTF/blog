---
title: Codeforces Round 815 (Div. 2)
tags: 
  - Codeforces
date: 2022-08-19
---

该多练了.

<!-- more -->

## [B. Interesting Sum](https://codeforces.com/contest/1720/problem/B)

考虑四个选项在序列里面，无论什么样的排列方式都能将它们取出来

因此排个序输出就好..

然而还是卡了很久..

[submission](https://codeforces.com/contest/1720/submission/168835069)

## [C. Corners](https://codeforces.com/contest/1720/problem/C)

注意到如果存在**斜对角的两个0**，或者**相邻的两个0**，就可以从这一块开始每次消一个1

否则**只有一个0**则是第一次会消两个1，如果**没有0**则第一次会消除3个1

讨论完输出1的个数减去不同情况的第一次消耗就好

[submission](https://codeforces.com/contest/1720/submission/168849435)

## [D1. Xor-Subsequence (easy version)](https://codeforces.com/contest/1720/problem/D1)

考虑 $O(N^2)$ 的暴力转移的DP

发现对于一个位置 $(i,a_i)$，
由于 $a_i \leq 200$，
$i$ 只会对 $[i+1,i+256]$ 的位置产生贡献

超出 $i+2^8$ 的范围的 $(j,a_j)$ 都不满足 $a_i \bigoplus j < a_j \bigoplus i$

[submission](https://codeforces.com/contest/1720/submission/168871283)

## [D2. Xor-Subsequence (hard version)](https://codeforces.com/contest/1720/problem/D2)

对于当前的i，考虑能够转移的选项 $j\ (j < i)$，有
$f_i=\max\limits_{a_j\bigoplus i<a_i\bigoplus j}\{f_j+1\}$

从高位往低位考虑，令 $i^p$ 表示 $i$ 的 $p$ 位

讨论 $a_i^p,i^p,a_j^p,j^p$ 的关系

1. 若 $a_j^p\bigoplus i^p<a_i^p\bigoplus j^p$，

对应到一位上的时候就只有 $0<1$ 这一种情况

即
$$\begin{align}
&a_j^p\bigoplus i^p=0,a_i^p\bigoplus j^p=1 \notag \\
&i^p\bigoplus a_i^p\bigoplus j^p\bigoplus a_j^p=1 \tag{1.1} \\
&j^p \ne a_i^p,i^p=a_j^p \tag{1.2}
\end{align}
$$

2. 若 $a_j^p\bigoplus i^p=a_i^p\bigoplus j^p$, 则

$$\begin{align}
  i^p\bigoplus a_i^p\bigoplus j^p\bigoplus a_j^p=0 \notag
\end{align}$$


开一个01 Trie维护一个 $i\bigoplus a_i$，从高往低考虑 $i\bigoplus a_i$ 的每一位，前面部分相等，在第一个位置 $p$ 有 $(i\bigoplus a_i)^p \ne (j\bigoplus a_j)^p$，就是一个满足条件的转移选项，我们想知道从这个 $j$ 转移过来能拿到的值，就要开一个
$f[u][0/1]$ 表示trie
当前这个节点，$a_j$ 在这位上是 $0/1$ 的最值

对于每个i，从高往低考虑 $i\bigoplus a_i$ 的每一位，
令 $v=(a[i]\bigoplus i)^c$

考虑第 $c$ 位不相等，$v$ 
取反就得到当前节点上满足条件的 $j$ 节点，然后$a_j$也应该满足情况，根据式 $(1.2)$
即 $a_j^c=i^c$，在f里面查这个的最大值

考虑第 $c$ 位相等，那么就继续找下去

插入的时候用转移来的 $\mathtt{dp[i]}$ 去更新
$\mathtt{f[trie[p][v]][a[i]^c]}$

写法看的Jiangly的，感觉写的是最清晰的..

[submission](https://codeforces.com/contest/1720/submission/168977744)
