---
title: Atcoder Beginner Contest 242
tags: 
	- Atcoder
	- DP
description: At的规律题还是一如既往的让人头疼..
date: 2022.3.6
---

## C - 1111gal password

一开始以为有什么数学规律 然后我发现样例那个2 25我就推不出来(太笨了)

于是就直接递推了 这个空间浪费了很多

其实只要开两个 vector\<int\>(10)就够了..
{%fold code%}
```cpp
#include <bits/stdc++.h>
#define int long long
using namespace std;
int dp[1000010][10];
const int MOD = 998244353;
signed main() {
  int n; std::cin >> n;
  for (int i = 1; i <= 9; i++)
    dp[1][i] = 1;
  for (int i = 2; i <= n; i++) {
    for (int j = 1; j <= 9; j++) {
      for (int it : {-1, 0, 1}) {
        int now = j - it;
        if (now <= 9 && now >= 1) {
          dp[i][j] = (dp[i][j] + dp[i-1][now]) % MOD;
        }
      }
    }
  }
  int ans = 0;
  for (int i = 1; i <= 9; i++) {
    ans = (ans + dp[n][i]) % MOD;
  }
  cout << ans << endl;
  return 0;
}
```
{%endfold%}
### D - ABC Transform

给定一个初始的字符串s 由'A', 'B', 'C'构成

给定q个询问 每个询问有一个t, k ($t\in [0, 10^{18}],k \in [1,10^{18}]$)

问的是t次变换后 从初始的$S^0$即$S$ 变换到$S^t$之后	第k位字符是什么

变换规则

	A->BC B->CA C->AB

设f(t, k)是对应的字母

这里我们从0开始下标计数

t=0的时 答案就是s[k]了

k=0时 $S^t$的第0位是$S^0$的第一位经过了t次变换后得到的字母

当$t, k > 0$时 f(t, k) 是 f(t-1, k/2)对应的变换字母 如果k是偶数 那么变换为第一个字母 如果是奇数 变换为第二个字母
{%fold code%}
```cpp
#include <bits/stdc++.h>

using ll = long long;

int main() {
  char S[101000]; scanf("%s", S);
  int Q; scanf("%d", &Q);
  
  auto g = [&](char s, ll add) {
    return char('A' + (s - 'A' + add) % 3);
  };

  auto get = [&](auto self, ll t, ll k) {
    if (t == 0) return S[k];
    if (k == 0) return g(S[0], t);
    return g(self(self, t - 1, k / 2), k % 2 + 1);
  };

  while (Q--) {
    ll t, k; scanf("%lld%lld", &t, &k);
    std::cout << get(get, t, k - 1) << std::endl;
  }

  return 0;
}
```
{%endfold%}
