---
title: Codeforces Round 932 (Div. 2)
date: 2024-03-12 00:53:14
tags:
  - Codeforces
  - 搞笑
---

开始复健，C题有点小难。但也没到D的难度，不知道是不是太久没打的缘故。

<!-- more -->

[题面](https://codeforces.com/contest/1935/problems)

A. Entertainment in MAC
=======================

给定一个字符串s，做n次操作，2选1：反转字符串，s=reverse(s)；加上一个反转的字符串，s=s+reverse(s)

n是偶数

求字典序最小的结果。

{% fold code %}
```cpp
#include <bits/stdc++.h>
using namespace std;
void solve() {
  int n;
  cin >> n;
  string s;
  cin >> s;
  string rs = s;
  reverse(rs.begin(), rs.end());
  cout << min({rs + s, s + rs , s}) << '\n';
}
int main() {
  int tt;
  cin >> tt;
  while (tt--) {
    solve();
  }
  return 0;
}
```
{% endfold %}

B. Informatics in MAC
=====================

给定一个长为n的数组a($0\leq a_i \leq n$)，问能否分割成2个以上的subsegment，每个subsegment的MEX相等。

{% fold solution %}
只考虑分成两段，找每个值的左右端点，如果MEX之前的值都能分到不同的段就OK，否则不行
{% endfold %}

{% fold code %}
```cpp
#include <bits/stdc++.h>
void solve(){
  int n;
  std::cin >> n;
  std::vector<int> l(n + 1, INT_MAX), r(n + 1, -1);
  for (int i = 1; i <= n; ++i) {
    int tem;
    std::cin >> tem;
    l[tem] = std::min(l[tem], i), r[tem] = std::max(r[tem], i);
  }
  int L = 1, R = n - 1;
  for (int i = 0; i <= n; ++i) {
    if (l[i] != INT_MAX) {
      L = std::max(L, l[i]), R = std::min(R, r[i] - 1);
    }
    else break;
  }
  if (L <= R) {
    std::cout << 2 << '\n' << '1' << ' ' << L << '\n' << L + 1 << ' ' << n << '\n';
  }
  else
    std::cout << "-1\n";
}
int main() {
  int tt;
  std::cin>>tt;
  while(tt--){
    solve();
  }
  return 0;
}
```
{% endfold %}

C. Messenger in MAC
===================

给定 $N, L$ 以及长为 $N$ 的数组 {A}, {B}

考虑一个大小为 $k$的序列 $p$，要求 $1\leq p_i\leq n$，$ p_i$ 互不相等，要求 
$$\sum\limits_{i=1}^{k}a_{p_i}+\sum\limits_{i=1}^{k-1}{|b_{p_i}-b_{p_{i+1}}|}\leq L$$

问最大的 $k$ 可以是多少

{% fold solution 1 %}
考虑按b的升序枚举，找a的个数，但是不太好维护a

是否可以考虑dp？
{% endfold %}

{% fold solution 2 %}
如果已经确定了b的上下界，给定固定的值 $\Delta l$ 和若干个 $a_i$，如何确定最多的个数？

$dp_i$ 表示拿 $i$ 个 $a_i$ 的最小总和，拿到一个 $a_i$ 显然可以更新一遍 $dp_i$:

$i = n\to 1, dp_i=min(dp_i, dp_{i-1}+a)$

回过来考虑 $b$ 的影响，和 $l$ 比较之后更新答案，同时特判只有1个的情况。
{% endfold %}

{% fold code %}
```cpp
#include <bits/stdc++.h>
void solve(){
  int n, l;
  std::cin >> n >> l;
  std::vector<int> a(n), b(n), p(n);
  for (int i = 0; i < n; ++i)
    std::cin >> a[i] >> b[i];
  std::iota(p.begin(), p.end(), 0);
  std::sort(p.begin(), p.end(), [&](int i, int j) { return b[i] < b[j]; });
  std::vector<long long> dp(n + 1, 1e18);
  int ans = 0;
  for (auto i : p) {
    for (int j = n - 1; j >= 1; --j) {
      dp[j + 1] = std::min(dp[j + 1], dp[j] + a[i]);
      if (dp[j] + a[i] + b[i] <= l)
        ans = std::max(ans, j + 1);
    }
    dp[1] = std::min(dp[1], 1ll * a[i] - b[i]);
    if (a[i] <= l)
      ans = std::max(ans, 1);
  }
  std::cout << ans << '\n';
}
int main() {
  int tt;
  std::cin >> tt;
  while (tt--) {
    solve();
  }
  return 0;
}
```
{% endfold %}

D. Exam in MAC
==============

给定一个 $N \leq 3\times 10^5$ 个元素的集合 $s$，和一个数字 $c \leq 10^9$，问能有多少对 $(x,y)$ 满足 $0\leq x\leq y\leq c$，并且 $x+y$ 和 $y-x$ 都不在集合 $s$ 中。

{% fold solution %}
正难则反，考虑枚举不合法的方案数量，即 [$x+y$ 在集合中的数量 $t_1$] + [$y-x$ 在集合中的数量 $t_2$] - [两者都在集合中的数量 $t_3$]

前两者都十分好求，而对于 $t_3$，令 $x+y=g, y-x=h$，可以发现 $g\equiv h(\mod 2)，且h\leq y$
{% endfold %}

{% fold code %}
```cpp
#include <bits/stdc++.h>
using namespace std;
using i64 = long long;
void solve() {
  int n, c;
  cin >> n >> c;
  i64 total = 1ll * (c + 1) * (c + 2) / 2;
  vector<int> a(n);
  for (int i = 0; i < n; ++i) cin >> a[i];
  for (auto ai : a) total -= 1ll * ai / 2 + 1, total -= c - ai + 1;
  int cnt[2] = {0, 0};
  for (auto ai : a) {
    cnt[ai % 2]++;
    total += cnt[ai % 2];
  }
  cout << total << '\n';
}
int main() {
  int tt;
  cin >> tt;
  while (tt--)
    solve();
  return 0;
}
```
{% endfold %}

E. Distance Learning Courses in MAC
===================================

给定 $n$ 和 $n$ 个区间 $[x, y]$，$n$ 个数范围限定在对应区间中。

$q$ 次询问，$[l, r]$ 表示第 $l$ 个数一直到第 $r$ 按位或，求最大值。

$n,q\leq 2\times 10^5, 0\leq x_i, y_i\leq 2^{30}, 1\leq l_i\leq r_i\leq n$

{% fold solution %}
{% endfold %}
