---
title: Codeforces-CFR874
date: 2023-05-23 20:29:42
tags:
    - Codeforces
---

div. 3糕手下大分

<!-- more -->

# [G. Ksyusha and Chinchilla](https://codeforces.com/contest/1833/problems)

给定一颗 $n$ 个点的树，询问是否能通过删除若干条边，将树分为若干条3个点的链

如果可以输出方案，即删边数量以及边的编号

* solution

考虑叶子结点和它的父亲 $u$，发现这个 $siz[u]>3$ 就寄了

于是dfs一下，如果刚好子树大小=3就直接拿掉，否则就向上贡献，如果整个过程中 $siz_u> 3$，那么就寄了，最后检查一下剩下来的 $siz[root]$ 即可

{% fold code %}
```cpp
#include <bits/stdc++.h>

#ifdef LOCAL
#include <dbg.h>
#else
#define dbg(...) 42
#endif

using i64 = long long;
using u64 = unsigned long long;
using u32 = unsigned int;
using db = double;

using std::cin, std::cout;

#define rep(i,a,n) for(int i=a;i<=n;i++)
#define per(i,a,n) for(int i=n;i>=a;i--)
#define pb push_back
#define fi first
#define se second
#define pi acos(-1)
#define sz(x) ((int)(x).size())
#define all(x) x.begin(),x.end()
typedef std::vector<int> VI;
typedef std::pair<int,int> PII;

i64 gcd(i64 a,i64 b) { return b?gcd(b,a%b):a; }

void solve() {
  VI ans;
  int n;cin>>n;
  std::vector<std::vector<PII>>e(n+1);
  for(int i=1,u,v;i<n;++i){
    cin>>u>>v;
    e[u].pb({v,i});
    e[v].pb({u,i});
  }
  VI siz(n+1);
  std::function<bool(int,int)> dfs=[&](int u,int fa){
    siz[u]=1;
    for(auto &[v,pid]:e[u]){
      if(v==fa)
        continue;
      if(!dfs(v,u))return false;
      if(siz[v]==3)ans.pb(pid);
      else siz[u]+=siz[v];
    }
    return siz[u]<=3;
  };
  if (!dfs(1,-1)||siz[1]!=3){
    cout<<-1<<'\n';
    return;
  }
  cout<<sz(ans)<<'\n';
  for(int&i:ans)cout<<i<<' ';
  cout<<'\n';
}

int main() {
	int tt;
	cin >> tt;
	while (tt--) {
		solve();
	}
  return 0;
}
```
{% endfold %}
