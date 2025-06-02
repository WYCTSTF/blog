---
title: 2020,2021 年 CF 简单题精选 贺题记录
tags:
  - 构造
  - 状压DP
  - Codeforces
date: 2022.6.23
---

最近没什么事情，原神也开始每天20min上班模式

把之前收藏的[题单](https://www.luogu.com.cn/training/2018#problems)好好做一下

<!-- more -->

## [CF1293 (Div. 2) D. Aroma's Search](https://codeforces.com/contest/1292/problem/B) 1700pts..

### solution

注意到 $\  a_x,a_y\geq 2$ 那么不难发现点从 $(x_0,y_0)$ 一路向上走，并且跳的至少是之前两倍的距离

那么从起点$\ (X_s,Y_s)$ 去搜集，找到一个最近的点 $P_i$ ，先从 $P_i$ 往 $P_0$ 走，然后如果有时间空余再像右上走，这个比较好发现

但是因为数据范围比较反常，我有点不知所措，就不会继续处理了

看了一个金钩爷的写法，一如既往的妙。。

主要是一点，$2^{64} > 10^{18}$ 所以直接写一个 70 的 $N^2$ 就行了


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
#define INF 0x7fffffff;
#define inf 0x3f3f3f3f;
#define MOD 998244353;
#define mod 1000000007;
typedef vector<int> VI;
typedef pair<int,int> PII;
typedef long long ll;
typedef double db;
ll gcd(ll a,ll b) { return b?gcd(b,a%b):a; }

const int N = 70;

ll xs, ys, ans, n, t;
ll x[N], y[N], ax, ay, bx, by;

ll dis(ll x1, ll y1, ll x2, ll y2) {
	return llabs(x1 - x2) + llabs(y1 - y2);
}

int main() {
	cin.tie(nullptr) -> sync_with_stdio(false);
	cin >> x[0] >> y[0] >> ax >> ay >> bx >> by;
	cin >> xs >> ys >> t;

	while (++n) {
		x[n] = ax * x[n-1] + bx;
		y[n] = ay * y[n-1] + by;
		if (x[n] > xs && y[n] > ys && dis(x[n], y[n], xs, ys) > t) break;
	}


	for (int i = 0; i <= n; i++) {
		ll tans = 0, tt = t;
		if (dis(xs, ys, x[i], y[i]) <= tt) tt -= dis(xs, ys, x[i], y[i]), tans++;
		else {ans = max(ans, tans); continue;}

		for (int j = i; j; j--) {
			if (dis(x[j], y[j], x[j-1], y[j-1]) <= tt) {
				tt -= dis(x[j], y[j], x[j-1], y[j-1]), tans++;
			} else
				break;
		}

		for (int j = 1; j <= n; j++) {
			if (dis(x[j], y[j], x[j-1], y[j-1]) <= tt) {
				tt -= dis(x[j], y[j], x[j-1], y[j-1]), tans += j > i;
			} else
				break;
		}
		ans = max(ans, tans);
	}
	cout << ans << endl;
	return 0;
}
```

## [CF1304 (Div. 2) C. Air Conditioner](https://codeforces.com/contest/1304/problem/c)  1500pts..

看了题目第一眼的想法是从后往前决定每一个 $t_i$ 时刻温度应当偏低还是偏高 或者不动

然后看了一眼 $N \leq 100$ 感觉怪怪的 先写一遍再说吧

然后写的时候发现问题了，，，

应该是对于给定的时间 $d$ 和当前能取到的范围 $(l,r)$，应该将 $(l-d,r+d)$ 与下一个范围取交集，如果为空即无解

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
#define INF 0x7fffffff;
#define inf 0x3f3f3f3f;
#define MOD 998244353;
#define mod 1000000007;
typedef vector<int> VI;
typedef pair<int,int> PII;
typedef long long ll;
typedef double db;
ll gcd(ll a,ll b) { return b?gcd(b,a%b):a; }

int main() {
	cin.tie(nullptr)->sync_with_stdio(false);
	int q;
	cin >> q;
	while (q--) {
		int n, m;
		cin >> n >> m;
		vector<int> d(n+1);
		vector<pair<int,int>> line(n+1);
		d[0] = 0, line[0].fi = line[0].se = m;
		for (int i = 1; i <= n; i++)
			cin >> d[i] >> line[i].fi >> line[i].se;
		bool Flag = true;
		for (int i = 1; i <= n; i++) {
			line[i-1].fi -= (d[i]-d[i-1]);
			line[i-1].se += (d[i]-d[i-1]);
			line[i].fi = max(line[i].fi, line[i-1].fi);
			line[i].se = min(line[i].se, line[i-1].se);
			if (line[i].se < line[i].fi) {
				// cout << line[i].fi << ' ' << line[i].se << endl;
				Flag = false; break;
			}
		}
		if (Flag) puts("YES");
		else puts("NO");
	}
	return 0;
}
```

## [CF1313 (Div. 2) D. Happy New Year](https://codeforces.com/contest/1313/problem/d) 2500pts

观察了一会儿，发现 最多连续的k个区间有交集，即按左端点排序之后，任意的$r[i] < l[i+k]$

虽然k很小，但是之后就不会处理了...

------

### 题意：

给定 $n,m,k$ 和 $n$ 个区间 $[l_i,r_i]$

对于一个长为 $m$ 的初始值为 $0$ 的序列 $a$，在给定的 $n$ 个区间中选择若干个，每个区间使得 $a[l_i] - a[r_i]$ 中元素各 $+1$，保证任何时刻 $a$ 中的最大值 $\leq k$

问序列中最多可能存在的奇数个数

$n\in[1,10^5],m\in[1,10^9],k\in[1,8]$

### solution

预处理的时候把每个区间的 $(l_i,i)$ 和 $(r_i+1,-i)$ 存进去，区域拆成点来处理，显然只有这两类点处答案会有变化

从左往右枚举端点，把当前包含的区间放到 $d$ 里面，然后这个 $d$ 就莫名巧妙的滚动起来了 

$f[i][j]$ 表示到第 $i$ 个点，区间覆盖状态为$j$ 的最大答案

$j$ 中二进制下如果第 $at-1$ 位是 $1$，表示选择了 $d[at]$ 且 $d[at]$ 覆盖在当前端点上

$at$ 表示该端点在数组 $d$ 中的位置，相邻两点可以如下递推


\begin{align}
&if\ (p_i.op=1) \notag \\

&\qquad if(at\in{j})\ f[i][j]=max(f[i][j],f[i-1][j]+[|j|\in odd](p_i.w-p_{i-1}.w)) \notag \\

&\qquad if(at\notin{j})\ f[i][j\bigcup{at}]=max(f[i][j\bigcup{at}],f[i-1][j]+|j|\in{odd}(p_i.w-p_{i-1}.w-1)+[(|j|+1)\in{odd}]) \notag \\

&if\ (p_i.op=-1) \notag \\

&\qquad if(at\notin j) \notag \\

&\qquad\qquad f[i][j]=max(f[i][j],f[i-1][j]+[|j|\in{odd}](p_i.w-p_{i-1}.w))\notag \\

&\qquad\qquad f[i][j]=max(f[i][j],f[i-1][j\bigcup{at}]+[(|j|+1)\in{odd}](p_i.w-1-p_{i-1}.w)+[|j|\in{odd}]) \notag
\end{align}

分类讨论一下，然后代码能看懂，跟上面的式子好像有点出入，就前两个 $f[i][j]$ 的更新式子并不是依照 $(at\in j)$ ，而是以之前能取到的所有状态

这题是真贺了快两天还没完全看懂题解，真麻了

以后状压DP做多了再来雪耻吧..

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
#define INF 0x7fffffff;
#define inf 0x3f3f3f3f;
#define MOD 998244353;
#define mod 1000000007;
typedef vector<int> VI;
typedef pair<int,int> PII;
typedef long long ll;
typedef double db;
ll gcd(ll a,ll b) { return b?gcd(b,a%b):a; }

const int N=100010,K=10;
int n,m,k,nn;
int l[N],r[N];
struct point{
	int op,w,d;
	point(int OP=0,int W=0,int D=0){op=OP,w=W,d=D;}
} p[N<<1];
bool cmp(point x,point y){
	if(x.w==y.w) return x.op<y.op;
	return x.w<y.w;
}
int d[K],one[260];
int f[N<<1][260];
void amax(int &a,int b){a=max(a,b);}
int dp(){
	int all=(1<<k)-1;
	rep(i,1,all)one[i]=one[i-(i&-i)]+1;
	rep(i,0,nn) rep(j,0,all) f[i][j]=-inf;
	f[0][0]=0;
	rep(j,1,k) d[j]=-1;
	int now=0;
	rep(i,1,nn){
		int at=-1;
		if(p[i].op==1){
			rep(j,1,k) if(d[j]==-1){
				at=j,d[j]=p[i].d;break;
			}
			assert(~at);
			rep(j,0,now) if((j&now)==j){
				amax(f[i][j],f[i-1][j]+(one[j]&1)*(p[i].w-p[i-1].w));
				amax(f[i][j|(1<<(at-1))],f[i-1][j]+(one[j]&1)*(p[i].w-p[i-1].w-1)+((one[j]+1)&1));
			}
			now|=(1<<(at-1));
		} else{
			rep(j,1,k) if(d[j]==p[i].d){at=j,d[j]=-1;break;}
			assert(~at);
			now^=(1<<(at-1));
			rep(j,0,now) if((j&now)==j){
				amax(f[i][j],f[i-1][j]+(one[j]&1)*(p[i].w-p[i-1].w));
				amax(f[i][j],f[i-1][j|(1<<(at-1))]+((one[j]+1)&1)*(p[i].w-p[i-1].w-1)+(one[j]&1));
			}
		}
	}
	return f[nn][0];
}
int main(){
	cin.tie(nullptr)->sync_with_stdio(false);
	cin>>n>>m>>k;
	rep(i,1,n){
		cin>>l[i]>>r[i];
		p[++nn]=point(1,l[i],i);
		p[++nn]=point(-1,r[i]+1,i);
	}
	sort(p+1,p+1+nn,cmp);
	cout<<dp()<<endl;
	return 0;
}
```

## [CF1323 (Div. 2) D. Present](https://codeforces.com/contest/1323/problem/d) 2100pts..

给定长为 $n$ 的序列 $\{a\}$， $\forall 1\leq i< j\leq n$ 求出 所有的 $(a_i+a_j)$ 的相异或的值

$n\leq 400000,a_i<=10^7$

------

按位考虑每一位 $(0-indexation)$ ，对于第k位，每个数考虑 $\mod 2^{k+1}$ 的部分

两个数的和要在 $[2^k,2^{k+1})$ 和 $[2^k+2^{k+1},2^{k+2}-2]$的范围内，那么第 $k$ 位会是 $1$，所以排序之后统计一边即可

```cpp
#include <bits/stdc++.h>

using ll = long long;

int main() {
  std::cin.tie(nullptr)->sync_with_stdio(false);

  int n;
  std::cin >> n;
  std::vector<int> a(n), b(n);
  for (int i = 0; i < n; ++i)
    std::cin >> a[i];

  int ans = 0;

  for (int k = 0; k < 25; ++k) {
    for (int i = 0; i < n; ++i) {
      b[i] = a[i] & ((1 << (k + 1)) - 1);
    }
    std::sort(b.begin(), b.end());
    int d = 1 << k;
    ll cnt = 0;
    for (int i = n - 1, x = 0, y = 0, z = 0; i >= 0; --i) {
      while (x < n && b[x] + b[i] < d)
        ++x;
      while (y < n && b[y] + b[i] < d * 2)
        ++y;
      while (z < n && b[z] + b[i] < d * 3)
        ++z;
      cnt += std::max(0, std::min(i, y) - x);
      cnt += std::max(0, i - z);
    }
    if (cnt & 1)
      ans |= (1 << k);
  }
  std::cout << ans << '\n';
  return 0;
}`
```

## [CF1322 (Div. 2) C. Instant Noodles](https://codeforces.com/contest/1322/problem/C)

一开始往左半部的点去考虑了，然后发现 重复的点其实是不好处理gcd的..

然后用右半边的方式去看，因为辗转相减的原理，很容易得到 $gcd(a, b) =gcd\{a,b,a+b\}$

对于每个右半部的点，把与它关联的点放到它的集合里面，这些点可以合并，这个合并后的点集对于gcd的贡献就是右半部当前点的权值 因为之前那个式子，可以发现要考虑不同因数就是由各种左半部的点集决定的，合并之后搞一搞，复杂度还是可做的

```cpp
#include <bits/stdc++.h>

using ll = long long;

template<typename T>
inline void scan(T &x) {
  x=0; int f=1; char ch=getchar();
  while(ch<'0'||ch>'9')
    f=(ch=='-')?-1:1,ch=getchar();
  while (ch>='0'&&ch<='9')
    x=(x<<3)+(x<<1)+ch-48,ch=getchar();
  x*=f;
}

template<typename T>
inline void _write(T x) {
  if (x>=10) _write(x/10);
  putchar('0'+x%10);
}
template<typename T>
inline void write(T x) {
  if (x<0) putchar('-');
  _write(x);
}

ll gcd(ll a, ll b) {return b ? gcd(b, a % b) : a;}

int main() {
  int tt;
  scan(tt);
  while (tt--) {
    int n, m;
    scan(n), scan(m);
    std::map<std::set<int>, ll> mp;
    std::set<int>s[n+1];
    std::vector<ll> tot(n + 1, 0LL);
    for (int i = 1; i <= n; i++)
      scan(tot[i]);
    
    for (; m; --m) {
      int u, v;
      scan(u), scan(v);
      s[v].insert(u);
    }

    for (int i = 1; i <= n; ++i) {
      if (s[i].empty()) continue;
      mp[s[i]] += tot[i];
    }
    ll ans = 0;
    for (auto &it : mp) {
      if (ans) ans = gcd(ans, it.second);
      else ans = it.second;
    }
    write(ans);
    puts("");
  }
  return 0;
}
```

## [CF1325 (Div. 2) D. Ehab the Xorcist](https://codeforces.com/contest/1325/problem/d)

给定两个数 $u,v (0\leq u,v\leq 10^{18})$

求一个最短的数组，所有值异或为 $u$，和为 $v$

如果没有方案输出-1

----

显然每个数必须大于0
