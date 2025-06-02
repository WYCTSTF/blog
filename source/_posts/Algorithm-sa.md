---
title: 后缀数组(SA) 学习笔记
tags:
  - SA
  - 算法模板
date: 2023-3-22
---

天梯赛校赛碰到的 本以为切个水题 没想到捅了老挝

甚至还有n,q=10w的区间众数 2333 就是数据比较水 感觉严一点分块都不一定能过

原题貌似是[这个](https://www.acwing.com/problem/content/1405/) 但是他妈的校赛n改到了2w

一开始感觉是差分+lcs或kmp之类的 然后感觉不太对劲...

还是需要一些处理字符串的手段 于是学一下SA和SAM 已经拖了挺久了...

<!-- more -->

前面的定义和求解过程理解移步[oi-wiki](https://oi-wiki.org/string/sa/#onlogn-%E5%81%9A%E6%B3%95)即可

那上面有图解，看的更清楚

## 定义

对于一长为$n$的字符串 $s$ 即$s[1-n]$ 令$suf[i]=s[i-n]$ 称为后缀$i$

将$s$的$n$个后缀排序

* $sa[i]$表示第$i$小的后缀的编号 即$suf[sa[i]]$是第$i$小的后缀
* $rk[i]$表示后缀$i$的排名

即$sa[rk[i]]==rk[sa[i]]=i$

## 求后缀数组

$O(n^2logn)$求法很显然。直接暴力排序就行了

考虑两个连续长为1的子串 即$s[i]$和$s[i+1]$的排名$rk_0[i]$和$rk_0[i+1]$作为两个关键字

能够得到所有长为2的子串的$sa_1[i]$ 通过$sa_1[i]$得到$rk_1[i]$ 然后再求$sa_2[i]$

以此类推得到$sa_w[i]$表示子串$s[i\to i+2^w-1]$的后缀数组

整个过程就是用$s[i\to i+2^j-1]$的子串排名即$rk$数组去求解 $s[i\to i+2^{j+1}-1]$的子串的后缀数组$sa$

能够倍增的原因就是因为连续的字符串排字典序 前面优先级大于后面 折半做就很显然

当$2^w\geq n$时即为整个串的后缀数组

```cpp
#include <bits/stdc++.h>
using namespace std;
int main() {
  string s;
  cin >> s;
  int n = s.size();
  s = '$' + s;
  vector<int> sa(n + 1), rk(n + 1 << 1), ork(n + 1 << 1);
  for (int i = 1; i <= n; ++i)
    sa[i] = i, rk[i] = s[i];
  for (int w = 1; w < n; w <<= 1) {
    sort(sa.begin() + 1, sa.end(), [&](int x, int y) {
      return rk[x] == rk[y] ? rk[x + w] < rk[y + w] : rk[x] < rk[y];
    });
    ork = rk;
    for (int p = 0, i = 1; i <= n; ++i)
      if (ork[sa[i]] == ork[sa[i - 1]] && ork[sa[i] + w] == ork[sa[i - 1] + w])
        rk[sa[i]] = p;
      else
        rk[sa[i]] = ++p;
  }
  for (int i = 1; i <= n; ++i)
    cout << sa[i] << " \n"[i == n];
  return 0;
}
```

倍增+sort 中间还有个更新操作 就是$O(nlogn+n)=O(nlogn)$的复杂度

呃呃 然后按理说$O(nlog_nlog_n)$是过不去的 但是C++17开了O2居然就直接过了... 过了...

[submission](https://loj.ac/s/1739917)

但是语言与时俱进的同时 丧心病狂的出题人肯定也会与时俱进 所以我们还是要学习标准算法的 233

-----------

## 复杂度降到 $O(NlogN)$

计数排序和基数排序 OI-wiki随便看下就好了 没有什么难度

如何快速理解计数排序？

某种意义上可以当成桶排来理解

```cpp
const int N = 100010;
const int W = 100010;

int n, w, a[N], cnt[W], b[N];

void counting_sort() {
    memset(cnt, 0, sizeof(cnt));
    for (int i = 1; i <= n; ++i) ++cnt[a[i]];
    for (int i = 1; i <= w; ++i) cnt[i] += cnt[i - 1];
    for (int i = n; i >= 1; --i) b[cnt[a[i]]--] = a[i];
}
```

如何快速理解基数排序？

多关键字排序，每个关键字可以选择一个合适的方法（一般是计数排序）排完之后保证稳定性，然后排下一个关键字

基于计数排序实现的基数排序可以理解成桶排的桶排

基于这个理念，我们依赖O(n)的辅助存储空间代替sort的比较

```cpp
#include <bits/stdc++.h>
using namespace std;
int main() {
  string s;
  cin >> s;
  int n = s.size();
  s = '$' + s;
  int m = 127;
  vector<int> sa(n + 1), rk((n + 1) << 1), cnt(m + 1);
  for (int i = 1; i <= n; ++i)
    ++cnt[rk[i] = s[i]];
  for (int i = 1; i <= m; ++i)
    cnt[i] += cnt[i - 1];
  for (int i = n; i >= 1; --i)
    sa[cnt[rk[i]]--] = i;
  auto _rk = rk;
  for (int p = 0, i = 1; i <= n; ++i)
    if (_rk[sa[i]] == _rk[sa[i - 1]])
      rk[sa[i]] = p;
    else
      rk[sa[i]] = ++p;
  m = n;
  cnt.resize(m + 1);
  for (int w = 1; w < n; w <<= 1) {
    fill(cnt.begin(), cnt.end(), 0);
    auto _sa = sa;
    for (int i = 1; i <= n; ++i)
      ++cnt[rk[_sa[i] + w]];
    for (int i = 1; i <= m; ++i)
      cnt[i] += cnt[i - 1];
    for (int i = n; i >= 1; --i)
      sa[cnt[rk[_sa[i] + w]]--] = _sa[i];

    fill(cnt.begin(), cnt.end(), 0);
    _sa = sa;
    for (int i = 1; i <= n; ++i)
      ++cnt[rk[_sa[i]]];
    for (int i = 1; i <= m; ++i)
      cnt[i] += cnt[i - 1];
    for (int i = n; i >= 1; --i)
      sa[cnt[rk[_sa[i]]]--] = _sa[i];
    
    _rk = rk;
    for (int p = 0, i = 1; i <= n; ++i)
      if (_rk[sa[i]] == _rk[sa[i - 1]] && _rk[sa[i] + w] == _rk[sa[i - 1] + w])
        rk[sa[i]] = p;
      else
        rk[sa[i]] = ++p;
  }
  for (int i = 1; i <= n; ++i)
    cout << sa[i] << " \n"[i == n];
  return 0;
}
```

OI-wiki上还有一些常数优化内容 我懒得研究了ToT..

然后就是看 SA-IS 和 DC3

