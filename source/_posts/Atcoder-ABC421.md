---
title: AtCoder-ABC421
date: 2025-09-04 23:42:53
tags:
---

[links](https://atcoder.jp/contests/abc421)

<!-- more -->

## A. Misdelivery

给定n个字符串，以及int k, string t;

判断第k个字符串是否等于t

## B. Fibonacci Reversed

f(x) = 倒转x的十进制表示后得到的数

给定$a_{1}, a_{2}$, $a_{i} = f(a_{i-2} + f(a_{i-1}))$ (i>=3)

输出$a_{10}$

手写reverse的时候没改成long long卡了好久

## C. Alternated

给定长为 $2N$ 的字符串S, 由N个'A'和N个'B'组成

一次操作交换S中相邻的两个字符，使得S中'A'和'B'交替出现的最小操作数

记录所有'A'的位置，计算换成"ABABAB..."和"BABABA..."的操作数，取最小值

{% fold code %}
```cpp
int main() {
  int n;
  std::cin >> n;
  long long ab = 0, ba = 0;
  std::vector<int> pos(n);
  std::string s; int t = 0;
  std::cin >> s;
  for (int i = 0; i < s.size(); ++i) {
    if (s[i] == 'A')
      pos[t++] = i;
  }
  for (int i = 0; i < n; ++i) {
    ab += abs(pos[i] - (2 * i));
    ba += abs(pos[i] - (2 * i + 1));
  }
  std::cout << std::min(ab, ba) << '\n';
  return 0;
}
```
{% endfold %}

## D. RLE Moving

无线大的二维平面，(R, C)表示相对于(0, 0)的R行C列

给定两个初始位置$(r_1, c_1), (r_2, c_2)$

以及两个字符串S, T, 分别表示从初始位置出发的移动序列

S T怎么来的没看懂。

先睡觉了明天继续。
