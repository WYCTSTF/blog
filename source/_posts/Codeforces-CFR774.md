---
title: Codeforces Round 774 (Div. 2)「C - E」
tags: 
	- 树形DP
	- DFS
	- 位运算
	- Codeforces
description: 好久没做CF了 要加练
date: 2022-03-06
---

## C. Factorials and Powers of Two

加数算上阶乘和 $2$ 的次幂 一共好像有52个左右

我想到了之前搜索做的那个scales s 就直接搜索剪了个枝交了

完事之后看了知乎发现别人的正解并不是这个.. 是我笨比了..

从大到小拿我能理解 这个前缀和一剪枝就跑的飞快我到现在都觉得好玄学
```cpp
#include <bits/stdc++.h>

int main() {
  int tt, ans; std::cin >> tt;
  long long n;
  std::set <long long> s;
  std::vector <long long> frac;
  long long sum = 1, tot = 2;
  do {
    s.insert(sum);
    sum *= tot++;
  } while (sum <= 1e12);
  sum = 1;
  do {
    s.insert(sum);
    sum *= 2;
  } while (sum <= 1e12);

  frac.push_back(0);
  for (auto it : s)
    frac.push_back(it);

  std::vector <long long> count(60, 0);
  for (int i = 1; i < frac.size(); i++)
    count[i] = count[i-1] + frac[i];

  auto dfs = [&](auto self, int now, long long tem, int cnt) -> void {
    if (tem > n) return;
    if (cnt > ans) return;
    if (tem == n) ans = std::min(cnt, ans);
    if (tem + count[now - 1] < n) return;
    for (int i = now - 1; i >= 1; i--) {
      self(self, i, tem + frac[i], cnt + 1);
    }
  };
  while (tt--) {
    ans = INT_MAX;
    std::cin >> n;
    dfs(dfs, frac.size(), 0ll, 0);
    if (ans == INT_MAX)
      puts("-1");
    else
      std::cout << ans << std::endl;
  }
  return 0;
}
```

官方题解的思路还是非常老套的从二进制位上考虑

emmm 快速看了一下 大致思路是 枚举15个阶乘数的选取情况

剩下的位数用2的次幂不上 最后一个二进制下等于n 感觉也不是很妙..

他们怎么都想到这么做了..
```cpp
#include <bits/stdc++.h>

int main() {
  int tt; std::cin >> tt;
  long long fac[15], t = 1;
  for (int i = 1; i <= 15; i++) t *= i, fac[i-1] = t;
  while (tt--) {
    long long n; std::cin >> n;
    
    int ans = 100;

    for (int i = 0; i < pow(2, 15); ++i) {
      std::bitset<15>b(i);
      long long t = n;
      for (int j = 0; j < 15; j++) t -= b[j] * fac[j];
      if (t >= 0) {
        std::bitset <64> b1(t);
        ans = std::min(ans, (int)(b.count() + b1.count()));
      }
    }
    std::cout << ans << '\n';
  }
  return 0;
}
```
这个感觉蟀是蟀了一点 但是速度(109ms)没有我的剪枝dfs(31ms)快就很 emmm

可能是因为选数的时候 $t[i] + t[i + 1] <= t[i + 2]$ 这个性质比较玄学吧

而且我把判断放到循环里 直接快进到15ms

```cpp
auto dfs = [&](auto self, int now, long long tem, int cnt) -> void {
    if (tem > n) return;
    if (cnt > ans) return;
    if (tem == n) ans = std::min(cnt, ans);
    // if (tem + count[now - 1] < n) return;
    for (int i = now - 1; i >= 1; i--) {
      if (tem + count[i] < n) return;
      self(self, i, tem + frac[i], cnt + 1);
    }
  };
```

-----

D E比赛的时候都没有做出来 就只有一点点思路

看了之后确实 E 比 D 简单

## D. Weight the Tree

D 实在没想法去看题解 然后说是树形DP 我就想着先复习一下树形DP 看能不能把这题做了

结果普通的树形DP 就那个[没有上司的舞会](https://www.luogu.com.cn/problem/P1352)这一题

感觉这个方程也特别的 emm 能表示很多东西吧

就是设一个dp[i] [0 / 1]表示以 $i$ 为节点的子树 在 $i$ 拿或不拿的时候能取到的最大值

方成很好搞 令$v$是$u$的子节点 e[u]是点$u$的子节点集合

$$dp[u][1] = \sum_{v \in e[u]}^{}{dp[v][0]}$$

$$dp[u][0] = \sum_{v \in e[u]}^{}{max(dp[v][0], dp[v][1])}$$

正常的dfs即可 或者有了拓扑序之后从下往上 O(n)

放到这题里面也是一样 我们设置$good vertex$的时候

除了n=2是一种特殊情况 剩下的就是设置了好点之后 相邻的点就不能设置好点

发现那些不能设置好点的地方权值可以统一成1

好点$u$权值固定为e[u].size()

乐！
```cpp
#include <bits/stdc++.h>

int main() {
  int n;
  std::cin >> n;
  std::vector <int> dp[2];
  std::vector <int> w[2];
  std::vector <int> val(n + 1);
  std::vector <std::vector<int>> e(n + 1);
  dp[0].resize(n + 1, 0), dp[1].resize(n + 1, 0);
  w[1].resize(n + 1, 0), w[0].resize(n + 1, 0);

  auto dfs = [&](auto self, int u, int fa) -> void {
    dp[0][u] = 0, dp[1][u] = 1;
    w[0][u] = 1, w[1][u] = e[u].size();
    for (auto v : e[u]) {
      if (v == fa) continue;
      self(self, v, u);

      dp[1][u] += dp[0][v], w[1][u] += w[0][v];

      if (dp[0][v] > dp[1][v] || (dp[0][v] == dp[1][v] && w[0][v] < w[1][v])) {
        dp[0][u] += dp[0][v];
        w[0][u] += w[0][v];
      } else {
        dp[0][u] += dp[1][v];
        w[0][u] += w[1][v];
      }
    }
  };

  auto tot = [&](auto self, int u, int fa, int op) -> void {
    if (op == 1)
      val[u] = e[u].size();
    else
      val[u] = 1;
    for (auto v : e[u]) {
      if (v == fa) continue;
      if (op == 1) {
        self(self, v, u, 0);
      } else {
        if (dp[0][v] > dp[1][v] || (dp[0][v] == dp[1][v] && w[0][v] < w[1][v]))
          self(self, v, u, 0);
        else
          self(self, v, u, 1);
      }
    }

  };

  for (int i = 1; i < n; i++) {
    int u, v; std::cin >> u >> v;
    e[u].push_back(v), e[v].push_back(u);
  }
  if (n == 2) {
    puts("2 2\n1 1");
    return 0;
  }
  dfs(dfs, 1, 0);
  // 随便定一个根 rt = 1
  if (dp[0][1] > dp[1][1] || (dp[0][1] == dp[1][1] && w[0][1] < w[1][1])) {
    std::cout << dp[0][1] << ' ' << w[0][1] << '\n';
    tot(tot, 1, 0, 0);
  } else {
    std::cout << dp[1][1] << ' ' << w[1][1] << '\n';
    tot(tot, 1, 0, 1);
  }
  for (int i = 1; i <= n; i++)
    std::cout << val[i] << ' ';
  return 0;
}
```
## E. Power Board

观察2的次幂

2的时候 m列会产生m个数 $2^{1 * 1},2^{1 * 2},\dots,2^{1 * m}$

对于 $4 =2 ^ 2$ 同样有 $2^{2 * 1},2^{2 * 2},\dots,2^{2 * m}$

那么预处理一下1-n次幂产生的不同数量 然后依次考虑每个数字 就好了
```cpp
#include <bits/stdc++.h>

signed main() {
  long long n, m;
  std::cin >> n >> m;
  std::vector frac(23, 0ll);
  std::bitset <20*1000000> vis;
  std::bitset <1000000> num;
  
  int cnt = 0;

  for (int i = 1; i <= 20; i++) {
    for (int j = 1; j <= m; j++) {
      if (vis[i * j] == 0) cnt++;
      vis[i * j] = 1;
    }
    frac[i] = cnt;
  }
  long long ans = 1;

  for (int i = 2; i <= n; i++) {
    if (num[i]) continue;
    long long j = 1, now = i;
    while (now <= n) {
      num[now] = 1;
      j++, now *= i;
    }
    j--;
    ans += frac[j];
  }
  std::cout << ans << '\n';
  return 0;
}
```
F咕了.. 不想看
