---
title: CodeTON Round 1 (Div. 1 + Div. 2, Rated, Prizes!) 「A - F」
tags:
	- 分类讨论
	- 模拟
    - Codeforces
mathjax: true
date: 2022.3.25
---

这场打的有点下饭 D竟然也是简单的分类讨论一下 只能说是不够冷静 没有仔细分析了

这几天没什么动力 也不想写什么东西 但这场比赛会补好 写完 因为白天闲时的一个念头

<!-- more -->

## [A. Good Pairs](https://codeforces.com/contest/1656/problem/A)

找到最大的数和最小的数的位置 注意顺序 输出

{% fold code %}

```cpp
#include<bits/stdc++.h>
using namespace std;
int main() {
	int tt;cin>>tt;
	while(tt--){
		int n;cin>>n;
		int Max=-1,Min=INT_MAX,p1,p2;
		for(int i=1;i<=n;i++) {
			int tem;cin>>tem;
			if(tem>Max) Max=tem,p1=i;
			if(tem<Min) Min=tem,p2=i;
		}
		if(p1>p2) p1^=p2^=p1^=p2;
		cout<<p1<<' '<<p2<<'\n';
	}
	return 0;
}
```
{% endfold %}

## [B. Subtract Operation](https://codeforces.com/contest/1656/problem/B)

经过 n-1 次操作最后的答案值是最后两个减数的差 set维护一下就好

{% fold code %}
```cpp
#include<bits/stdc++.h>
using namespace std;
int main(){
	int tt;cin>>tt;
	while(tt--){
		int n,k;cin>>n>>k;
		vector a(n,0);
		for(int i=0;i<n;i++) cin>>a[i];
		set<int>s{a.begin(),a.end()};
		bool flag=false;
		for(auto it:s) if(s.find(it+k)!=s.end()) {flag=true; break;}
		if(flag) puts("YES");
		else puts("NO");
	}
	return 0;
}
```
{% endfold %}

## [C. Make Equal With Mod](https://codeforces.com/contest/1656/problem/C)

考虑构造的方式： 找到最大的数k %k得到0 %k-1得到1

可以知道同时含有0 1的情况是处理不了的

那么如果1有出现过 就尝试把别的数变到1 就不能有连续的数字k和k+1

如果没有1 那么全部变到0 从大到小依次%当前的Max就可以做到

{% fold code %}
```cpp
#include<bits/stdc++.h>
using namespace std;
int main(){
	int tt;cin>>tt;
	while(tt--){
		int n;cin>>n; vector<int>a(n);
		bool f1=false;
		for(int i=0;i<n;i++) {cin>>a[i]; if(a[i]==1) f1=true;}
		multiset<int>s{a.begin(),a.end()};
		bool F1=false;
		if(f1) for(auto it:s) if(s.count(it+1)>=1) {F1=true; break;}
		if(F1) {puts("NO"); continue;}
		puts("YES");
	}
	return 0;
}
```
{% endfold %}

## [D. K-good](https://codeforces.com/contest/1656/problem/D)

给定一个数$n$ 判断是不是$k$个数之和 并且这$k$个数$\mod k$构成$k$的完全剩余系

如果是 输出k 不是输出-1

事实上还是分类讨论 是我想歪了.. 首先很容易得到一个东西

1. $n=[2g+(k-1)]*\frac{k}{2}\ \ if(k\mod 2=0)$

2. $n=[g+\frac{k-1}{2}]*k\ \ if(k\mod 2=1)$

$g=\sum_{i=0}^{n-1}{a_i}$ 假设$b_i=a_i*k+i$且$n=\sum_{i=0}^{n-1}b_i$

额 然后我这里十分sb的去分解因数找k去了 结果不是边界搞错就是T.. 还在想$10^{18}$估计是要Pollard Rho..

事实上注意到肯定有一个因数是奇数 那么如果是2的次幂 就可以输出-1了

但是有了答案也不能草率的输出奇数或者对应的除数作为k 不然可能会有g等于0的情况

题设要求正整数 因此不能有0的出现 因此我们要求1 2式里乘号右边那东西尽量小

{% fold code %}
```cpp
#include<bits/stdc++.h>
using namespace std;
using ll=long long;
int main(){
	ios_base::sync_with_stdio(false);
	cin.tie(nullptr);
	int tt;cin>>tt;
	while(tt--){
		ll n;cin>>n; ll k=1;
		while(n%2==0) n/=2,k*=2;
		if(n==1) cout<<"-1\n";
		else cout<<min(n,2*k)<<'\n';
	}
}
```
{% endfold %}

## [E. Equal Tree Sums](https://codeforces.com/contest/1656/problem/E)

给定n个点的树的连接情况 要求给每个点赋值$a_i$ 使得删除任意一个点之后 剩余的联通块权值和相等

要求$1\leq a_i\leq 10^5$

看了知乎几个回答 除了小岛的有分析之外别的就直接上染色+度数的方法了 然后再balabala事后分析一波 感觉不太好

这种事后分析感觉没什么帮助

首先随便画个链 可知需要设置负权 进一步能想到设置负权的原因是

假设都是正权 如果删除一个点之后 假设还剩两个联通块 如果权值能平衡 那么不删除这个这点 转而删除旁边的点

权值就势必不会平衡 进一步可知点权的贡献应该都视作-1或1

后面随便搞个Huffman树 完全二叉树 权值与度数关联这个比较好想 就是二分图染色可能是比较常用的套路 就是令一条边的影响为|1|

用度数和其相反数设置过去 一条边给两个点的贡献是-1+1=0 这样整张图的权值为0

在删除一个节点之后 设权值为k 会产生$|k|$个联通块 那么每个联通块在失去了当前节点之后 就会产生一个$-\frac{|k|}{k}$的权值

剩余的联通块于是就平衡了

{% fold code %}
```cpp
#include<bits/stdc++.h>
using namespace std;
int main() {
	int tt;cin>>tt;
	while(tt--){
		int n;cin>>n;
		vector e(n+1,vector<int>{});
		vector ans(n+1,0);
		for(int i=1;i<n;i++){ int u,v;cin>>u>>v; e[u].push_back(v),e[v].push_back(u); }
		auto dfs = [&](auto self,int u,int f,int k)->void{
			ans[u]=k*e[u].size();
			for(auto it:e[u]){
				if(it==f) continue;
				self(self,it,u,-k);
			}
		};
		dfs(dfs,1,0,1);
		for(int i=1;i<=n;i++) cout<<ans[i]<<' ';
		cout<<endl;
	}
	return 0;
}
```
{% endfold %}

## [F. Parametric MST](https://codeforces.com/contest/1656/problem/F)

给定a_i表示点权 设图G(t)由n个点和边(i,j) 边权为$a_i*a_j+t(a_i+a_j)$组成

f(t)是G(t)的最小生成树的花费 要求找出f(t)的上界 或者是INF t在实数范围内

简单分析一下 边权只考虑$t*(a_i+a_j)$ 即$t \to +\infty | t\to -\infty$

如果所有的形态都是花费>0 或者<0 那么配上$t\to\infty$就会趋向INF 不然就确保有解

之后的就不会了 有二分的感觉 但是好像不行.. 后面的内容就属于是[搬运题解](https://www.luogu.com.cn/problem/solution/CF1656F)了..

考虑固定t之后快速求出MST.. 边权变换为$(a_i+t)*(a_j+t)-t^2$ 删掉常数$t^2$ 答案就是新图的MST-$(n-1)t^2$

这个时候连边的方式就是$a_1$和$a_n$相连 然后$>0$的连向$a_1$否则$a_n$ 这个过程满足prime的要求 顺序无所谓

这个形态发生改变的过程在t取到$-a_i$的时候 然后更新上界就好了 整个过程的瓶颈在于排序

{% fold code %}
```cpp
#include <bits/stdc++.h>
#define rep(i,a,n) for(int i=a;i<n;i++)
#define per(i,a,n) for(int i=n-1;i>=a;i--)
#define max(a,b) (a>b?a:b)
#define min(a,b) (a<b?a:b)
#define mp make_pair
#define pb push_back
#define fi first
#define se second
#define il inline
#define rg register
#define SZ(x) ((int)(x).size())
#define all(x) x.begin(),x.end()
using namespace std;
typedef vector<int> VI;
typedef pair<int,int> PII;
typedef long long ll;
typedef double db;
const int INF=0x7fffffff;
const int inf=0x3f3f3f3f;
const int MOD=998244353;
const int mod=1e9+7;
ll gcd(ll a,ll b) { return b?gcd(b,a%b):a; }
// head
template<typename T>
inline void scan(T &x) {
	x=0; int f=1; char ch=getchar();
	while(ch<'0'||ch>'9')
		f=(ch=='-')?-1:1,ch=getchar();
	while (ch>='0'&&ch<='9')
		x=(x<<3)+(x<<1)+ch-48,ch=getchar();
	x*=f;
}
void solve(){
	int n;scan(n);
	vector a(n+1,0LL),sum(n+1,0LL);
	rep(i,1,n+1) scan(a[i]);
	sort(a.begin()+1,a.begin()+1+n);
	rep(i,1,n+1) sum[i]=sum[i-1]+a[i];
	if(a[1]*(n-2)+sum[n]>0||a[n]*(n-2)+sum[n]<0){
		puts("INF");
		return;
	}
	ll ans=-2e18;
	auto calc=[&](int pos,ll val)->ll{
		return -(n-1)*val*val+(a[n]+val)*(pos*val+sum[pos])+(a[1]+val)*(sum[n-1]-sum[pos]+(n-1-pos)*val);
	};
	rep(i,1,n) ans=max(ans,calc(i,-a[i]));
	cout<<ans<<endl;
}
int main() {
	int tt;scan(tt);
	while(tt--){
		solve();
	}
	return 0;
}
```
{% endfold %}

之前看小岛的回答 说F的确有二分的做法 我没啥思路 网上找了一圈也没见着 小岛还删回答了 哎..

---

这感觉已经是Div. 1C的难度了 后面的题暂时不开了 补别的场次了..
