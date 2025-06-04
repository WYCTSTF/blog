---
title: 2015-2016 ACM-ICPC, NEERC, Northern Subregional Contest
tags:
    - Codeforces
date: 2022-07-16
---

今天问xy打的什麽比赛，原来是他们学校找了一场neerc在训练

暑假确实要vp区域赛的题，哪怕单开、、

题面传上来了，放在资料栏、链接从文章里面点开会有路径问题..

菜成傻逼了，只会贺题..

没1900没法看数据，也没法看别人的代码（没过题之前），太折磨了

<!-- more -->

# A. Alex Origami Squares

签到题

{% fold code %}

```cpp
#include <bits/stdc++.h>

using ll = long long;

int main() {
  freopen("alex.in", "r", stdin);
  freopen("alex.out", "w", stdout);
  double w, h;
  std::cin >> w >> h;

  if (w < h)
    std::swap(w, h);
  printf("%.6lf", std::max(h / 2.0, std::min(w / 3.0, h)));
  return 0;
}
```
{% endfold %}

# G. Graph

不会做，看的题解，主要是不会处理同一列里面，如果k还有剩余该如何交换顺序，以及断开的各个块

贪心的考虑拓扑序，依次固定数值，用一个小根堆，维护入度为0的点，这些点的拓扑序都可以在满足给出条件的基础上任意指定，如果还有边的话

那么用一个大根堆来维护已经被分配了一条边的点集

如果小根堆中的顶点$x$没有大根堆里面的好，那么把$x$加入到大根堆中，即分配一条边给它

但如果 ($k=0$) 或者 (小根堆的 $size=1$且大根堆为空或者顶点小于$x$)（这个时候分配入边则会成环，或者入度为0的点没有必要加到大根堆里），那么就直接拓扑$x$

在小根堆满足后，再按照大根堆的元素依次拓扑

拓扑的过程中，加入每个点的同时，它所指向的点入度都--，如果为0，则加入到小根堆中

```cpp
#include <bits/stdc++.h>

using ll = long long;
using std::vector;

int main() {
#ifndef LOCAL
  freopen("graph.in", "r", stdin);
  freopen("graph.out", "w", stdout);
#endif
  int n, m, k;
  std::cin >> n >> m >> k;

  vector<int> in(n + 1, 0), ord(n + 1, 0);
  vector<vector<int>> g(n + 1);
  vector<std::pair<int, int>> edge;

  for (int i = 1, u, v; i <= m; ++i) {
    std::cin >> u >> v;
    g[u].push_back(v);
    in[v]++;
  }

  std::set<int> mn, mx;
  for (int i = 1; i <= n; ++i)
    if (in[i] == 0)
      mn.insert(i);
  
  int pre = 0, cnt = 0;

  auto topo = [&](int x) -> void {
    ord[++cnt] = x; pre = x;
    for (auto y : g[x]) {
      if (--in[y] == 0) mn.insert(y);
    }
  };

  while (cnt < n) {
    if (mn.empty()) {
      int x = *--mx.end();
      edge.push_back({pre, x});
      topo(x);
      mx.erase(x);
    } else if (!k || mn.size() == 1 && (mx.empty() || *mn.begin() > *--mx.end())) {
      int x = *mn.begin();
      topo(x);
      mn.erase(x);
    } else {
      --k;
      int x = *mn.begin();
      mn.erase(x);
      mx.insert(x);
    }
  }
  for (int i = 1; i <= cnt; ++i) {
    std::cout << ord[i] << " \n"[i == cnt];
  }
  std::cout << edge.size() << '\n';
  for (auto [u, v] : edge) {
    std::cout << u << ' ' << v << '\n';
  }
  return 0;
}
```
