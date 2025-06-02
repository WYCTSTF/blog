---
title: CSAPP 第三章学习笔记
date: 2025-03-17 15:21:25
tags:
  - csapp
---

第二章跳过了，对着一堆学过的概念重新补充数学定义,2的次幂倒腾来去没啥意思

IEEE浮点数相关的，要用了再补吧。

挂一个ouuan的[笔记](https://ouuan.moe/post/2022/09/csapp-2)

第三章主要补汇编知识，，多花点时间在上面。

<!-- more -->

### 处理器状态

* 程序计数器 PC,program counter 用`%rip`表示，待执行的下一条指令的地址。
* 整数寄存器文件,register file,16个存储整型的寄存器
* 条件码寄存器，status flag，存储算术、逻辑运算的状态
* vector registers，一组向量寄存器，存放多个整型或者浮点数


