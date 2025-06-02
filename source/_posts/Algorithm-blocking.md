---
title: 分块 学习笔记
tags:
  - 分块
  - 莫队
  - 算法模板
date: 2022.3.14
---

分块一种比较常见的区间维护手段 看[hzw的博客](http://hzwer.com/8053.html)和进阶指南学的

<!-- more -->

### [数列分块 1](https://loj.ac/p/6277)

给定一个序列{$a_n$} 两种操作 区间加法 单点查询

考虑把数列分为m块 每块打个标记 那么每次修改的元素不超过O(n/m) + 2m

根据均值不等式 显然$m = \sqrt n$时最好

单次修改就是O($\sqrt{n}$)


```cpp
#include<bits/stdc++.h>
using namespace std;
int main() {
  int n; cin.tie(nullptr)->sync_with_stdio(false); cin>>n; 
  int m=sqrt(n);
  vector a(n+1, 0), tag(n/2+2, 0), pos(n+1, 0);
  for (int i=1; i<=n; i++) cin>>a[i], pos[i]=(i-1)/m+1;
  auto add=[&](int l, int r, int c)->void {
    for (int i=l; i<=min(r,pos[l]*m); i++) a[i]+=c;
    if (pos[l]!=pos[r]) for (int i=(pos[r]-1)*m+1; i<=r; i++) a[i]+=c;
    for (int i=pos[l]+1; i<=pos[r]-1; i++) tag[i]+=c;
  };
  for (int i=1, op, l, r, c; i<=n; i++) {
    cin>>op>>l>>r>>c;
    if (op==0) add(l, r, c); else cout<<a[r]+tag[pos[r]]<<'\n';
  }
  return 0;
}
```


### [数列分块 2](https://loj.ac/p/6278)

区间加法 区间查询小于x的值的数量

考虑询问 对分好的块内重新排序 二分x 单块内查询O(log${\sqrt{n}}$)

维护加法标记的时候 头尾两个直接改元素的部分 这两个块要重新排序

```cpp
#include<bits/stdc++.h>
using namespace std;
using ll=long long;
template<typename T>
inline void scan(T &x) {
	x=0; int f=1; char ch=getchar();
	while(ch<'0'||ch>'9')
		f=(ch=='-')?-1:1,ch=getchar();
	while (ch>='0'&&ch<='9')
		x=(x<<3)+(x<<1)+ch-48,ch=getchar();
	x*=f;
}
int main(){
	int n; scan(n); int m=sqrt(n);
	vector a(n+1,0),p(n+1,0),tag(m+2,0);
	vector<int>v[505];
	for(int i=1;i<505;i++) v[i].clear();
	for(int i=1;i<=n;i++)
		scan(a[i]),p[i]=(i-1)/m+1,v[p[i]].push_back(a[i]);
	for(int i=1;i<p[n];i++)
		sort(v[i].begin(),v[i].end());
	auto trim=[&](int x)->void{
		v[x].clear();
		for(int i=(x-1)*m+1;i<=min(x*m,n);i++) v[x].push_back(a[i]);
		sort(v[x].begin(),v[x].end());
	};
	auto add=[&](int x,int y,int val)->void{
		for(int i=x;i<=min(p[x]*m,y);i++) a[i]+=val;
		trim(p[x]);
		if(p[x]!=p[y]){
			for(int i=(p[y]-1)*m+1;i<=y;++i) a[i]+=val;
			trim(p[y]);
		}
		for(int i=p[x]+1;i<p[y];i++)
			tag[i]+=val;
	};
	auto query=[&](int x,int y,int val)->int{
		int ans=0;
		for(int i=x;i<=min(p[x]*m,y);i++) if(a[i]+tag[p[x]]<val) ans++;
		if(p[x]!=p[y]){
			for(int i=(p[y]-1)*m+1;i<=y;++i)
				if(a[i]+tag[p[y]]<val) ans++;
		}
		for(int i=p[x]+1;i<p[y];i++){
			int tem=val-tag[i];
			ans+=lower_bound(v[i].begin(),v[i].end(),tem)-v[i].begin();
		}
		return ans;
	};
	for(int i=1;i<=n;i++){
		int op,x,y,val;
		scan(op); scan(x); scan(y); scan(val);
		if(op==0) add(x,y,val);
		else cout<<query(x,y,val*val)<<'\n';
	}
	return 0;
}
```

### [数列分块 3](https://loj.ac/p/6279)

区间查询改为查询一个x的前驱（最大的小于x的数） 用set维护

```cpp
#include <bits/stdc++.h>
using namespace std;
int main() {
  ios_base::sync_with_stdio(false);
  cin.tie(nullptr);
  int n;
  cin >> n;
  int m = sqrt(n);
  vector a(n + 1, 0), p(n + 1, 0), tag(m + 2, 0);
  set<int> s[m + 10];
  for (int i = 1; i <= n; i++) {
    cin >> a[i];
    p[i] = (i - 1) / m + 1;
    s[p[i]].insert(a[i]);
  }
  auto add = [&](int x, int y, int val) -> void {
    for (int i = x; i <= min(p[x] * m, y); i++) {
      s[p[x]].erase(a[i]);
      a[i] += val;
      s[p[x]].insert(a[i]);
    }
    if (p[x] != p[y]) {
      for (int i = (p[y] - 1) * m + 1; i <= y; i++) {
        s[p[y]].erase(a[i]);
        a[i] += val;
        s[p[y]].insert(a[i]);
      }
    }
    for (int i = p[x] + 1; i < p[y]; i++)
      tag[i] += val;
  };
  auto query = [&](int x, int y, int val) -> int {
		int ans=-1;
		for(int i=x;i<=min(p[x]*m,y);i++) {
      if (a[i]+tag[p[i]]<val) ans=max(a[i]+tag[p[i]],ans);
    }
    if(p[x]!=p[y]){
      for(int i=(p[y]-1)*m+1;i<=y;i++){
        if (a[i]+tag[p[i]]<val) ans=max(a[i]+tag[p[i]],ans);
      }
    }
    for (int i=p[x]+1;i<p[y];i++){
      int x=val-tag[i];
      auto it=s[i].lower_bound(x);
      if(it==s[i].begin()) continue;
      ans=max(ans,*--it+tag[i]);
    }
    return ans;
  };
  for(int i=1;i<=n;i++) {
    int f,x,y,val; cin>>f>>x>>y>>val;
    if(f==0) add(x,y,val);
    else cout<<query(x,y,val)<<'\n';
  }
  return 0;
}
```

### [数列分块 4](https://loj.ac/p/6280) 区间加法 ｜ 区间求和

```cpp
#include <bits/stdc++.h>
using namespace std;
using ll=long long;
int main() {
	ios_base::sync_with_stdio(false);
	cin.tie(nullptr);
	int n,m; cin>>n; m=sqrt(n);
	vector p(n+1,0);
	vector sum(m+5,0LL), a(n+1,0LL), tag(m+5,0LL);
	for(int i=1;i<=n;i++){
		cin>>a[i]; p[i]=(i-1)/m+1; sum[p[i]]+=a[i];
	}
	auto add=[&](int x,int y,ll val)->void{
		for(int i=x;i<=min(p[x]*m,y);i++)
			sum[p[x]]+=val,a[i]+=val;
		if(p[x]!=p[y])
			for(int i=(p[y]-1)*m+1;i<=y;i++)
				sum[p[y]]+=val,a[i]+=val;
		for(int i=p[x]+1;i<p[y];i++) sum[i]+=m*val,tag[i]+=val;
	};
	auto query=[&](int x,int y)->ll{
		ll ans=0;
		for(int i=x;i<=min(p[x]*m,y);i++) ans+=a[i]+tag[p[x]];
		if(p[x]!=p[y]) for(int i=(p[y]-1)*m+1;i<=y;i++) ans+=a[i]+tag[p[i]];
		for(int i=p[x]+1;i<p[y];i++) ans+=sum[i];
		return ans;
	};
	for(int i=1;i<=n;i++){
		int op,x,y,val;
		cin>>op>>x>>y>>val;
		if(op==0) add(x,y,val);
		else cout<<query(x,y)%(val+1)<<'\n';
	}
	return 0;
}
```

### [数列分块 5](https://loj.ac/p/6281) 区间开方 ｜ 区间求和

因为值域在$2^{31}$ 因此一个元素最多开方个几次

所以维护块信息的时候 记录元素是否都变成了1/0

如果是 那么这块就能跳过 否则 就暴力.. 暴力.. 力..

```cpp
#include <bits/stdc++.h>
using namespace std;
using ll=long long;
const int N=50010;
int n,m;
int p[N],flag[N];
ll a[N],sum[N];
template<typename T>
inline void scan(T &x) {
	x=0; int f=1; char ch=getchar();
	while(ch<'0'||ch>'9')
		f=(ch=='-')?-1:1,ch=getchar();
	while (ch>='0'&&ch<='9')
		x=(x<<3)+(x<<1)+ch-48,ch=getchar();
	x*=f;
}
void solve(int x){
	if(flag[x]==1) return;
	flag[x]=1; sum[x]=0;
	for(int i=(x-1)*m+1;i<=x*m;i++){
		a[i]=sqrt(a[i]),sum[x]+=a[i];
		if(a[i]>1) flag[x]=0;
	}
}
void add(int x,int y){
	for(int i=x;i<=min(p[x]*m,y);i++) sum[p[x]]-=a[i],a[i]=sqrt(a[i]),sum[p[x]]+=a[i];
	if(p[x]!=p[y])
		for(int i=(p[y]-1)*m+1;i<=y;i++) sum[p[y]]-=a[i],a[i]=sqrt(a[i]),sum[p[y]]+=a[i];
	for(int i=p[x]+1;i<p[y];i++)
		solve(i);
}
ll query(int x,int y){
	ll ans=0;
	for(int i=x;i<=min(p[x]*m,y);i++) ans+=a[i];
	if(p[x]!=p[y])
		for(int i=(p[y]-1)*m+1;i<=y;i++) ans+=a[i];
	for(int i=p[x]+1;i<p[y];i++)
		ans+=sum[i];
	return ans;
}
int main() {
	cin>>n; m=sqrt(n);
	for(int i=1;i<=n;i++) scan(a[i]),p[i]=(i-1)/m+1,sum[p[i]]+=a[i];
	for(int i=1;i<=n;i++){
		int op,x,y; ll val;
		scan(op),scan(x),scan(y),scan(val);
		if(op==0) add(x,y);
		else cout<<query(x,y)<<'\n';
	}
	return 0;
}
```

### [分块入门 6](https://loj.ac/p/6282) 单点插入 ｜ 单点查值

这里比较能体现分块的思想了 并不是固定的分成多少块然后操作 只是种局部暴力 均摊O($n^{\frac{3}{2}}$)的思想

如果单点插入使得一个块的内容过大 那么就需要重新分块：每$\sqrt{n}$次插入之后 来一次O(N)的重构

```cpp
#include<map>
#include<set>
#include<cmath>
#include<stack>
#include<queue>
#include<cstdio>
#include<vector>
#include<cstring>
#include<cstdlib>
#include<iostream>
#include<algorithm>
#define mod 998244353
#define pi acos(-1)
#define inf 0x7fffffff
#define ll long long
using namespace std;
ll read()
{
    ll x=0,f=1;char ch=getchar();
    while(ch<'0'||ch>'9'){if(ch=='-')f=-1;ch=getchar();}
    while(ch>='0'&&ch<='9'){x=x*10+ch-'0';ch=getchar();}
    return x*f;
}
int n,blo,m;
int v[100005];
vector<int>ve[1005];
int st[200005],top;
pair<int,int> query(int b)
{
    int x=1;
    while(b>ve[x].size())
        b-=ve[x].size(),x++;
    return make_pair(x,b-1);
}
void rebuild()
{
    top=0;
    for(int i=1;i<=m;i++)
    {
        for(vector<int>::iterator j=ve[i].begin();j!=ve[i].end();j++)
            st[++top]=*j;
        ve[i].clear();
    }
    int blo2=sqrt(top);
    for(int i=1;i<=top;i++)
        ve[(i-1)/blo2+1].push_back(st[i]);
    m=(top-1)/blo2+1;
}
void insert(int a,int b)
{
    pair<int,int> t=query(a);
    ve[t.first].insert(ve[t.first].begin()+t.second,b);
    if(ve[t.first].size()>20*blo)
        rebuild();
}
int main()
{
    n=read();blo=sqrt(n);
    for(int i=1;i<=n;i++)v[i]=read();
    for(int i=1;i<=n;i++)
        ve[(i-1)/blo+1].push_back(v[i]);
    m=(n-1)/blo+1;
    for(int i=1;i<=n;i++)
    {
        int f=read(),a=read(),b=read(),c=read();
        if(f==0)insert(a,b);
        if(f==1)
        {
            pair<int,int> t=query(b);
            printf("%d\n",ve[t.first][t.second]); 
        }
    }
    return 0;
}
```

### [数列分块 7](https://loj.ac/p/6283) 区间加法 ｜ 区间乘法 ｜ 单点查询

维护两个标记 整块乘的时候把元素和加法标记视为一个整体乘就可以了

不知道为什么mul开的时候初值为1 但是没有初始化还是出锅了..

```cpp
#include<bits/stdc++.h>
#define mod 10007LL
using namespace std;
using ll=long long;
template<typename T> inline void scan(T &x) {
	x=0; int f=1; char ch=getchar();
	while(ch<'0'||ch>'9') f=(ch=='-')?-1:1,ch=getchar();
	while (ch>='0'&&ch<='9') x=(x<<3)+(x<<1)+ch-48,ch=getchar();
	x*=f;
}
int main(){
	int n;scan(n);int m=sqrt(n);
	vector p(n+1,0); vector a(n+1,0LL),add(m+2,0LL),mul(m+2,1LL);
	for(int i=1;i<=n;i++) scan(a[i]),p[i]=(i-1)/m+1;
	auto pushdown=[&](int x){
		for(int i=(x-1)*m+1;i<=min(x*m,n);i++)
			a[i]=((a[i]*mul[x])%mod+add[x])%mod;
		mul[x]=1LL; add[x]=0LL;
	};
	auto mark=[&](int mode,int x,int y,ll val)->void{
		pushdown(p[x]);
		for(int i=x;i<=min(p[x]*m,y);i++)
			a[i]=((mode==0)?(a[i]+val):(a[i]*val))%mod;
		if(p[x]!=p[y]){
			pushdown(p[y]);
			for(int i=(p[y]-1)*m+1;i<=y;i++)
				a[i]=((mode==0)?(a[i]+val):(a[i]*val))%mod;
		}
		for(int i=p[x]+1;i<p[y];i++){
			if(!mode)add[i]=(add[i]+val)%mod;
			else add[i]=(add[i]*val)%mod,mul[i]=(mul[i]*val)%mod;
		}
	};
	for(int i=1;i<=p[n];i++) mul[i]=1,add[i]=0;
	for(int i=1;i<=n;i++){
		int op,x,y; ll val; scan(op),scan(x),scan(y),scan(val);
		if(op!=2) mark(op,x,y,val);
		else cout<<((a[y]*mul[p[y]])%mod+add[p[y]])%mod<<'\n';
	}
	return 0;
}
```

### [数列分块 8](https://loj.ac/p/6284)

只有区间询问 给定c 询问等于c的元素个数 并且把整个区间都改为c

写一次挂一次 自闭了3H..

区间分块的时候还是把位置记录下来的好..

```cpp
#include<bits/stdc++.h>
using namespace std;
using ll=long long;
int main() {
	ios_base::sync_with_stdio(false);
	cin.tie(nullptr);
	int n;
	cin>>n;
	int m=sqrt(n);
	vector a(n+1,0),p(n+1,0),L(m+2,0),R(m+2,0),tag(m+2,INT_MIN),fix(m+2,0);
	for(int i=1;i<=n;i++){
		cin>>a[i];
		p[i]=(i-1)/m+1;
		fix[p[i]]=0;
		if(L[p[i]]==0) L[p[i]]=i;
		R[p[i]]=i;
	}
	auto free=[&](int x)->void{
		if(fix[x]==0) return;
		for(int i=L[x];i<=R[x];i++)
			a[i]=tag[x];
		fix[x]=0;
	};
	auto qry=[&](int x,int y,int val)->int{
		int ans=0;
		free(p[x]);
		for(int i=x;i<=min(R[p[x]],y);i++)
			if(a[i]!=val) a[i]=val; else ans++;
		if(p[x]==p[y]) return ans;
		free(p[y]);
		for(int i=L[p[y]];i<=y;i++)
			if(a[i]!=val) a[i]=val; else ans++;
		for(int i=p[x]+1;i<p[y];i++){
			if(fix[i]==0){
				for(int j=L[i];j<=R[i];j++)
					if(a[j]==val) ans++;
				fix[i]=1; tag[i]=val;
			}else{
				if(tag[i]==val) ans+=R[i]-L[i]+1;
				else tag[i]=val;
			}
		}
		return ans;
	};
	int x,y,val;
	for(int i=1;i<=n;i++){
		cin>>x>>y>>val;
		int now=qry(x,y,val);
		cout<<now<<'\n';
	}
	return 0;
}
```

### [数列分块 9]()

如何维护带修的区间众数：[区间众数](/../file/区间众数%20-%20陈立杰.pdf)

不带修的根号魔法题.. 

双倍经验 [[Violet]蒲公英](https://www.luogu.com.cn/problem/P4168)

简单思考一下强制在线的话怎么分块

众数不满足区间可加性 很显然查询的时候 所有关联的块要放一起考虑 分开来统计的话是个假思路(废话)

所以预处理出第$i$块到第$j$块的众数

那么区间查询的时候 候选项就是连续块的众数和两边不超过$2\sqrt{n}的数字$

所以再预处理一下每个数字在前$i$个块里出现的次数 或者存了出现的位置直接查一下 就行了

设块的大小为$T$ 单次询问的复杂度为$O(N/T*logN)$ 预处理的复杂度是$O(NT)$ 计算一下得到$T=\sqrt{NlogN}$

```cpp
#include <bits/stdc++.h>
#define rep(i,a,n) for(int i=a;i<n;i++)
#define per(i,a,n) for(int i=n-1;i>=a;i--)
#define max(a,b) (a>b?a:b)
#define min(a,b) (a<b?a:b)
#define pb push_back
#define fi first
#define se second
#define pi acos(-1)
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
template<typename T>
inline void scan(T &x) {
	x=0; int f=1; char ch=getchar();
	while(ch<'0'||ch>'9')
		f=(ch=='-')?-1:1,ch=getchar();
	while (ch>='0'&&ch<='9')
		x=(x<<3)+(x<<1)+ch-48,ch=getchar();
	x*=f;
}
const int N=40010;
int a[N],p[N],val[N],lg[N]={-1};
int f[1000][1000],cnt[N];
int n,m,q,id;
map<int,int>mp;
vector<int>ve[N];
void pre(int x){
	memset(cnt,0,sizeof(cnt));
	int mx=0,ans=0;
	for(int i=(x-1)*m+1;i<=n;i++){
		cnt[a[i]]++;
		int t=p[i];
		if (cnt[a[i]]>mx||(cnt[a[i]]==mx&&val[a[i]]<val[ans]))
			ans=a[i],mx=cnt[a[i]];
		f[x][t]=ans;
	}
}
int query(int x,int y,int val){ // 查询x到y里面val出现的次数
	int t=upper_bound(all(ve[val]),y)
				-lower_bound(all(ve[val]),x);
	return t;
}
int query(int x,int y){
	int ans=inf,mx=0;
	if(p[x]+1<=p[y]-1)
		ans=f[p[x]+1][p[y]-1], mx=query(x,y,ans);
	for(int i=x;i<=min(p[x]*m,y);i++){
		int t=query(x,y,a[i]);
		if(t>mx||(t==mx&&val[a[i]]<val[ans]))
			ans=a[i],mx=t;
	}
	if(p[x]!=p[y]){
		for(int i=(p[y]-1)*m+1;i<=y;i++){
			int t=query(x,y,a[i]);
			if(t>mx||(t==mx&&val[a[i]]<val[ans]))
				ans=a[i],mx=t;
		}
	}
	return ans;
}
int main() {
	scan(n); scan(q);
	int ans=0;
	for(int i=1;i<=n;i++) lg[i]=lg[i/2]+1;
	m=sqrt(n/lg[n]);
	for(int i=1;i<=n;i++) {
		scan(a[i]);
		if(!mp[a[i]]) mp[a[i]]=++id,val[id]=a[i];
		a[i]=mp[a[i]],p[i]=(i-1)/m+1;
		ve[a[i]].pb(i); // 存位置
	}
	for(int i=1;i<=p[n];i++) pre(i);// 枚举所有的起点i 预处理f[i][]
	for(int i=1;i<=q;i++){
		int x,y; scan(x),scan(y);
		x=(x+ans-1)%n+1,y=(y+ans-1)%n+1;
		if(x>y) swap(x,y);
		ans=val[query(x,y)];
		cout<<ans<<'\n';
	}
	return 0;
}
```

LOJ上的是10w 数组开到[2000][2000]就不会RE了.. 去掉一个强制在线的ans 别的没区别..

### [磁力块](https://www.acwing.com/problem/content/252/)

暴力做法 BFS依次入队 然后用每一个石头吸引新的石头

有两个判断条件 分块的时候可以先按质量来 分成N/T段

然后显然块内按照距离重新排序 对于队头的磁石 找到一个断点块k 前面的质量小的k-1个块从各自的依次尝试进队

对于块k直接扫一遍判断因为每个点至多出入队一次 扫描过程均摊$O(1)$ 复杂度$O(n\sqrt{n})$

先按距离来 然后块内按质量也是一样

就是这个25w的数据 2s的时限 让我感觉有点奇怪 评测是个玄学..

```cpp
#include <bits/stdc++.h>
#define int long long
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
bool vis[250010];
int xX,yY,l[510],r[510],mx[510];
struct Node {int d,m,p,r;} a[250010];
bool cmpM(const Node &A,const Node &B){return A.m<B.m;}
bool cmpD(const Node &A,const Node &B){return A.d<B.d;}
signed main() {
	ios_base::sync_with_stdio(false);
	cin.tie(nullptr);
	int n;
	cin>>xX>>yY>>a[0].p>>a[0].r>>n;
	a[0].r*=a[0].r;
	rep(i,1,n){
		int x,y;cin>>x>>y>>a[i].m>>a[i].p>>a[i].r;
		a[i].d=(x-xX)*(x-xX)+(y-yY)*(y-yY), a[i].r*=a[i].r;
	}
	sort(a+1,a+1+n,cmpM);
	int len=sqrt(n),top=ceil(1.0*n/len),ans=0;
	rep(i,1,top){
		l[i]=(i-1)*len+1,r[i]=min(i*len,n);
		rep(j,l[i],r[i]) mx[i]=max(mx[i],a[j].m);
		sort(a+l[i],a+r[i]+1,cmpD);
	}
	auto check=[&](Node A,Node B)->bool{
		if(A.p>=B.m&&A.r>=B.d) return true;
		else return false;
	};
	queue<Node>q; q.push(a[0]);
	while(!q.empty()){
		auto tem=q.front(); q.pop();
		rep(i,1,top){
			if(mx[i]>tem.p) {
				rep(j,l[i],r[i]){
					if(vis[j]==1) continue;
					if(check(tem,a[j])) ans++,vis[j]=true,q.push(a[j]);
				}
				break;
			}
			while(l[i]<=r[i]&&check(tem,a[l[i]])){
				if(vis[l[i]]==true) {l[i]++; continue;}
				ans++;
				q.push(a[l[i]++]);
			}
		}
	}
	cout<<ans<<endl;
	return 0;
}
```

### [小Z的袜子](https://www.luogu.com.cn/problem/P1494)

离线做法 对M个询问进行分块 按左端点进行排序 分成$\sqrt{N}$块

每块里面对右端点排序 这样左端点差值在$\sqrt{N}$内 右端点有序

暴力每块的第一个询问 然后后面就是左右指针 + + - -

同时更新一个相同颜色数量$num[c]$的贡献值$\sum_{c}{num[c] * (num[c]-1)/2}$

```cpp
#include <bits/stdc++.h>
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
const int N=50010;
int n,m,a[N],p[N],tot[N];
ll ans,ansx[N],ansy[N];
struct Query{
	int l,r,id;
	bool operator<(const Query &A) const{
		return p[l]==p[A.l]?r<A.r:l<A.l;
	}
}qry[N];
ll query(int x){return 1LL*x*(x-1)/2;}
int main() {
	ios_base::sync_with_stdio(false);
	cin.tie(nullptr);
	cin>>n>>m;
	int len=sqrt(n);
	rep(i,1,n) cin>>a[i], p[i]=(i-1)/len+1;
	rep(i,1,m) cin>>qry[i].l>>qry[i].r,qry[i].id=i;
	sort(qry+1,qry+1+m);
	int l=1,r=0;
	auto query=[&](int x)->ll{return 1LL*x*(x-1)/2;};
	auto add=[&](int x)->void{ans+=tot[x]++;};
	auto del=[&](int x)->void{ans-=--tot[x];};
	rep(i,1,m){
		int x=qry[i].l,y=qry[i].r;
		if(x==y) {
			ansx[qry[i].id]=0,ansy[qry[i].id]=1;
			continue;
		}
		while(x<l) add(a[--l]);
		while(x>l) del(a[l++]);
		while(y<r) del(a[r--]);
		while(y>r) add(a[++r]);
		ansx[qry[i].id]=ans;
		ansy[qry[i].id]=query(y-x+1);
	}
	for(int i=1;i<=m;i++){
		ll d=gcd(ansx[i],ansy[i]);
		cout<<ansx[i]/d<<'/'<<ansy[i]/d<<endl;
	}
	return 0;
}
```
