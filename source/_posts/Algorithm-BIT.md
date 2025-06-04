---
title: 基础树状数组
tags: 
	- 树状数组
	- 算法模板
date: 2022-03-23
---

睡不着觉 根据以前写的破烂玩意儿复习一下树状数组

然后再改一改 嗯 就凌晨4点多了 mdzz..

<!-- more -->

## 树状数组

我不知道为什么总是有种先入为主的观念妨碍我对树状数组的理解...

任意一个正整数x都有唯一的二进制表示，表示为$x=2^{i_1}+2^{i_2}+...+2^{i_m}$

不妨设$i_1>i_2>i_3>i_4>...>i_m$，故区间$[1,x]$也可以分成$log\ x$个小区间：

长度为$2^{i_1}$的小区间$[1,2^{i_1}]$

长度为$2^{i_2}$的小区间$[2^{i_1}+1,2^{i_1}+2^{i_2}]$
...
长度为$2^{i_m}$的小区间$[2^{i_1}+2^{i_2}+...+2^{i_{m-1}}+1,x]$

额 然后我们就通过一种奇怪的标准将[$1,x$]进行了一个块的分

如果区间结尾为R 则区间长度就等于R的“二进制分解”下最小的2的次幂，记为lowbit(R)

例如7=4+2+1 区间分为[1,4] [5,6] [7,7] **4=$0b$100 6=$0b$110 7=$0b$111**

lowbit(4)=4 lowbit(6)=2 lowbit(7)=1 这样就很能分出一个x的区间了 只要不停的减去lowbit(x) 

就能找到上一个区间的结尾

### LowBit

lowbit(n)定义为非负整数n在二进制表示下"最低位的1及其后面所有的0"构成的数值。例如n=10的二进制表示为$(1010)_2$，则lowbit(n)=2=$(10)_2$

设$n>0$，$n$的第$k$位是1，第$0--k-1$位都是0

为了实现lowbit运算，先把n取反，此时第$k$位变为0，第$0--k-1$位都是1，再令n=n+1

这个时候$n$的第$k$位到最高位都是1，又因为$～n=-1-n$

所以lowbit(n)=n&(～n+1)=n&(-n)

所以可以计算出区间[1,x]分成的O($log x$)个小区间

```cpp
while (x > 0) {
    printf("[%d, %d]\n", x - (x & -x) + 1, x);
    x -= x & -x;
}
```

对比分块 考虑为什么需要用这种分类方式?

树状数组基于此种思想，其基本用途是维护序列的前缀和。对于给定的序列a，我们建立一个数组c，其中c[x]保存序列a的区间[x-lowbit(x)+1,x]中所有的序列a，即$\sum^x_{i=x-lowbit(x)+1}{a[i]}$

数组c可以看成一个树形结构，并且满足了一些性质：
1. 每个内部节点c[x]保存以它为根的子树中所有 **叶节点** 的和
2. 每个内部节点c[x]的子节点个数等于lowbit(x)的位数
3. 除树根外，每个内部节点c[x]的父节点是c[x+lowbit(x)]
4. 树的深度为O($logN$)
如果N不是2的整数次幂，那么树状数组就是一个具有同样性质的森林

比方说c[15] 包含了[15,15]中的区间信息 c[14]包含了[13,14]区间的信息 c[13]包含了[13,13]的区间信息

c[13]是c[14]的子节点 修改a[13] 更新c[13]的时候同样要更新c[14]

那么对于c[16] 由于lowbit(16)=16 位数是5位 子节点是 c[15] c[14] c[12] c[8]

发现一个单点更新的时候 就是一直往上加lowbit(self) 来到达包含了修改节点的、有更大区间的父节点

### 区间查询
ask(x)查询1-x的前缀和，查询区间和[x,y]显然就是ask(y)-ask(x-1)即可
根据性质1,2我们很容易写出一个 ask(int x)
```cpp
inline int ask(int x) {
    int ans=0;
    for (; x; x-=low(x)) ans+=c[x];
    return ans;
}
```

### 单点修改
前缀和意义里包含a[x]的节点全部更新即可 上文里面有解释

### [模板题1：单点修改|区间查询](https://www.luogu.com.cn/problem/P3374)

```cpp
#include<bits/stdc++.h>
#define low(x) (x&(-x))
using namespace std;
using ll=long long;
const int N=501000;
int n,m,c[N];
int main(){
	cin>>n>>m;
	for(int i=1;i<=n;i++){
		int tem; cin>>tem;
		int now=i; while(now<=n){c[now]+=tem; now+=low(now);}
	}
	auto query=[&](int x) {
		ll ans=0; while(x>0) {ans+=c[x]; x-=low(x);}
		return ans;
	};
	for(int i=1;i<=m;i++){
		int op,x,k;
		cin>>op>>x>>k;
		if(op==1) while(x<=n){c[x]+=k; x+=low(x);}
		else cout<<query(k)-query(x-1)<<endl;
	}
	return 0;
}
```

### [模板题2：区间修改|单点查询](https://loj.ac/p/131)

思考 区间修改｜单点查询时候的操作 其实是用b[i]维护差分 b[l]+=v b[r+1]-=v

这样的话前缀和b[1~x]就是一条"l r v"区间修改操作对a[x]的影响 用树状数组维护前缀和

```cpp
#define low(x) (x&-x)
const int N=5e5+10;
int n,m;
int a[N],c[N];
void add(int x,int v){for(;x<=n;x+=low(x)) c[x]+=v;}
ll ask(int x){
    ll ans=0;
    for(;x;x-=low(x)) ans+=c[x]*1LL;
    return ans;
}
int main(){
    n=read(),m=read();
    rep(i,1,n,1){int tem;a[i]=read();}
    int op,x,y,k;
    while(m--){
        op=read(),x=read();
        if(op==1){
            y=read(),k=read();
            add(y+1,-k),add(x,k);
        } else{
            cout<<a[x]+ask(x)<<endl;
        }
    }
    return 0;
}
```

分块，但是是卡常

```cpp
#include <cstdio>
#include <cmath>
const int N=501000;
int n,m,M;
int a[N],pos[N],tag[10005];
void add(int l,int r,int c){
	if(pos[l]==pos[r]) for(int i=l;i<=r;i++) a[i]+=c;
	else {
		for(int i=l;pos[i]==pos[l];i++) a[i]+=c;
		for(int i=r;pos[i]==pos[r];i--) a[i]+=c;
		for(int i=pos[l]+1;i<pos[r];i++) tag[i]+=c;
	}
}
int main() {
	scanf("%d%d",&n,&m); M=sqrt(n);
	for(int i=1;i<=n;i++) scanf("%d", &a[i]),pos[i]=(i-1)/M+1;
	for(int i=1;i<=m;i++) {
		int op,x,y,k; scanf("%d%d",&op, &x);
		if(op==1) {scanf("%d%d",&y,&k); add(x,y,k);}
		else printf("%d\n", a[x]+tag[pos[x]]);
	}
	return 0;
}
```

### [模板题3：区间修改｜区间查询](https://loj.ac/p/132)

已经知道了 $\sum\limits_{i=1}^{x}b[i]$ =∆a[x]

那么∆a[1~x]就是$\sum\limits_{i=1}^{x}\sum\limits_{j=1}^{i}b[j]$

$\sum\limits_{i=1}^{x}\sum\limits_{j=1}^{i}b[j]=\sum\limits_{i=1}^{x}(x-i+1)*b[i]$ 这个过程就是把每个b[i]的贡献单独计算一下..

![](/images/bit%20qjmo%20qjqey.png)

$$\sum\limits_{i=1}^{x}(x-i+1)*b[i]=(x+1)\sum\limits_{i=1}^{x}{b[i]} - \sum \limits_{i=1}^{x} {i * b[i]}$$

因此再开一个树状数组维护i*b[i]的前缀和 用前缀和sum[]保存a[]的原始区间信息

```cpp
#ifdef ONLINE_JUDGE
#pragma GCC optimize(2)
#endif
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
int main() {
	int n,q;scan(n),scan(q);
	vector sum(n+1,0LL);
	vector c(2,vector<ll>(n+1,0LL));
	auto add=[&](int k,int x,ll v) {
		for(;x<=n;x+=x&-x) c[k][x]+=v;
	};
	auto qry=[&](int k,int x) {
		ll ans=0; for(;x;x-=x&-x) ans+=c[k][x]; return ans;
	};
	for(int i=1;i<=n;i++)
		scan(sum[i]),sum[i]+=sum[i-1];
	for(;q;q--){
		int op,l,r; scan(op),scan(l),scan(r);
		if(op==1){
			ll v; scan(v); add(0,l,v); add(0,r+1,-v); add(1,l,l*v); add(1,r+1,-(r+1)*v);
		} else {
			ll ans=sum[r]+(r+1)*qry(0,r)-qry(1,r);
			ans-=sum[l-1]+l*qry(0,l-1)-qry(1,l-1);
			cout<<ans<<endl;
		}
	}
	return 0;
}
```

## 树状数组求逆序对

对值域建立树状数组统计 倒着拿进来 统计即可

```cpp
for(int i=n;i;i--){
	ans+=ask(a[i]-1);
	add(a[i],1);
}
```

时间复杂度O((N+M)logM)

数据范围太大的时候要先离散化 但是离散化也要排序，， 所以单纯求逆序对只要归并排序就好了

动态开点么.. 以前道听途说 在UOJ里面问了一下 EI说并没有 动态开点树状数组这种东西

个人觉得就是一种用map乱搞的做法吧.. 懒得离散化直接用一个map<int,int>来建立映射不太好

至少unordered_map是有可能随规模呈线性关系的 map么，开了O2其实不太容易被卡掉
