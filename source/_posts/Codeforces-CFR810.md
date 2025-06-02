---
title: Codeforces Round 810 (Div. 2)
date: 2022.7.24
tags: 
  - Codeforces
---

同一场的div. 1 E弄出了个原题... 轩然大波..

<!-- more -->

## [C. Color the Picture](https://codeforces.com/contest/1711/problem/C)

手玩一下会发现这个条件十分苛刻，要求在第1行和第n行相连，第1列和第n列相邻的情况每个点都有至少三个邻格颜色相同，其实填法就只能是用

* 整一行同色，$n*k(k\geq 2)$ 的颜色块拼接起来
* 整一列同色，$k*m(k\geq 2)$ 的颜色块拼接起来

然后就是考虑奇数的情况就好了，这里我不知道因为什么原因写挂了，大概是算一个颜色块的时候直接按 $\div2n$ 的数量统计，取整可能会导致一些问题..

事实上是判断行数够不够，然后特判一下有没有3行\列的数量来满足奇数

傻呗写法卡了8发，无语了

```cpp
#include <bits/stdc++.h>

using ll = long long;

void solve() {
  int n, m, k;
  std::cin >> n >> m >> k;
  std::vector<int> a(k);
  for (int &x : a)
    std::cin >> x;
  auto check = [&](int x, int y) -> bool {
    ll cnt = 0;
    bool ok = false;
    for (auto xx : a) {
      int now = xx / x;
      if (now >= 2)
        cnt += 1ll * now;
      if (now >= 3)
        ok = true;
    }
    if (cnt < 1ll * y)
      return false;
    if (y % 2 && !ok)
      return false;
    return true;
  };
  if (check(n, m) || check(m, n))
    puts("Yes");
  else
    puts("No");
}

int main() {
  std::cin.tie(nullptr)->sync_with_stdio(false);
  int tt;
  std::cin >> tt;

  while (tt--) {
    solve();
  }
  return 0;
}
```

## [D. Rain](https://codeforces.com/contest/1711/problem/D)

对于一个 $(x_i,p_i)$，希望 $a\left[x_i-p_i+1,x_i\right]$ 按位分别加上 $\left[1,p_i\right]$， $a\left[x_i,x_i+p_i-1\right]$ 按位分别加上 $\left[p_i,1\right]$，然后 $a[x_i]-=p_i$，这是一段修改

给定 $n$ 和 $m$，以及 $n$ 段修改信息 $(x_i,p_i)$，对于每段修改信息，我们想知道删除它之后，别的加在一起，是否有 $a[j] > m$ 的情况

### sol1

看到一个[非常妙的做法](https://www.blog-e.tk/2022/07/27/%E9%A2%98%E8%A7%A3-CF1710B-Rain/)，比线段树这种暴力不知道高到哪里去了

可知最大值只会出现在 $x_i$ 的位置上

用两次差分和前缀和计算出所有的 $a_{x_i}$

考虑每个大于 $m$ 的 $a_j$，第 $i$ 个消除能令它合法仅当 $p_i-|x_i-j|\geq a_j-m$

移项，即 $p_i+m-|x_i-j|\geq a_j$

也就是对于下完雨的整个 $\{a_j\}$，考虑 $a_j>m$ 的时候，要求这样的 $a_j$ 都在蓝色区域内，这样消除第 $i$ 块的影响时，才会满足条件

![](/images/801_1.png)

然后反过来，对于 $a_j>m$，需要 $p_i+m$ 满足对应的性质，才能够把所有的非法变成合法

![](/images/801_2.png)

如果 $(x_i,p_i+m)$ 在红色区域内，就能修改 $a_j$，取一个红色区域并，可以**用两个函数的截距取最值**的方法来维护

这一步太蟀了..

```cpp
#include <bits/stdc++.h>
using namespace std;
using ll = long long;

int main() {
  ios_base::sync_with_stdio(false);
  cin.tie(nullptr);
  int tt;
  cin >> tt;
  while (tt--) {
    int n, m;
    cin >> n >> m;
    vector<ll> x(n), p(n);
    map<ll, ll> mp;
    for (int i = 0; i < n; ++i) {
      cin >> x[i] >> p[i];
      mp[x[i]-p[i]+1]++;
      mp[x[i]+1]-=2ll;
      mp[x[i]+p[i]+1]++;
    }
    ll a=0ll, k=0ll, las=INT_MIN;
    ll _b=INT_MIN,b=INT_MIN;
    for (auto &[X, K]:mp) {
      a += k * (X-las);
      k+=K;
      if(a>m){
        b=max(b,a-X+1); // 斜率为1的截距
        _b=max(_b,a+X-1); // -1的截距
      }
      las = X;
    }
    for(int i=0;i<n;++i)
      cout<<((p[i]+m-x[i]>=b)&&(p[i]+m+x[i]>=_b));
    cout<<'\n';
  }
  return 0;
}
```

### sol2

看的知乎上，cup-pyy和ygg，两人算是写清楚的了(maybe)，但是一大坨文字让我绝望

线段树维护差分，看半天没看懂，不想搞了 ~~(太长了懒得看)~~

貌似还是斜率截距什么在搞，那不是 $O(n)$ 扫一遍就好了 ~~，线段树用魔怔了的感觉..~~ 也没有动态修改

不清楚了，反正赛时能过就是爹

### sol3

还有一种是分类讨论

对于 $j<x_i$，有 $a_j-(p_i-|x_i-j|)\leq m \iff a_j-j-m\leq p_i-x_i$

然后正序扫一遍，维护一个最大值，对于满足条件的x，左半边都成立了

对于 $a_j+j-m\leq p_i+x_i$，倒过来也是一样

代码可以参考[Jiangly的submission](https://codeforces.com/contest/1710/submission/165550188)

唯一 $O(nlogn)$ 的地方是离散化

CF评论区好像有关于线段树做法的阐释，自称是 incredibly ugly way using segment Tree，但看起来还是蛮清楚的，，懒得研究了

