---
title: Codeforces Round 802 (Div. 2)「A - D」
tags: 
  - Codeforces
date: 2022.6.21
---

好久没打CF

这场CF的上午是蓝桥杯C++国赛B组 再往前是 原神 打到3:30

下午xy突然叫我打CF 我那时候正半梦半醒地在玩原神..

然后现在凌晨2:37开始写blog 作息越来越狂野了

<!-- more -->

# [A. Optimal Path](https://codeforces.com/contest/1700/problem/A)

1 -> 2 -> .. -> m -> 2m -> nm

{% fold code %}
```cpp
#include <bits/stdc++.h>
using namespace std;
int main() {
	int tt; cin >> tt;
	while (tt--) {
		int n, m;
		cin >> n >> m;
		long long ans = 0;
		ans += 1LL * (1 + m) * m / 2;
		ans += 1LL * (m + n * m) * n / 2;
		cout << ans - m << endl;
	}
	return 0;
}
```
{% endfold %}

# [B. Palindromic Numbers](https://codeforces.com/contest/1700/problem/B)

先变到 99..999 然后看加数的第一位是不是0 是0再加上一个等长的 11...12

{% fold code %}
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
  int tt;
  cin >> tt;
  while (tt--) {
    int n;
    string s;
    cin >> n >> s;
    vector res(n,0);
    for (int i = 0; i < n; i++) {
      int tem = s[i] - '0';
      res[i]=9-tem;
    }
    if(res[0]==0){
      int more=(res[n-1]+2)/10;
      res[n-1]=(res[n-1]+2)%10;
      for(int i=n-2;i>=0;i--){
        res[i]+=more+1;
        more=res[i]/10;
        res[i]%=10;
      }
    }
    for(auto it:res)cout<<it;
    cout<<endl;
  }
  return 0;
}
```
{% endfold %}

# [C. Helping the Nature](https://codeforces.com/contest/1700/problem/C)

手推一下样例 发现得出的方式只能是从右往左或者从左往右一位位依次对齐

这里从左往右搞 $\forall i < n$ 如果 $a[i] < a[i+1]$ 打上一个标记，表示整段右边每一位都减去了a[i+1]-a[i]

然后对于所有情况考虑a[i]的时候，a[i+1]先减去标记得到真实值，记录一下a[i+1]变成a[i]的代价

统计值+a[n]的绝对值就是答案

{% fold code %}
```cpp
#include <bits/stdc++.h>

using namespace std;

#ifdef LOCAL
#include "algo/debug.h"
#else
#define debug(...) 42
#endif

#define rep(i, a, n) for (int i = a; i <= n; i++)
#define per(i, a, n) for (int i = n; i >= a; i--)
#define max(a, b) (a > b ? a : b)
#define min(a, b) (a < b ? a : b)
#define mp make_pair
#define pb push_back
#define fi first
#define se second
#define pi acos(-1)
#define il inline
#define rg register
#define SZ(x) ((int)(x).size())
#define all(x) x.begin(), x.end()
#define INF 0x7fffffff;
#define inf 0x3f3f3f3f;
#define MOD 998244353;
#define mod 1000000007;
typedef vector<int> VI;
typedef pair<int, int> PII;
typedef long long ll;
typedef double db;
ll gcd(ll a, ll b) { return b ? gcd(b, a % b) : a; }

int main() {
  int tt;
  cin >> tt;
  while (tt--) {
    int n;
    cin >> n;
    vector<ll> a(n + 1, 0);
    rep(i, 1, n) cin >> a[i];
    ll R = 0;
    ll ans = 0;
    for (int i = 1; i < n; i++) {
      a[i + 1] -= R;
      ans += abs(a[i] - a[i + 1]);
      if (a[i] < a[i + 1])
        R += a[i + 1] - a[i], a[i + 1] = a[i];
    }
    // cout << ans << endl;
    // ans += abs(a[n - 1] - a[n]);
    ans += abs(a[n]);
    cout << ans << endl;
  }
  return 0;
}
```
{% endfold %}

# [D. River Locks](https://codeforces.com/contest/1700/problem/D)

额，题意理解错了，想当然的把它看成了另一个问题。。

注意到只能从 $i \to i+1$，那么其实开 $k$ 个管子最好是开前 $k$ 个，这样最好..

假设我们有$f[i]$表示前$i$个pipes填满$n$个locks的最小时间，这个东西显然是递减的，因此我们 lower_bound 一下找到最小的$i$满足$f[i] \leq t_i$

因为流向只能是 $\ i \to i+1$ 所以要特别考虑一个东西，令$\ dp[i]$ 表示前$\ i$ 个locks被$\ i$ 个pipes填满的时间，会有 $\ dp[i-1]$ 大于$\ \lceil sum[i]/i\rceil$ 的情况，即从$\ i-1$ 个管子开到$\ i$ 的时候，第$\ i$ 个locks填满了，但是前面的还没有

因此$\ dp[i]=max(dp[i-1],\lceil sum[i]/i\rceil)$ 且同样的对于$\ f[i]$ 有

$$f[i]=max(dp[i],\lceil sum[n]/i\rceil)$$

表示只有前面的$\ dp[i]$ 限制了整体填满的时间，因为流向是单向的(双向就是弱智题了)

这样就处理出了$\ f[i]$ ，如果$\ t_i<f[n]$ 那么就是无解的，剩下的可以轻松lower_bound

lower_bound的时候，找到的是这么一个管子数量$k$，有$f[k]\leq t_i，f[k-1]>t_i$

对于$\ f[k]$ 来说，$\ f[k]=max\{\lceil sum[n]/k\rceil,\{dp[j]\mid 1\leq j\leq i\}\}$

显然，$\ t_i$ 有解$\ k$ 的时候$\ t_i>dp[i],\forall i\in[1,n]$

则 $$all\ dp\leq t_i<f[k-1]$$

故 $$f[k-1]=\frac{sum(n)}{(k-1)}>t_i\geq \frac{sum(n)}{k}$$

$$k=\lceil{\frac{sum[n]}{t_i}}\rceil$$

$\ O(N)$ 解决

```cpp
#include <bits/stdc++.h>
using namespace std;
int main() {
  int n, tem;
  cin >> n;
  long long sum = 0LL, mx = 0;
  for (int i = 1; i <= n; i++) {
    cin >> tem;
    sum += 1ll * tem;
    mx = max(mx, (sum+i-1)/i);
  }
  cin >> n;
  for (int i = 1; i <= n; i++) {
    cin >> tem;
    if (tem < mx) puts("-1");
    else cout << 1ll*(sum+tem-1)/tem << endl;
  }
  return 0;
}
```

有时候我自己都觉得自己太过无聊了hhh..
