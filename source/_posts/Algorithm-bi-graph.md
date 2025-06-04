---
title: 二分图 & 网络流整理
tags: 
	- 二分图
	- 算法模板
date: 2022-10-11
---

复习一下以前草草略过的知识，再学一下同样很重要的网络流..

<!-- more -->

## 二分图判定

如果节点能分为两个集合，一个集合内的节点没有连边，则构成二分图

**染色法判定**

不存在奇环的图肯定是二分图

```cpp
const int N = 1000010;
int n, m, v[N];
vector<int> e[N];

bool dfs(int u, int c) {
  v[u] = c;
  for (int v : e[u]) {
    if (v[v] == c)
      return false;
    if (!v[v] && !dfs(v, 3 - c))
      return false;
  }
  return true;
}
int main() {
  // 读入忽略
  for (int i = 1; i <= n; ++i) {
    if (!v[i] && !dfs(i, 1)) {
      cout << "No\n";
      return 0;
    }
  }
  cout << "Yes\n";
  return 0;
}
```

### 例题 [[NOIP2010 提高组] 关押罪犯](https://www.luogu.com.cn/problem/P1525)

这题我居然没用并查集写过...

刚好补上，反正扩展域和边带权可以看成一个东西

用二分图来看，可以视为，取一个最小的 $k$，保留 $>k$ 的边，剩下的图是否构成一个二分图

二分答案即可

不过要注意一个只有一条边的corner case，因为我一直搞不清二分最后的边界，就索性让low++ --，但是这里会有一个限制，要特判


```cpp
const int N = 20010;

vector<pair<int, int>> e[N];
int n, m, col[N];

bool dfs(int u, int c, int k) {
  col[u] = c;
  for (auto &[v, w] : e[u]) {
    if (w <= k)
      continue;
    if (col[v] == c)
      return false;
    if (!col[v] && !dfs(v, 3 - c, k))
      return false;
  }
  return true;
}

int main() {
  ios_base::sync_with_stdio(false);
  cin.tie(nullptr);
  cin >> n >> m;
  int low = -1;
  int high = INT_MAX;
  for (int i = 1; i <= m; ++i) {
    int u, v, w;
    cin >> u >> v >> w;

    e[u].pb({v, w});
    e[v].pb({u, w});
  }

  auto check = [&](int k) {
    fill(col, col + N, 0);
    bool flag = true;
    for (int i = 1; i <= n; ++i) {
      if (!col[i] && !dfs(i, 1, k)) {
        flag = false;
        break;
      }
    }
    return flag;
  };
  
  while (low < high) {
    // cerr << "fuck" << '\n';
    int mid = (low + high) / 2;
    if (check(mid))
      high = mid - 1;
    else
      low = mid + 1;
  }
  while (!check(low))
    low++;
  while (check(low) && low >= 0)
    low--;
  cout << low + 1 << '\n';
  return 0;
}
```

## 二分图最大匹配

每个点至多被一条边覆盖，从二分图中选出最多的边，称为二分图最大匹配

对应概念：

匹配：一些边的集合，任意两条边没有公共顶点

匹配点，非匹配点，匹配边，非匹配边

匹配点也叫盖点

最大匹配：边数最多 ｜ 完美匹配：所有点都是匹配点

### 匈牙利算法

对于一条路径，若两端是非匹配点，非匹配边和匹配边在路径上交替出现，则该路径为该匹配的增广路

考虑当前匹配 $P$ 和最大匹配 $M$，考虑一种： **$M$ 中两端是匹配点，同时 $P$ 中两端是非匹配点的边**，这些边显然可以直接加入到 $P$ 中，得到 $Q$

**那么 $M$ 中任意的匹配边在 $Q$ 中都会覆盖某个匹配点**

如果此时 $Q$ 还不是 $M$，说明我们可以通过变换已有匹配点连接的匹配边去增加新的覆盖点，以达到最大匹配

考虑边集 $X=M-M\bigcap Q$和 $Y=Q-M\bigcap Q$，这个比较抽象，例子也不太好举..

![](/images/bi-graph-1.png)

以上图为例，最大匹配显然是 `1-6,2-5,3-4`，当 $Q$ 为 `6-1,5-3` 时，考虑 `X=2-5,3-4`, `Y=3-5` 这就构成了一条交错的路径

归纳之后能够发现会构成 $X-Y-X-...-X-Y-X$ 的交错路径，对于 $Q$ 来说就是增广路，因此不断将匹配边和非匹配边调换，不断扩展，因为任意非最大匹配的匹配一定存在增广路，且已经进入匹配的点不会退出匹配

这个分类讨论之后不难归纳

```cpp
const int N = 1010;
const int R = 510; // 右部节点数

vector<int> adj[N];
int f[R]; // 右部匹配的左部点
set<int> l;
bitset<N> vis;

bool dfs(int u) { // 从左部的节点开始搜
  for (auto v : adj[u]) {
    if (vis[v])
      continue;
    if (!f[v] || dfs(f[v])) { // 如果能够u v直连或者另一端也扩展,进行增广
      f[v] = u;
      return true;
    }
  }
  return false;
}

int maxMatch(int n, int m) {
  fill(f, f + R, 0);
  int ret = 0;
  for (auto i : l) {
    vis.reset();
    if (dfs(i)) {
      ret++;
    }
  }
  return ret;
}
```

### [模板] [二分图最大匹配](https://www.luogu.com.cn/problem/P3386)

```cpp
#include <bits/stdc++.h>
using namespace std;

const int N = 1010;
const int R = 510; // 右部节点数

vector<int> adj[N];
int f[R]; // 右部匹配的左部点
set<int> l;
bitset<N> vis;

bool dfs(int u) { // 从左部的节点开始搜
  for (auto v : adj[u]) {
    if (vis[v])
      continue;
    vis[v] = true;
    if (!f[v] || dfs(f[v])) { // 如果能够u v直连或者另一端也扩展,进行增广
      f[v] = u;
      return true;
    }
  }
  return false;
}

int maxMatch(int n, int m) {
  fill(f, f + R, 0);
  int ret = 0;
  for (auto i : l) {
    vis.reset();
    if (dfs(i)) {
      ret++;
    }
  }
  return ret;
}

int main() {
  int n, m, e;
  cin >> n >> m >> e;
  for (int i = 1; i <= e; ++i) {
    int u, v;
    cin >> u >> v;
    l.insert(u);
    adj[u].push_back(v);
  }
  cout << maxMatch(n, m) << '\n';
  return 0;
}
```

### [例题] [[ZJOI2007] 矩阵游戏 ](https://www.luogu.com.cn/problem/P1129)

给定一个 $n\times n$ 的01矩阵，支持两种操作，行交换和列交换，问是否能够使主对角线上都是1，多测

$t\leq 20,n\leq 200$

显然同一行上的1不可能分开，同一列上的1也是，那么就是检验是否存在 $n$ 个以上不同行不同列的坐标

那么行号和列号连边，跑个最大匹配数判 $n$ 就可以了，有更简单的验证做法吗？ 似乎没有了，因为这和最大匹配问题等价，似乎没有更简单的解法

不知道这个问题变成三维之后要求挪动到空间对角线上有什么好的做法。。

三维的问题我考虑了一下分层图和CDQ，貌似都没有pee关系，也没什么别的处理手段

### [双倍经验] [U64970 車的放置](https://www.luogu.com.cn/problem/U64970)

### [妙妙题mini] [U64949 棋盘覆盖](https://www.luogu.com.cn/problem/U64949)

有点妙，但不是特别妙

## 二分图最小点覆盖

König定理：最大匹配数=最小点覆盖

考虑左盖右未盖的情况，从右边的点开始跑增广，能到的左边已盖点就是被选中的点，这种边覆盖了所有的这种边

对应的右未盖左盖也是一样，找到右边已盖点

两种搜到的盖点不会在同一条边上，否则就产生了增广路，不是最大匹配

如果上面选的两种点都没有覆盖到一些**两边都是盖点的边**，那么随便选一个就好



## 参考资料

* [洛谷日报 #148 [xht37] 二分图与网络流](https://www.luogu.com.cn/blog/xht37/er-fen-tu-yu-wang-lao-liu)
* OI-wiki
* 以前的课件
