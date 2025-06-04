---
title: 洛谷P1032 [NOIP2002 提高组] 字串变换
tags: 
  - KMP
  - 双向BFS
mathjax: true
date: 2022-02-12
---
KMP+双向同时BFS

<!-- more -->

正常BFS题 但是数据很假

我写完看题解 发现有双向bfs做的 有KMP加快替换的 

还有卡常的（大雾

于是心生一计 去复习了KMP 打算把两个放一起写

写完发现从原来的42ms -> 19ms

除了最前排的一堆人抄的unordered_map 或者 看不懂的科技 或者 对着答案数据预判直接continue的速度干不过

其他的而言还是很快的 把[加强数据版本](https://www.luogu.com.cn/problem/U90810)的过了 hzwer博客说的[vijos上的](https://vijos.org/records/62071b94f4136204406cff4b)会5个t也过了

总的来说还行 写太长就是折磨自己了
{% fold code %}
```cpp
#include <bits/stdc++.h>
using namespace std;
int n = 1;
string start, target;
string a[10], b[10];
set <string> s1, s2;
queue <pair<string, int>> q1, q2;
int nxt[2][10][30];
int main() {
  s1.clear(); s2.clear();
  cin >> start >> target;
  start = '$'+ start, target = '$' + target;
  while(cin >> a[n] >> b[n]) {a[n] = '$' + a[n]; b[n] = '$' + b[n]; n++;}
  n--;
  for (int i = 1; i <= n; i++) {
    for (int j = 2, k = 0; j < a[i].size(); j++) {
      while (k > 0 && a[i][j] != a[i][k+1]) k=nxt[0][i][k];
      if (a[i][j] == a[i][k+1]) k++;
      nxt[0][i][j] = k;
    }
    for (int j = 2, k = 0; j < b[i].size(); j++) {
      while (k > 0 && b[i][j] != b[i][k+1]) k=nxt[1][i][k];
      if (b[i][j] == b[i][k+1]) k++;
      nxt[1][i][j] = k;
    }
  }
  int step = 0;
  q1.push({start, 0}), q2.push({target, 0});
  while (++step <= 5) {
    while (q1.front().second == step-1) {
      string now = q1.front().first;
      q1.pop();
      for (int i = 1; i <= n; i++) {
        string tem = now;
        for (int j = 1, k = 0; j < tem.size(); j++) {
          while (k > 0 && tem[j] != a[i][k+1]) k = nxt[0][i][k];
          if (tem[j] == a[i][k+1]) k++;
          if (k == a[i].size()-1) {
            int pos=j - k + 1;
            string res="$";
            for (int z = 1; z < pos; z++) res += tem[z];
            for (int z = 1; z < b[i].size(); z++) res += b[i][z];
            for (int z = j + 1; z < tem.size(); z++) res+=tem[z];
            if (s1.find(res) != s1.end()) {continue;}
            if (s2.find(res) != s2.end()) {cout << step * 2 - 1 << endl; return 0;}
            q1.push({res, step}); s1.insert(res);
          }
        }
      }
    }
    while (q2.front().second == step-1) {
      string now = q2.front().first;
      q2.pop();
      for (int i = 1; i <= n; i++) {
        string tem = now;
        for (int j = 1, k = 0; j < tem.size(); j++) {
          while (k > 0 && tem[j] != b[i][k+1]) k = nxt[1][i][k];
          if (tem[j] == b[i][k+1]) k++;
          if (k == b[i].size()-1) {
            int pos = j - k + 1;
            string res="$";
            for (int z = 1; z < pos; z++) res+=tem[z];
            for (int z = 1; z < a[i].size(); z++) res+=a[i][z];
            for (int z = j + 1; z < tem.size(); z++) res += tem[z];
            if (s2.find(res) != s2.end()) {continue;}
            if (s1.find(res) != s1.end()) {cout << step * 2 << endl; return 0;}
            q2.push({res, step}); s2.insert(res);
          }
        }
      }
    }
  }
  cout << "NO ANSWER!";
  return 0;
}
```
{% endfold %}
