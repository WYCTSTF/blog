---
title: 线代笔记
tags:
    - 线性代数 
date: 2022.5.8
---

看的GS的课 [B站上有很多](https://www.bilibili.com/video/BV1bb411H7JN?p=3&spm_id_from=pageDriver)

记录一下学的时候产生的问题和搜到的、思考的答案，以及速成备考的时候的笔记

<!-- more -->

# $\S 3$ 矩阵的乘法和逆

## Q1. 如何证明矩阵乘法的结合律

线性组合、往后学就理解了

---

## Q2. 如何理解矩阵的分块相乘

第三节讲的第五种矩阵乘法方法

看的时候并没有像弹幕一样一眼理解 人比较笨。。

令矩阵 $A$ 分为 

$\begin{bmatrix}
  A_1 & A_2 \\\\
  A_3 & A_4 \\\\
\end{bmatrix}$，
$B$ 分为
$\begin{bmatrix}
  B_1&B_2\\\\
  B_3&B_4\\\\
  \end{bmatrix}$，
$C=AB=$
$\begin{bmatrix}
  A_1B_1+A_2B_3&A_1B_2+A_2B_4\\\\
  A_3B_1+A_4B_3&A_3B_2+A_4B_4
  \end{bmatrix}$

当然分出来的小矩阵 $A_i, B_i$ 之间满足矩阵乘法的要求，即 $A$ 列的划分和 $B$ 行的划分相同

以 $A=n\times m=$ 
$\left[
  \begin{array}{cc|c}
  1&2&3\\\\
  4&5&6\\\\ \hline
  7&8&9 \end{array}\right]$ , $B=m\times p=$
$\left[
  \begin{array}{c|c}
  1&2\\\\
  3&4\\\\ \hline
  5&6
  \end{array}\right]$
为例，**先考虑 $A$ 只划分列，$B$ 只划分行时候的情况，即 $m$ 不变**

$\left[
  \begin{array}{cc|c}
  1&2&3\\\\
  4&5&6
  \end{array}
\right]$
$\left[
  \begin{array}{c}
  1\\\\
  3\\\\ \hline
  5\end{array}
\right]=$
$\left[
  \begin{array}{}
  1&2\\\\
  4&5
  \end{array}
\right]
\left[
  \begin{array}{c}
  1\\\\
  3
  \end{array}
\right]+\begin{bmatrix}3\\\\ 6 \end{bmatrix}\begin{bmatrix}5\end{bmatrix}$

这个过程过程意味着用 $\begin{bmatrix}1\\\\ 3\\\\ 5\end{bmatrix}$ 作为系数，对 $column\ vector$$\begin{bmatrix}1\\\\ 4\end{bmatrix}$ $\begin{bmatrix}2\\\\ 5\end{bmatrix}$ $\begin{bmatrix} 3\\\\ 6\end{bmatrix}$ 进行线性组合，**所以 $A$ 划分行  $B$ 划分列的运算是成立的，即加法的结合律**

这样重复下去，$A$ 只有列的划分 最终分为 $m$ 行，$B$ 中只有行的划分，最终分为 $p$ 列，线性组合得到一个 $m\times p$ 的矩阵

同样，用矩阵分块去理解前四种方法，也是很显然的事情

-----

## Q3. 如何证明 $square\ matrix$ 左逆等于右逆

这个知道了矩阵乘法的含义就没有问题,设 $A$ 是 $n\times{n}$ 的矩阵，$\forall{i}\in[1,n]$，如果$AA^{-1}=I$，那么在 $A[i][j]=1$ 的时候，就有$A^{-1}[j][i]=1$，交换结合顺序，自然对于每个 $A^{-1}[i][j]=1$ 有 $A[j][i]=1$

所以 $AA^{-1}=I=A^{-1}A$

--------

# $\S 4\ A$ 的 $LU$ 分解

## P1. 转置矩阵

上来一个 **转置矩阵** ，查了维基百科：

在线性代数中，矩阵 $A$ 的转置是另一个矩阵 $A^T$，由下列等价动作建立

* 把 $A$ 的列写作 $A^T$ 的行
* 把 $A$ 的行写作 $A^T$ 的列

还看了一些性质，等到之后有知识储备了再弄吧

## Q1. 为什么对于置换矩阵 $P$ 有 $P^{-1}\ =\ P^T$

考虑一个置换矩阵
$P = \begin{bmatrix}
0 & 0 & 1 \\\\
1 & 0 & 0 \\\\
0 & 1 & 0
\end{bmatrix}$， 如果要求一个 $P^{-1}$ 使得 $P^{-1}P=I$，那么对于 $I$ 的第一个主元，由 $P^{-1}$ 的第一行和 $P$ 的第一列点乘得到，显然只有 $\begin{bmatrix} 0 & 1 & 0 \end{bmatrix} \times \begin{bmatrix}0\\\\ 1\\\\ 0\end{bmatrix}$ 得到 $1$，别的都会是 $0$，对于别的主元也是一样，因此在这个例子里很容易得到 $P^{-1}=\begin{bmatrix}
0&1&0\\\\
0&0&1\\\\
1&0&0
\end{bmatrix}$ ，对于所有的置换矩阵都是如此，即 $P^{-1}$ 的第 $i$ 行必须是$P$ 的第 $i$ 列，即有 $P^{-1}=P^T$

-----

## Q2. 关于 $LU$ 分解对比 $Gauss-Jordan$求逆方法

高斯消元的时候，左乘消元矩阵的过程会产生交叉：

$\mathop{\begin{bmatrix}
1 & 0 & 0\\\\
0 & 1 & 0\\\\
0 & -5 & 1
\end{bmatrix}}\limits_{E_{32}}\mathop{\begin{bmatrix}
1&0&0\\\\
-2&1&0\\\\
0&0&1
\end{bmatrix}}\limits_{E_{21}}=\mathop{\begin{bmatrix}
1&0&0\\\\
-2&1&0\\\\
10&-5&1
\end{bmatrix}}\limits_{E}$

其中 $E$ 左下角的10就是由于消元时使用的是新的第二行，因此要加回10倍的第一行

这样的话，一个单位操作算成一个位置上的乘法和减法，整体消元过程就是 $O(N^3)$ 的复杂度

$$1^2+2^2+\dots+n^2=\int_1^nx^2\mathrm{d}x=\frac{1}{3}n^3$$

但是在求解L的时候，可以直接把 $E_{21}^{-1}、E_{32}^{-1}$ 填入， $\mathop{\begin{bmatrix}
1&0&0\\\\
2&1&0\\\\
0&0&1
\end{bmatrix}}\limits_{E_{21}^{-1}}
\mathop{\begin{bmatrix}
1&0&0\\\\
0&1&0\\\\
0&5&1
\end{bmatrix}}\limits_{E_{32}^{-1}}=
\mathop{\begin{bmatrix}
1&0&0\\\\
2&1&0\\\\
0&5&1
\end{bmatrix}}\limits_{L}$

因为这个过程中，在处理第 $i$ 行时依赖的是 $i-1$ 行，倒推不会产生传递，因此每行之间没有影响

除去了矩阵乘法的过程，这个分解使得求逆的复杂度变低

-------

# $\S 5$ 转置、置换、向量空间

$\begin{bmatrix}
1 & 1 & 2\\\\
2 & 1 & 3\\\\
3 & 1 & 4\\\\
4 & 1 & 5
\end{bmatrix}\times\begin{bmatrix}x_1\\\\ x_2\\\\ x_3\end{bmatrix}$ $\iff x_1\begin{bmatrix}1\\\\ 2\\\\ 3\\\\ 4\end{bmatrix}+x_2\begin{bmatrix}1\\\\ 1\\\\ 1\\\\ 1\end{bmatrix}+x_3\begin{bmatrix}2\\\\ 3\\\\ 4\\\\ 5\end{bmatrix}$

wxy说严格来讲一般矩阵乘列向量称为线性组合，抛开翻译不谈，Gilbert课上说的也只是combination..

----

# $\S 6$ 列向量和零空间

听的异常轻松，可能是我有地方自以为理解了其实不然

看书的时候再好好看、好好做题吧，这个不预习可能不太行

----

# $\S 7$ $Ax=0$：主变量、特解

$rref(A)$ 这个矩阵不难理解，就是A消元、回代然后矩阵分块

这个过程我唯一不理解的是为什么可以写成$R=[I\ F]$的形式，然后xy说是行交换，然后我不理解，那$x$的$\begin{bmatrix}x1\\\\ x2\\\\ \vdots \\\\ x_n\end{bmatrix}$怎么办，然后xy说$x$也交换就好了..

就好了..

---

# $\S 8$ $Ax=b$：可解性和解的结构

就 $row\ rank$ 和 $column\ rank$ 的理解可能有一点小区别，我问了xy，说是一样，就是矩阵张成的空间维数，wxy说是行最简式和列最简式的区别，这样理解也对（虽然我学的都是行消元，对列最简式这个东西没概念..）

## Q1. 为什么可逆方阵一定满秩

发现自己关于逆矩阵含义的笔记基本没有，因此看书补充

然后我才发现书上2.5这节提前的写了很多蛋疼的结论：

1. The algorithm to test invertibility is elimination: A must have n(nonzero) pivots.
2. The algebra test for invertibility is the determinant of A: det A must not be zero.
3. The equation that tests for invertibility is $Ax=0:x=0$ must be the only solution.

看完第9节就解决这个问题了，考虑逆矩阵 $A^{-1}$ 使得 $AA^{-1}=I=A^{-1}A$

考虑 $\begin{bmatrix}A&I\end{bmatrix}$ 消元到 $\begin{bmatrix}R&E\end{bmatrix}$ 的过程，如果 ${A}$ 中各列线性无关，此时 ${R}$ 就是 ${I}$，没什么好说的，${E}$ 就是 ${A^{-1}}$ ，即可逆方阵一定满秩

------

### Note

$r=m<n$时，$R=[I\ F]$ 有无数解

$r=n<m$时，$R=\begin{bmatrix}I\\\\ 0\end{bmatrix}$ 有0或1解，看特解是否存在

$r=n=m$时，$R=[I]$ 有且仅有1解

$r<n,r<m$时， 无解或者无穷多解

$Ax=b$ 有解的充要条件是 $r(A)=r(A,b)$

------

# $\S 9$ 线性相关、基、维数

线性相关、张成一个空间，作为一个basis的对象都是向量组 a bunch of vectors 而非矩阵

definition - 如果不存在结果为零向量的组合，向量组线性无关(except the zero comb)

definition - Vectors $v_1,v_2,\dots,v_n$ span a space means: This space consists of all combinations of those vectors


definition - Basis for a space is a sequence of vectors $v_1,v_2,\dots,v_n$ with 2 properties:
  * They are independent
  * They span the space

n vectors gives basis if $n\times{n}$ matrix is invertible.

他一直在讲可逆，但是又没教...

基向量的个数就是空间的维数

因此对于 $m * n$ 的矩阵 $A$ ，若秩为 $r$ ，那么 $C(A)$ 的维数是 $r$

------------

# $\S 10$ 四个基本子空间

when A is ${m}\times{n}$ 四个基本子空间 $\begin{cases}C(A)&in\ R^m\\\\ N(A)&in\ R^n\\\\ R(A)=C(A^T)&in\ R^n\\\\ N(A^T)&in\ R^m\end{cases}$

一般管 $N(A^T)$ 叫左零空间

1. dim of $C(A)=r$

通过初等行变换和消元可知 $C(A)=r$

2. dim of $N(A)=n-r$

有 $n-r$ 个自由列，故有 $n-r$ 组特解构成零空间

3. dim of $R(A)=$ dim of $R(rref(A))=r$

消元到 reduced row echelon form 的时候，列向量会因为行变换改变，但是行空间的基两者还是一样的，秩为 $r$，那么 $A$ 的行空间的维数就是 $r$，要注意的是基和列空间不同，只是维数相同

4. dim of $N(A^T)$
考虑 $N(A^T)$ 中的向量 $y$，存在 $A^Ty=\begin{bmatrix}0\\\\ \vdots\\\\ 0\end{bmatrix}\iff{y^tA=\begin{bmatrix}0&\cdots&0\end{bmatrix}}$

这也是为什么习惯叫 N(A^T) 为左零空间的原因

补充：

左乘构造矩阵是行变换，例如 $\begin{bmatrix}0&1\\\\ 1&0\end{bmatrix}\begin{bmatrix}a&b\\\\ c&d\end{bmatrix}=\begin{bmatrix}c&d\\\\ a&b\end{bmatrix}$

右乘构造矩阵是列变换，例如 $\begin{bmatrix}a&b\\\\ c&d\end{bmatrix}\begin{bmatrix}0&1\\\\ 1&0\end{bmatrix}=\begin{bmatrix}b&a\\\\ d&c\end{bmatrix}$

----

$\begin{bmatrix}A_{m\times{n}}&I_{m\times{m}}\end{bmatrix}\stackrel{左乘E}\rightarrow\begin{bmatrix}R_{m\times{n}}&E_{m\times{m}}\end{bmatrix}$

即

$E\begin{bmatrix}A&I\end{bmatrix}=\begin{bmatrix}R&E\end{bmatrix}$

类似高斯消元，只不过这里 $A\to{R}$ 而非 $A\to{I}$ 所以 $E\ne{A^{-1}}$

那么 $rref(A^T)$ 这个动作之后会得到 $m-r$ 个零行，$N(A^T)$ 的维数就一目了然了

而基则是 $E$ 中对应的行向量，一目了然，因为对应的行向量其实就是我们找的 $y$

----------

# $\S 14$ 正交向量和子空间

两个向量 $\mathbf{A}=\begin{bmatrix}x_1\\\\ y_1 \end{bmatrix}$ 和 $\mathbf{B}=\begin{bmatrix}x_2\\\\ y_2\end{bmatrix}$

如果他们正交(orthogonal)，即垂直，有$A\cdot{B}=x_1x_2+y_1y_2=0=A^TB$

不难从勾股定理证明得到 $$\mid{A}\mid^2+\mid{B}\mid^2=\mid{A+B}\mid^2\iff{A^TA+B^TB}=(A+B)^T(A+B)=A^TA+A^TB+B^TB+B^TA$$

即 $A^TB=0=B^TA$

一个向量空间 $S$ 正交于另一个向量空间 $T$ 意味着 $\forall \mathbf{X}\in{S},\mathbf{Y}\in{T}$ 都有 $X^TY=0$

行空间正交于零空间，这个由定义和式子 $Ax=0$ 

列空间正交于左零空间，只不过是 $A^Tx=0$ 罢，一样的道理

Nullspace and row space are orthogonal complements in $R^n$ for the reason Nullspace contains all vectors $\perp$ row space (空间意义上，所谓正交补)

$A^TA$ 是一个对称方阵，$N(A^TA)=N(A)$ 且 rank of ($A^TA$) = rank of ($A$)

前一条结论说明 $A^TA$ 可逆仅当 $A$ 各列线性无关

这两个结论证明详见 P15

---------

# $\S 17$ 正交基、正交矩阵、正交化法

对于正交基 : Orthogonal basis $q_1,\dots,q_n$ 有

$q_i^T\cdot{q_j}=\begin{cases}0 & if\ i\ne{j}\\\\ 1 & if\ i=j\end{cases}$

有标准正交列的矩阵 $Q_i=\begin{bmatrix}q_1&\dots&q_n\end{bmatrix}$，$Q_i^TQ_i=\begin{bmatrix}I&0\end{bmatrix}$，只当它为方阵的时候我们称作正交矩阵，显然 $Q_i^TQ_i=I$

一些符合要求的正交矩阵 
$Q=
\left[
  \begin{array}{cc}
  \cos\theta&-\sin\theta\\\\
  \sin\theta&\cos\theta
  \end{array}
\right]$、
$Q=\frac{1}{\sqrt{2}}
\left[
  \begin{array}{cc}
  1&1\\\\
  1&-1
  \end{array}
\right]$
$Q=\frac{1}{2}
\left[
  \begin{array}{cccc}
  1&1&1&1\\\\
  1&-1&1&-1\\\\
  1&1&-1&-1\\\\
  1&-1&-1&1
  \end{array}
\right]$ 
如此里面的列向量都在正交基里

证明正交矩阵：每列都是单位向量，并且两两正交

QR分解 最小二乘什么的，暂时先放掉、、

--------

# $\S 18$ 行列式的性质

从这一节开始 不再研究Ax=b (A不一定为方阵 b不一定为零向量的问题，所以我真搞不懂上来行列式干什么，特别是用同济教材还不一定铺垫前置的空间解析几何，真就国情特殊，服务考研、课时？)，转而研究 $Ax=\lambda{x}$ 的行列式与特征值

先从性质入手

## 性质1 $\det(I)=1$

## 性质2 交换方阵的两行，行列式符号改变

$\left|
  \begin{array}{cc}
  1 & 0\\\\
  0 & 1
  \end{array}
\right|=1$
，
$\left|
  \begin{array}{cc}
  0 & 1\\\\
  1 & 0
  \end{array}
\right|=-1$

## 性质3

* 性质3.a

$\left|
  \begin{array}{cc}
  ta&tb\\\\
  c&d
  \end{array}
\right|=t
\left|
  \begin{array}{cc}
  a&b\\\\
  c&d
  \end{array}
\right|$

* 性质3.b

$\left|
  \begin{array}{cc}
  a+a' & b+b'\\\\
  c & d
  \end{array}
\right|$ $=$ $\left|
  \begin{array}{cc}
  a & b \\\\
  c & d
  \end{array}
\right|+
\left|
  \begin{array}{cc}
  a'& b'\\\\
  c & d
  \end{array}
\right|$

## 性质4 若有两个相同的行则矩阵行列式为0

只要用性质2就可以证明

## 性质5 消元不改变行列式，即 $\det{A}=\det{U}$

证：
$$\left[
  \begin{array}{cc}
  a&b\\\\
  c-la&d-lb
  \end{array}
\right]=
\left[
  \begin{array}{cc}
  a&b\\\\ c&d
  \end{array}
\right]
-l
\left[
  \begin{array}{cc}
  a&b\\\\
  a&b
  \end{array}
\right]
$$

## 性质6 有一行 $0$ 向量则 $\det{A}=0$

随便用一个 $det{A}=5\det{A}$ 就整出来了

## 性质7 一个上三角矩阵 

$U=
\left[
  \begin{matrix}
  d_1 & \cdots&\cdots \\\\
  0 & d_2 & &\vdots\\\\
  \vdots& & \ddots & \vdots\\\\
  0&\cdots&\cdots& d_n
  \end{matrix}
\right]
$
有 $\det{U}=d_1d_2\dots{d_n}$，证明： $\ U$ 可以消元回去得到一个对角矩阵 $D$，只留下了主对角线上的 $d_1,d_2,\dots,d_n$ 然后利用性质123即得

## 性质8 奇异矩阵行列式为 $0$，可逆矩阵行列式不为 $0$

这里因为我跳着看的，没学过，百度搜了一下，定义是反过来的，奇异矩阵是行列式为 $0$ (不满秩)的矩阵

后半条性质很好说，搞成对角矩阵 $D$，主元不为 $0$，提出来变成一个系数乘 $I$ 就好了

## 性质9 $\det{AB}=\det{A}\times\det{B}$

用这个性质可以知道 $\det{A^{-1}}=\frac{1}{\det{A}}$，$\det{2A}=2^n\det{A}$

* 证明：

考虑 
$\begin{vmatrix}
AB
\end{vmatrix}$，将 $A$ 消元得到对角矩阵 $D$，有 
$\begin{vmatrix}
A
\end{vmatrix}=
\begin{vmatrix}
D
\end{vmatrix}$
，而对角矩阵$D$给B的影响是 $D_{ii}$ 不为 $0\ (i\in[1,n])$其实是给 $B$ 的第 $i$ 行乘它本身，那么可以用 
$3.a$ 
的性质把因数提出来，也就有 
$\begin{vmatrix}
DB
\end{vmatrix}=
\begin{vmatrix}
D
\end{vmatrix}
\begin{vmatrix}
B
\end{vmatrix}$
，因为线性组合的关系，不难发现 
$\begin{vmatrix}
AB
\end{vmatrix}=
\begin{vmatrix}
DB
\end{vmatrix}$，考虑 $A$ 不满秩的情况，等式仍然成立

另一种证明方法是考虑证明 $\frac{|AB|}{|B|}=\det{A}$，分类讨论 $\frac{|AB|}{|B|}$，用前三条性质证明它就是 $A$ 的行列式

## 性质10 $\det{A^T}=\det{A}$

推论是全 
$0$
 列的存在使行列式也是 
$0$
，交换两列也会改变符号，证明该性质：

$\left|A\right|=|L||U|$，$|A^T|=|U^T||L^T|$，又有 $|L|=1$, $L^T$ 虽然是上三角矩阵，但是主对角线上还是 $1$，所以 $|L^T|=1$，对于 $U$ 而言也是同样的道理，得证

------

最后，从性质2可以得知，任何一种行交换得到的置换，都可以区分奇偶，那就是国内教材从排列引出行列式的另一种方式了

到这里，满足前三个性质的值称为行列式，但是它的意义我还不理解，[维基百科上](https://zh.wikipedia.org/wiki/%E8%A1%8C%E5%88%97%E5%BC%8F#%E7%9B%B4%E8%A7%82%E5%AE%9A%E4%B9%89)说是在方块矩阵上计算得到的标量，几何意义后面也讲了，二阶的、三阶的行列式可以表示面积、体积

----

# $\S 19$ 行列式公式 & 代数余子式

要求 n阶行列式的计算方法，先从 $2*2$ 的矩阵开始考虑

$\left|
  \begin{matrix}
  a&b\\\\
  c&d
  \end{matrix}
\right|=
\left|
  \begin{matrix}
  a&0\\\\
  c&d\\
  \end{matrix}
\right|+
\left|
  \begin{matrix}
  0&b\\\\
  c&d
  \end{matrix}
\right|=
\left|
  \begin{matrix}
  a&0\\\\
  c&0
  \end{matrix}
\right|+
\left|
  \begin{matrix}
  a&0\\\\
  0&d
  \end{matrix}
\right|+
\left|
  \begin{matrix}
  0&b\\\\
  c&0
  \end{matrix}
\right|+
\left|
  \begin{matrix}
  0&b\\\\
  0&d
  \end{matrix}
\right|=ad-bc$

而对于一个三阶的行列式
$\left|
  \begin{matrix}
  a_{11}&a_{12}&a_{13}\\\\
  a_{21}&a_{22}&a_{23}\\\\
  a_{31}&a_{32}&a_{33}
  \end{matrix}
\right|$ 
我们考虑将其拆分的过程，也就是每行每列只留下一个元素，再排除那些包含零行的情况，得到:

$\left|
  \begin{matrix}
  a_{11}&a_{12}&a_{13}\\\\
  a_{21}&a_{22}&a_{23}\\\\
  a_{31}&a_{32}&a_{33}
  \end{matrix}
\right|=
\left|
  \begin{matrix}
  a_{11}&0&0\\\\
  0&a_{22}&0\\\\
  0&0&a_{33}
  \end{matrix}
\right|+
\left|
  \begin{matrix}
  a_{11}&0&0\\\\
  0&0&a_{23}\\\\
  0&a_{32}&0
  \end{matrix}
\right|+
\left|
  \begin{matrix}
  0&a_{12}&0\\\\
  a_{21}&0&0\\\\
  0&0&a_{33}
  \end{matrix}
\right|+$

$\left|
  \begin{matrix}
  0&a_{12}&0\\\\
  0&0&a_{23}\\\\
  a_{31}&0&0
  \end{matrix}
\right|+
\left|
  \begin{matrix}
  0&0&a_{13}\\\\
  a_{21}&0&0\\\\
  0&a_{32}&0
  \end{matrix}
\right|+
\left|
  \begin{matrix}
  0&0&a_{13}\\\\
  0&a_{22}&0\\\\
  a_{31}&0&0
  \end{matrix}
\right|=$

$$a_{11}a_{22}a_{33}-a_{11}a_{23}a_{32}-a_{12}a_{21}a_{33}+a_{12}a_{23}a_{31}+a_{13}a_{21}a_{32}-a_{13}a_{22}a_{31}$$

我们考虑每个数字下表中列的部分，可以发现 ：交换行的次数奇偶性 和按照行固定顺序后，列数字里面的逆序数奇偶性有关系，这就决定了正负号

至此我们可以尝试推出 $n$ 阶矩阵行列式的计算方法(有一说一如果这种方法去算行列式，按所谓逆序数的数量去交换行是一件很慢的事情，能不能用双指针去固定一个个行的位置？然后$O(N)$做完这件事情？)

可以知道 $n$ 阶的时候我们要考虑 $n!$ 项，那么行列式公式

$\det{A}=\sum\limits_{all\ permutation}{a_{1p_1}\times a_{2p_2}\times}\dots\times a_{np_n}\times(-1)^k$

其中 $p_1p_2\dots p_n$ 是 $n$ 阶全排列中的一组，$k$ 是这组排列的逆序数，意味着要交换行的次数(用傻瓜方法交换)

现在我们有了行列式的计算公式，用这个公式也可以证明上述所有性质

(注意逆序数以及上面这个公式教授并没有整理甚至提到，而是在指出行交换的次数奇偶性就没有进一步定义，也确实没有围绕这东西做文章的必要)

代数余子式(cofactor,辅因子)的作用是把 $n$ 阶行列式化简成 $n-1$ 阶行列式，以三阶行列式为例，
$$\begin{align*}
\det{A}&=a_{11}(a_{22}a_{33}-a_{23}a_{32})\\
&+ a_{12}(a_{23}a_{31}-a_{21}a_{33})\\
&+ a_{13}(a_{21}a_{32}-a_{22}a_{31})
\end{align*}$$

$[$Cofactor of $A_{ij}]=C_{ij} = \pm\det$ ( $n-1$ matrix with $row_i,col_j$ removed )，当 $i+j$ 为奇时取负，否则为正

代数余子式在第一行展开 $\det{A}=a_{11}C_{11}+\dots+a_{1n}c_{1n}$

这也是行列式的第三种定义，利用代数余子式和指定行展开求行列式

当然，消完元对角线乘起来(主元公式)求行列式的方法还是最爽的，不用展开什么的

----------

# $\S 20$ 克拉默法则、逆矩阵、体积

## 逆矩阵公式：

$A^{-1}=\frac{1}{\det{A}}C^T$，$C$ 教授称作代数余子式矩阵，$C^T$ 一般称为伴随矩阵，也写作 $\operatorname{adj}({\mathbf{A}})$

[维基百科-伴随矩阵](https://zh.wikipedia.org/wiki/%E4%BC%B4%E9%9A%8F%E7%9F%A9%E9%98%B5#2x2%E7%9F%A9%E9%98%B5)


以下定义转自维基百科

* 定义：$A$关于第$i$行第$j$列的余子式（记作$M_{ij}$）是去掉$A$的第$i$行第$j$列之后得到的$(n − 1)\times(n − 1)$矩阵的行列式。
* 定义：$A$关于第$i$行第$j$列的代数余子式是

$C_{ij}=(-1)^{i+j}M_{ij}$

* 定义：$\operatorname{A}$ 的**余子矩阵**是一个 $n\times{n}$ 的矩阵 $\operatorname{C}$，使得其第 $\operatorname{i}$ 行第 $\operatorname{j}$ 列的元素是 $\operatorname{A}$ 关于第 $\operatorname{i}$ 行第 $\operatorname{j}$ 列的**代数余子式**

${2\times2}$ 的形式:

$\begin{bmatrix}
a&b\\\\
c&d
\end{bmatrix}^{-1}=
\frac{1}{ad-bc}
\begin{bmatrix}
d&-b\\\\
-c&a
\end{bmatrix}$

证明： check $AC^T=(\det{A})I$

$A=
\begin{bmatrix}
a_{11}&\dots&a_{1n}\\\\
\\\\
\\\\
a_{n1}&\dots&a_{nn}
\end{bmatrix}$,
$C^T=
\begin{bmatrix}
c_{11}&\ &\ \\\\
\vdots&\ &\ \\\\
c_{1n}&\ &\
\end{bmatrix}$，写出这个之后不难发现，主对角线上的元素都是 $\det{A}$，而如果选择了不对应的行列即 $A$ 的第 $i$ 行和 C 的第 $j$ 列 $(i\ne j)$，那么本质上是在用公式计算行列式的时候一列上选择了相同的元素，这样消元后会产生 $0$ 行，因此不再主对角线上的元素自然为 $0$

------

## 克拉默法则

$$Ax=b$$

$$x=\frac{1}{\det{A}}C^Tb$$

**Cramer's Rule:**

考虑 $x$ 的各个分量，是一组代数余子式乘 $b$，不妨设 $x_1=\frac{\det{B_1}}{\det{A}},x_2=\frac{\det{B_2}}{\det{A}},\dots$

考虑 $B_1$，我们发现 $x_1=c_{11}b_1+c_{21}b_2+\dots+c_{n1}b_{n}$

那么就等价于把 $A$ 的第一列换成 $b$ 向量，然后沿第一列展开乘代数余子式求行列式的操作，因为我们之前已经知道了一个性质 $\det{A^T}=\det{A}$，所以按行展开还是按列展开都是自由的，主要是确保每列每行只有一个元素被选中，计算行列式时候才不为 $0$

因此 $B_j$ 就是把 $A$ 的第 $j$ 列改成 $b$，然后计算整整 $n+1$ 个行列式，就能得到答案辣！

$x_i=\frac{\det{B_i}}{\det{A}}$

作用么，作为代数形式的观赏作用吧。

题外话，我原来觉得消元这种 $N^2$ 操作慢的一批，十分基础，没想到已经是大道至简了。。

---------

## 体积、面积、行列式的几何意义

给定三个不同向、不共面的向量 $(a_{11},a_{12},a_{13})$,$(a_{21},a_{22},a_{23})$,$(a_{31},a_{32},a_{33})$，他们组成的平行六面体体积就是 $\det{A}$ 的绝对值，正负号表示该平行六面体是左手系还是右手系

证明：如果这个体积具有行列式的前三个性质，那么这三个性质又能推出行列式，那么可以得知体积就是行列式

首先可以知道的事 $\det{I}=1$ 这在三阶的时候成立，体积就是1

然后来考虑正交矩阵，他的每一列都是标准正交向量，当然用行向量表示一条边还是列向量无所谓，因为行列式转置不变的性质，$A=Q$ 这时得到一个旋转过的单位立方体，而此时 $|Q|=1$，因为 $QQ^T=I$，则有 $\begin{vmatrix}Q\end{vmatrix}\begin{vmatrix}Q^T\end{vmatrix}=1\iff\begin{vmatrix}Q\end{vmatrix}^2=1\iff\begin{vmatrix}Q\end{vmatrix}=\pm1$

相应的还有向量叉积，几何意义上也是三阶行列式对应面积

现在性质 $1$ 证明完了，考虑性质 $2$，叉积从一个 $\mathbf{a}$ 转向 $\mathbf{b}$ 的过程有正方向，逆时针和负方向，改变方向会改变叉积的符号，当然在计算值的时候加上绝对值，可以不考虑这一点

考虑性质 $3$

对于性质 $3.a$，当长方体的一边改变长度，对于单位立方体来说就是一条边改变一个系数

对于性质 $3.b$，当一边加上另一个变量，可以用体积的割补看出来，面积也是如此

-----

# $\S 21$ 特征值 & 特征向量

$Ax$ 是 $x$ 左乘一个 $A$，得到一组变量，这里我们可以把 $A$ 看作一个函数，那么对于 $A$，如有 $x$ 满足 $Ax=\lambda x$，即 $Ax$ 和 $x$ 平行，那么我们称 $x$ 为特征向量，$\lambda$ 称为特征值，特征向量不能是零向量，没有意义

推论：若 $A$ 是奇异矩阵，则一定有一个 $\lambda=0$，并且有 $\lambda=0$ 的矩阵一定是奇异矩阵

性质：$n\times n$ 的矩阵有 $n$ 个特征值，特征值的和等于对角线元素和($\sum\limits_{i=1}^{n}{a_{ii}}$)

求解 $Ax=\lambda x$

$\to (A-\lambda I)x=0$，又因为 $x$ 不能是零向量，因此 $(A-\lambda I)$ 必须是奇异的，这也说明了为什么 $n\times n$ 的矩阵有 $n$ 个特征值，此时转而求解 $\begin{vmatrix}A-\lambda I\end{vmatrix}=0$，这称为特征(值)方程，解出 $n$ 个可能重复的特征值 $\lambda$，回代求出对应的零空间

if $Ax=\lambda x$ then $(A+kI)x=\lambda x + 3x=(\lambda+3)x$

特征值之积等于行列式，去知乎了一些解释，看不懂，纯纯数学白痴，明年上半年找时间补一下代数知识吧。。。

还剩一个对角化，保险起见考前再看一下吧

----

# 要注意的地方

傻呗同济单位矩阵用E表示，秩用r()表示，如增广矩阵的秩为 $r(A,b)$ 伴随矩阵用 $A^*$ 表示

向量构成的一组矩阵所谓的“极大无关组”就是 该向量空间对应的线性基

----------------------

到这里应付鄙校的线代考试内容就足够了(甚至没考过对角化)，这篇笔记的内容越到后面也越臃肿了

等之后暑假学FFT、矩阵加速的时候把剩下的内容补完，并且做一个简化吧
