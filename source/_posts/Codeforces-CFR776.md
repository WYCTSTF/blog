---
title: Codeforces Round 776 (Div. 3)「B - E」
tags: 
	- Codeforces
	- 模拟
date: 2022-03-09
---

Div3.. 倒开车失败

<!-- more -->

## B. DIV + MOD

$[l, r]$的区间选出一个数$x$使得对于给定的$a$有$\lfloor \frac{a}{x} \rfloor + x$ mod $a$最大

令$m=\lfloor \frac{r}{a} \rfloor$，$n=m*a$

那么显然在[l, n-1]里n-1是除数最大 模数也最大的值

在[n, r]里除数相同，r的模数更大 因此比较这两个值就好 注意还在范围内即可

```cpp
#include<cstdio>
#define max(a, b) (a>b?a:b)
int main() {
  int tt, l, r, a; scanf("%d", &tt);
  while (tt--) {
    scanf("%d%d%d", &l, &r, &a);
    int m=r/a, n=m*a, Max=-1;
    Max=max(Max, max(n-1,l)/a+max(n-1,l)%a);
    Max=max(Max, r/a+r%a);
    printf("%d\n", Max);
  }
  return 0;
}
```

## C. Weight of the System of Nested Segments

做完D开C 结果xmx本来已经不当学姐的好舔狗了 但是又被主动加上的老乡妹妹给迷住了

于是我一边打岔唠嗑一边C题看了快40min

读完题意后把最小的2n个重量拿出来就好了

```cpp
#include <bits/stdc++.h>
using namespace std;
struct Node { int u, w, p; };
int main() {
  int tt; cin>>tt;
  while (tt--) {
    int n, m, sum=0; cin>>n>>m;
    vector<Node>a(m);
    for (int i=0; i<m; i++) cin>>a[i].u>>a[i].w, a[i].p=i+1;
    sort(a.begin(), a.end(),[&](Node a, Node b){return a.w<b.w;});
    for (int i = 0; i < 2 * n; i++) sum += a[i].w;
    sort(a.begin(), a.begin()+2*n,[&](Node a,Node b){return a.u<b.u;});
    cout << sum << '\n';
    for(int i=0;i<n;i++) cout<<a[i].p<<' '<<a[2*n-1-i].p<<'\n';
  }
  return 0;
}
```

## D. Twist the Permutation

给定一个{$a_n$}，$a[i]=i$

$\forall i \in [1..n]$ 每次会把序列的前i部分往右轮换{$k_i$}步

现在给出轮换后的数组{$a'_n$} 询问每次的轮换步数

正难则反 每次都只能是向左轮换 把当前的$k \in [n, n-1 ... 1]$放到第k个位置

挺sb的一道题 29min过的 慢的离谱 后面索性就摆烂了

```cpp
#include<bits/stdc++.h>
using namespace std;
int main() {
  cin.tie(nullptr)->sync_with_stdio(false);
  int a[2010], tt, n; cin>>tt;
  stack<int>sta;
  auto turn=[&](auto self, int k) {
    if (k==0) return;
    int now=1; while (a[now]!=k) now++;
    if (now<k) {
      sta.push(now);
      vector<int>e;
      for (int i=now+1; i<=k; i++) e.push_back(a[i]);
      for (int i=1; i<=now; i++) e.push_back(a[i]);
      for (int i=0; i<k; i++) a[i+1]=e[i];
    } else
      sta.push(0);
    self(self, k-1);
  };
  for (; tt; tt--) {
    cin>>n;
    for (int i=1; i<=n; i++) cin>>a[i];
    turn(turn, n);
    while (!sta.empty()) cout<<sta.top()<<' ', sta.pop();
    cout<<'\n';
  }
}
```

## E. Rescheduling the Exam

给定一个$n$，$d$，序列{$a$}

一共有$d$天，有$n$场考试，分别会在{$a_i$}天考掉

能够调整一天的考试 令每场考试之间的间隔尽可能的长 请问最短的间隔最大是多少

所有的$a_i$升序给出

![](../../images/CFR776Ep1.png)

![](../../images/CFR776Ep2.png)


如样例所示 第2场考试调整到第12天 最短间隔从1变到2

需要最移动的位置 就是构成最小间隔的两场考试

挪动一场之后 剩下来的空间里面 放在最大的间隔居中或者是结尾(如果结尾可以放的话) 是最好的选择

那么两个点都考虑一下

```cpp
#include<bits/stdc++.h>
using namespace std;
int main(){
  int tt;cin>>tt;
  while(tt--){
    int n,d,pp,Min=INT_MAX;cin>>n>>d;
    vector a(n+1,0);
    for(int i=1;i<=n;i++){
      cin>>a[i];
      if(Min>a[i]-a[i-1]-1)Min=a[i]-a[i-1]-1,pp=i;
    }
    auto check=[&](){
      int mx=0,mn=INT_MAX;
      for(int i=1;i<n;i++)mn=min(mn,a[i]-a[i-1]-1);
      for(int i=1;i<n;i++)mx=max(mx,a[i]-a[i-1]-1);
      return min(mn,max(d-a[n-1]-1,mx-1>>1));
    };
    stack<int>sta; int k=n;
    while(k!=pp)
      sta.push(a.back()), k--, a.pop_back();
    int now=a[k]; a.pop_back();
    while(!sta.empty()) a.push_back(sta.top()),sta.pop();
    int ans=check();
    if (pp>1) a[pp-1]=now;
    ans=max(ans,check());
    cout<<ans<<'\n';
  }
  return 0;
}
```
---

这把倒开车被舔狗室友煲电话粥干扰了

不公平 重赛重赛！[doge]
