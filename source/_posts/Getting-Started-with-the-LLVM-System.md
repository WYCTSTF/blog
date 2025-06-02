---
title: Getting Started with the LLVM System
date: 2024-10-28 16:47:52
tags:
    - LLVM
    - 编译原理
---

对 [Getting Started with the LLVM System](https://llvm.org/docs/GettingStarted.html) 的部分翻译 & 学习笔记

<!-- more -->

## 总览

LLVM项目包含工具、运行库、（需要被处理为中间表示并转换为目标平台文件的）头文件、libc++（STL的一个实现）、lld（链接器）在内的诸多元素，工具包括汇编器、反汇编器、bitcode分析器/优化器，以及基本的回归测试等。

bitcode是llvm ir的一种二进制编码格式

可以看到对于LLVM-Core而言只包含了中间表示和后端生成部分，与C/C++对应的前端Clang独立

## 获取源码 \& 构建LLVM

拉取最新的仓库

```bash
git clone --depth 1 https://github.com/llvm/llvm-project.git
```

构建一个带调试信息的llvm，编译并运行LLVM tests

因为在arm上，不需要别的build

```bash
cmake -S llvm -B build -G Ninja -DCMAKE_BUILD_TYPE=Debug -DLLVM_TARGETS_TO_BUILD="ARM" -DLLVM_USE_LINKER=lld
ninja -C build check-llvm
```


