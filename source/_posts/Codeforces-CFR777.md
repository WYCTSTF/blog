---
title: Codeforces Round 777 (Div. 2)「B - E」
tags: 
	- Codeforces
	- 模拟
date: 2022.3.13
mathjax: true
---

梦游了..

说实话现在也挺懵的

[题面](https://codeforces.com/contest/1647/problems)

<!-- more -->

## B. Madoka and the Elegant Gift

只检索一个 $2*2$ 区域内是否有一个面积为3的折角

比赛的时候蒙圈了 写笨了


```cpp
#include<bits/stdc++.h>
using namespace std;
int a[110][110];
int main() {
  int tt;cin>>tt;
  while(tt--){
    int n,m;cin>>n>>m;
    memset(a,0,sizeof(a));
    for(int i=1;i<=n;i++){
      string s;cin>>s;
      for(int j=0;j<m;j++)
        if(s[j]=='0') a[i][j+1]=0;
        else a[i][j+1]=1;
    }
    // 扫描线扫一下
    auto check=[&](){
      for(int i=1;i<=n;i++){
        for(int j=1;j<=m;j++){
          if(a[i][j]==1){
            if(a[i][j-1]==1&&((a[i-1][j-1]+a[i-1][j]==1)||(a[i+1][j-1]+a[i+1][j]==1))) return true;
            if(a[i][j+1]==1&&((a[i-1][j+1]+a[i-1][j]==1)||(a[i+1][j+1]+a[i+1][j]==1))) return true;
          }
        }
      }
      return false;
    };
    if(check()) puts("NO");
    else puts("YES");
  }
}
```


## C. Madoka and Childish Pranks

从下往上 从右往左构造 利用 $1 * 2$ 或者 $2 * 1$的格子可以填满除了左上角的格子

```cpp
#include <bits/stdc++.h>
using namespace std;
int tar[110][110];
struct Node {
  int x1,y1,x2,y2;
};
int main() {
  int tt;cin>>tt;
  int n,m;
  while(tt--){
    cin>>n>>m;
    memset(tar,0,sizeof(tar));
    for(int i=1;i<=n;i++){string s;cin>>s;
      for(int j=0;j<m;j++) {if(s[j]=='0') tar[i][j+1]=0; else tar[i][j+1]=1;}
    }
    if(tar[1][1]==1) {cout<<"-1"<<'\n';continue;}
    queue<Node>q;
    for(int i=n;i>=1;i--){
      for(int j=m;j>=1;j--){
        if(tar[i][j]==1){
          if(j>1) q.push({i,j-1,i,j});
          else q.push({i-1,j,i,j});
        }
      }
    }
    cout<<q.size()<<'\n';
    while(!q.empty()) {
      auto u=q.front(); q.pop();
      cout<<u.x1<<' '<<u.y1<<' '<<u.x2<<' '<<u.y2<<'\n';
    }
  }
  return 0;
}
```

## D. Madoka and the Best School in Russia

### Solution1

这个看了tutorial 说是有两种做法 DP做法能把所有的分解情况数算出来

看了好久 没有搞懂这个转移方程

另一种是大力分类讨论的思路

问的是 $x$ 能不能分解成 两种以上的方案 

使得 $k_1 * k_2 * \dots * k_a * d^a$ 其中$1\leq k_i$且$\ k_i \mod d \neq 0$

直接根据样例大力分析一波

令 $x=d^a*k$ ($k\mod d \neq 0$)

1. 如果是只是一个好数 $a=1$ 那么就寄了 因为它只有自身一种产生方法
2. 如果 $x=d^a*k$ 那么如果k不是质数 那么就能拆出第二种方案
3. 剩下的就是 $a>2$ 并且d是一个合数 那么能拆一个d满足第二个方案 不过有一个点要特判
4. 如样例中的 128 4 虽然满足第3点 但是它还是G了 因为它可以拆分成 $4*4*4*2$的形式

对于最后一个点 如果$d$是一个质数$p$的平方 $x=p^7$ 恰好会有这种不能拆d的情况


```cpp
#include<bits/stdc++.h>
using namespace std;
int prime(int x){
  for (int i=2;i*i<=x;i++) if(x%i==0) return i;
  return -1;
}
int main() {
  int tt;cin>>tt;
  while(tt--){
    int n,d,k,tot=0;cin>>n>>d;
    while(n%d==0) n/=d,tot++;
    if (tot==1) {puts("NO"); continue;} // point 1
    if (prime(n)!=-1) {puts("YES"); continue;} // point 2

    if (tot==3&&prime(d)==n&&d==prime(d)*n) {puts("NO"); continue;} // point 4
    if (tot>=3&&prime(d)!=-1) {puts("YES"); continue;} // point 3
    puts("NO");
  }
  return 0;
}
```

其实看完题解我还是很迷糊

直到在评论区看到一个印度佬求助查错 我手贱点开了记录

研究了1H 人都要麻了 才发现他的诡异写法没有考虑第四点的质数条件

如果不是质数 d能够进一步拆分 也就不会有这种始终存在 %d^2% 的情况了

这是那个大哥的错误代码


```cpp
#include<bits/stdc++.h>
#include<chrono>
using namespace std;
// ifstream fin ("test.txt");
// #define cin fin
#define ll long long
#define ld long double
#define all(v) (v).begin(), (v).end()
#define fshow(v) for(auto& x__x: v) cout << x__x << " "; cout << '\n'
#define finp(v,n) v.resize(n); for(int i=0;i<n;i++) cin>>v[i]
#define fsum(v) accumulate(all(v), 0LL)
#define fsort(v) sort(all(v))
#define fdsort(v) sort(all(v), greater<ll>())
#define fmax(v) *max_element(all(v))
#define fmin(v) *min_element(all(v))

struct mhash {
    static uint64_t splitmix64(uint64_t x) {
        x += 0x9e3779b97f4a7c15;
        x = (x ^ (x >> 30)) * 0xbf58476d1ce4e5b9;
        x = (x ^ (x >> 27)) * 0x94d049bb133111eb;
        return x ^ (x >> 31);
    }
 
    uint64_t operator()(uint64_t x) const {
        static const uint64_t FIXED_RANDOM = chrono::steady_clock::now().time_since_epoch().count();
        return splitmix64(x + FIXED_RANDOM);
    }
};
bool is_prime(ll n){
    if (n <= 3) return true;

    for (int i = 2; i <= sqrt(n); i++)
        if (n % i == 0)
            return false;
 
    return true;
}

int main(){
    ios::sync_with_stdio(false);
    cin.tie(0);
    int t;
    cin >> t;
    while (t--){
        ll x,d; cin >> x >> d;
        x /= d;
        if (!is_prime(d)){
            if (x%d == 0){
                x /= d;
                if (is_prime(x)) cout << "NO\n";
                else if (d * sqrt((double)d) == x) cout << "NO\n";
                else cout << "YES\n";
            }
            else cout << "NO\n";
        }
        else{
            if (x%d != 0){
                cout << "NO\n"; continue;
            }
            while(x%d == 0){
                x /= d;
            }
            if (is_prime(x)) cout << "NO\n";
            else cout << "YES\n";
        }
    }
    return 0;
}
```
怎么都热衷于前摇这么长的代码..

main里面这个分类不知道咋想的..

### Solution2

还有一种做法 是用dp把所有的内容算出来

## E. Madoka and the Sixth-graders

题意懒得写了 感觉有点小奇怪

首先很容易计算出变换的轮数$k$ 等于增量/每次空出的位置

那么考虑每个i变换$k$轮之后所在的位置

我一开始想的是k可能会很大 这个倒推的过程就直接糊一个结论

特别傻逼的把一个点往之前的位置挪 看变换次数%2==1？决定是否改变

我不知道为什么会这么搞一个完全没有根据的东西 然后就被第三个样例叉掉了

每次 i->p[i] 变换的这个模式好像是个蛮经典的倍增题目 恕我孤陋寡闻了..

看来要去写一写倍增的题 记得之前做的 [跑路](https://www.luogu.com.cn/problem/P1613) [开车旅行](https://www.luogu.com.cn/problem/P1081)都是19年xjb贺的题解

设$go[i][j]$表示第j个位置经过了$2^i$的变换之后所在的位置 有$go[i][j]=go[i-1][go[i-1][j]]$这个结论.. 再写了一遍式子 发现自己傻逼了 首先这个结论是对的

推的根据是go[i-1][j]这个位置是(可能)不同于j的位置 第i-1轮的时候所有的点跳$2^{i-1}$步的结果已经全部算好了 所以能用重复数据倍增.. 纠结的点奇怪了一点 别的倒没啥问题

得到了k轮之后的位置 我们知道了所有初始的$b_i$最后会到的地方

以最后的位置为下标把起始点其中起来 如果$a[i]\leq n$ 那么最靠前的$b$的值是$a[i]$

那么再维护一个坐标向量 把当前所有的起始点放进去 这里面最小的选择就是a[i]

对于剩下1-n里面没有的数字 因为对于起始位置没有要求 最后都会被置换 因此按升序放置


```cpp
#include <bits/stdc++.h>
using namespace std;
using ll=long long;
using VI=vector<int>;
const int N=101000;
int n,p[33][N],a[N],vis[N],ans[N];
vector<int>Vpos[N],Rpos[N];
int main() {
  ios_base::sync_with_stdio(false);
  cin.tie(nullptr);
  cin>>n; set<int>s;
  for (int i=1;i<=n;i++) cin>>p[0][i], s.insert(p[0][i]);
  for (int i=1;i<=n;i++) cin>>a[i];
  int maxx=*max_element(a+1,a+1+n), tt=(maxx-n)/(n-s.size());
  for (int i=1;i<=30;i++) for(int j=1;j<=n;j++)
    p[i][j]=p[i-1][p[i-1][j]];
  for (int i=1;i<=n;i++) {
    int pos=i;
    for (int j=0;j<=30;j++) if(tt&(1<<j)) pos=p[j][pos];
    Vpos[pos].push_back(i); // begin i end pos
  }
  for (int i=1;i<=n;i++) if(a[i]<=n) { // 如果对当前的结束位置有最小值要求
    ans[Vpos[i][0]]=a[i]; // 当前是a[i] 找到最靠前的b[pos]
    vis[a[i]]=1;
    for(int j=1;j<Vpos[i].size();j++) Rpos[a[i]].push_back(Vpos[i][j]); // a[i]插入之后 要把所有同一pos的位置集合起来 保证a[i]是最小的
  }
  set<int>bpos;
  for (int i=1;i<=n;i++) { // 没有位置要求的按升序放置
    if (!vis[i]) {
      int v=*bpos.begin();
      ans[v]=i;
      bpos.erase(v);
    }
    for(auto it:Rpos[i]) bpos.insert(it); // 保证最小数字是i的集合里的位置不会在选择1～i-1时出现
  }
  for(int i=1;i<=n;i++)
    cout<<ans[i]<<' ';
  return 0;
}
```


这个E搞了老半天 无语了...
