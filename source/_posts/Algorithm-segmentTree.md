---
title: 基础线段树
tag:
  - 权值线段树
  - 动态开点
  - 线段树
  - 算法模板
date: 2022-03-14
---

没啥会的东西 先从线段树开始复习..

<!-- more -->

利用二叉树的性质 节点保存区间信息

标记下传实现的是查的有多深就更新信息到哪里 尽量停留在区间层面 不然单次区间修改就是O(N)

没看到过懒标记的复杂度严格分析 不过也得看询问的情况 酱紫搞期望logn

## [线段树1](https://www.luogu.com.cn/problem/P3372)

递归建树


```cpp
#include<bits/stdc++.h>
#define ls p<<1
#define rs p<<1|1
#define mid (l+((r-l)>>1))
#define N 101000
using namespace std;
using ll=long long;
int n, m;
ll seg[N<<2], tag[N<<2];
template<typename T>
inline void scan(T &x) {
  x=0; T f=1; char ch=getchar();
  while (ch<'0'||ch>'9') f=(ch=='-')?-1:1, ch=getchar();
  while (ch<='9'&&ch>='0') x=x*10+ch-48, ch=getchar();
  x*=f;
}
void create(int p, int l, int r) {
  if (l==r) return scan(seg[p]);
  create(ls, l, mid); create(rs, mid+1,r);
  seg[p]=seg[ls]+seg[rs];
}
void mark(int p, int l, int r, ll k) {
  seg[p]+=(r-l+1)*k; tag[p]+=k;
}
void PushDown(int p, int l, int r){
  if (l==r||tag[p]==0) return;
  mark(ls, l, mid, tag[p]); mark(rs, mid+1, r, tag[p]);
  tag[p]=0;
}
void mark(int p, int l, int r, int L, int R, ll k) {
  if (L<=l&&r<=R) return mark(p, l, r, k);
  PushDown(p, l, r); if (L<=mid) mark(ls, l, mid, L, R, k);
  if (R>mid) mark(rs, mid+1, r, L, R, k);
  seg[p]=seg[ls]+seg[rs];
}
ll query(int p, int l, int r, int L, int R) {
  if (L<=l&&r<=R) return seg[p];
  PushDown(p, l, r); ll ans=0;
  if (L<=mid) ans+=query(ls, l, mid, L, R);
  if (R>mid) ans+=query(rs, mid+1, r, L, R);
  return ans;
}
int main() {
  scan(n); scan(m);
  create(1, 1, n);
  int op, l, r; ll k;
  for (; m; m--) {
    scan(op); scan(l); scan(r);
    if (op==1) scan(k), mark(1, 1, n, l, r, k);
    else cout<<query(1, 1, n, l, r)<<'\n';
  }
}
```


## [线段树2](https://www.luogu.com.cn/problem/P3373)

显然需要开两个懒标记$add[N]$, $mul[N]$

考虑这么区间$[1,3]$，先给第一个节点$+2$，那么$seg[1]$+=$(3-1+1) * 2$,$add[1]$+=$2$

然后再令节点 $1$ 乘 $4$，那么$seg[1]$ *= $4$ , $mul[1]$*=$4$

再次给节点一$+3$的时候就有问题了，如果还是直接更新这个$seg$和$add$，显然是不对的做法

所以我们点修的选择有两种，一种是先加后乘，对于新来的$add    $，如果$mul>1$，那么先令add\mul，最后统计贡献的时候会乘回来，这样运算顺序是对的，但是这种方式会有精度丢失，不好用

那么就考虑先乘后加，每次得到一个$mul$，如果有$add$，把这个$mul$的贡献给$add$也算一遍，这样再来$add$的时候就可以直接+=了
```cpp
// Where does Mongolia Top Come From ?
#include <bits/stdc++.h>
#define ls p << 1
#define rs p << 1 | 1
#define mid (l + r >> 1)
using namespace std;
using ll = long long;
const int N = 1e5 + 5;
int n, m, mod;
ll seg[N << 2], add[N << 2], mul[N << 2];
template <typename T>
inline void scan(T &x) {
  x = 0; T f = 1; char ch = getchar();
  while (ch < '0' || ch > '9') f = (ch == '-') ? -1 : 1, ch = getchar();
  while (ch <= '9' && ch >='0') x = x * 10 + ch - 48, ch = getchar();
  x *= f;
}
void upd(int p) {seg[p] = seg[ls] + seg[rs]; if (seg[p] >= mod) seg[p] -= mod;}
void create(int p, int l, int r) {
  add[p] = 0, mul[p] = 1;
  if (l == r) return scan(seg[p]);
  create(ls, l, mid); create(rs, mid + 1, r);
  upd(p);
}
void mark(int p, int l, int r, ll A, ll M) {
  seg[p] = (seg[p] * M % mod + 1ll*(r - l + 1) * A % mod) % mod;
  add[p] = (add[p] * M + A) % mod;
  mul[p] = mul[p] * M % mod;
}
void PushDown(int p, int l, int r) {
  if (add[p] == 0 && mul[p] == 1 || l == r) return;
  mark(ls, l, mid, add[p], mul[p]); mark(rs, mid + 1, r, add[p], mul[p]);
  add[p] = 0; mul[p] = 1;
}
void mark(int p, int l, int r, int L, int R, ll A, ll M) {
  if (L <= l && r <= R) return mark(p, l, r, A, M);
  PushDown(p, l, r);
  if (L <= mid) mark(ls, l, mid, L, R, A, M);
  if (R > mid) mark(rs, mid + 1, r, L, R, A, M);
  upd(p);
}
ll query(int p, int l, int r, int L, int R) {
  if (L <= l && r <= R) return seg[p];
  PushDown(p, l, r); ll ans = 0;
  if (L <= mid) ans = (ans + query(ls, l, mid, L, R)) % mod;
  if (R > mid) ans = (ans + query(rs, mid + 1, r, L, R)) % mod;
  return ans;
}
int main() {
  scan(n), scan(m), scan(mod);
  create(1, 1, n);
  for (; m; m--) {
    int op, x, y, k;
    scan(op), scan(x), scan(y);
    if (op == 1) {scan(k); mark(1, 1, n, x, y, 0, k);}
    else if (op == 2) {scan(k); mark(1, 1, n, x, y, k, 1);}
    else cout << query(1, 1, n, x, y) << endl;
  }
  return 0;
}
```


## 权值线段树

把维护的区间下标改成值域 维护的就可以是类似桶的东西

单次操作的复杂度就是$log_len$，$len$表示最大的权值

支持第k大 查询排名的动态维护

理解是好理解 码量其实也不小(对我这种手残玩家来说挺长的)

不过题目可能不会刻意设置权值范围 如果正常1e9肯定炸空间

以[普通平衡树](https://loj.ac/p/104)的模板

这种时候 要么动态开点 时空复杂度一般$O(M\ log_{2}{len}$) 不卡log的话一般不会寄

要么离散化一下 ~~要么完蛋~~

先来份动态开点的

线段树动态开点就是用变量保存下标位置 哪里要用节点哪里建立 整个数组当内存池就行了

### version 动态开点


```cpp
#include<bits/stdc++.h>
#define mid (l+((r-l)>>1))
using namespace std;
const int L=-1e7-5;
const int R=1e7+5;
const int N=1e5+5;
int n,sz,rt;
int ls[N<<5],rs[N<<5],seg[N<<5];
void pushUp(int p){seg[p]=seg[ls[p]]+seg[rs[p]];}
void mark(int &p,int l,int r,int x,int v) {
  if (!p) p=++sz;
  if (l==r){ seg[p]+=v; return ;}
  if (x<=mid) mark(ls[p],l,mid,x,v);
  else mark(rs[p],mid+1,r,x,v);
  pushUp(p);
}
int QueryCnt(int p,int l,int r,int x,int y) {
  if(!p) return 0;
  if(l==x&&r==y) return seg[p];
  if (y<=mid) return QueryCnt(ls[p],l,mid,x,y);
  else if(x>mid) return QueryCnt(rs[p],mid+1,r,x,y);
  else return QueryCnt(ls[p],l,mid,x,mid)+QueryCnt(rs[p],mid+1,r,mid+1,y);
}
int QueryNum(int p,int l,int r,int k) {
  if (l==r) return l;
  if (seg[ls[p]]>=k) return QueryNum(ls[p],l,mid,k);
  else return QueryNum(rs[p],mid+1,r,k-seg[ls[p]]);
}
int main() {
  ios_base::sync_with_stdio(false);
  cin.tie(nullptr);
  cin>>n; int op,k;
  for(int i=1;i<=n;i++){
    cin>>op>>k;
    if (op==1) mark(rt,L,R,k,1);
    if (op==2) mark(rt,L,R,k,-1);
    if (op==3) cout<<QueryCnt(rt,L,R,L,k-1)+1<<'\n';
    if (op==4) cout<<QueryNum(rt,L,R,k)<<'\n';
    if (op==5) {
      int cnt=QueryCnt(rt,L,R,L,k-1);
      cout<<QueryNum(rt,L,R,cnt)<<'\n';
    }
    if (op==6) {
      int cnt=QueryCnt(rt,L,R,L,k)+1;
      cout<<QueryNum(rt,L,R,cnt)<<'\n';
    }
  }
  return 0;
}
```


### Version 离散化

离散化的话就要求离线了。。


```cpp
#include<bits/stdc++.h>
using namespace std;
#define ls p<<1
#define rs p<<1|1
#define mid (l+((r-l)>>1))
const int N=1e5+5;
int n,tot,op[N],V[N],lsh[N],seg[N<<2];
void mark(int p,int l,int r,int q,int v){
  if (l==r) {seg[p]+=v; return;}
  if (q<=mid) mark(ls,l,mid,q,v);
  else mark(rs,mid+1,r,q,v);
  seg[p]=seg[ls]+seg[rs];
}
int QueryCnt(int p,int l,int r,int ql,int qr){
  if(l==ql&&qr==r) return seg[p];
  if (qr<=mid) return QueryCnt(ls,l,mid,ql,qr);
  else if(ql>mid) return QueryCnt(rs,mid+1,r,ql,qr);
  return QueryCnt(ls,l,mid,ql,mid)+QueryCnt(rs,mid+1,r,mid+1,qr);
}
int QueryNum(int p,int l,int r,int k){
  if (l==r) return l;
  if (k<=seg[ls]) return QueryNum(ls,l,mid,k);
  else return QueryNum(rs,mid+1,r,k-seg[ls]);
}
int main() {
  ios_base::sync_with_stdio(false);
  cin.tie(nullptr);
  cin>>n;
  for (int i=1;i<=n;i++) {
    cin>>op[i]>>V[i];
    if (op[i]!=4) lsh[++tot]=V[i];
  }
  sort(lsh+1,lsh+1+tot);
  tot=unique(lsh+1,lsh+1+tot)-lsh-1;
  for (int i=1;i<=n;i++) {
    if (op[i]!=4) V[i] = lower_bound(lsh+1,lsh+1+tot,V[i])-lsh;
    if (op[i]==1) mark(1,1,tot,V[i],1);
    if (op[i]==2) mark(1,1,tot,V[i],-1);
    if (op[i]==3) {
      if (V[i]==1) {cout<<'1'<<'\n'; continue;}
      cout<<QueryCnt(1,1,tot,1,V[i]-1)+1<<'\n';
    }
    if (op[i]==4) cout<<lsh[QueryNum(1,1,tot,V[i])]<<'\n';
    if (op[i]==5) {
      int rk=QueryCnt(1,1,tot,1,V[i]-1);
      cout<<lsh[QueryNum(1,1,tot,rk)]<<'\n';
    }
    if (op[i]==6) {
      int rk=QueryCnt(1,1,tot,1,V[i])+1;
      cout<<lsh[QueryNum(1,1,tot,rk)]<<'\n';
    }
  }
}
```


## 可持久化线段树

未完待咕..
