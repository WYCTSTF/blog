---
title: Java 异常：四个问题
date: 2026-10-30 00:06:33
tags:
  - Java
  - 异常
category:
  - Java
---

补 Java 异常时卡住的四个问题，记一下答案。

<!-- more -->

## 1. 自定义异常为什么 extends RuntimeException？

先纠正前提：异常没被 catch 时，checked 和 unchecked 都会终止程序；被 catch 时都不会。区别只在编译期——checked 逼调用方 catch 或 throws，unchecked 不逼。

所以 `CorruptRecordException` 用 unchecked：检测在深处，处理在边界，中间层不该被迫为上层策略写一串 `throws`。

## 2. 为什么要有 throws，而不是假设所有函数都可能抛异常？

那样签名就不带信息了，调用方只能 `catch (Throwable)`，真正的 bug 和正常失败混在一起。`throws` 是“已知失败”的契约：IO 这类可恢复失败用 checked，NPE、参数错这类用 unchecked。

## 3. 为什么把 IOException 包成 UncheckedIOException？

`throws IOException` 会把处理义务一路往上推，放进 lambda 还编不过。在边界包成 unchecked，上层签名干净，`getCause()` 也保留原始异常。代价是调用方可能忘接。

## 4. catch 为什么必须具体在前？

catch 从上往下匹配，子类也是父类。`RuntimeException` 在前会把 `CorruptRecordException` 一起接走，后面的具体 catch 永远到不了，编译器直接报 already caught。所以具体在前，笼统在后。

一句话：checked 是编译器帮你记账，unchecked 是自己记账；程序断不断，看有没有人在合适的层 catch。
