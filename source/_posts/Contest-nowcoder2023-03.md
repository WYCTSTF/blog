---
title: 2023牛客多校第三场
date: 2023-07-26 10:04:14
tags:
  - 牛客多校
---

又忙又菜..
<!-- more -->

# A. World Fragments I

读两个二进制数，输出差的绝对值

# D. Ama no Jaku

考虑第一列，如果有0有1，那么$\min(r_i)<\max(c_i)$势必成立，就寄了，于是每一列要么全0要么全1

然后考虑每行的状态，不难发现每列要么全0或全1的情况下整个矩阵都得是0或1

于是行和列的状态都只能有两种：第一行（列）和它的反转状态，然后$n^2$枚举一下答案即可

{% fold code %}
```cpp
#include<bits/stdc++.h>
using namespace std;
#ifdef LOCAL
#include "algo/debug.h"
#else
#define debug(...) 114514
#endif
int n;
int solve(vector<string>&v){
  int t1=1,t2=0;
  for(int i=1;i<n;++i){
    if(v[i]==v[0])t1++;
    else{
      int tag=1;
      for(int j=0;j<n;++j)
        if(v[i][j]==v[0][j])
          tag=0;
      if(tag)
        t2++;
    }
  }
  if(t1+t2!=n){
    return -1;
  }
  int tot=0;
  for(char c:v[0])if(c=='1')tot++;
  int ans = min(t1, t2) + min(n - tot, tot);
  return ans;
}
int main(){
  cin>>n;
  vector<string>v(n);
  for(int i=0;i<n;++i)
    cin>>v[i];
  debug(v);
  vector<string>_v;
  for(int j=0;j<n;++j){
    string tem="";
    for(int i=0;i<n;++i)
      tem+=v[i][j];
    _v.push_back(tem);
  }
  debug(_v);
  int ans=solve(v);
  if(ans==-1){
    cout<<"-1\n";
    return 0;
  }else{
    debug(ans);
    ans=min(ans,solve(_v));
    cout<<ans<<'\n';
  }
  return 0;
}
```
{% endfold %}

# H. Until the Blue Moon Rises

比赛的时候傻逼无比的拍了个递归上去，然后没发现，偏偏牛客把Tle也当Wa，贡献了n发罚时

用哥猜当结论分类讨论一下即可。

{% fold code %}
```cpp
#include <bits/stdc++.h>
using namespace std;
#ifdef LOCAL
#include "algo/debug.h"
#else
#define dbg(...) 42
#endif
using ll = long long;
bool check(ll k) {
  if (k == 1)
    return false;
  for (int i = 2; i * i <= k; ++i)
    if (k % i == 0)
      return false;
  return true;
}
int main() {
  int n;
  ll m = 0;
  cin >> n;
  for (int i = 1; i <= n; ++i) {
    int tem;
    cin >> tem;
    m += tem;
  }
  if (n == 1) {
    if (check(m))
      cout << "Yes";
    else
      cout << "No";
  } else if (n == 2) {
    if (m < n * 2)
      cout << "No";
    else {
      if (m % 2 == 0 || check(m - 2))
        cout << "Yes";
      else
        cout << "No";
    }
  } else {
    if (m < n * 2)
      cout << "No";
    else
      cout << "Yes";
  }
  return 0;
}
```
{% endfold %}

# J. Fine Logic

比赛的时候有个高手一直不明白什么是minimal number，我不说是谁

考虑拓扑，如果是 $DAG$ 就 $k=1$ 然后输出，否则搞一个排序和反排序，保证所有的环都在其中

{% fold code %}
```cpp
#include <bits/stdc++.h>
using namespace std;
#ifdef LOCAL
#include "algo/debug.h"
#else
#define debug(...) 42
#endif
int main() {
  int n, m;
  cin >> n >> m;
  vector<vector<int>> adj(n + 1);
  vector<int> in(n + 1, 0);
  for (int i = 1; i <= m; ++i) {
    int u, v;
    cin >> u >> v;
    in[v]++;
    adj[u].push_back(v);
  }
  set<int> q;
  for (int i = 1; i <= n; ++i) {
    if (in[i] == 0)
      q.insert(i);
  }
  vector<int> ans{};
  while (!q.empty()) {
    int u = *q.begin();
    for (int v : adj[u]) {
      if (--in[v] == 0)
        q.insert(v);
    }
    ans.push_back(u);
    q.erase(u);
  }
  if (ans.size() == n) {
    cout << "1\n";
    for (int i : ans)
      cout << i << ' ';
  } else {
    cout << "2\n";
    for (int i = 1; i <= n; ++i)
      cout << i << " \n"[i == n];
    for (int i = n; i >= 1; --i)
      cout << i << " \n"[i == 1];
  }
  return 0;
}
```
{% endfold %}
