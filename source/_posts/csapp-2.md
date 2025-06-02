---
title: CSAPP 第二章学习笔记
date: 2024-10-15 18:42:53
tags:
  - csapp
mathjax: true
---

这章关于浮点数、精度、存储

<!-- more -->

## 抛砖引玉

```c
printf("%f\n", (3.14 + 1e20) - 1e20);
printf("%f", 3.14 + (1e20 - 1e20));
```


ans
```text
0.000000
3.140000
```

## 信息存储

byte，一个8位，作为最小的可寻址单位，而非bit。内存(memory)被视为array of byte，机器级程序视其为virtual memory

每个byte有唯一的数字标识，即内存地址(address)，集合为虚拟地址空间(virtual memory address)

然而实现可能是由 动态随机访问存储器(DRAM)、闪存、磁盘存储器、特殊硬件和操作系统软件结合起来，为程序提供的统一、连续的array of byte.

至此C中指针的概念也很好理解了。指针包含两部分，值与类型，值表示address上的byte内容，这个内容为另一个address,而类型决定了如何处理&表示另一address上的byte值。

byte 8位

$00000000_2$~$11111111_2$ = $0_{10}$ $\to$ $255_{10}$ = $00_{16}$ $\to$ $FF_{16}$

