---
title: CDQ分治笔记
tags: 
	- 算法模板
	- CDQ分治
category:
    - 算法
date: 2022-09-19
---

同样是两三年前就听说的知识点，现在再来学..

<!-- more -->

# 解决一类点对问题

不管是OI-wiki还是你谷题解第一眼看上去都有点懵，感觉是那种会的看得懂，不会的看不懂的讲解..

所以结合着题目来理解，再概括会比较好

## 例题 [P3810 [模板]三维偏序](https://www.luogu.com.cn/problem/P3810)

像逆序对就是一个经典的二维偏序问题，固定了下标之后，只剩下一维，用权值线段树、树状数组维护一下就好

那么现在固定了一维 $(i<j)$
之后，将剩下的部分改成二维的 $(a,b)$，然后求一个满足条件的偏序数量

设

$$
f(i)=\sum\limits_{j\ne i}{[a_j<a_i\&b_j<b_i]}
$$

求 $\forall d\in [0,n-1]$，输出
$f(i)=d$ 的数量，共 $n$ 行

如果消除第一维的影响，这题就变成了一个二维偏序，用树状数组就能很容易的做掉

考虑将 $(l,r)$ 范围内的第一维分治，分成
$(l,mid)$ 和 $(mid+1,r)$ 两部分，这样左边的第一维就严格小于右边的，然后对于每一个
$j\in[mid+1,r]$，把所有 $a_i<a_j,i\in[l,mid]$ 插入到树状数组里，统计
$<b_j$ 的个数， $i,j$ 的移动只要排个序就能解决

现在是，实现时间！

放到这题里面，因为相等的元素也要算，直接处理起来比较坑爹，一个好方法是记录一个附加位置，对于相同的元素，他们的附加位置相同，附加位置作为新的id，然后强行变成严格偏序，这样的计数效果就一样了

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
#define INF 0x7fffffff
#define inf 0x3f3f3f3f
#define MOD 998244353
#define mod 1000000007
typedef vector<int> VI;
typedef pair<int, int> PII;
typedef long long ll;
typedef double db;
ll gcd(ll a, ll b) { return b ? gcd(b, a % b) : a; }

namespace FAST_IO {
#define ll long long
#define ull unsigned long long
#define db double
#define _8 __int128_t
const int LEN = 1 << 20;
char BUF[LEN], PUF[LEN];
int Pin = LEN, Pout;
inline void flushin() {
  memcpy(BUF, BUF + Pin, LEN - Pin), fread(BUF + LEN - Pin, 1, Pin, stdin),
      Pin = 0;
  return;
}
inline void flushout() {
  fwrite(PUF, 1, Pout, stdout), Pout = 0;
  return;
}
inline char Getc() {
  return (Pin == LEN ? (fread(BUF, 1, LEN, stdin), Pin = 0) : 0), BUF[Pin++];
}
inline char Get() { return BUF[Pin++]; }
inline void Putc(char x) {
  if (Pout == LEN)
    flushout(), Pout = 0;
  PUF[Pout++] = x;
}
inline void Put(char x) { PUF[Pout++] = x; }
template <typename tp = int> inline tp read() {
  (Pin + 32 >= LEN) ? flushin() : void();
  tp res = 0;
  char f = 1, ch = ' ';
  for (; ch < '0' || ch > '9'; ch = Get())
    if (ch == '-')
      f = -1;
  for (; ch >= '0' && ch <= '9'; ch = Get())
    res = (res << 3) + (res << 1) + ch - 48;
  return res * f;
}
template <typename tp> inline void wt(tp a) {
  if (a > 9)
    wt(a / 10);
  Put(a % 10 + '0');
  return;
}
template <typename tp> inline void write(tp a, char b = '\n') {
  static int stk[20], top;
  (Pout + 32 >= LEN) ? flushout() : void();
  if (a < 0)
    Put('-'), a = -a;
  else if (a == 0)
    Put('0');
  for (top = 0; a; a /= 10)
    stk[++top] = a % 10;
  for (; top; --top)
    Put(stk[top] ^ 48);
  Put(b);
  return;
}
inline void wt_str(std::string s) {
  for (char i : s)
    Putc(i);
  return;
}
} // namespace FAST_IO
using namespace FAST_IO;

struct Element {
  int a, b, c;
  int id;
};

int main() {
  int n, k;
  n = read(), k = read();

  vector<Element> e(n + 1);

  rep(i, 1, n) e[i].a = read(), e[i].b = read(), e[i].c = read(), e[i].id = i;

  sort(e.begin() + 1, e.begin() + 1 + n,
       [&](const Element &x, const Element &y) {
         return (x.a == y.a) ? ((x.b == y.b) ? (x.c < y.c) : (x.b < y.b))
                             : (x.a < y.a);
       });

  VI ID(n + 1), num(n + 1, 0);

  for (int i = 1; i <= n;) {
    int j = i + 1;
    while (j <= n && e[i].a == e[j].a && e[i].b == e[j].b && e[i].c == e[j].c)
      ++j;
    while (i < j)
      ID[e[i].id] = e[j - 1].id, ++i;
  }

  rep(i, 1, n) e[i].a = i;

  VI c(k + 1, 0);

  auto mark = [&](int x, int v) {
    for (; x <= k; x += x & -x)
      c[x] += v;
  };

  auto query = [&](int x) {
    int res = 0;
    for (; x; x -= x & -x)
      res += c[x];
    return res;
  };

  function<void(int, int)> cdq = [&](int l, int r) {
    if (l == r)
      return;
    int mid = (l + r) / 2;
    cdq(l, mid);
    cdq(mid + 1, r);
    sort(e.begin() + l, e.begin() + r + 1,
         [&](const Element &x, const Element &y) {
           return (x.b == y.b) ? ((x.c == y.c) ? (x.a < y.a) : (x.c < y.c))
                               : (x.b < y.b);
         });
    rep(i, l, r) {
      if (e[i].a <= mid)
        mark(e[i].c, 1);
      else
        num[e[i].id] += query(e[i].c);
    }

    rep (i, l, r)
      if (e[i].a <= mid)
        mark(e[i].c, -1);
  };

  cdq(1, n);

  VI f(n + 1, 0);
  rep (i, 1, n)
    f[num[ID[e[i].id]]]++;
  
  for (int i = 0; i < n; ++i)
    write(f[i], '\n');

  flushout();
  return 0;
}
```

还有一个理解，就是cdq可以嵌套，依次处理每一维，这种思想还是很屌的，可以参考[洛谷题解](https://www.luogu.com.cn/blog/user39216/solution-p3810)
