---
title: 2017-2018 ICPC Central Quarter Final of NEERC - C 「Magic FootBall」
tags:
  - 思维
  - 剪枝
date: 2022.3.11
---

XY给我推荐的一道好题

<!-- more ->

我一看 人家队伍已经快把[整场](https://codeforces.com/gym/102788)做完了 就剩了一个L的计算几何

再看看me 鄙校 这个状态确实有点贻笑大方了 责任在我

等过两天也把整场补了吧 先把基本板子开完 这几场CF补完 动作要是慢点估计还跟不上出新题的速度..


至少这样下去8行

### 题目描述：

总共有n个选手 标号从$1\to n$ 从中选出k个选手 每分钟要更换一名选手 要求每次的阵容不能重复

询问t分钟内的安排 输出序号 如果不存在 输出0

给定n k t

### 样例

#### 输入1

    5 3 10

#### 输出1

    10
    1 2 3 
    1 3 4 
    2 3 4 
    1 2 4 
    1 4 5 
    2 4 5 
    3 4 5 
    1 3 5 
    2 3 5 
    1 2 5 

#### 输入2

    2 1 3

#### 输出2

    0

### Solution

XY用的是递归去移动111100000这样的安排 我还没仔细看过 看懂了更新

正常打一个爆搜 枚举所有的排列

```cpp
vector<int>pre;
void dfs(int now, int left) {
  if (left==0) {
    // code
  }
  if (n-now+1<left) return;
  if (now==n+1) return;
  pre.push_back(now);
  dfs(now+1, left-1);
  pre.pop_back();
  dfs(now+1, left);
}
```

违背题意的地方在于当前节点不选 继续往下考虑 这个时候就不止有一处不同

在这里发现一个规律 跳过当前节点继续搜索 如果不再次跳过 产生的内容是连续的

因此我们可以翻转实现前后拼接 上图说明会好一点 原谅我的劣质图示。。

![](/images/2017-2018CentralQuarter-NEERC.jpg)

那么主要的做法就很了然了 写了一遍 交上去

**Time limit exceeded on test 12..**

考虑到 $t \leq 10^5$ 然而组合数产生的数量可能会远大于这个值

所以我们对于固定的k 要尽量降低n 使得  $\tbinom{n}{k}$ 接近t

这样能够勉强卡过 不过时空开销都是xy的两倍有余了..

{% fold code %}

```cpp
#include<bits/stdc++.h>
using namespace std;
typedef vector<int> VI;
vector<int>pre;
int n,k,t;
vector<VI> dfs(int now,int las){
  if(las==0){
    vector<VI>ret; ret.push_back(pre);
    return ret;
  }
  if(n-now+1<las) return{};
  if(now==n+1) return{};
  pre.push_back(now);
  vector<VI>r1=dfs(now+1,las-1);
  pre.pop_back();
  vector<VI>r2=dfs(now+1,las);
  reverse(r2.begin(),r2.end());
  vector<VI>ret;
  for(auto v1:r1) ret.push_back(v1);
  for(auto v2:r2) ret.push_back(v2);
  if (ret.size()>=t) {
    cout<<t<<'\n';
    for(int i=0;i<t;i++)
      for(int j=0;j<k;j++)
        cout<<ret[i][j]<<((j==k-1)?'\n':' ');
    exit(0);
  }
  return ret;
}
int main(){
  cin>>n>>k>>t;
  long long v=1;
  for(int i=k+1;i<=n;i++){
    v*=i;
    v/=(i-k);
    if (v>=t){
      n=i;
      break;
    }
  }
  vector<VI>ans=dfs(1,k);
  cout<<0<<endl;
  return 0;
}
```

{% endfold %}
