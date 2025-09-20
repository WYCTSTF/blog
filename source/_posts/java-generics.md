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

并不是引入泛型就能避免所有的类型转换异常。理解这一点就理解了工程中需要注意点所在。

```java
// 用原始类型数组（合法，但会有 unchecked 警告）
List<String>[] array = (List<String>[]) new List[10];

List<Integer> intList = List.of(1, 2, 3);

Object[] objArray = array;   // 数组是协变的，可以赋值给 Object[]
objArray[0] = intList;       // 往里面放 List<Integer>

// 取的时候编译器以为里面是 List<String>
String s = array[0].get(0);  // 运行时 ClassCastException
```

有些说法表示类型擦除和值类别的缺失是缺陷也是区别于cpp的特点。那我问你（

实际工作缺失不伐能跑就别动的场景。突然想到自己值类别那篇blog即没讲清楚又啰嗦还没讲完，有空重写吧。
