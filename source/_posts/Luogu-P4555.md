---
title: 洛谷P4555 [国家集训队] 最长双回文串
tags:
    - Manacher
date: 2023-04-21
---

[传送门](https://www.luogu.com.cn/problem/P4555), manacher板子题

<!-- more -->

# Manacher解法

如果你还不会manacher请看[这里](http://syh521.cn/2022/02/10/Algorithm-string-basic/#Manacher)

考虑遍历所有这样的形式，$l_i$表示$i$为结尾的最长的回文串长度,$r_i$表示$i$为开头的...

至于怎么得到呢？显然我们每次更新$d_1[i],d_2[i]$的时候，都可以更新一些$l_i,r_i$

如何得到剩下的$l_i,r_i$？只要用已有的最大值递推即可，从结尾往回推，$l_i=\max{(l_{i+2}-2,l_i)}$

同理$r_i=\max{(r_{i-2}-2,r_i)}$

枚举一个$l_i+r_{i+1}$，完了

```cpp
#include <bits/stdc++.h>
using namespace std;
int main() {
  string s;
  cin >> s;
  int n = s.size();
  vector<int> d1(n), d2(n);
  vector<int> ll(n, 1), rr(n, 1);
  for (int i = 0, l = 1, r = -1; i < n; ++i) {
    int k = (i > r) ? 1 : min(d1[r + l - i], r - i + 1);
    while (0 <= i - k && i + k < n && s[i - k] == s[i + k])
      ++k;
    d1[i] = k--;
    rr[i - k] = max(rr[i - k], k * 2 + 1);
    ll[i + k] = max(ll[i + k], k * 2 + 1);
    if (i + k > r)
      l = i - k, r = i + k;
  }
  for (int i = 0, l = 1, r = -1; i < n; ++i) {
    int k = (i > r) ? 0 : min(d2[l + r - i + 1], r - i + 1);
    while (0 <= i - k - 1 && i + k < n && s[i - k - 1] == s[i + k])
      ++k;
    d2[i] = k--;
    ll[i + k] = max(ll[i + k], d2[i] * 2);
    rr[i - k - 1] = max(rr[i - k - 1], d2[i] * 2);
    if (i + k > r)
      l = i - k - 1, r = i + k;
  }
  int ans = 0;
  for (int i = 1; i < n; ++i)
    rr[i] = max(rr[i], rr[i - 1] - 2);
  for (int i = n - 2; i >= 0; --i)
    ll[i] = max(ll[i], ll[i + 1] - 2);
  for (int i = 0; i + 1 < n; ++i)
    ans = max(ll[i] + rr[i + 1], ans);
  cout << ans;
  return 0;
}
```

----

## PAM解法 

咕咕了，还没学回文自动只因
