---
title: 分层图dp & 拆点连边
tags:
  - 算法模板
date: 2022-08-10
---

继续看图论小寄巧的日报，发现之前的分层图咕了，那甚至是4.17昆明之前的事了

决意好好地补一补，然后发现没有什么东西可弄的..

高中的时候还以为是什么高深的东西..

<!-- more -->

就是说，如果一个点，或者一张图，有K种状态，那么我们可以建K层图，然后连边，记录转移的信息，来维护..

## [通信线路](https://www.acwing.com/problem/content/342/)

给定 $n$ 个点， $m$ 条边的图，定义一条路径的花费为最大的边权

至多可以选择 $k$ 条边为0，问点 $1 \to n$ 最小的花费

于是我们可以开 $k+1$ 层图，然后对于所有边 $(u,v)$
 ，给一个第 $i$ 层的 $u$ 指向第 $i+1$ 层的 $v$ 边权为0的边，每层图之间正常连边

 然后dijkstra的转移改成 $\mathtt{dis[v]=min(dis[v], max(dis[u],u))}$，逝分合理

 当然为了省空间，其实可以只设一个dis[k][i]表示到点i用了k条边的花费，然后简单转移一下，因为不难知道点 $u$ 只能把当前指向的点和上一层的同样点作为选项，所以不需要把图建出来

 ```cpp
#include <algorithm>
#include <bitset>
#include <climits>
#include <cmath>
#include <complex>
#include <cstdio>
#include <cstring>
#include <deque>
#include <fstream>
#include <functional>
#include <iostream>
#include <list>
#include <map>
#include <queue>
#include <set>
#include <sstream>
#include <stack>
#include <string>
#include <utility>
#include <vector>
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
using namespace std;
typedef vector<int> VI;
typedef pair<int, int> PII;
typedef long long ll;
typedef double db;
const int INF = 0x7fffffff;
const int inf = 0x3f3f3f3f;
const int MOD = 998244353;
const int mod = 1e9 + 7;
ll gcd(ll a, ll b) { return b ? gcd(b, a % b) : a; }
const int N = 1010;
int n, m, k;
int dis[N][N];
bool vis[N][N];
vector<pair<int, int>> adj[N];
priority_queue<pair<int, pair<int, int>>> q;
int main() {
  ios::sync_with_stdio(false);
  cin.tie(0);
  cin >> n >> m >> k;
  rep(i, 1, n) rep(j, 0, k) dis[i][j] = INF;
  for (int i = 1; i <= m; i++) {
    int u, v, w;
    cin >> u >> v >> w;
    adj[u].pb(mp(v, w));
    adj[v].pb(mp(u, w));
  }
  dis[1][0] = 0;
  q.push(mp(0, mp(1, 0)));
  while (!q.empty()) {
    int i = q.top().se.fi, j = q.top().se.se;
    q.pop();
    if (vis[i][j] == true)
      continue;
    vis[i][j] = true;
    for (int G = 0; G < adj[i].size(); G++) {
      int v = adj[i][G].fi, w = adj[i][G].se;
      if (dis[v][j] > max(dis[i][j], w)) {
        dis[v][j] = max(dis[i][j], w);
        q.push(mp(-dis[v][j], mp(v, j)));
      }
      if (j < k && dis[v][j + 1] > dis[i][j]) {
        dis[v][j + 1] = dis[i][j];
        q.push(mp(-dis[v][j + 1], mp(v, j + 1)));
      }
    }
  }
  int ans = INT_MAX;
  rep(i, 0, k) ans = min(ans, dis[n][i]);
  if (ans == INT_MAX)
    puts("-1");
  else
    cout << ans << endl;
  return 0;
}
 ```

## [[JLOI2011] 飞行路线](https://www.luogu.com.cn/problem/P4568)

求的最小的最大边权改为最短路，做法也是一样

```cpp
#include <bits/stdc++.h>
using namespace std;
int main() {
  int n, m, k;
  cin >> n >> m >> k;
  int s, t;
  cin >> s >> t;
	int tot = k * n + n - 1;
  vector<vector<pair<int, int>>> adj(k * n + n);
  for (int i = 1; i <= m; ++i) {
    int u, v, w;
    cin >> u >> v >> w;
		adj[u].push_back({v, w});
		adj[v].push_back({u, w});
    for (int j = 1; j <= k; ++j) {
			adj[u + j * n - n].push_back({v + j * n, 0});
			adj[v + j * n - n].push_back({u + j * n, 0});
			adj[u + j * n].push_back({v + j * n, w});
			adj[v + j * n].push_back({u + j * n, w});
    }
  }
	vector<int> dis(tot + 1, INT_MAX);
	dis[s] = 0;
	set<pair<int, int>> p;
	for (int i = 0; i <= tot; ++i)
		p.insert({dis[i], i});
	for (int i = 0; i <= tot; ++i) {
		int u = p.begin()->second;
		p.erase(p.begin());
		for (auto it : adj[u]) {
			int v = it.first, w = it.second;
			if (dis[v] > dis[u] + w) {
				p.erase({dis[v], v});
				dis[v] = dis[u] + w;
				p.insert({dis[v], v});
			}
		}
	}
	int Min = INT_MAX;
	for (int i = t; i <= tot; i += n) {
		Min = min(Min, dis[i]);
	}
	cout << Min << '\n';
  return 0;
}
```

咳咳我就是来水博客的

主要是今天看了那个Legacy的线段树节点连边，突然觉得这个东西好弱智，之前还是那种理解了写不出来的状态。。

还是太菜了

三倍经验

[[BJWC2012]冻结](https://www.luogu.com.cn/problem/P4822)

[[USACO09FEB]Revamping Trails G](https://www.luogu.com.cn/problem/P2939)
