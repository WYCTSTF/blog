---
title: Java 异常：从一条别扭的 throws 链说起
date: 2026-10-30 00:06:33
tags:
  - Java
  - 异常
category:
  - Java
---

补 Java 基础补到异常这一课，作业里有四个问题。本来以为就是背一下 checked / unchecked，结果第一个问题就把我问住了：

> 自定义异常为什么 `extends RuntimeException`？如果写 `extends Exception`，程序不是直接断了吗？可读取失败又不该干扰程序运行……但被正常处理的话，两者不是一样吗？说真的我不知道为什么。

后来发现，这个“不知道”不是语法问题，而是 checked exception 的设计意图问题。顺便把工作里一直觉得别扭、又说不上来的一件事也想通了：为什么老代码里，一个很靠里的函数处理了异常，外面还是一串 `throws`。

于是有了这篇。

<!-- more -->

## 一、checked 和 unchecked，管的不是“程序会不会断”

先把前提拆掉：

- **没被 catch**：两种异常都会一路往上抛，最后终止线程或程序
- **被 catch**：两种都不会断

所以“`extends Exception` 程序就断了”这个前提不成立。未被捕获的 checked 异常一样会崩。

真正的区别只有一个：**编译器逼不逼调用方表态**。

| | 编译器要求 | 典型用途 |
|---|---|---|
| `extends Exception`（checked） | 必须 `catch` 或 `throws` | 外部可恢复失败：IO、网络、数据库 |
| `extends RuntimeException`（unchecked） | 不管 | 编程错误、参数错、数据损坏 |

那为什么 `CorruptRecordException` 要设计成 unchecked？

如果它 `extends Exception`，那么 `checkCrc` 必须写 `throws CorruptRecordException`；接着**每一个调用 `checkCrc` 的中间函数**也都得写 `throws` 或者就地 catch：

```java
static void f() {
  checkCrc(1, 2);   // checked 的话，这里直接编译错
}
```

于是 `throws` 会沿着调用链一路复制上去。但中间层根本不知道“CRC 坏了该怎么办”——它既不能跳过记录，也不能截断文件，只能把锅继续往上递。真正的处理点在恢复逻辑那一层。

所以设计成 unchecked：**检测点在深处，处理点在边界，中间层不被迫表态**。让异常自己冒到知道怎么办的那一层，在那里 catch。

注意：“读取失败不干扰程序”不是 `RuntimeException` 给的，是**那一层 catch 给的**。想继续跑，就在恢复层 catch 住并跳过；觉得数据关键，就让它继续往上炸。异常类型只决定“编译器管不管”，不决定“必须吞”。

也正因为这样，在练习的小文件里把 `RuntimeException` 改成 `Exception`，程序照样能跑——因为 `main` 直接 catch 了，中间没有别的层。差别要在多层调用里才看得出来。

## 二、为什么要有 throws，而不是假定所有函数都可能抛异常

如果编译器假定“任何函数可能抛任何异常”，那调用方只能：

```java
try {
  // ...
} catch (Throwable e) {
  // 这到底该重试、该跳过、还是该崩？
}
```

签名不再携带任何信息，编译器也帮不了你；最后要么到处吞异常，要么靠 `instanceof` / 字符串猜类型。真正的 bug（空指针、数组越界）会被当成“正常失败”一起吞掉。

Java 的折中是：

- **可恢复的外部失败** → checked，逼你处理（`IOException`）
- **编程错误 / 不该到处处理的失败** → unchecked（`NullPointerException`、`IllegalArgumentException`、自定义的 `CorruptRecordException`）
- **JVM 级灾难** → `Error`（OOM、StackOverflow），一般也不 catch

`throws` 也不是“我只会抛这些”，它是一份**已知失败的契约**：调用方必须为这些做好准备；unchecked 仍然可能半路杀出来。

这套设计争议一直很大，C#、Kotlin、Scala 都干脆不要 checked 异常；Java 自己到了 lambda / stream 时代也难受，所以才有 `UncheckedIOException` 这种包装。

## 三、既然有 IOException，为什么还要包一层

两种写法都合法，区别是**把处理义务推给谁**：

```java
static byte[] load(...) throws IOException   // 义务继续往上推
```

意味着 `load` 的每一个调用者都要 catch 或再 `throws`。如果 `load` 是给外部用的 API，调用方会被迫写一堆 try/catch；放进 lambda 更直接编不过，因为 `Supplier` / `Consumer` 这些接口没声明 checked：

```java
list.forEach(x -> load(x));   // checked 的话，编译错
```

包装则是：

```java
catch (IOException e) {
  throw new UncheckedIOException("打开数据目录失败", e);
}
```

在这一层把“必须处理”结清，转成 unchecked；同时 `getCause()` 还保留原始 `IOException`，信息没丢。这不是把异常藏起来，是换一种规则让它往上走。

代价是调用方可能忘记 catch。所以包装通常发生在 API 边界，并配 `@throws` 文档说明。打开目录失败基本是致命的，不想逼每个使用者写 try/catch，于是就在边界做这个转换。

## 四、catch 为什么必须“具体在前”

`catch` 从上往下匹配，**第一个匹配上的执行，后面的不再看**。

`CorruptRecordException` 是 `RuntimeException` 的子类。所以：

```java
catch (RuntimeException e) { ... }        // 先把子类也接走了
catch (CorruptRecordException e) { ... }  // 永远轮不到 → 编译错误
```

编译器报的是 “exception CorruptRecordException has already been caught”。它**没有**分析 try 里实际会抛什么，也不做依赖顺序推理；它只比较 catch 参数类型之间的继承关系：

```text
CorruptRecordException <: RuntimeException <: Exception <: Throwable
```

前面的类型是后面的父类 → 后面的 catch 不可达 → 直接拒绝编译。所以规则就是“具体在前，笼统在后”。

（另有一条独立规则：如果 catch 一个 checked 异常，但 try 里根本不可能抛它，也会编译错。这个不适用于 `RuntimeException`。）

## 五、回到那条别扭的 throws 链

工作里看到老代码时，最别扭的是：一个很靠里的函数处理了异常，结果从里到外一整条调用链都在 `throws`。

先精确一下：

- `throws` **不是处理**，只是在签名上登记“我这层不处理，调用我的那层得管”。
- 链条不是永远传到顶，而是**传到第一个真正 catch 的层为止**。如果每层都只登记不处理，看起来就像整条链都在 throw。
- 如果里面真的处理完了，那个异常就不该再出现在外层签名里；外层那串大概率是**别的异常**，或者是里面 catch 完又原样 rethrow 了（那等于没处理）。

中间层的职责，可以落成三条：

1. **不做自己没资格做的决定**
   中间层不知道“坏了该跳过还是该终止”，就别 catch 了替上层决定。它只负责发现和上报。

2. **可以翻译，但别裁决**
   跨了抽象边界，就把底层异常翻译成自己这层的语言。比如 repository 把 `SQLException` 包成 `DataAccessException`，上层就不需要知道 JDBC。这是“翻译”，不是“处理”。

3. **可以补上下文，但别刷日志**
   `throw new UncheckedIOException("打开数据目录失败: " + dir, e)` 是有价值的，因为它补了“哪里失败”。`catch (e) { log.error(...); throw e; }` 通常只是把同一条日志在每个层刷一遍。

所以那种“怪”可能是两种东西混在一起：

- **必要的透明**：底层 `read()` 可能失败，中间层确实没法处理，只能登记。这是 checked 的设计本意——让失败可见。
- **抽象泄漏**：高层 service 的方法签名里出现 `throws SQLException` / `throws IOException`，说明底层实现细节漏到了高层。这种“怪”是设计问题，正确做法是在边界 wrap 掉，而不是让高层认识底层异常。

翻成一句话：

> **谁有能力做决定，谁 catch；谁只负责发现，谁 throw；中间层只翻译，不裁决。**

## 收尾

checked 和 unchecked 的取舍，说到底是把成本放在哪儿：

- checked：**编译期强制可见**，代价是签名污染
- unchecked：**签名干净**，代价是靠纪律、文档和边界兜底

而程序断不断，从来不取决于异常继承自谁，只取决于**有没有人在合适的层 catch 它**。异常类型决定的，只是谁被迫面对这笔账。
