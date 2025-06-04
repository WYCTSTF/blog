---
title: Codeforces Round 812 (Div. 2)
tags: 
  - Codeforces
date: 2022-08-07
---

中间困了好久，， D就不想做

然而晚上又睡不着，于是起来补

<!-- more -->

## [C. Build Permutation](https://codeforces.com/contest/1713/problem/C)

懵了半天没发现规律，打个表才发现..

可以分段搞，开始的上限 $now$ 是 $n - 1$

我们设 $l_1 \leq now \leq l_2$，且 $l_1,l_2$ 都是完全平方数

不难发现，如果 $l_1 = now$，直接按 $now \to 0$ 的顺序把下标 $0 \to now$ 排一遍就好

然后考虑 $l_1 + 1 \to now$ 的部分，这部分要成为完全平方数只能变到 $l_2$，但是 $l_1 \to 0$ 加上 $l_2 - l_1 - 1 \to l_2 - now$ 是不行的

我在这里卡了好久

然后打表发现从后往前考虑补成对应的平方数就好了，代码比较清楚

```cpp
#include <bits/stdc++.h>
using namespace std;
int main() {
	int tt;
	cin >> tt;
	while (tt--) {
		int n;
		cin >> n;
		vector<int> ans(n);
		int now = n - 1;
		while (now > 0) {
			int l1 = sqrt(now);
			int l2 = sqrt(now) + 1;
			// cout << l2 << ' ' << now << '\n';

			if (l1 * l1 == now) {
				for (int i = 0; i <= now; ++i)
					ans[i] = l1 * l1 - i;
				break;
			}

			for (int i = now; l2 * l2 - i <= now; --i)
				ans[i] = l2 * l2 - i;
			now = l2 * l2 - now - 1;
		}
		for (int i = 0; i < n; ++i)
			cout << ans[i] << " \n"[i == n - 1];
	}
	return 0;
}
```

## [D. Tournament Countdown](https://codeforces.com/contest/1713/problem/D)

一共有 $2^n$ 个人

如果按照题意一轮轮询问下去，次数就是

$$
\begin{equation*}
  2^{n-1}+2^{n-2}+\cdots+2^{0}=2^n-1
\end{equation*}
$$

而题目要求的是不超过 $\lceil \frac{2}{3}\ {2^n} \rceil$ 次询问，显然寄了

对于询问a b，给定的是赢的次数，第一轮会淘汰 $2^{n-1}$ 个人，
即有 $2^{n-1}$ 个人赢 0 次，
一直到第 $n + 1$ 轮，还剩 1 个人，赢了 $n$ 次

因此我们询问 (a, b)，就会得到多种情况

1. 相等，说明a b都被淘汰了
2. a>b，说明b被淘汰
3. 反之a被淘汰

并且对于同一层的 (a, b), (c, d)，询问必从两组中各挑一个，这样相等说明ab 都被淘汰，因为b d肯定决出胜负，不等则询问胜者与败者组的另一个

这样2次询问能把两组4个人变为1个人

令 $2^{2k}\leq 2^n < 2^{2k+2}$

经过 $\frac{1}{2}n+\frac{1}{8}n+\cdots+2 {\frac{1}{4}}^k n$ 次询问会使 $2^n$ 缩小到 $\frac{2^n}{2^{2k}}$ (0 or 1) 的范围

得到总次数为 $\frac{2}{3}2^{n}(1-\frac{1}{4^k})$，分类讨论一下 
$n \mod 2$ 的值，发现都是成立的

```cpp
#include <bits/stdc++.h>
#define m (1 << n)
using namespace std;
int main() {
  int tt;
  cin >> tt;
  while (tt--) {
    int n;
    cin >> n;
    auto ask = [&](int &x, int &y) {
      cout << "? " << x << ' ' << y << endl;
      int tem;
      cin >> tem;
      return tem;
    };
    vector<int> a(m);
    for (int i = 0; i < m; ++i)
      a[i] = i + 1;
    while (m >= 4) {
      vector<int> b;
      for (int i = 0; i < m; i += 4) {
        int t1 = ask(a[i], a[i + 2]), t2;
        if (t1 == 0) {
					t2 = ask(a[i + 1], a[i + 3]);
					b.push_back(t2 == 1 ? a[i + 1] : a[i + 3]);
				}
        else if (t1 == 1) {
					t2 = ask(a[i], a[i + 3]);
					b.push_back(t2 == 1 ? a[i] : a[i + 3]);
				}
        else {
					t2 = ask(a[i + 1], a[i + 2]);
					b.push_back(t2 == 1 ? a[i + 1] : a[i + 2]);
				}
      }
			a = b;
			n -= 2;
    }
		if (a.size() == 1)
			cout << "! " << a[0] << endl;
		else {
			int ans = (ask(a[0], a[1]) == 1) ? a[0] : a[1];
			cout << "! " << ans << endl;
		}
  }
  return 0;
}
```

## [E. Cross Swapping](https://codeforces.com/contest/1713/problem/E)

发现如果令 $k=a,k=b$ 进行两次操作，$A_{ab}和A_{ba}$ 的位置不会改变，剩下的则是正常的行列交换

因此不难发现如果 $1\cdots n$ 全部操作一遍，不会改变这个矩阵

因此如果贪心的考虑每一位，优先满足第一行字典序最小，那么只要考虑 $A_{1i}=A_{i1}$ 的情况就好了，其中 
$i\in [1,n]$，令这样的位置为集合 $S$

显然我们在 $S$ 里面进行决策，不会改变第一行的情况

考虑 $i \in S$，对 $i$ 进行操作会影响到第 $i$ 行与第 $i$ 列的元素，然后发现对于第二列，也是如此，如果第二列交换与不交换都是这样，那么就作为改变第三行答案的选项留在集合里

逝了世发现上面那个想法假了，，wa 2但是我看不到数据，有高手看到可以Hack一下我..

[案发现场](https://codeforces.com/contest/1713/submission/168492362)

爬去看题姐..

简单讲就是说，从前往后考虑，然后每个i考虑操作或者不操作，那么在满足前面的关系上，顺序对每个位置涉及到的 $i,j$ 操作一下

然后用并查集维护就好了、、

扩展域还是边带权都一样

```cpp
#ifdef LOCAL
#include "algo/debug.h"
#else
#define debug(...) 42
#endif

#include <bits/stdc++.h>
using namespace std;
int main() {

	ios_base::sync_with_stdio(false);
	cin.tie(nullptr);

	int tt;
	cin >> tt;
	while (tt--) {
		int n;
		cin >> n;
		vector a(n + 1, vector<int>(n + 1, 0));


		vector fa(2 * n + 1, 0);
		iota(fa.begin(), fa.end(), 0);

		function<int(int)> find = [&](int o) {
			return o == fa[o] ? o : fa[o] = find(fa[o]);
		};

		function<void(int, int)> merge = [&](int u, int v) {
			if (find(u) == find(v))
				return;
			fa[find(v)] = find(u);
		};


		for (int i = 1; i <= n; ++i)
			for (int j = 1; j <= n; ++j)
				cin >> a[i][j];

		for (int i = 1; i <= n; ++i)
			for (int j = i + 1; j <= n; ++j) {
				if (a[i][j] == a[j][i] || find(i) == find(j) || find(i) == find(j + n))
					continue;
				if (a[i][j] < a[j][i]) {
					merge(i, j);
					merge(i + n, j + n);
				} else {
					merge(i, j + n);
					merge(i + n, j);
				}
			}

		for (int i = 1; i <= n; ++i) {
			if (find(i) <= n) {
				// deb(i);
				for (int j = 1; j <= n; ++j)
					swap(a[i][j], a[j][i]);
			}
		}

		for (int i = 1; i <= n; ++i)
			for (int j = 1; j <= n; ++j)
				cout << a[i][j] << " \n"[j == n];
	}
	return 0;
}
```

中间非常诡异的是这个，第46行的merge如果换一下顺序，就会wa

仔细思考一下，因为我的merge写法导致如果调换顺序，事实上并没有把 $i,j$ 分割开..
