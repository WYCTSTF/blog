---
title: Educational Codeforces Round 131
tags:
  - Codeforces
  - 二分
  - 分类讨论
date: 2022-07-15
---

那么，就到此为止吧，再做就不礼貌了

D题没出来我是真没想到，还剩45分钟的时候基本改对了，上下界推的基本没问题，但是下界算错了，我是脑瘫

只写 A - D 这种白痴题解，嗯，我就是在水博客，我是废物 (理直气壮.jpg

<!-- more -->

# [A. Grass Field](https://codeforces.com/contest/1701/problem/A)

```cpp
#include <bits/stdc++.h>
using namespace std;
int main() {
  int tt;
  cin >> tt;
  while (tt--) {
    int tem;
    int ans = 0;
    cin >> tem;ans+=tem;
    cin >> tem;ans+=tem;
    cin >> tem;ans+=tem;
    cin >> tem;ans+=tem;
    if (ans>=1&&ans<=3) puts("1");
    else if (ans==4) puts("2");
    else puts("0");
  }
  return 0;
}
```

# [B. Permutation](https://codeforces.com/contest/1701/problem/B)

$d=2$ 然后贪一下就好了

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
  ios_base::sync_with_stdio(false);
  cin.tie(nullptr);
  int tt;
  cin >> tt;
  while (tt--) {
    int n;
    cin >> n;
    vector<int>a(n, 0);
    for(int i=0;i<n;i++) a[i]=i+1;
    set<int>s{all(a)};
    cout << '2' << endl;
    vector<vector<int>> v(n+1);
    for(int i=1;i<=n;i++){
      int tem = i;
      while (s.find(tem) != s.end()) {
        s.erase(tem);
        v[i].push_back(tem);
        tem*=2;
      }
    }
    for(auto it:v){
      for(auto iter:it){
        cout<<iter<<' ';
      }
    }
    cout<<endl;
  }
  return 0;
}
```

# [C. Schedule Management](https://codeforces.com/contest/1701/problem/C)

复读了一下题意，因为对应的人干活恰好+1，所以可以二分

莫名其妙爆了一次long long，不知道为什么

```cpp
// 有 n 个工人 m 个任务
// 第 i 个任务 有 a_i 表示第 a_i 个人来做要 1 分钟，否则要两分钟
// 怎么有种二分即视感

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

#define int long long

signed main() {
  ios_base::sync_with_stdio(false);
  cin.tie(nullptr);
  int tt;
  cin>>tt;
  while(tt--){
    // cerr << tt << endl;
    int n,m;
    cin>>n>>m;
    vector<int>a(m+1,0);
    for(int i=1;i<=m;i++) cin>>a[i];
    int L=1,R=m*2,mid;
    auto check=[&](int tog)->bool{
      vector<int>tot(n+1,0);
      int sum=0;
      for (int i = 1; i <= m; i++) {
        if (tot[a[i]] < tog) tot[a[i]]++;
        else sum++;
      }
      int lim=0;
      for (int i=1;i<=n;i++)
        lim+=(tog-tot[i])/2;
      if(lim>=sum) return true;
      return false;
    };
    while(L<R){
      // cout<<"fuck"<<endl;
      mid=(L+R)>>1;
      if(check(mid)) R=mid-1;
      else L=mid+1;
    }
    while(check(L)) L--;
    while(check(L)==false) L++;
    if (check(L)==true) L--;
    if (check(L)==false) L++;
    // cerr << "fuck" << endl;
    cout<<L<<endl;
  }
  return 0;
}
```

# [D. Permutation Restoration](https://codeforces.com/contest/1701/problem/D)

$\forall i \in [1,n]$ 对于 $b[i]=0$ 的情况，$a[i]$ 上界为 $n$，下界为 $i+1$，若 $b[i]\ne0$，则下界为 $i/(b[i]+1)+1$，上界为 $i/b[i]$

我后者的下界推错了，嗯，小学学了除法和余数就能算出来的东西，我弄错了..

剩下的就是区间排个序然后分配一下，没了，这场主要难度在E、F，明天回家补

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

int main(){
  cin.tie(nullptr)->sync_with_stdio(false);
  int tt;cin>>tt;
  while(tt--){
    int n;cin>>n;VI b(n),r(n),l(n);
    vector<VI> v(n);
    rep(i,0,n-1){
      cin>>b[i];l[i]=(i+1)/(b[i]+1)+1,r[i]=b[i]==0?n:(i+1)/b[i];
      v[l[i]-1].pb(i);
    }
    VI a(n);
    set<array<int,2>>s;
    rep(i,1,n){
      for(auto it:v[i-1]) s.insert({r[it],it});
      a[(*s.begin())[1]]=i;
      s.erase(s.begin());
    }
    rep(i,0,n-1) cout<<a[i]<<" \n"[i==n-1];
  }
  return 0;
}
```

------

在家里慢悠悠的开始写E F，丝毫不为网络赛 多校和没学的东西没做题的担忧、、

这样下去可要怎么办捏

------

# [E. Text Editor](https://codeforces.com/contest/1701/problem/E)

给定一个长为 $n$ 的字符串 $s$ 和一长为 $m$ 的字符串 $t$

给定一个指针，一开始在 $s$ 的末尾，支持 左移、右移、跳到开头、跳到结尾、删除指针前的字母五种操作，问最少几次操作将 $s$ 变成 $t$

可以知道最优的操作一定是先从后面往回删，然后可能跳到开头，往后删，也可能不跳

枚举断点 $pos$

得到两个串 $s[0,pos)$ 和 $s[pos,n)$

考虑可以得到的 从 $s[pos,n)$ 中得到的$t$的后缀

令其为 $t[m-suf,m)$ $suf$从$0$到$m$

用$SUF[i]$记录$s$从后往前拿到$t[i]$的位置

显然如果$m-suf<=SUF[pos]$ 那都是可以匹配的

而且这一段的操作数就是 $n-i$

然后来考虑 $s[0,pos)$ 这里我们按了一次 home，除非 $pos=0$

我们需要知道的是从 $s[0,pos)$ 中拿到$t[0,m-suf)$的最小代价

显然我们要让 $s[0, pos)$ 的后半部分和 $t[0,m-suf)$ 尽可能的匹配

因此 LCP 最长公共前缀是影响答案的东西，这里可以用 $Z$ 函数处理

$pos - suf$ 是前缀中我们需要删掉的字符数 $pos - lcp$ 是需要移动的数量 还有一个 press home

代码看的Jiangly的，题解都看半天，我是fw..

```cpp
#include <bits/stdc++.h>

using ll = long long;

void solve() {
  int n, m;
  std::cin >> n >> m;

  std::string s, t;
  std::cin >> s >> t;

  std::vector<int> pre(m + 1), suf(m + 1);
  for (int i = 0, j = 0; i < m; ++i) {
    while (j < n && s[j] != t[i]) ++j;
    if (j == n) {puts("-1"); return;}
    pre[i + 1] = ++j;
  }

  suf[m] = n;
  for (int i = m - 1, j = n - 1; i >= 0; --i) {
    while (s[j] != t[i]) --j;
    suf[i] = j--;
  }

  std::vector lcp(n + 1, std::vector<int>(m + 1));

  // lcp[i][j] 保存了 s[i] 和 t[j] 开头的最长连续串长度
  for (int i = n - 1; i >= 0; --i) {
    for (int j = m - 1; j >= 0; --j) {
      lcp[i][j] = s[i] == t[j] ? 1 + lcp[i + 1][j + 1] : 0;
    }
  }

  int ans = n - suf[0]; // 需要移动 n - suf[0]步，如果不按一次 home

  for (int i = 0; i < m; ++i) { // 枚举按 home 的地方
    for (int j = pre[i]; j < n; ++j) { // pre[i]表示t[i-1]最靠前的选择+1的位置
      // 选择 t[i,m) 和 s[j,n) 得到能够匹配的 lcp
      int len = lcp[j][i]; // 从 i j 开始连着的长度
      if (suf[i + len] >= j + len) { // 如果不理解可以考虑一般情况
      // suf[i] >= j
        ans = std::min(ans, (j > 0) + j + (m - i - len));
        // 前缀部分要右移j次
        // 后缀部分能用的有m - i - len，这些是直接跳过的
      }
    }
  }

  ans += n - m;
  std::cout << ans << '\n';
}

int main() {
  int tt;
  std::cin >> tt;

  while (tt--) {
    solve();
  }
  return 0;
}
```

# [F. Points](https://codeforces.com/problemset/problem/1701/F)

$f_i$表示点$i$存在时，$[i+1,i+d]$中点的个数

答案就是 $\displaystyle\sum\limits_{i\in S}\frac{f_i(f_i-1)}{2}$

考虑增加一个点$i$，答案先加上 $\frac{f_i(f_i-1)}{2}$，然后对于$[i-d,i-1]$中所有存在的点$j$，$f[j]$++，每个点对答案的影响是$\frac{(f_j+1)f_j}{2}-\frac{f_j(f_j-1)}{2}=f_j$，所以答案增加一个$f_j$的区间和，然后区间+1

删除点的时候，每个$j$的影响是$-(f_j-1)$，所以删除的时候先区间修改然后区间求和

```cpp
#include <bits/stdc++.h>
#define ls p << 1
#define rs p << 1 | 1
#define mid ((l + r) >> 1)

using namespace std;
using ll = long long;

const int N = 200010;

// seg 是 以i为起点的三元组数量 建立的线段树
// tot 就区间计数
ll seg[N << 2], tot[N << 2], tag[N << 2];

void update(int p) {
  seg[p] = seg[ls] + seg[rs];
  tot[p] = tot[ls] + tot[rs];
}

void spread(int p) {
  if (tag[p] == 0)
    return;
  seg[ls] += tag[p] * tot[ls], tag[ls] += tag[p];
  seg[rs] += tag[p] * tot[rs], tag[rs] += tag[p];
  tag[p] = 0;
}

void fix(int p, int l, int r, int x, int v, int w) {
  if (l == r) {
    tot[p] = v, seg[p] = w;
    return;
  }
  spread(p);
  if (x <= mid)
    fix(ls, l, mid, x, v, w);
  else
    fix(rs, mid + 1, r, x, v, w);
  update(p);
}

void mark(int p, int l, int r, int x, int y, int d) {
  if (x <= l && r <= y) {
    seg[p] += tot[p] * d, tag[p] += d;
    return;
  }
  spread(p);
  if (x <= mid)
    mark(ls, l, mid, x, y, d);
  if (y > mid)
    mark(rs, mid + 1, r, x, y, d);
  update(p);
}

ll query(int p, int l, int r, int x, int y, ll *arr) {
  if (x <= l && r <= y)
    return arr[p];
  if (y < l || x > r)
    return 0;
  spread(p);
  ll ans = 0;
  if (x <= mid)
    ans += query(ls, l, mid, x, y, arr);
  if (y > mid)
    ans += query(rs, mid + 1, r, x, y, arr);
  return ans;
}

int main() {
  cin.tie(nullptr)->sync_with_stdio(false);

  int n = 200000, q, d;
  cin >> q >> d;

  ll ans = 0;

  while (q--) {
    int i;
    cin >> i;

    ll t = query(1, 1, n, min(i + 1, n), min(i + d, n), tot);
    if (query(1, 1, n, i, i, tot)) {
      mark(1, 1, n, max(1, i - d), max(1, i - 1), -1);
      fix(1, 1, n, i, 0, 0);
      ans -=
          t * (t - 1) / 2 + query(1, 1, n, max(1, i - d), max(1, i - 1), seg);
    } else {
      ans +=
          t * (t - 1) / 2 + query(1, 1, n, max(1, i - d), max(1, i - 1), seg);
      mark(1, 1, n, max(1, i - d), max(1, i - 1), 1);
      fix(1, 1, n, i, 1, t);
    }
    cout << ans << endl;
  }
  return 0;
}
```
