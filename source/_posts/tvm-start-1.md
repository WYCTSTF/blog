---
title: TVM新人入坑 - 1
date: 2025-06-06 19:11:17
tags:
---

本来要在npu上玩的，结果zh的机器tm的不知为什么卡又掉了，必须得系统关机之后物理重启电源。等修完估计答辩也没一两天了，windows上弄个能跑的demo先。

本文内容时效性截至2025.6.7

<!-- more -->

[TVM官方文档](tvm.apache.org/docs/)

# 从源码安装

## dependencies

* CMake (>= 3.24.0)
* LLVM (recommended >= 15)
* Git
* A recent C++ compiler supporting C++ 17, at the minimum

  我使用的是llvm-mingw，clang --version信息如下
  ```
  clang version 20.1.6 (https://github.com/llvm/llvm-project.git 47addd4540b4c393e478ba92bea2589e330c57fb)
  Target: x86_64-w64-windows-gnu
  Thread model: posix
  InstalledDir: D:/Program Files/llvm-mingw-20250528-ucrt-x86_64/bin
  Configuration file: D:/Program Files/llvm-mingw-20250528-ucrt-x86_64/bin/x86_64-w64-windows-gnu.cfg
  ```