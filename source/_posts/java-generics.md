---
title: JAVA 泛型
date: 2025-09-20 03:27:18
tags:
    - Java
    - 泛型
category:
    - Java
---

首先是一个知乎问题：
[最近看到有人说，List<Integer> 是卡车装钉子，编程界之耻，如何理解？](https://www.zhihu.com/question/13077935547/answer/109566040562)

之后在工作上也遇到了 `Map<Stirng, Object>` 这种写法。

<!-- more -->

## 什么是泛型

编译期的类型检查机制。不允许再写出这种代码：
```java
List list = new ArrayList();
list.add("hello");
Integer i = (Integer) list.get(0); // 运行时异常
```

但由于类型擦除，运行时并没有类型检查，所以 `List<Integer>` 和 `List<String>` 在运行时是一样的。

并不是引入泛型就能避免所有的类型转换异常。

```java
List<String>[] array = new List[10];  // 这里编译器会警告 unchecked
List<Integer> intList = List.of(1, 2, 3);

Object[] objArray = array;  
objArray[0] = intList;  // 编译能过，因为数组的运行时类型只知道是 Object[]

String s = array[0].get(0); // ClassCastException
```
