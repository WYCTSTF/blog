---
title: 洛谷官方题单 「图论2-1」树
date: 2023-06-02 12:38:05
tags:
  - DFS
---

洛谷官方题单 [【图论2-1】树](https://www.luogu.com.cn/training/207#problems) 部分题解

说实话这个题单质量真的挺高的，老老实实做完大部分经典套路都会了~~(严重超纲的题给萌新做能不变强吗~~

<!-- more -->

# [P5908 猫猫和企鹅](https://www.luogu.com.cn/problem/P5908)

简单dfs

{% fold code %}
```cpp
#include<bits/stdc++.h>
using namespace std;
int main(){
  int n,d;cin>>n>>d;
  vector<vector<int>>adj(n+1);
  for(int i=1,u,v;i<n;++i)
    cin>>u>>v,adj[u].push_back(v),adj[v].push_back(u);
  int ans=0;
  function<void(int,int,int)> dfs=[&](int u,int fr,int dis){
    if(dis<=d)ans++;
    for(int&v:adj[u])
      if(v!=fr)
        dfs(v,u,dis+1);
  };
  dfs(1,-1,0);
  cout<<ans-1<<'\n';
  return 0;
}
```
{% endfold %}

# [P1099 [NOIP2007 提高组] 树网的核](https://www.luogu.com.cn/problem/P1099)

给定一颗无根带权树，找一条任意一个直径上的路径，长度不超过 $s$，使得其余的点到该路径的距离的最大值最小

点 $u$ 到路径 $p$ 的距离为 $\min_{v\in p}{d(u,v)}$

* solution

> 考虑多条直径，必然相交于同一点
> 并且我们只需要在一条直径上求最小偏心距即可

一看数据 $N\le 300$，差点没绷住😅，但是也在情理之中，一开始默认当成 $N\le 10^5$，还纳闷怎么07年的NOIP就这么残暴了

{% fold solution - 暴力 %}
直接暴力 枚举一条直径上的起点，然后路径尽可能的长，dfs一遍，$O(N^2)$
{% endfold %}

{% fold code %}
```cpp
#include <bits/stdc++.h>
#ifdef LOCAL
#include <dbg.h>
#else
#define dbg(...) 42
#endif
using namespace std;
int main() {
  int n, s;
  cin >> n >> s;
  vector<vector<pair<int, int>>> adj(n + 1);
  for (int i = 1; i < n; ++i) {
    int u, v, w;
    cin >> u >> v >> w;
    adj[u].push_back({v, w});
    adj[v].push_back({u, w});
  }
  vector<int> dis(n + 1, 0);
  int st = 1;
  function<void(int, int, int &)> dfs = [&](int u, int fr, int &ep) {
    if (dis[u] > dis[ep])
      ep = u;
    for (auto &[v, w] : adj[u])
      if (v ^ fr)
        dis[v] = dis[u] + w, dfs(v, u, ep);
  };
  dis[1] = 0;
  dfs(1, 1, st);
  dis[st] = 0;
  int ed = 0;
  dfs(st, st, ed);
  dbg(st, ed);
  vector<int> dia;
  function<void(int, int, vector<int>)> get = [&](int u, int fr,
                                                  vector<int> path) {
    if (u == ed) {
      dia = path;
    }
    for (auto &[v, w] : adj[u]) {
      if (v ^ fr) {
        path.push_back(v);
        get(v, u, path);
        path.pop_back();
      }
    }
  };
  get(st, st, {st});
  // dbg(dia);
  vector<int> dep(n + 1, 0);
  vector<vector<int>> f(n + 1, vector<int>(26, 0));
  function<void(int, int)> pre = [&](int u, int fr) {
    dep[u] = dep[fr] + 1;
    f[u][0] = fr;
    for (int i = 1; dep[u] >= (1 << i); ++i)
      f[u][i] = f[f[u][i - 1]][i - 1];
    for (auto &[v, w] : adj[u]) {
      if (v ^ fr)
        pre(v, u);
    }
  };
  dep[st] = 1;
  pre(st, 0);
  function<int(int, int)> qry = [&](int u, int v) {
    if (u == v)
      return u;
    if (dep[u] < dep[v])
      swap(u, v);
    for (int i = 20; i >= 0; --i) {
      if (dep[f[u][i]] >= dep[v])
        u = f[u][i];
    }
    if (u == v)
      return u;
    for (int i = 20; i >= 0; --i) {
      if (f[u][i] != f[v][i])
        u = f[u][i], v = f[v][i];
    }
    return f[u][0];
  };
  function<int(int, int)> getd = [&](int u, int v) {
    return dis[u] + dis[v] - 2 * dis[qry(u, v)];
  };
  bitset<310> vis;
  int maxx, ans = INT_MAX;
  vector<int> dd(n + 1, 0);
  function<void(int)> mark = [&](int u) {
    maxx = max(maxx, dd[u]);
    for (auto &[v, w] : adj[u]) {
      if (vis[v] == 0) {
        vis[v] = 1;
        dd[v] = dd[u] + w;
        mark(v);
      }
    }
  };
  // cout << "fuck\n";
  for (int i = 0, j = 0; i < dia.size(); ++i) {
    while (j + 1 < dia.size() && getd(dia[i], dia[j + 1]) <= s)
      ++j;
    vis.reset();
    fill(dd.begin(), dd.end(), 0);
    maxx = -1;
    for (int k = i; k <= j; ++k)
      vis[dia[k]] = 1;
    for (int k = i; k <= j; ++k)
      mark(dia[k]);
    ans = min(ans, maxx);
  }
  cout << ans << '\n';
  return 0;
}
```
{% endfold %}

{% fold solution - 二分 %}

偏心距求了一个$max$，又要求最小的偏心距，一看到最小值最大或者最大值最小就很容易往单调性上去想

考虑二分答案，那么对于直径上找出来的核，直径的两个端点为 $u,v$，核的两端，靠近 $u$ 的为 $p$，靠近 $v$ 的为 $q$

那么检查 $p,q$ 的距离是否 $\le s$，$u$ 到 $p$ 的距离和 $v$ 到 $q$ 的距离是否小于等于 $mid$ 值，以及直径外的点到核最远距离是否小于等于 $mid$

这样二分下来就是 $O(N\log{K})$ 的，但不知道为什么不吸氧交到 $N\le 3\times 10^5$ 的[消防](https://www.luogu.com.cn/problem/P2491)只有50分，吸了氧剩下的点勉强跑过去，hydro上的remote judge也是同样的效果

然后就是 $N\le 5\times 10^5$ 的BZOJ数据，这个我在 hydro 测的，直接[MLE](https://hydro.ac/d/bzoj/record/6489079ee3e11911225fd831)了

按理说C++17开O2的STL速度应该还是可以的，但是洛谷上吸了氧剩下的50分也是极限跑过，换了BZOJ数据（即hydro自测）也就快了100ms不到，在t的边缘

可能是fill常数太大了，按理说直接在直径上二分没什么复杂度。懒得换C风格的写法了。

{% endfold %}

{% fold code %}
```cpp
#include<bits/stdc++.h>
#ifdef LOCAL
#include"algo/debug.h" #else
#define dbg(...) 114514
#endif
using namespace std;
using i64=long long;
int main(){
  cin.tie(nullptr)->sync_with_stdio(false);
  int n,s;cin>>n>>s;
  vector<vector<pair<int,int>>>adj(n+1);
  for(int i=1,u,v,w;i<n;++i)
    cin>>u>>v>>w,adj[u].push_back({v,w}),adj[v].push_back({u,w});
  int st=0,ed=0;
  vector<int>dis(n+1,0);
  function<void(int,int,int&)>dfs=[&](int u,int fr,int &ep){
    if(dis[u]>dis[ep])ep=u;
    for(auto &[v,w]:adj[u])
      if(v^fr)
        dis[v]=dis[u]+w,dfs(v,u,ep);
  };
  dfs(1,0,st);
  dis[st]=0;
  dfs(st,0,ed);
  vector<int>dia;
  function<void(int,int,vector<int>)>get=[&](int u,int fr,vector<int>path){
    if(u==ed){dia=path;return;}
    for(auto&[v,w]:adj[u])
      if(v^fr)
        path.push_back(v),get(v,u,path),path.pop_back();
  };
  get(st,0,{st});
  //debug(dia);
  vector<int>dd(dia.size(),0);
  function<void(int)>calc=[&](int p){
    int u=dia[p];
    if(u==ed)return;
    for(auto&[v,w]:adj[u])
      if(v==dia[p+1])
        dd[p+1]=dd[p]+w,calc(p+1);
  };
  calc(0);
  //debug(dd);
  i64 low=0,high=dd.back();
  high/=2;
  //debug(dia);
  //debug(dd);
  //debug(low,high);
  int maxx=-1;
  bitset<500010>vis;
  vector<int>ddis(n+1);
  function<void(int)> mark=[&](int u){
    maxx=max(maxx,ddis[u]);
    for(auto&[v,w]:adj[u])
      if(vis[v]==0)
        vis[v]=1,ddis[v]=ddis[u]+w,mark(v);
  };
  auto check=[&](int k){
    maxx=-1;
    vis.reset();
    fill(ddis.begin(),ddis.end(),0);
    int l=0,r=dia.size()-1;
    while(l+1<dia.size()&&dd[l+1]<=k)
      ++l;
    while(r>=1&&dd[dia.size()-1]-dd[r-1]<=k)
      --r;
    for(int i=l;i<=r;++i) vis[dia[i]]=1;
    for(int i=l;i<=r;++i) mark(dia[i]);
    return (dd[r]-dd[l]<=s&&maxx<=k);
  };
  while(low+1<high){
    i64 mid=(low+high)/2;
    if(check(mid))
      high=mid;
    else
      low=mid;
  }
  cout<<low+1<<'\n';
  return 0;
}
```
{% endfold %}

{% fold solution - O(N)解法 %}

考虑单调性，在上一步二分的基础上，发现不需要二分，只要枚举直径上的核的一个端点，剩下的另一个端点保持不超过 $s$ 的距离直接移动，这样复杂度是均摊 $O(N)$ 的，也叫尺取。

那么偏心距就 $\ge \max{(dis[u,p],dis[v,q])}$

然后考虑不在直径上的点到核的偏心距，如果点到直径的路径和核没有交集，那么不会比直径的两端 $u,v$ 更远，如果有交集，那么到核的距离就是到直径的距离

故最后标记完直径上的点向外dfs一遍求最大值，并且这是一个固定的值，就是偏心距的下界之一

{% endfold %}

{% fold code %}
```cpp
#include<bits/stdc++.h>
#ifdef LOCAL
#include"algo/debug.h"
#else
#define dbg(...) 114514
#endif
using namespace std;
using i64=long long;
const int N=500010;
vector<pair<int,int>>adj[N];
bitset<N>vis;
int dis[N];
int main(){
  cin.tie(nullptr)->sync_with_stdio(false);
  int n,s;cin>>n>>s;
  for(int i=1,u,v,w;i<n;++i)
    cin>>u>>v>>w,adj[u].push_back({v,w}),adj[v].push_back({u,w});
  int st=0,ed=0;
  function<void(int,int,int&)>dfs=[&](int u,int fr,int &ep){
    if(dis[u]>dis[ep])ep=u;
    for(auto &[v,w]:adj[u])
      if(v^fr)
        dis[v]=dis[u]+w,dfs(v,u,ep);
  };
  dfs(1,0,st);
  dis[st]=0;
  dfs(st,0,ed);
  vector<int>dia;
  function<void(int,int,vector<int>)>get=[&](int u,int fr,vector<int>path){
    if(u==ed){dia=path;return;}
    for(auto&[v,w]:adj[u])
      if(v^fr)
        path.push_back(v),get(v,u,path),path.pop_back();
  };
  get(st,0,{st});
  //debug(dia);
  vector<int>dd(dia.size(),0);
  function<void(int)>calc=[&](int p){
    int u=dia[p];
    if(u==ed)return;
    for(auto&[v,w]:adj[u])
      if(v==dia[p+1])
        dd[p+1]=dd[p]+w,calc(p+1);
  };
  calc(0);
  int ans=INT_MAX;
  for(int l=0,r=0;l<dia.size();++l){
    r=max(l,r);
    while(r+1<dia.size()&&dd[r+1]-dd[l]<=s)r++;
    ans=min(ans,max(dd[l],dd[dia.size()-1]-dd[r]));
  }
  vis.reset();
  dd.resize(n+1);
  for(int&x:dia)
    dis[x]=0,vis[x]=1;
  function<void(int)>mark=[&](int u){
    ans=max(ans,dis[u]);
    for(auto&[v,w]:adj[u])
      if(vis[v]==0)
        vis[v]=1,dis[v]=dis[u]+w,mark(v);
  };
  for(int&x:dia)
    mark(x);
  cout<<ans<<'\n';
  return 0;
}
```
{% endfold %}

[P1395 会议](https://www.luogu.com.cn/problem/P1395)
==================================================

{% fold sol %}
不知道为什么，一眼就是一个树形DP

考虑 f[i] 表示代价。从父节点 $u$ 推到 $v$，即

$$f[v]=f[u]+(n-siz[v])-siz[v]$$

$siz[u]$ 表示以 $u$ 为根的子树大小

打两遍dfs即可
{% endfold %}

{% fold code %}
```cpp
#include <bits/stdc++.h>
using namespace std;
#ifdef LOCAL
#include "algo/debug.h"
#else
#define debug(...) 114514
#endif

using i64=long long;

int main() {
  cin.tie(nullptr)->sync_with_stdio(false);
  int n;
  cin>>n;
  vector<vector<int>>adj(n+1);
  for(int i=1,u,v;i<n;++i)
    cin>>u>>v,adj[u].push_back(v),adj[v].push_back(u);
  vector<int>dis(n+1),siz(n+1);
  vector<i64>f(n+1,0LL);
  function<void(int,int)> dfs=[&](int u,int fr){
    siz[u]=1;
    for(int&v:adj[u]){
      if(v^fr){
        dis[v]=dis[u]+1;
        dfs(v,u);
        siz[u]+=siz[v];
      }
    }
  };
  dis[1]=0;
  dfs(1,0);
  function<void(int,int)>mark=[&](int u,int fr){
    for(int&v:adj[u])
      if(v^fr)
        f[v]=f[u]+(n-siz[v])-siz[v],mark(v,u);
  };
  f[1]=0;
  //debug(siz);
  //debug(f);
  //debug(dis);
  for(int i=1;i<=n;++i)
    f[1]+=dis[i];
  mark(1,0);
  int pos;
  i64 minn=LONG_MAX;
  for(int i=1;i<=n;++i)
    if(minn>f[i])
      minn=f[i],pos=i;
  cout<<pos<<' '<<minn<<'\n';
  return 0;
}
```
{% endfold %}

[P3379 【模板】最近公共祖先](https://www.luogu.com.cn/problem/P3379)
==========================================================

模板题，放几种方法

{% fold 倍增 %}
最常用的方法之一
{% endfold %}

{% fold code %}
```cpp
#include <bits/stdc++.h>
using namespace std;
int main() {
  cin.tie(nullptr)->sync_with_stdio(false);
  int n, m, s;
  cin >> n >> m >> s;
  vector<vector<int>> adj(n + 1);
  for (int i = 1; i < n; ++i) {
    int u, v;
    cin >> u >> v;
    adj[u].push_back(v);
    adj[v].push_back(u);
  }
  vector<int> dep(n + 1);
  vector<vector<int>> f(n + 1, vector<int>(26, 0));
  dep[0] = 0;
  function<void(int, int)> dfs = [&](int u, int fr) {
    dep[u] = dep[fr] + 1;
    f[u][0] = fr;
    for (int i = 1; dep[u] >= (1 << i); ++i)
      f[u][i] = f[f[u][i - 1]][i - 1];
    for (auto &v : adj[u]) {
      if (v ^ fr) {
        dfs(v, u);
      }
    }
  };
  dfs(s,0);
  auto qry=[&](int u,int v){
    if(u==v)return u;
    if(dep[u]<dep[v])swap(u,v);
    for(int i=20;i>=0;--i)
      if(dep[f[u][i]]>=dep[v])
        u=f[u][i];
    if(u==v)return u;
    for(int i=20;i>=0;--i)
      if(f[u][i]!=f[v][i])
        u=f[u][i],v=f[v][i];
    return f[u][0];
  };
  for(int i=1;i<=m;++i){
    int u,v;cin>>u>>v;
    cout<<qry(u,v)<<'\n';
  }
  return 0;
}
```
{% endfold %}

{% fold 树链剖分 %}
另一种上跳方法，更像是树形结构上的分块

没有学过树剖的左转 [OI-wiki](https://oi-wiki.org/graph/hld/)
{% endfold %}

{% fold code %}
```cpp
#include <bits/stdc++.h>
using namespace std;
int main() {
  int n, m, s;
  cin >> n >> m >> s;
  vector<vector<int>>adj(n + 1);
  for (int i = 1; i < n; ++i) {
    int u, v;
    cin >> u >> v;
    adj[u].push_back(v);
    adj[v].push_back(u);
  }
  vector<int> dep(n + 1), fa(n + 1), siz(n + 1), son(n + 1);
  dep[s] = 1;
  function<void(int)> dfs1 = [&](int u) {
    son[u] = -1, siz[u] = 1;
    for (auto v : adj[u]) {
      if (!dep[v]) {
        dep[v] = dep[u] + 1, fa[v] = u;
        dfs1(v);
        siz[u] += siz[v];
        if (son[u] == -1 || siz[v] > siz[son[u]]) {
          son[u] = v;
        }
      }
    }
  };
  vector<int> top(n + 1), dfn(n + 1), rnk(n + 1);
  function<void(int, int)> dfs2 = [&](int u, int _top) {
    static int cnt = 0;
    top[u] = _top;
    dfn[u] = ++cnt;
    rnk[cnt] = u;
    if (son[u] == -1)
      return;
    dfs2(son[u], _top);
    for (auto v : adj[u]) {
      if (v != son[u] && v != fa[u])
        dfs2(v, v);
    }
  };
  dfs1(s);
  dfs2(s, s);
  auto lca = [&](int u, int v) {
    while (top[u] != top[v]) {
      if (dep[top[u]] > dep[top[v]])
        u = fa[top[u]];
      else
        v = fa[top[v]];
    }
    return dep[u] > dep[v] ? v : u;
  };
  for (int i = 1; i <= m; ++i) {
    int u, v;
    cin >> u >> v;
    cout << lca(u, v) << '\n';
  }
  return 0;
}
```
{% endfold %}

{% fold 欧拉序+RMQ %}
考虑每个节点的dfn，从 $u$ 走到 $v$ 的过程中不会经过比 $lca(u, v)$ 深度更小的节点

然后做一个区间查询最小值就行了
{% endfold %}
