---
title: Atcoder Regular Contest 160
date: 2023-05-19 06:22:01
tags:
    - Atcoder
    - 数论分块
    - 数位DP
---

开始写at

<!-- more -->

## [A - Reverse and Count](https://atcoder.jp/contests/arc160/tasks/arc160_a)

给定一个 $1\sim N$的排列$A$，定义$f(L,R)$为reverse $A_L,\dots,A_R$部分得到的新排列，于是有$\frac{N(N+1)}{2}$个$f(L,R)$，求字典序第$k$大的新排列


依次考虑第 $i$ 位，排列从小到大，一定是将 $[i+1,n]$ 中比 $p[i]$ 小的数字与其替换，再者考虑固定了第 $i$ 位之后剩余的 $n-i$ 位，再考虑 $[i+1,n$ 中比 $p[i]$ 大的数字与其替换

复杂度 $O(N^2)$



```cpp
#include<bits/stdc++.h>
using namespace std;
int main(){
  int n,k;
  cin>>n>>k;
  vector<int>p(n);
  for(int &x:p)cin>>x;
  int a=1,b=n*(n+1)/2;
  for(int i=0;i<n;++i){
    vector<int>low,high;
    for(int j=i+1;j<n;++j)
      if(p[j]<p[i])low.push_back(p[j]);
      else high.push_back(p[j]);
    int x=-1;
    if(k-a<(int)low.size()){
      sort(low.begin(),low.end());
      x=low[k-a];
    }
    if(b-k<(int)high.size()){
      sort(high.begin(),high.end(),greater<int>());
      x=high[b-k];
    }
    if(x!=-1){
      int j=i;
      while(p[j]!=x)++j;
      reverse(p.begin()+i,p.begin()+j+1);
      break;
    }
    a+=low.size(),b-=high.size();
  }
  for(int &x:p)
    cout<<x<<' ';
  return 0;
}
```


## [B - Triple Pair](https://atcoder.jp/contests/arc160/tasks/arc160_b)

多测

给定一个整数 $N$，求满足条件 $(xy\le n,zx\le n,yz\le n)$ 的三元组 $(x,y,z)$ 数量，答案对 $998244353$ 取模

$T\le 100, 1\le N\le 10^9$


分类讨论得答案 $\sqrt{n}^3+\sum\limits_{i=\sqrt{n}+1}^n{3\times\frac{n}{i}}$

但如果只是循环还是会T，所以要上数论分块



```cpp
#include <bits/stdc++.h>
using i64=long long;
const i64 mod = 998244353;
void solve() {
  int n;
  std::cin >> n;
  int m = sqrt(n);
  i64 ans = ((1ll * m * m) % mod) * m % mod;
  for (int i = m + 1, j; i <= n; i = j + 1) {
    int v = n / i;
    j = n / v;
    ans = (ans + ((1ll * v * v) % mod) * 3 * (j - i + 1) % mod) % mod;
  }
  std::cout << ans << '\n';
}
int main() {
  int tt;
  std::cin >> tt;
  while (tt--) {
    solve();
  }
}
```


顺便贴一份Jiangly的 modInt 板子，不过赛场上不太可能用得到就是了


```cpp
template<class T>
constexpr T power(T a, i64 b) {
  T res = 1;
  for (; b; b /= 2, a *= a) {
    if (b % 2) {
      res *= a;
    }
  }
  return res;
}

constexpr i64 mul(i64 a, i64 b, i64 p) {
  i64 res = a * b - i64(1.L * a * b / p) * p;
  res %= p;
  if (res < 0) {
    res += p;
  }
  return res;
}
template<i64 P>
struct MLong {
  i64 x;
  constexpr MLong() : x{} {}
  constexpr MLong(i64 x) : x{norm(x % getMod())} {}

  static i64 Mod;
  constexpr static i64 getMod() {
    if (P > 0) {
      return P;
    } else {
      return Mod;
    }
  }
  constexpr static void setMod(i64 Mod_) {
    Mod = Mod_;
  }
  constexpr i64 norm(i64 x) const {
    if (x < 0) {
      x += getMod();
    }
    if (x >= getMod()) {
      x -= getMod();
    }
    return x;
  }
  constexpr i64 val() const {
    return x;
  }
  explicit constexpr operator i64() const {
    return x;
  }
  constexpr MLong operator-() const {
    MLong res;
    res.x = norm(getMod() - x);
    return res;
  }
  constexpr MLong inv() const {
    assert(x != 0);
    return power(*this, getMod() - 2);
  }
  constexpr MLong &operator*=(MLong rhs) & {
    x = mul(x, rhs.x, getMod());
    return *this;
  }
  constexpr MLong &operator+=(MLong rhs) & {
    x = norm(x + rhs.x);
    return *this;
  }
  constexpr MLong &operator-=(MLong rhs) & {
    x = norm(x - rhs.x);
    return *this;
  }
  constexpr MLong &operator/=(MLong rhs) & {
    return *this *= rhs.inv();
  }
  friend constexpr MLong operator*(MLong lhs, MLong rhs) {
    MLong res = lhs;
    res *= rhs;
    return res;
  }
  friend constexpr MLong operator+(MLong lhs, MLong rhs) {
    MLong res = lhs;
    res += rhs;
    return res;
  }
  friend constexpr MLong operator-(MLong lhs, MLong rhs) {
    MLong res = lhs;
    res -= rhs;
    return res;
  }
  friend constexpr MLong operator/(MLong lhs, MLong rhs) {
    MLong res = lhs;
    res /= rhs;
    return res;
  }
  friend constexpr std::istream &operator>>(std::istream &is, MLong &a) {
    i64 v;
    is >> v;
    a = MLong(v);
    return is;
  }
  friend constexpr std::ostream &operator<<(std::ostream &os, const MLong &a) {
    return os << a.val();
  }
  friend constexpr bool operator==(MLong lhs, MLong rhs) {
    return lhs.val() == rhs.val();
  }
  friend constexpr bool operator!=(MLong lhs, MLong rhs) {
    return lhs.val() != rhs.val();
  }
};

template<>
i64 MLong<0LL>::Mod = 1;

template<int P>
struct MInt {
  int x;
  constexpr MInt() : x{} {}
  constexpr MInt(i64 x) : x{norm(x % getMod())} {}

  static int Mod;
  constexpr static int getMod() {
    if (P > 0) {
      return P;
    } else {
      return Mod;
    }
  }
  constexpr static void setMod(int Mod_) {
    Mod = Mod_;
  }
  constexpr int norm(int x) const {
    if (x < 0) {
      x += getMod();
    }
    if (x >= getMod()) {
      x -= getMod();
    }
    return x;
  }
  constexpr int val() const {
    return x;
  }
  explicit constexpr operator int() const {
    return x;
  }
  constexpr MInt operator-() const {
    MInt res;
    res.x = norm(getMod() - x);
    return res;
  }
  constexpr MInt inv() const {
    assert(x != 0);
    return power(*this, getMod() - 2);
  }
  constexpr MInt &operator*=(MInt rhs) & {
    x = 1LL * x * rhs.x % getMod();
    return *this;
  }
  constexpr MInt &operator+=(MInt rhs) & {
    x = norm(x + rhs.x);
    return *this;
  }
  constexpr MInt &operator-=(MInt rhs) & {
    x = norm(x - rhs.x);
    return *this;
  }
  constexpr MInt &operator/=(MInt rhs) & {
    return *this *= rhs.inv();
  }
  friend constexpr MInt operator*(MInt lhs, MInt rhs) {
    MInt res = lhs;
    res *= rhs;
    return res;
  }
  friend constexpr MInt operator+(MInt lhs, MInt rhs) {
    MInt res = lhs;
    res += rhs;
    return res;
  }
  friend constexpr MInt operator-(MInt lhs, MInt rhs) {
    MInt res = lhs;
    res -= rhs;
    return res;
  }
  friend constexpr MInt operator/(MInt lhs, MInt rhs) {
    MInt res = lhs;
    res /= rhs;
    return res;
  }
  friend constexpr std::istream &operator>>(std::istream &is, MInt &a) {
    i64 v;
    is >> v;
    a = MInt(v);
    return is;
  }
  friend constexpr std::ostream &operator<<(std::ostream &os, const MInt &a) {
    return os << a.val();
  }
  friend constexpr bool operator==(MInt lhs, MInt rhs) {
    return lhs.val() == rhs.val();
  }
  friend constexpr bool operator!=(MInt lhs, MInt rhs) {
    return lhs.val() != rhs.val();
  }
};

template<>
int MInt<0>::Mod = 1;

template<int V, int P>
constexpr MInt<P> CInv = MInt<P>(V).inv();

constexpr int P = 998244353;
using Z = MInt<P>;
```


## [C - Power Up](https://atcoder.jp/contests/arc160/tasks/arc160_c)

给定长为 $n\le 2\times 10^5$ 的序列 $a,a_i\le 2\times 10^5$

允许做若干次操作，一次操作可以将两个 $x$ 变为一个 $x+1$

问 $A$ 的方案数模 998244353


令 $B_x$ 表示 $x$ 在 $A$ 中出现的次数，而 $A$ 中最大的数可以是 $\max{A}+\log{N}$

考虑从小到大计数，这样不会漏掉可能的情况

* 令 $f[i][j]$ 为操作完 $1\sim i$ 中的数后有 $j$ 个 $i+1$ 时， $A$ 的情况数

若操作完 $1\sim i-1$ 后至多有 $k$ 个 $i$，即 $1\sim i-1$ 每个数字都至多保留一个，那么最多能产生 $\frac{k+b_i}{2}$ 个 ${i+1}$，即 $f[i+1][(k+b_i)/2]+=f[i][k]$，易得 $\forall j\in [0,\frac{k+b_i}{2}]$，都有 $f[i+1][(j+b_i)/2]+=f[i][j]$

考虑保留一部分的 $i$，那么能产生 $j$ 个 $i+1$ 的 $A$ 自然也能产生 $j-1$ 个 $i+1$

dp用滚动数组压掉一维即可

---------

考虑复杂度，其实就是将每次的计数次数求和

$$\sum_{i=1}^{\max{A}+\log{N}}\sum_{j=1}^{i}\frac{B_j\times 2^j}{2^i}$$

交换求和号

$$\iff \sum_{j=1}^{\max{A}+\log{N}}\sum_{i=j}^{\max{A}+\log{N}}{B_j(\frac{1}{2})^{i-j}}\le \sum_{j=1}^{\max{A}+\log{N}}2B_j\le 2N$$

如果觉得不够直观，可以看我 {% post_link Algorithm-BIT 树状数组博客 %} 的最后那个图，本质其实是一样的。


```cpp
#include<bits/stdc++.h>
using namespace std;
int n,t[201000],f[201000],g[401000];
const int N=2e5,mod=998244353;
int main(){
  cin>>n;
  for(int i=0,tem;i<n;++i)cin>>tem,t[tem]++;
	int sj=0;
	f[0]=1;
	for(int i=1;i<=N+200;i++){
		int Z=(sj+t[i])/2;
		for(int j=0;j<=Z;j++)g[j]=0;
		for(int j=0;j<=sj;j++)(g[(j+t[i])/2]+=f[j])%=mod;
		for(int j=Z-1;j>=0;j--)(g[j]+=g[j+1])%=mod;
		for(int j=0;j<=Z;j++)f[j]=g[j];
		sj=Z;
	}
  cout<<f[0]<<'\n';
}
```
