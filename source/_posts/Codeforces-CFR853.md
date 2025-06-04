---
title: Codeforces Round 853「Div. 2」
tags: 
  - Codeforces
date: 2023-02-27
---
开始复健

<!-- more -->

[题面](https://codeforces.com/contest/1789/problems)

## A. Serval and Mocha's Array

$n \leq 100$，直接找有没有 $gcd\leq 2$就行

## B. Serval and Inversion Magic

考虑前半部分，如果 "和对应位置不同"的字母中间夹了和"对应位置相同"的字母，那就不行

[submission](https://codeforces.com/contest/1789/submission/195085230)

## C. Serval and Toxel's Arrays

单独考虑每个数字的贡献.

在 $m+1$ 次里，没有贡献的就是在 $i,j$ 中均未出现的情况

用 $\frac{(m+1)m}{2}$ 减掉没有贡献的情况即可。

[submission](https://codeforces.com/contest/1789/submission/196178473)
