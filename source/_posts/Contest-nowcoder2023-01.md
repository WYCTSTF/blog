---
title: 2023牛客多校第一场
date: 2023-08-12 09:27:33
tags:
  - 牛客多校
---

项目和啥软比赛都要dll了。

<!-- more -->

# D. Chocolate

分类讨论一下，发现只有1*1的时候先手会输

# J. Roulette

一开始读错题了，后来发现 `输...输赢` 为一轮总是赢1块。

由 $2^r-1\geq n$ 可知当前有 $n$ 元最多输 $\log_2{n+1}$ 次，所以要连着赢 $m$ 轮，概率为

$$\prod_{x=n}^{x=n+m}(1-\frac{1}{2^{\log_2{x+1}}})$$

统一考虑所有 $\log_2{x+1}$ 相同的 $x$，复杂度就从 $O(N)$ 降到了 $O(logN)$

令概率为 $\frac{d}{dx}$，则最终求的 $a\times dx\equiv d(mod\ 998244353)$，
只要在每次更新 $d$ 的时候乘到 $a$ 上，更新 $dx$ 的时候乘对应的逆元到 $a$ 上即可。

逆元用费马小定理求一下即可。

{% fold code %}
```cpp
#include<bits/stdc++.h>
using namespace std;
using ll=long long;
const ll mod=998244353;
ll pow(ll a,ll b){
  ll ans=1;
  for(;b;b>>=1,a=a*a%mod)if(b&1)ans=ans*a%mod;
  return ans;
}
int main(){
  ll n,m;
  cin>>n>>m,m+=n;
  ll d=1,dx=1,ans=1;
  while(n<m){
    ll r=log2(n+1);
    ll lim=min(m,(1ll<<(r+1))-1);
    ll _dx=1<<r,_d=_dx-1;
    dx=dx*pow(_dx,lim-n)%mod;
    ans=(ans*pow(_d,lim-n)%mod)*pow(pow(_dx,lim-n),mod-2)%mod;
    n=lim;
  }
  cout << ans << '\n';
  // cout<<d<<' '<<dx<<'\n';
  return 0;
}
```
{% endfold %}
