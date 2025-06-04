---
title: 平衡树相关
tags: 
	- 算法模板
	- 平衡树
date: 2022-11-16
mathjax: true
---

整理.

<!-- more -->

# 笛卡尔树

给定一堆节点 $(k, w)$，要求构造一棵树，使得 $k$ 满足 bst 的性质，$w$ 满足堆的性质 

即：给定一个数组，考虑一棵二叉树，每个节点都是所在子树的极值，中序遍历一棵树的顺序等于原区间的顺序

## 建树

1. 用栈保存从根开始的右链，顺序插入每一个数
2. 对于当前的树，从最右边的节点（栈顶）开始找到一个位置插入，并且把下面的链变成左儿子

考虑这个过程，不难理解，可以用维基百科上的图模拟一下

![](../images/cartesian-tree1.png)

-----

**code**

```cpp
#include <bits/stdc++.h>
using ll = long long;
const int N = 10000010;
int n, p[N], to[N];
int l[N], r[N];
inline char gc() {
	static const int N = 1 << 20;
	static char buf[N | 1], *S = buf, *T = buf;
	return S == T && (T = (S = buf) + fread(buf, 1, N, stdin), S == T) ? EOF : *S++;
}
template<typename T>
inline void read(T &x) {
	x = 0;
	char ch = gc();
	for (; ch < '0' || ch > '9';) ch = gc();
	for (; ch <= '9' && ch >= '0';)
		x = x * 10 + (ch ^ 48), ch = gc();
}	
int main() {
	read(n);
	std::stack<int> st;
	for (int i = 1; i <= n; ++i) {
		read(p[i]), to[p[i]] = i;
		int las = -1;
		while (!st.empty() && st.top() > p[i]) 
			las = st.top(), st.pop();
		if (las != -1) 
			l[i] = to[las];
		if (!st.empty()) 
			r[to[st.top()]] = i;
		st.push(p[i]);
	}
	ll _l = 0, _r = 0;
	for (int i = 1; i <= n; ++i) 
		_l ^= 1ll * i * (l[i] + 1), _r ^= 1ll * i * (r[i] + 1);
	std::cout << _l << ' ' << _r << '\n';
	return 0;
}
```

洛谷上这题卡的有点变态了，，逼的我去更新了更快的板子，这份用的 Siyuan 的
