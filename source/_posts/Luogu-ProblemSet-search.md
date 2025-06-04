---
title: 枚举贺题记录
tags:
  - DFS
  - BFS
  - 折半枚举
date: 2022.2.7
---

练一练搜索水题

按照你谷上的[能力提升综合题单](https://www.luogu.com.cn/training/9376#problems)来写的

<!-- more -->

## 暴力枚举

### [洛谷P1019 单词接龙](https://www.luogu.com.cn/problem/P1019)

#### description:

如果两个单词之间有重叠部分  那么就可以拼接起来  两个单词不能q是包含关系

给定n个单词和一个字母k 问k起始的最长接龙是多长 每个单词最多使用两遍

#### Solution:

显然重叠的部分是越短越好

code

```cpp
#include <bits/stdc++.h>

int check(char *s1, char *s2) {
  int len1 = strlen(s1), len2 = strlen(s2);
  for (int i = 1; i < min(len1, len2); i++){
    bool flag = true;
    for (int j = 0; j < i; j++) if (s1[len1-i+j] != s2[j]) {flag=false; break;}
    if (flag) return i;
  }
  return 0;
}

int ans;
int n, tot[22];
char s[22][30];

void dfs(char *now, int len) {
  ans = max(ans, len);
  for (int i = 1; i <= n; i++) {
    if (tot[i] == 2) continue;
    int pos = check(now, s[i]);
    if (pos == 0) continue;
    tot[i]++;
    dfs(s[i], len+strlen(s[i])-pos);
    tot[i]--;
  }
}

int main() {
  // cin.tie(nullptr)->sync_with_stdio(false);
  cin >> n;
  for (int i = 1; i <= n; i++)
    scanf("%s", s[i]);
  scanf("%s", s[0] + 1);
  s[0][0] = '%';
  dfs(s[0], 1);
  cout << ans;
  return 0;
}
```

刚开始上手没读请题目 一顿敲键盘不知道在写什么...

一没有从后往前拿 而没有考虑必须打头的字母

浪费了好久的时间..

### [洛谷P5194 Scales S](https://www.luogu.com.cn/problem/P5194)

#### solution

用的折半枚举 但还没一个迷惑的剪枝快 我不理解

<!-- more -->

能选的权值单调递增并且a[i+3]>=a[i+1]+a[i+2]恒成立 所以倒着拿会更容易拿到范围内的最大值

估计也是因为这个性质 加一个判断前缀和的就跑的飞快..

N理论上不超过43 还是练了下折半枚举 实际数据可能都不超过30

折半枚举的 没有从后往前拿 就当是写板子了

```cpp
const int N = (1<<22)+5;
long long a[45], s1[N], s2[N];
long long C, ans, n, tot1, tot2;

void dfs(int l, int r, long long s, long long v[], long long &tot) {
  if (s > C) return;
  if (l > r) {v[++tot] = s; return;}
  dfs(l + 1, r, s + a[l], v, tot);
  dfs(l + 1, r, s, v, tot);
}

int main() {
  cin >> n >> C;
  // tot1 = tot2 = ans = 0;
  for (int i = 1; i <= n; i++)
    cin >> a[i];
  dfs(1, n / 2, 0, s1, tot1);
  dfs(n / 2 + 1, n,  0, s2, tot2);
  sort(s1 + 1, s1 + 1 + tot1);
  ans = s1[tot1];
  for (int i = 1; i <= tot2; i++) {
    long long now = C - s2[i];
    int pos = upper_bound(s1 + 1, s1 + 1 + tot1, now) - s1 - 1;
    ans = max(ans, s1[pos]+s2[i]);
  }
  cout << ans << endl;
  return 0;
}
```

### [洛谷P5440 [XR-2]奇迹](https://www.luogu.com.cn/problem/P5440)

#### description

T组测试数据 每次给定一个长为8位的数字 表示一个日期 YYYYMMDD的形式

每个位置上是固定的数字或者 - 表示可以填写任何数字

问有多少种可能的情况满足 DD是质数 MMDD是质数 YYYYMMDD是质数

#### solution

tnnd用爆搜写了快一下午 要不就是segment fault要不就是发现自己写假了

自闭一下午 写的破东西狗看了都摇头

后来受不了了 构造解然后对照一下 没有用线性筛预处理 勉强卡进1s

```cpp

const int day[] = {0, 31, 29, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31};

int T, n;

bool IsPrime(int x) {
  if (x == 1) return false;
  for (int i = 2; i * i <= x; i++) {
    if (x % i == 0) return false;
  }
  return true;
}

bool check(int x) {
  return (x % 4 == 0 && x % 100 != 0) || (x % 400 == 0);
}

bool check(int x, char *s) {
  for (int i = 8; i >= 1; x /= 10, i--) {
    if (s[i] == '-') continue;
    if (s[i] - '0' != x % 10) return false;
  }
  return true;
}
int main() {
  std::vector<int> v1, v2, v;
  for (int i = 1; i <= 9999; i++) {
    v1.push_back(i);
  }
  for (int i = 1; i <= 12; i++) {
    for (int j = 1; j <= day[i]; j++) {
      int x = i * 100 + j;
      if (IsPrime(x) && IsPrime(j)) v2.push_back(x);
    }
  }
  for (auto x : v1) {
    for (auto y : v2) {
      if (!check(x) && y == 229) continue; // 润！
      if (IsPrime(x * 10000 + y)) {
        v.push_back(x * 10000 + y);
      }
    }
  }
  cin >> T;
  for (int cs = 1; cs <= T; cs++) {
    char s[10];
    scanf("%s", s + 1);
    int ans = 0;
    for (auto x : v) ans += check(x, s);
    cout << ans << endl;
  }
}
```

rnm tq！

### [洛谷P1378 油滴扩展](https://www.luogu.com.cn/problem/P1378)

#### solution

全排列  题目要求输出剩余空间 被晃了一下

next_permutation

```cpp
#define PI 3.1415926535
const int N=10;
int a[N];
int n;
double x[10], y[10], r[10];
double xl, xr, yl, yr, ans;
double g1, g2, g3, g4;
vector <int> rec;

int pre(double x) {
  x *= 10;
  if ((int)x % 10 >= 5) x += 10;
  x = (int)(x) / 10;
  return (int)(x);
}

int main() {
  cin >> n;
  for (int i = 1; i <= n; i++) a[i] = i;
  cin >> g1 >> g2 >> g3 >> g4;
  xl = min(g1, g3); xr = max(g1, g3);
  yl = min(g2, g4); yr = max(g2, g4);
  for (int i = 1; i <= n; i++) cin >> x[i] >> y[i];
  ans = 0;
  do {
    rec.clear();
    for (int i = 1; i <= n; i++) r[i] = 0.0;
    for (int i = 1; i <= n; i++) {
      double x2 = x[a[i]], y2 = y[a[i]];
      double R = 0x7fffffff;
      if (!rec.empty()) {
        for (auto it : rec) {
          double x1 = x[it], y1 = y[it];
          double d = sqrt((x1 - x2) * (x1 - x2) + (y1 - y2) * (y1 - y2));
          R = min(R, max(d - r[it], 0.0));
        }
      }
      R = min(R, abs(x2 - xl)); R = min(R, abs(x2 - xr));
      R = min(R, abs(y2 - yl)); R = min(R, abs(y2 - yr));
      r[a[i]] = R; rec.push_back(a[i]);
    }
    double tem = 0;
    for (int i = 1; i <= n; i++)
      tem += r[i] * r[i] * PI;
    ans = max(ans, tem);
  } while (next_permutation(a + 1, a + 1 + n));
  cout << pre((xr - xl) * (yr - yl) - ans);
  return 0;
}
```

### [洛谷P1443 马的遍历](https://www.luogu.com.cn/problem/P1443)

#### solution

按时间顺序BFS即可

```cpp
const int X[8] = {2, 1, 2, 1, -2, -1, -2, -1};
const int Y[8] = {-1, -2, 1, 2, 1, 2, -1, -2};
queue < pair <int, int> > q;
int n, m, x, y;
int f[410][410];
bool vis[410][410];
int main() {
  cin >> n >> m >> x >> y;
  for (int i = 1; i <= n; i++) for (int j = 1; j <= m; j++)
    f[i][j] = -1, vis[i][j] = false;
  f[x][y] = 0; vis[x][y] = true; q.push({x, y});
  while (!q.empty()) {
    int xx = q.front().first, yy = q.front().second; q.pop();
    for (int i = 0; i < 8; i++) {
      int _x = xx + X[i] , _y = yy + Y[i];
      if (vis[_x][_y] || _x < 1 || _x > n || _y < 1 || _y > m) continue;
      vis[_x][_y] = true; q.push({_x, _y}); f[_x][_y] = f[xx][yy] + 1;
    }
  }
  for (int i = 1; i <= n; i++) {
    for (int j = 1; j <= m; j++)
      printf("%-5d", f[i][j]);
    puts("");
  }
  return 0;
}
```

### [P3956 [NOIP2017 普及组] 棋盘](https://www.luogu.com.cn/problem/P3956)

#### solution:

对于需要施展魔法的选择 选择和当前位置一样的颜色 贡献肯定是最优的

然后正常BFS即可

```cpp
const int dx[4]={1,0,-1,0};
const int dy[4]={0,1,0,-1};

struct Point {
  int x,y,c,s;
};
queue <Point> q;
int m,n;
int x,y,c,s,ans=0x7fffffff;
int mp[105][105],sum[105][105];

int main() {
  cin>>m>>n;
  memset(mp,-1,sizeof(mp));
  memset(sum,0x7f,sizeof(sum));
  for (int i=1; i<=n; i++) {
    cin>>x>>y>>c;
    mp[x][y]=c;
  }
  q.push((Point){1,1,mp[1][1], 0});
  while (!q.empty()) {
    x=q.front().x, y=q.front().y;
    c=q.front().c, s=q.front().s; q.pop();
    if (s > ans) continue;
    if (x==m && y==m) {
      ans = min(ans, s);
      continue;
    }
    for (int i=0; i<4; i++) {
      int xx=x+dx[i], yy=y+dy[i];
      if (xx<1 || xx>m || yy<1 || yy>m)
        continue;
      int st=mp[x][y], ed=mp[xx][yy], ss=sum[xx][yy], cs;
      if (st>=0 && ed>=0) { // 合理移动
        cs=s+(st==ed?0:1);
        if(cs<ss){
          q.push((Point){xx,yy,ed,cs});
          sum[xx][yy]=cs;
        }
      } else if(st>=0 && ed<0) { // 施展魔法 [doge]
        if (s+2<ss) {
          q.push((Point){xx,yy,st,s+2});
          sum[xx][yy]=s+2;
        }
      } else if(st<0 && ed>=0){
        cs=s+(c==ed?0:1);
        if (cs<ss) {
          q.push((Point){xx,yy,ed,cs});
          sum[xx][yy]=cs;
        }
      }
    }
  }
  if (ans==0x7fffffff) cout<<"-1";
  else cout<<ans;
  return 0;
}
```

### [洛谷 P1032 [NOIP2002 提高组] 字串变换](https://www.luogu.com.cn/problem/P1032)

#### solution1:

BFS 正常的替换队头能替换的部分 如果是重复出现的字符串忽略 即可

但是莫名其妙被卡了最后第5个点

发现是map炸了 因为我用 map<string,int> 去保存对应的string需要的步数

在这个基础上做一些奇怪的剪枝 老刻舟求剑了 BFS本身就是随时间递增 答案肯定是最优的

然后45ms -> 1.2s 一开始还怀疑到string的push_back上去了 hhhh

```cpp
#include <bits/stdc++.h>
using namespace std;
string start, target;
string a[10], b[10];
int tot;
map<string, int>mp;
queue<pair<string,int>>q;

int main() {
  tot = 1;
  cin >> start >> target;
  while (cin >> a[tot] >> b[tot]) tot++;
  tot--;
  q.push({start,0});
  string x, y, z;
  int step;
  int ans=-1;
  while(!q.empty()) {
    x = q.front().first;
    step = q.front().second;
    q.pop();
    if (mp.count(x) == 1) continue;
    if (x==target) {ans=step; break;}
    mp[x] = 1;
    for (int k = 1; k <= tot; k++) {
      y = a[k], z = b[k];
      for (int i = 0; i <= max(-1, (int)(x.size() - y.size())); i++) {
        if (x[i] == y[0]) {
          bool flag = true;
          for (int j = 0;j < (int)y.size(); j++)
            if (x[i+j] != y[j]) {flag = false; break;}
          if (flag) {
            string ans="";
            int siz=-1;
            for (int j = 0; j < i; j++) ans+=x[j];
            for (int j = 0; j < (int)z.size(); j++) ans+=z[j];
            for (int j = i + y.size(); j < (int)x.size(); j++) ans+=x[j];
            q.push({ans, step + 1});
          }
        }
      }
    }
  }
  if (ans==-1||ans>10) puts("NO ANSWER!");
  else cout << ans;
  return 0;
}
```

### [洛谷 P1126 机器人搬重物](https://www.luogu.com.cn/problem/P1126)

#### solution:

正常BFS 每一步走 1 2 3步或者转向

记录每个点以及朝向情况来判重

注意机器人在网格上走 本身有宽度 不能碰壁 障碍物是网格 标记要打给四个角

```cpp
char ch;
int n, m, step;
int sx, sy, ex, ey;
const int dx[][3] = {{0, 0, 0}, {-1, -2, -3}, {0, 0, 0}, {1, 2, 3}};
const int dy[][3] = {{-1, -2, -3}, {0, 0, 0}, {1, 2, 3}, {0, 0, 0}};
bool a[55][55], vis[55][55][5];
struct Node {
  int x, y, d;
};
queue<pair<Node,int>>q;
int main() {
  cin >> n >> m;
  for (int i = 1; i <= n; i++) {
    for (int j = 1; j <= m; j++) {
      cin >> a[i][j];
      if (a[i][j] == true)
        a[i-1][j] = a[i-1][j-1] = a[i][j-1] = true;
    }
  }
  cin >> sx >> sy >> ex >> ey >> ch;
  Node g; a[sx][sy] = 1;
  if (ch == 'W') g.d = 0;
  if (ch == 'E') g.d = 2;
  if (ch == 'N') g.d = 1;
  if (ch == 'S') g.d = 3;
  g.x = sx, g.y = sy;
  vis[sx][sy][g.d] = 1;
  q.push({g, 0});
  while (!q.empty()) {
    g = q.front().first;
    int x, y;
    step = q.front().second;
    q.pop();
    if (g.x == ex && g.y == ey) {
      cout << step << endl;
      return 0;
    }
    for (int i = 0; i < 3; i++) { // 走三步
      x = g.x + dx[g.d][i], y = g.y + dy[g.d][i];
      if (x < 1 || x >= n || y < 1 || y >= m || a[x][y]) break;
      if (vis[x][y][g.d]) continue;
      vis[x][y][g.d] = true;
      q.push({(Node){x, y, g.d}, step + 1});
    }
    int D = g.d + 1;
    if (g.d + 1 == 4) D = 0;
    if (!vis[g.x][g.y][D])
      vis[g.x][g.y][D] = true, q.push({(Node){g.x, g.y, D}, step + 1});
    D = g.d - 1;
    if (g.d - 1 == -1) D = 3;
    if (!vis[g.x][g.y][D])
      vis[g.x][g.y][D] = true, q.push({(Node){g.x, g.y, D}, step + 1});
  }
  puts("-1");
  return 0;
}
```

## 记忆化搜索

这个基础的东西 之前每次碰到的时候 都是下次一定

以至于我还从来没写过一道记搜的题目

说起来这个是dp的思路 为什么分类在搜索里面 emmm

没必要当一个 algorithm lawyer 斤斤计较

[洛谷日报的教学](https://www.luogu.com.cn/blog/interestingLSY/memdfs-and-dp) 也就是OIwiki上的 讲的还行

现在的理解就是记搜就是利用重叠的信息 降低复杂度

### [洛谷 P1514 [NOIP2010 提高组] 引水入城](https://www.luogu.com.cn/problem/P1514)

每个起点能够覆盖的路径不会发生交叉

如果分叉 有地方留不到 那么这个点就寄了 之后的源点也覆盖不了它

那么产生的区间就是左端点单调递增的

记搜的时候 如果一个点已经搜过了 那么这个点维护的左端点和右端点信息可以直接拿来用

最后贪心一下即可

```cpp
const int dx[4] = {-1, 0, 1, 0}, dy[4] = {0, -1, 0, 1};
int n, m, cnt, L = 0, R;
bool vis[505][505], flag;
int main() {
  cin >> n >> m;
  vector h(n, vector<int>(m)), l(n, vector<int>(m, 0x3f3f3f3f)), r(n, vector<int>(m, 0));
  for (int i = 0; i < n; i++)
    for (int j = 0; j < m; j++)
      cin >> h[i][j];
  for (int i = 0; i < m; i++)
    l[n-1][i] = r[n-1][i] = i;
  auto bfs = [&](auto self, int x, int y) -> void {
    vis[x][y] = true;
    for (int i = 0; i < 4; i++) {
      int xx = x + dx[i], yy = y + dy[i];
      if (xx < 0 || xx >= n || yy < 0 || yy >= m || h[xx][yy] >= h[x][y]) continue;
      if (vis[xx][yy] == false) self(self, xx, yy); // 记搜部分 可以利用到已经搜过的部分
      l[x][y] = min(l[x][y], l[xx][yy]);
      r[x][y] = max(r[x][y], r[xx][yy]);
    }
  };
  for (int i = 0; i < m; i++)
    if (vis[0][i] == false)
      bfs(bfs, 0, i);
  for (int j = 0; j < m; j++)
    if (vis[n-1][j] == false)
      flag = true, cnt++;
  if (flag) {
    cout << '0' << '\n' << cnt << '\n';
    return 0;
  }
  while (L < m) {
    R = 0;
    for (int i = 0; i < m; i++)
      if (l[0][i] <= L) R = max(R, r[0][i]);
    cnt++, L = R + 1;
  }
  cout << '1' << '\n' << cnt << '\n';
  return 0;
}
```

### [洛谷 P1535 [USACO08MAR]Cow Travelling S](https://www.luogu.com.cn/problem/P1535)

emm 直接bfs 复杂度到$4^{15}$ 也就是 $2^{30}$

这个也不能折半枚举 所以说要另寻记录方法

这里我想了好久 也说不上来正常bfs到底是哪里白搜了好久浪费时间

用dp[x][y][k]表示第k时刻到达点(x, y) 的方案数

$dp[x][y][k] = \sum{dp[xx][yy][k-1]}$

(xx, yy)是与(x, y)相邻的四个点

于是我就直接$O(NMT)$ dp了

```cpp
const std::pair<int, int> p[4] = {{-1, 0}, {1, 0}, {0, 1}, {0, -1}};

int dp[105][105][20];

int main() {
  int n, m, t;
  int sx, sy, tx, ty, xx, yy;
  std::cin >> n >> m >> t;
  std::vector <std::string> Map(n);
  for (int i = 0; i < n; i++)
    std::cin >> Map[i];
  std::cin >> sx >> sy >> tx >> ty;
  sx--, sy--, tx--, ty--;
  dp[sx][sy][0] = 1;
  for (int k = 1; k <= t; k++)
    for (int i = 0; i < n; i++)
      for (int j = 0; j < m; j++) {
        for (auto it : p) {
          xx = i + it.first, yy = j + it.second;
          if (xx < 0 || xx >= n || yy < 0 || yy >= m || Map[xx][yy] == '*')
            continue;
          dp[i][j][k] += dp[xx][yy][k-1];
        }
      }
  std::cout << dp[tx][ty][t] << '\n';
  return 0;
}
```

### [洛谷 P1434 [SHOI2002]滑雪](https://www.luogu.com.cn/problem/P1434)

我不知道为什么我写的记搜只有90分

然后中规中矩用标准记搜dfs的时候用外部变量 就过了...

90pts 不知道第二个点挂在哪里了

```cpp
#define max(a, b) (a > b ? a : b)

const std::pair<int, int> d[4]={{-1, 0}, {0, 1}, {0, -1}, {1, 0}};

int main() {
  int n, m, xx, yy;
  std::cin >> n >> m;
  std::vector h(n, std::vector<int>(m));
  std::vector dp(n, std::vector<int>(m, 1));

  for (int i = 0; i < n; i++)
    for (int j = 0; j < m; j++)
      std::cin >> h[i][j];

  auto dfs = [&](auto self, int x, int y) -> void {
    for (auto it : d) {
      xx = x + it.first, yy = y + it.second;
      if (xx < 0 || xx >= n || yy < 0 || yy >= m) continue;
      if (h[xx][yy] >= h[x][y]) continue;
      if (dp[xx][yy] > dp[x][y]) continue;
      dp[xx][yy] = dp[x][y] + 1;
      self(self, xx, yy);
    }
  };

  for (int i = 0; i < n; i++)
    for (int j = 0; j < m; j++)
      if (dp[i][j] == 1)
        dfs(dfs, i, j);
  int ans = -1;
  for (auto iter : dp)
    for (auto it : iter)
      ans = max(ans, it);
  std::cout << ans;
  return 0;
}
```

100pts

```cpp
const std::pair<int, int> d[4] = {{-1, 0}, {1, 0}, {0, -1}, {0, 1}};

int main() {
  int n, m, xx, yy, ans = -1;
  std::cin >> n >> m;
  std::vector h(n, std::vector<int>(m, 0)), dp(n, std::vector<int>(m, -1));
  for (int i = 0; i < n; i++)
    for (int j = 0; j < m; j++)
      std::cin >> h[i][j];
  auto dfs = [&](auto self, int x, int y) -> int {
    if (~dp[x][y])
      return dp[x][y];
    else
      dp[x][y] = 1;
    for (auto it : d) {
      xx = x + it.first, yy = y + it.second;
      if (xx < 0 || xx >= n || yy < 0 || yy >= m)
        continue;
      if (h[x][y] <= h[xx][yy]) continue;
      dp[x][y] = std::max(dp[x][y], self(self, xx, yy) + 1);
    }
    return dp[x][y];
  };
  for (int i = 0; i < n; i++)
    for (int j = 0; j < m; j++)
      ans = std::max(ans, dfs(dfs, i, j));
  std::cout << ans;
  return 0;
}
```

不能沉迷各种巧妙的写法了

虽然90pts那个感觉也是记忆化 也挺快的 不知道慢在哪里了...
