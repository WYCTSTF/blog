---
title: 连通性问题 笔记
tags:
    - 算法模板
    - Tarjan
date: 2022-07-25
---

根绝OI-wiki和李煜东的[课件](/file/图连通性若干拓展问题探讨_李煜东.pptx)来学习，因为公开在Share OI上，我也就传上来了

<!-- more -->

强连通分量 SCC - 极大强连通子图

首先是最基础的有向图 Tarjan 或 Kosaraju 求 SCC，没啥好说的..

## DFS生成树

DFS生成树的四种边

* Tree edge
* back edge 遇到了一个已经访问过的节点，是当前节点的祖先
* cross edge 遇到了一个已经访问过的节点，但不是当前节点的祖先
* forward edge (u,v) 遇到一个被访问过的子节点

如果 $u$ 是某个强连通分量在搜索树中遇到的第一个节点，那么该SCC剩余节点都在以 $u$ 为根结点的子树中

反证法：若有个结点 $v$ 在该强连通分量中但是不在以 $u$ 为根的子树中，那么 $u$ 到 $v$ 的路径中肯定有一条离开子树的边。**但是这样的边只可能是横叉边或者反祖边**，然而这两条边都要求指向的结点已经被访问过了，这就和 $u$ 是第一个访问的结点矛盾了。

----

## Tarjan求SCC

维护两个东西

1. $dfn_u$ 表示dfs时点$u$被搜索到的顺序
2. $low_u$ 表示能够回溯到的最早已在栈中的节点。设以 $u$ 为根的子树为 $Subtree_u$。 $low_u$ 定义为以下节点的 $dfn$ 的最小值：$Subtree_u$ 中的节点，从 $Subtree_u$ 通过一条不在搜索树上的边能到达的节点

搜索过程中，对于节点 $u$ 和与其相邻的节点 $v$，考虑三种情况

1. $v$ 未被访问，就继续深搜，回溯的时候用 $low_v$ 更新 $low_x$
2. $v$ 被访问过，并且在栈中，那么就用 $dfn_v$ 更新 $low_u$
3. $v$ 被访问过，不在栈中，说明 $v$ 所在的整个强连通都被处理完了，跟 $u$ 没有关系

并且在一个SCC中，显然有且只有一个 $u$ 满足 $dfn_n=low_u$，回溯的过程中如果条件成立，那么栈里从 $u$ 开始往上的节点都在当前SCC中

就第2点我自己想了一下，我觉得用 $low[v]$ 来更新好像也没什么问题

因为low定义的是至多通过一条反向边到达的点，所以 $low[v]$ 可能也用到了别的反向边，因此如果 $(u,v)$ 是反向边，所以根据定义，更新 $low[u]$ 还是用 $dfn[v]$，只不过最后因为判断条件是 $low[u]=dfn[u]$，这两者怎么处理都无所谓了

|||
|--|--|
| <img src=\images\tarjan1.png> | <img src=\images\tarjan2.png> |

可以发现上面两个 $low[4]$ 的差异其实没有影响

```cpp
#ifdef LOCAL
#include "algo/debug.h"
#else
#define debug(...) 42
#endif

#include <bits/stdc++.h>
using namespace std;

int main() {
  int n, m;
  cin >> n >> m;

  vector<vector<int>> adj(n + 1);

  for (int i = 1; i <= m; ++i) {
    int u, v;
    cin >> u >> v;
    adj[u].push_back(v);
  }

  vector<int> low(n + 1, 0), dfn(n + 1, 0);
  stack<int> sta;
  bitset<10000> vis;
  vis.reset();

  int sc = 0;
  vector<int> scc(n + 1, 0);
  vector<vector<int>> SCC;
  SCC.push_back(vector<int>{});

  function<void(int)> tarjan = [&](int u) {
    static int dfc = 0;
    low[u] = dfn[u] = ++ dfc;
    sta.push(u);
    vis[u] = 1;
    for (int &v : adj[u]) {
      if (!dfn[v]) {
        tarjan(v);
        low[u] = min(low[u], low[v]);
      } else if (vis[v]) {
        low[u] = min(low[u], dfn[v]);
      }
    }
    if (dfn[u] == low[u]) {
      ++sc;
      SCC.push_back(vector<int>{});
      while (sta.top() != u) {
        scc[sta.top()] = sc;
        SCC[sc].push_back(sta.top());
        vis[sta.top()] = 0;
        sta.pop();
      }
      scc[sta.top()] = sc;
      SCC[sc].push_back(sta.top());
      vis[sta.top()] = 0;
      sta.pop();
    }
  };

  for (int i = 1; i <= n; ++i) {
    if (!dfn[i]) {
      tarjan(i);
    }
  }

  cout << "SCC's number - " << SCC.size() - 1 << '\n';
  for (int i = 1; i <= sc; ++i) {
    cout << "SCC " << i << ':' << '\n';
    for (int u : SCC[i]) {
      deb(u);
      deb(dfn[u]);
      deb(low[u]);
    }
    cout << '\n';
  }
  return 0;
}
```

---------

## 拓扑排序

做[缩点模板题](https://www.luogu.com.cn/problem/P3387)的时候突然发现自己还没有学过拓扑，两句话总结一下

1. 拓扑排序要求对给定的一张图进行节点顺序排序，保证对于所有有向边(u,v)，都有u的顺序在v的顺序之前
2. 动态维护一个入度为0的节点集合，这些就是当前能够排到顺序里的候选项

---------

## [洛谷 P3387 【模板】缩点](https://www.luogu.com.cn/problem/P3387)

缩点之后新图拓扑排序，然后递推一遍

思路十分简单

```cpp
#include <bits/stdc++.h>

using namespace std;

#ifdef LOCAL
#include "algo/debug.h"
#else
#define debug(...) 42
#endif

#define rep(i, a, n) for (int i = a; i <= n; i++)
#define per(i, a, n) for (int i = n; i >= a; i--)
#define max(a, b) (a > b ? a : b)
#define min(a, b) (a < b ? a : b)
#define mp make_pair
#define pb push_back
#define fi first
#define se second
#define pi acos(-1)
#define il inline
#define rg register
#define SZ(x) ((int)(x).size())
#define all(x) x.begin(), x.end()
#define INF 0x7fffffff;
#define inf 0x3f3f3f3f;
#define MOD 998244353;
#define mod 1000000007;
typedef vector<int> VI;
typedef pair<int, int> PII;
typedef long long ll;
typedef double db;
ll gcd(ll a, ll b) { return b ? gcd(b, a % b) : a; }

int main() {
  int n, m;
  cin >> n >> m;
  VI val(n + 1, 0);
  for (int i = 1; i <= n; ++i)
    cin >> val[i];
  vector<VI> adj(n + 1);
  for (int i = 1; i <= m; ++i) {
    int u, v;
    cin >> u >> v;
    adj[u].push_back(v);
  }

  int sc = 0;
  VI dfn(n + 1, 0), low(n + 1, 0);
  vector<VI> SCC;
  SCC.push_back(VI{});
  VI scc(n + 1, 0);
  bitset<10000> in;
  in.reset();
  stack<int> sta;

  function<void(int)> tarjan = [&](int u) {
    static int dfc = 0;
    low[u] = dfn[u] = ++dfc;
    sta.push(u);
    in[u] = 1;
    for (int &v : adj[u]) {
      if (!dfn[v]) {
        tarjan(v);
        low[u] = min(low[u], low[v]);
      } else if (in[v]) {
        low[u] = min(low[u], dfn[v]);
      }
    }
    if (dfn[u] == low[u]) {
      ++sc;
      SCC.push_back(VI{});
      while (sta.top() != u) {
        SCC[sc].push_back(sta.top());
        scc[sta.top()] = sc;
        in[sta.top()] = 0;
        sta.pop();
      }
      SCC[sc].push_back(sta.top());
      scc[sta.top()] = sc;
      in[sta.top()] = 0;
      sta.pop();
    }
  };

  for (int i = 1; i <= n; ++i)
    if (dfn[i] == 0)
      tarjan(i);

  int N = (int)SCC.size() - 1;
  vector<VI> edge(N + 1);
  vector<int> Val(N + 1);
  vector<int> In(N + 1, 0);

  for (int i = 1; i <= N; ++i)
    for (int u : SCC[i])
      Val[i] += val[u];

  for (int u = 1; u <= n; ++u) {
    for (int &v : adj[u]) {
      if (scc[u] != scc[v]) {
        edge[scc[u]].push_back(scc[v]);
        In[scc[v]]++;
      }
    }
  }

  set<int> s;
  for (int i = 1; i <= N; ++i) {
    if (In[i] == 0)
      s.insert(i);
  }
  vector<int> top;
  while (!s.empty()) {
    int u = *s.begin();
    for (int v : edge[u]) {
      In[v]--;
      if (In[v] == 0)
        s.insert(v);
    }
    top.push_back(u);
    s.erase(u);
  }

  vector<int> dp(N + 1);
  for (int u : top)
    for (int v : edge[u])
      dp[v] = max(dp[v], dp[u] + Val[u]);

  int ans = 0;
  for (auto u : top)
    ans = max(ans, dp[u] + Val[u]);
  cout << ans << '\n';

  return 0;
}
```

----

## Kosaraju求SCC

首先我们知道，有向图中如果 $A\to B$ 成立，且反图中 $A\to B$ 也成立的话，那么 $A\to B \to A$ 是一个环

然后考虑后序遍历，即左右根，先把儿子压入栈，然后父节点压入栈，发现这个顺序反过来满足拓扑序，管这个叫**逆后序**

那么对于一张图，拿到它的逆后序，只要是连通的部分，靠前的点总能到达靠后的点，那么用这个顺序在反图里面遍历，所有能到达的点和当前的点都在一个SCC里

非常好懂

kosaraju的缩点代码

```cpp
#include <bits/stdc++.h>

using namespace std;

int main() {

  vector<int> s;

  int n, m;
  cin >> n >> m;

  vector<int> a(n + 1);
  for (int i = 1; i <= n; ++i)
    cin >> a[i];

  vector<vector<int>> adj(n + 1), inv(n + 1);
  for (int i = 1; i <= m; ++i) {
    int u, v;
    cin >> u >> v;
    adj[u].push_back(v);
    inv[v].push_back(u);
  }

  bitset<10000> vis;
  vis.reset();
  function<void(int)> dfs1 = [&](int u) {
    vis[u] = 1;
    for (int &v : adj[u])
      if (!vis[v])
        dfs1(v);
    s.push_back(u);
  };
  for (int i = 1; i <= n; ++i)
    if (vis[i] == 0)
      dfs1(i);

  int sc = 0;
  vector<int> scc(n + 1, 0);

  vector<int> val;
  function<void(int)> dfs2 = [&](int u) {
    scc[u] = sc;
    val[sc] += a[u];
    for (int &v : inv[u])
      if (!scc[v])
        dfs2(v);
  };
  val.push_back(0);
  for (int i = n - 1; i >= 0; --i) {
    if (!scc[s[i]]) {
      ++sc;
      val.push_back(0);
      dfs2(s[i]);
    }
  }

  vector<int> dp(sc + 1, 0), in(sc + 1, 0);
  vector<vector<int>> to(sc + 1);
  for (int i = 1; i <= n; ++i)
    for (int &v : adj[i])
      if (scc[i] != scc[v])
        in[scc[v]]++, to[scc[i]].push_back(scc[v]);
  set<int> S;
  for (int i = 1; i <= sc; ++i)
    if (!in[i])
      S.insert(i);
  while (!S.empty()) {
    int u = *S.begin();
    for (int &v : to[u]) {
      if (--in[v] == 0)
        S.insert(v);
      dp[v] = max(dp[v], dp[u] + val[u]);
    }
    S.erase(u);
  }
  int ans = 0;
  for (int i = 1; i <= sc; ++i)
    ans = max(ans, dp[i] + val[i]);
  cout << ans;
  return 0;
}
```

----

## 割点和桥

定义

### 割点

* 在无向连通图 $G$ 上进行定义
* 割点：删掉某点 $P$ 之后，$G$ 分裂为两个或两个以上的子图，则称 $P$ 为 $G$ 的割点
* 割点集合：在无向连通图 $G$ 中，如果有一个顶点集合，删除这个顶点集合以及与该点集中的顶点相关联的边以后，原图分成多于一个连通块，则称这个点集为 $G$ 的割点集合
* 点连通度：最小割点集合的大小

### 割边

相关定义同割点

### 双连通分量

* 点/边 双连通图：(点/边)连通度大于1的图
* 无向图的极大双连通子图被称为双连通分量

-------

### 找割点｜点双连通

emmm 还是从指定的根节点dfs出去，标 $dfn_i$，然后如果对于一个节点 $u$，存在一个儿子 $v$ 的  $low_v\geq dfn_u$，那么不难意识到 $u$ 是一个割点，因为 $Tarjan$ 维护的 $low$ 是一个点通过反向边、横叉边能到达的 $dfn$ 最小的点，这个性质说明了很多..

然后对于根结点，这样的 $v$ 要至少有两个，特判一下就好了..

可以在求割点的过程维护一个栈求出每个点双连通分量，栈的操作如同之前的有向图Tarjan求SCC

* 若边 $(u,v)$ 满足 $low(v)\geq dfn(u)$，即满足了 $u$ 是割点的判断条件，那么把点从栈顶依次取出，直到取出点 $v$，这些点和 $u$ 一同构成点双连通
* 割点可能属于多个点双连通分量，其余点和每条边仅属于一个点双连通，因此从栈中取出节点时，要把 $u$ 留在栈中
* DFS结束之后，栈中还剩余的节点构成一个V-BCC

求点双连通的没找到模板，自己造了点数据测了下，不是很安逸的感觉..

|||
|:--:|:--:|
| <img src=\images\tarjan3.png> | <img src=\images\tarjan4.png> |

```cpp
#include <bits/stdc++.h>

using namespace std;

#ifdef LOCAL
#include "algo/debug.h"
#else
#define debug(...) 42
#endif

#define rep(i, a, n) for (int i = a; i <= n; i++)
#define per(i, a, n) for (int i = n; i >= a; i--)
#define max(a, b) (a > b ? a : b)
#define min(a, b) (a < b ? a : b)
#define mp make_pair
#define pb push_back
#define fi first
#define se second
#define pi acos(-1)
#define il inline
#define rg register
#define SZ(x) ((int)(x).size())
#define all(x) x.begin(), x.end()
#define INF 0x7fffffff;
#define inf 0x3f3f3f3f;
#define MOD 998244353;
#define mod 1000000007;
typedef vector<int> VI;
typedef pair<int, int> PII;
typedef long long ll;
typedef double db;
ll gcd(ll a, ll b) { return b ? gcd(b, a % b) : a; }

int main() {
  ios_base::sync_with_stdio(false);
  cin.tie(nullptr);
  int n, m;
  cin >> n >> m;
  vector<VI> adj(n + 1);
  for (int i = 1; i <= m; ++i) {
    int u, v;
    cin >> u >> v;
    adj[u].pb(v);
    adj[v].pb(u);
  }
  VI low(n + 1), dfn(n + 1, 0);
  vector<VI> v_bcc;
  stack<int> sta;
  int root;
  VI cut(n + 1, 0);
  function<void(int)> tarjan = [&](int u) {
    static int dfc = 0;
    low[u] = dfn[u] = ++dfc;
    sta.push(u);
    int cnt = 0;
    for (int v : adj[u]) {
      if (!dfn[v]) {
        tarjan(v);
        low[u] = min(low[u], low[v]);
        if (low[v] >= dfn[u]) {
          cnt++;
          VI tem;
          if (cnt > 1 || root != u) {
            cut[u] = 1;
            while (!sta.empty() && sta.top() != v) {
              tem.pb(sta.top());
              sta.pop();
            }
            tem.pb(sta.top());
            sta.pop();
            tem.pb(u);
            v_bcc.pb(tem);
          }
        }
      } else
        low[u] = min(low[u], dfn[v]);
    }
  };
  for (int i = 1; i <= n; ++i) {
    if (!dfn[i]) {
      root = i;
      tarjan(i);
    }
  }
  vector<int> tem;
  while (!sta.empty()) {
    tem.pb(sta.top());
    sta.pop();
  }
  v_bcc.pb(tem);
  for (auto it : v_bcc) {
    for (auto iter : it)
      cout << iter << ' ';
    cout << '\n';
  }
  return 0;
}
```

------

### 找割边｜边双连通

口胡一下做法，因为不怎么用代码不写了，tarjan的时候同时维护一个父节点，然后只要`low[v]>dfn[u]`并且`low[u] = min(low[u], dfn[v]`的时候`u!=fa[v]`就可以了，即没有别的回到父节点的路，也不用考虑根节点什么的..

还要详细的话看 [OI-wiki](https://oi-wiki.org/graph/cut/#_5) 就好了

------

## 例题 UVA1364 Knights of the Round Table

给定 $n$ 个骑士和 $m$ 对关系
