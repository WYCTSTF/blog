---
title: 线段树建边
tags: 
  - 线段树
  - 算法模板
date: 2022-08-10
---

如果说给一个点向下标连续的点集连边，那么就可以用线段树来维护这个东西

不过不用额外维护区间信息，只用到节点和对应的区间范围即可

<!-- more -->

模板题

## [CF786B Legacy](https://codeforces.com/problemset/problem/786/B)

给定 $n,q,s$ 表示点数，边数，以及源点

给定3种边，一个是点指向点，一种是点指向区间中的每一个点，另一种是区间的每个点指向单点

然后问单源最短路径

显然 $O(N^2)$ 建图肯定T了

考虑一个点 $u$
指向 $\mathtt{[l,r]}$ 内所有的点，用线段树思想把这段区间拆成
至多 $lgN$ 的节点，给 $u$ 向每个节点连一条边，
线段树内的节点从大区间指向小区间也需要边来维护，边权为0，这样的维护就是等价的

考虑区间的点指向一个点，反图再开一颗线段树来维护，
底部也是从 $\mathtt{[l,r]}$ 指向叶子节点，线段树内的节点也是小区间指向大区间

这样两颗线段树内的节点就连通了，并且满足原图的关系

然后新图跑一遍Dijkstra

调的要吐了

```cpp
#include <bits/stdc++.h>

using namespace std;

#ifdef LOCAL
#include "algo/debug.h"
#else
#define debug(...) 42
#endif

#define rep(i,a,n) for(int i=a;i<=n;i++)
#define per(i,a,n) for(int i=n;i>=a;i--)
#define max(a,b) (a>b?a:b)
#define min(a,b) (a<b?a:b)
#define mp make_pair
#define pb push_back
#define fi first
#define se second
#define pi acos(-1)
#define il inline
#define rg register
#define SZ(x) ((int)(x).size())
#define all(x) x.begin(),x.end()
#define INF 0x7fffffff
#define inf 0x3f3f3f3f
#define MOD 998244353
#define mod 1000000007
typedef vector<int> VI;
typedef pair<int,int> PII;
typedef long long ll;
typedef double db;
ll gcd(ll a,ll b) { return b?gcd(b,a%b):a; }

inline int read(){
	int x=0,f=1;
	char ch=getchar();
	while(ch<'0'||ch>'9') f=(ch=='-')?-1:1,ch=getchar();
	while(ch>='0'&&ch<='9') x=(x<<3)+(x<<1)+ch-'0',ch=getchar();
	return x*f;
}

#define ls p << 1
#define rs p << 1 | 1

const int N = 900010;

int n, q, s, op;
int u, v, w;
int tot;
int seg[2][N];
VI ve;
ll dis[N];
vector<PII> adj[N];
set<pair<long long, int>> p;

void add(int u, int v, int w) {
	adj[u].pb({v, w});
	// cout << u << ' ' << v << ' ' << w << '\n';
}

void build(int p, int l, int r, int ty) {
	seg[ty][p] = ++tot;
	if (l == r) {
		if (ty == 0)
			add(seg[0][p], l, 0);
		if (ty == 1)
			add(l, seg[1][p], 0);
		return;
	}
	int mid = (l + r) >> 1;
	build(ls, l, mid, ty);
	build(rs, mid + 1, r, ty);
	if (ty == 0) {
		add(seg[0][p], seg[0][ls], 0);
		add(seg[0][p], seg[0][rs], 0);
	} else {
		add(seg[1][ls], seg[1][p], 0);
		add(seg[1][rs], seg[1][p], 0);
	}
}

void mark(int p, int l, int r, int tl, int tr, int ty) {
	if (tl == l && r == tr) {
		ve.pb(seg[ty][p]);
		return;
	}
	int mid = (l + r) >> 1;
	if (tr <= mid)
		mark(ls, l, mid, tl, tr, ty);
	else if (tl > mid)
		mark(rs, mid + 1, r, tl, tr, ty);
	else
		mark(ls, l, mid, tl, mid, ty), mark(rs, mid + 1, r, mid + 1, tr, ty);
}

int main() {
	ios_base::sync_with_stdio(false);
	cin.tie(nullptr);

	n = read(), q = read(), s = read();
	tot = n;
	build(1, 1, n, 0);
	build(1, 1, n, 1);

	int l, r;

	for (int i = 1; i <= q; ++i) {
		op = read(), v = read();
		if (op == 1) {
			u = read(), w = read();
			add(v, u, w);
		} else {
			l = read(), r = read(), w = read();
			ve.clear();
			mark(1, 1, n, l, r, op - 2);
			if (op == 2)
				for (auto u : ve)
					add(v, u, w);
			else
				for (auto u : ve)
					add(u, v, w);
		}
	}

	for (int i = 1; i <= tot; ++i)
		dis[i] = 1ll << 60;
	dis[s] = 0;
	for (int i = 1; i <= tot; ++i)
		p.insert({dis[i], i});
	for (int i = 1; i <= tot; ++i) {
		int u = p.begin()->se;
		p.erase(p.begin());
		for (auto j : adj[u]) {
			int v = j.fi;
			long long w = j.se;
			if (dis[v] > dis[u] + w) {
				p.erase({dis[v], v});
				dis[v] = dis[u] + w;
				p.insert({dis[v], v});
			}
		}
	}

	for (int i = 1; i <= n; ++i) {
		if (dis[i] >= (1ll << 50))
			dis[i] = -1;
		cout << dis[i] << " \n"[i == n];
	}
	return 0;
}
```
