---
title: 牛客挑战赛 62
date: 2022-07-17
---

什么都不会，每天只能贺代码混混日子

C D E F 从过题人数上来看就很不可做、

等CF的一些题写完了再回来补

<!-- more -->

# [A. Pair](https://ac.nowcoder.com/acm/contest/11202/A)

对于两个数，我们只需考虑它的最高位，就是从左往右第一个1的位置

如果位数相同，那么这两个是好的，如果位数不相同，则不满足条件

那么用2的次幂把给定的数字划分一下就好了

{% fold code %}

```cpp
#include <bits/stdc++.h>

using ll = long long;

int main() {
  int n;
  std::cin >> n;
  std::vector<int> a(n);
  std::vector<std::vector<int>> tot(33);
  for (int i = 0; i < n; ++i)
    std::cin >> a[i];
  std::sort(a.begin(), a.end());
  int tag=0;
  for (auto it:a) {
    while ((1<<(tag+1))<=it) tag++;
    if ((1<<tag) <= it && (1 << (tag + 1)) - 1 >= it)
      tot[tag].push_back(it);
  }
  ll ans = 0;
  for (auto iter:tot){
    ans += 1ll * iter.size() * (iter.size()-1ll) / 2;
  }
  std::cout << ans << '\n';
  return 0;
}
```
{% endfold %}

----

# [B. 置换](https://ac.nowcoder.com/acm/contest/11202/B)

对着错误的题意一厢情愿嗯搞半天，中间还差点把xy绕晕了，说多了都是泪、、

其实就是求个环，然后确保每个环转的圈数合法就行，我弄了个倍增写了一会儿，配合错误的理解死活过不去

其实题目说的很清楚了，一个置换就是一个函数，每次把$i$改为对应的$F_i$，然后$k$次幂就是函数的$k$次复合

后来发现第一次的理解是对的，但是判断的条件写错了，我想的是先给一个位置暴力找到转的圈数，剩下的倍增跳一跳，判断是否符合，问题就在于，暴力判转的圈数不是直接和b对上就行，因为对上的情况有很多种、、

然后就是改vector来写了..

{% fold code %}
```cpp
#include <bits/stdc++.h>
using namespace std;

template <typename T> T gcd(T a, T b) { return b ? gcd(b, a % b) : a; }

int main() {
  int tt;
  cin >> tt;
  while (tt--) {
    int n;
    cin >> n;

    std::vector<int> a(n + 1), b(n + 1);

    for (int i = 1; i <= n; ++i)
      cin >> a[i];
    for (int i = 1; i <= n; ++i)
      cin >> b[i];

    bitset<100010> vis;
    vis.reset();

    vector<int> ve(n + 1), id(n + 1), ring(n + 1), len(n + 1);

    for (int i = 1, G = 0; i <= n; ++i) {
      int now = i;
      if (!vis[i]) {
        int c = 0;
        ring[++G] = i; // 环 G 的起点 i
        while (!vis[now]) {
          vis[now] = 1;
          ve[now] = G;
          id[now] = c++;
          now = a[now];
        }
        len[G] = c;
      }
    }

    bool ok = true;
    for (int i = 1; i <= n; ++i) {
      if (ve[a[i]] != ve[b[i]]) {
        ok = false;
        break;
      }
    }
    if (!ok) {
      puts("No");
      continue;
    }

    std::vector<int> md(n + 1, -1);
    for (int i = 1; i <= n; ++i) {
      int L = len[ve[b[i]]];
      int d = (id[b[i]] + L - id[a[i]]) % L;
      if (md[L] != -1)
        ok &= (md[L] == d);
      else
        md[L] = d;
    }

    if (!ok) {
      puts("No");
      continue;
    }

    vector<int> vec;
    for (int i = 1; i <= n; ++i)
      if (md[i] != -1)
        vec.push_back(i);

    auto check = [&](int x, int y, int z, int w) -> bool {
      int _gcd = gcd(x, z);
      if (y % _gcd != w % _gcd)
        return false;
      return true;
    };

    for (int i : vec)
      for (int j : vec) // 枚举所有环的长度，和该长度的环转的次数
        ok &= check(i, md[i], j, md[j]);

    puts(ok ? "Yes" : "No");
  }
  return 0;
}
```
{% endfold %}
