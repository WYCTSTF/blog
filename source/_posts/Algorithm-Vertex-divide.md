---
title: 点分治笔记
tags: 
	- 算法模板
	- 点分治
date: 2022.9.12
---

解决一类树上路径问题的方法

<!-- more -->


## 树的重心

大概就是物理意义上的质心，让一棵树尽可能平衡..

对于一个节点，计算其所有子树中最大的节点数，该值最小的节点就是树的重心

## [模板 点分治](https://www.luogu.com.cn/problem/P3806)

给定一棵有 $n$ 个点的树，询问树上距离为 $k$ 的点对是否存在。

指定一个根 $rt$ ，影响的就是在其子树中并且经过 $rt$ 的路径，这些路径考虑完就可以排除它的影响往下递归

枚举 $rt$ 的所有子节点 $ch$，记 $d_i$ 为节点 $i$ 到 $rt$ 的距离，$tf_s$ 表示之前处理的子树是否存在 $d_i=s$，然后检查 $tf_{k-d_i}$ 即可

清空 $tf$ 的时候只把出现过的清空，不直接memset以保证复杂度

点分治过程假设递归了 $h$ 层，复杂度为 $O(hn)$，因此每次选择树的重心，保证在
$O(n\log n)$

也就亿点点难写而已..

```cpp
#include <bits/stdc++.h>
using namespace std;

const int N = 10010;
const int M = 110;

int n, m;
int rt, sum;
int siz[N], weight[N], q[M];
bool vis[N], ans[N], tf[10000010];
vector<pair<int, int>> adj[N];

void getRoot(int u, int fa) {
	siz[u] = 1, weight[u] = 0;
	for (auto &[v, w] : adj[u]) {
		if (v == fa || vis[v])
			continue;
		getRoot(v, u);
		weight[u] = max(weight[u], siz[v]);
		siz[u] += siz[v];
	}
	weight[u] = max(weight[u], sum - siz[u]);
	if (weight[u] < weight[rt]) rt = u;
}

int d[N], dis[N], cnt;
void getDis(int u, int fa) {
	dis[++cnt] = d[u];
	for (auto &[v, w] : adj[u]) {
		if (v == fa || vis[v])
			continue;
		d[v] = d[u] + w, getDis(v, u);
	}
}

queue<int> del;
void dfs(int u, int fa) {
	tf[0] = 1;
	del.push(0);
	vis[u] = 1;
	for (auto &[v, w] : adj[u]) {
		if (v == fa || vis[v])
			continue;
		d[v] = w;
		getDis(v, u);
		for (int k = 1; k <= cnt; ++k)
			for (int i = 1; i <= m; ++i)
				if (q[i] >= dis[k])
					ans[i] |= tf[q[i] - dis[k]];

		for (int k = 1; k <= cnt; ++k)
			if (dis[k] <= 1e7)
				del.push(dis[k]), tf[dis[k]] = 1;

		cnt = 0;
	}
	while (!del.empty())
		tf[del.front()] = 0, del.pop();
	for (auto &[v, w] : adj[u]) {
		if (v == fa || vis[v])
			continue;
		sum = siz[v];
		rt = 0;
		weight[rt] = INT_MAX;
		getRoot(v, u);
		getRoot(rt, -1); // 计算siz
		dfs(rt, u);
	}
}

int main() {
	ios::sync_with_stdio(false);
	cin.tie(nullptr);
	
	cin >> n >> m;
	for (int i = 1; i < n; ++i) {
		int u, v, w;
		cin >> u >> v >> w;
		adj[u].push_back({v, w});
		adj[v].push_back({u, w});
	}
	
	for (int i = 1; i <= m; ++i)
		cin >> q[i];
	
	rt = 0, sum = n, weight[rt] = INT_MAX;
	getRoot(1, -1);
	getRoot(rt, -1); // 计算siz
	dfs(rt, -1);
	
	for (int i = 1; i <= m; ++i)
		if (ans[i] == 1)
			cout << "AYE\n";
		else
			cout << "NAY\n";
	return 0;
}
```

## [洛谷 P4178 Tree](https://www.luogu.com.cn/problem/P4178)

男人八题之一，十八年前的神仙题现在已经飞入寻常百姓家了..

给定一棵 $n$ 个节点的树，每条边有边权，求出树上两点距离小于等于 $k$ 的点对数量。

变成了点修区间查，用线段树或者树状数组搞一搞就好了

值得注意的是因为维护值域的话下标为 0 不是很好处理，所以所有值 +1 处理

```cpp
#include <bits/stdc++.h>

using namespace std;

const int N = 40010;
const int K = 20010;

int n, k;
int rt, sum;
int siz[N], weight[N];

bitset<N> vis;
vector<pair<int, int>> adj[N];

void getRoot(int u, int fa) {
	siz[u] = 1, weight[u] = 0;
	for (auto &[v, w] : adj[u]) {
		if (v == fa || vis[v])
			continue;
		getRoot(v, u);
		siz[u] += siz[v];
		weight[u] = max(weight[u], siz[v]);
	}
	weight[u] = max(weight[u], sum - siz[u]);
	if (weight[u] < weight[rt])
		rt = u;
}

int d[N], dis[N], cnt;

void getDis(int u, int fa) {
	dis[++cnt] = d[u];
	for (auto &[v, w] : adj[u]) {
		if (v == fa || vis[v])
			continue;
		d[v] = d[u] + w, getDis(v, u);
	}
}

queue<int> tag;

int c[K];

void mark(int x, int v) {
	for (; x <= K; x += x & -x) c[x] += v;
}

int query(int x) {
	int res = 0;
	for (; x; x -= x & -x) res += c[x];
	return res;
}

queue<int> del;

int ans;

void dfz(int u, int fa) {
	// cout << "root " << u << '\n';

	mark(1, 1);
	del.push(1);
	vis[u] = 1;

	for (auto &[v, w] : adj[u]) {
		if (v == fa || vis[v])
			continue;
		d[v] = w;
		getDis(v, u);

		for (int i = 1; i <= cnt; ++i)
			if (k >= dis[i])
				ans += query(k - dis[i] + 1);

		for (int i = 1; i <= cnt; ++i)
			if (dis[i] <= k)
				mark(dis[i] + 1, 1), del.push(dis[i] + 1);
		cnt = 0;
	}

	// for (int i = 1; i <= n; ++i)
	// 	cout << "d[" << i << "] " << d[i] << '\n';

	// cout << query(k + 1) << "\n\n";

	while (!del.empty())
		mark(del.front(), -1), del.pop();

	cnt = 0;
	for (auto &[v, w] : adj[u]) {
		if (v == fa || vis[v])
			continue;
		sum = siz[v];
		rt = 0;
		weight[rt] = INT_MAX;
		getRoot(v, u);
		getRoot(rt, -1);
		dfz(rt, u);
	}
}

int main() {
	ios::sync_with_stdio(false);
	cin.tie(nullptr);

	cin >> n;
	for (int i = 1; i < n; ++i) {
		int u, v, w;
		cin >> u >> v >> w;
		adj[u].push_back({v, w});
		adj[v].push_back({u, w});
	}

	cin >> k;

	ans = 0;

	rt = 0;
	sum = n;
	weight[rt] = INT_MAX;

	getRoot(1, -1);
	getRoot(rt, -1);
	dfz(rt, -1);

	cout << ans << '\n';

	return 0;
}
```

动态点分、、 这玩意儿先不搞，这种就和整体二分、复杂莫队一样，考场金牌题，平时训练又是一回事
