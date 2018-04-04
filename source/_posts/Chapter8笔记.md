---
title: Chapter_8 笔记
date: 2018-03-14 15:24:16
tags: 
	- 算法导论
categories:
	- Algorithm算法相关
src: 1.jpg
---
&emsp;&emsp;算法导论第八章笔记——几个运行时间是线性的排序算法！
<!--more-->
&emsp;&emsp;这一章的某些算法分析要用到前面第五章的概率分析和随机算法的知识(刚好是我略过没讲的- -)。
# 8.1 基于比较的排序的下界
&emsp;&emsp;任何基于比较的排序算法在最坏的情况下需要$\Omega(nlgn)$次比较。</br>
&emsp;&emsp;证明：书上是通过一棵“比较树”(decision tree)证明的，
![decision tree](deemo1.jpg)
&emsp;&emsp;首先在这棵树中，每一个结点中的比较结果都会决定下一次的比较是在哪一个结点(比如根结点的$1:2$，结果是小于，所以下一次的比较就是它的左孩子)，也就是说每一层中都只会选一个结点来比较，所以排序一次要比较的次数与这棵树的高度有关。</br>
&emsp;&emsp;按照书上的证明：令树的高度为$h$，叶子(reachable leaves)的个数为$l$，那么根据二叉树的性质(每一层都是上一层的两倍，$2^h$就是完全二叉树的叶子数了)，有：
$$
	l≤2^h
$$&emsp;&emsp;然后因为decision tree的叶子其实是把输入的树的排列情况列出来，所以又有：
$$
	n!≤l
$$

>&emsp;&emsp;作者：“书上说是"≤"，其实我也认为是$n!=l$，不过这个也影响不大。”

&emsp;&emsp;所以就有：
$$
	n!≤2^h
$$&emsp;&emsp;两边取$lg$，得到(利用了P58的公式3.19)：
$$
	h≥lg(n!)=\Omega(nlgn)
$$
>&emsp;&emsp;作者：“这个比较简单，粗略带过。”

# 8.2 计数排序(Counting sort)
&emsp;&emsp;令需要排序的$n$个数的范围是从$0$到$k$整数，那么当$k=O(n)$时，计数排序需要的时间是$O(n)$。因为不是基于比较的，所以计数排序不受$\Omega(nlgn)$的限制，但是它需要对输入的数进行限制：要是整数。
## 计数排序的过程
![书上的例子和代码](deemo2.jpg)
&emsp;&emsp;首先看书上的例子，很明显的看出数组$A$中的数的范围是从$0$到$5$，所以就得到$k=5$。
>&emsp;&emsp;作者：“我认为要找出$k$的话还应该要找出数组$A$中的最大值和最小值，不过反正找最大最小值也是要$\theta(n)$，这个影响不大。”

&emsp;&emsp;这样的话就可以新建一个大小为6的辅助数组$C$(从$0$到$5$，代码的第一行)，然后就是清空数组$C$(2、3行)，然后再扫描一次$A$数组，把$A$里面的数字出现的次数记录在$C$中(即最终$A$中大小为$i$的数的个数有$C[i]$个，代码的4、5行)。
&emsp;&emsp;下一步就是把$C$中的数累加起来(就是$C[i] += C[i-1]$，代码7、8行)。到这里可以归纳出一些性质：①此时$C[i]$代表的是$A$中小于等于$i$的数的(总)个数；②$A$中大小为$i$的数的个数为$C[i]-C[i-1]$个。
&emsp;&emsp;最后一步就是按照一定的“规则”，利用$C$把$A$中的数放到新数组$B$中，完成后$B$就是排好序的$A$数组了(代码10到12行)。这一步如果把$A$中全部数堆在一起分析的话可能不容易看出为什么要这样做，试着抓住一个数来分析的话可能会简单一点。
&emsp;&emsp;比如可以只关注$3$，在扫到第一个$3$时，$C[3]=7$，其实数组$C$更像一个指示器，指示$A$中的数在$B$中应该放置的位置，比如现在就是要放到$B$中"7"的位置，为什么要放到"7"？根据上面的性质①，共有$C[3]-1=6$个数(除去自身)是小于等于$3$的，也就是$3$比这些数都大(或相等)，把$3$放到$B[7]$，然后把那$6$个数放到$B[1]~B[6]$(先不管顺序)那就是合理的了。
&emsp;&emsp;在放好第一个"3"后，$C[3]$就自减$1$($C[3]=C[3]-1=6$，既然那一个放在$B[7]$的"3"都放好了，接下来就不用考虑它了)，然后继续扫会遇到第二个"3"，同理，就可以知道有$C[3]-1=5$个数小于等于那个"3"(为什么C[3]自减$1$后还成立？根据性质②，只要$C[i]$没减到$C[i-1]$的话性质①都是成立的，而减到$C[i-1]$的话就表明大小为$i$的数已经被处理完了)，所以把$3$放到$B[6]$，然后把那$5$个数放到$B[1]~B[5]$也是合理的。剩下的"3"同理。
&emsp;&emsp;其他的数也是同理，把全部的数一起看时也是同理。
>&emsp;&emsp;作者：“废话了这么多(还没有图!)，如果知道怎样解释这个算法的合理性的可以绕过- -”

&emsp;&emsp;另外，有一个地方要重点注意的就是代码第10行的那个"down to"，为什么要从后往前扫？因为要保持排序的稳定性(两个数相等的时候顺序要跟原来数组的一样，书P196页最后一行)，至于为什么从前往后扫不行，自己试一下就知道了。
&emsp;&emsp;结合上面的分析，自己也可以试一下把这个算法改成降序(从大到小)，只需要把代码第8行的“累加”换一个方向就好了。

## 算法分析
&emsp;&emsp;这个没什么好分析的，四个for循环，两个跑了$k$次，两个跑了$n$次，合起来就是$\theta(n+k)$了。又因为通常情况下$k=O(n)$的时候我们才会用(这时候效率才足够高)，所以$k$就可以忽略，所以就是$\theta(n)$了。

# 8.3 基数排序(Radix sort)
&emsp;&emsp;所谓的基数排序其实就是把一些比较大的数按照从低位到高位的规则进行排序，比如书上的例子，就是一堆三位的数，先把各位排好，再把十位排好，再把百位排好，那么这些数就是排好顺序的了。
![书上例子](deemo3.jpg)
&emsp;&emsp;代码的话也就是两行：
![代码](deemo4.jpg)
&emsp;&emsp;为什么要从低位开始排？可以理解为高位的数(数字)对一个数的大小起的作用更大(所谓主角都是最后出场的。。。)，而有一点要注意的是排高位的时候，如果有几个数的那一位是相同的话，在排序的时候不可以影响到前面排好的低位数(不然努力就白费了)，因此就要用到前面说的稳定性，也就是代码中说的“用一个稳定的算法对每一位进行排序”。
>&emsp;&emsp;作者：“至于为什么不稳定性不行，为什么这个为什么那个...其实自己找一些数演算一下会更好理解。”

## 算法分析
&emsp;&emsp;因为每一位的排序用的是计数排序(也符合稳定性)，所以每一位花费的时间是$\theta(n+k)$，一共有
$d$位数，所以总时间就是：
$$
	\theta(d(n+k))
$$&emsp;&emsp;书上还给了一种处理较大数的一种方法(我把它理解为一种方法)：给定$n$个有$b$位(bit，这里是二进制的位)的数，可以取一个小于或等于$b$的整数$r$，令这些数的每一位(digit，这里是个位十位百位的位)的大小都是有$b$位(bit)。这样的话就得到：
$$
	d=b/r&ensp;,&ensp;[digit=(all&ensp;bit)/(bit&ensp;on&ensp;every&ensp;digit)]
$$&emsp;&emsp;然后代入$\theta(d(n+k))$，就得到：
$$
	\theta((b/r)(n+k))
$$&emsp;&emsp;$k$代表是一个digit的大小，其实也就是$2^r$了，所以代进上式：
$$
	\theta((b/r)(n+2^r))
$$&emsp;&emsp;因为$b$是自己取的，所以还要关注一下$b$取什么值时有最好的情况。这个要分两种情况：

* 第一种就是当$b<⌊lgn⌋$时:
&emsp;&emsp;因为$r≤b$，所以：
$$
	n<(n+2^r)<(n+2^b)≤(n+2^{lgn})=2n
$$&emsp;&emsp;也就是:
$$
	(n+2^r)=\theta(n)
$$&emsp;&emsp;这个时候对于$(b/r)$，因为$r≤b$，所以明显当$r=b$时,$(b/r)$最小：
$$
	\theta((b/r)(n+2^r))=\theta(n)
$$
&emsp;&emsp;一句话来说就是这个时候取$r=b$时有最好情况$\theta(n)$。

* 第二种就是当$b≥⌊lgn⌋$时:
&emsp;&emsp;这个时候就是$r=⌊lgn⌋$时有最好情况$\theta(n)$，因为：
&emsp;&emsp;当$r>⌊lgn⌋$时，整理一下上面的公式，可以得到：
$$
	(b/r)(n+2^r)=(bn+b·2^r)/r
$$&emsp;&emsp;因为$n$和$b$是确定的，所以只需要关注$r$，可以看出分子中的$2^r$是爆炸性增长，分母是线性增长，分子比分母增长快，所以整体是递增的(就是递增函数啦)。
&emsp;&emsp;当$r<⌊lgn⌋$时，无论$r$怎么减小，$(n+2^r)$这一部分都是$\theta(n)$，但是$(b/r)$这一部分却随着$r$的减小而增加，所以既然都是$\theta(n)$了，继续减小$r$只会吃力不讨好。
>&emsp;&emsp;作者：“所以当数字特别大的时候可不可以把多个digit当作一个digit来排？”


# 8.4 桶排序(Bucket sort)
&emsp;&emsp;桶排序也是对输入有限制的，它是假设输入的数范围在[0,1)，它的平均运行时间是$O(n)$。

## 桶排序过程
![书上的例子和代码](deemo5.jpg)
&emsp;&emsp;首先对于输入的$A$数组，新建一个数组$B$用来当作桶(书上的取了$B$的大小跟$A$的一样，是为了使每一个桶中的数都尽量少，所谓的以空间换时间- -)。
&emsp;&emsp;然后对于$A$中的数，按照一定规则放到$B$的桶中(代码的第6行)，如果一个桶中不止有一个数的话就用链表把它们串起来。
&emsp;&emsp;数放完后就对它们进行排序：先是对每个桶中的数进行排序(链表的插入排序)，然后再把每个桶中的链表串起来(当然最后不一定用链表串，可以用数组)，总而言之就是采取“先局部再整体的战略”。
&emsp;&emsp;可以看出，因为用了插入排序，所以这个算法的最坏情况是$O(n^2)$，就是全部数都堆在一个桶的时候。不过这种情况的几率很少，书上的例子的话就是$(\frac{1}{n})^n$。

## 算法分析
&emsp;&emsp;首先，除了插入排序的那个for循环，其他的都是$\theta(n)$的(其他两个循环都是执行了$n$次，每次$\theta(1)$，第9行的即使全部扫一遍也是$\theta(n)$)。设$n_i$是第$i$个桶里面的数的个数的话，因为插入排序花费的时间是$O(n)$，所以对第$i$个桶排序花费的是$O(n_i)$，所以第8、9行的花费时间就是把每个桶的排序时间加起来，也就是最后：
$$
	T(n)=\theta(n)+\sum_{i=0}^{n-1}O(n_i^2)
$$&emsp;&emsp;求平均运行时间，所以求个期望：
$$
	E[T(n)]=E\left[\theta(n)+\sum_{i=0}^{n-1}O(n_i^2)\right]
$$&emsp;&emsp;根据线性性：
$$\begin{equation}\begin{aligned}
	E[T(n)]&=\theta(n)+\sum_{i=0}^{n-1}E\left[O(n_i^2)\right] \\\ 
	       &=\theta(n)+\sum_{i=0}^{n-1}O(E\left[n_i^2\right])
\end{aligned}\end{equation}$$&emsp;&emsp;然后就要把$E[n_i^2]$解出来：
&emsp;&emsp;首先设定一个指示器变量，表示$A[j]$落入桶$i$这个事件：
$$
	X_{ij}=I\\{A[j]&ensp;falls&ensp;in&ensp;bucket&ensp;i\\}
$$&emsp;&emsp;因为$X_{ij}$在$A[j]$落到桶$i$的时候为$1$，不落在的时候为$0$，看有多少数落在桶$i$的话就只需要把从$X_{i1}$到$X_{in}$累加起来(相当于计数器，有一个数落在桶$i$就加一)，就是：
$$
	n_i=\sum_{j=1}^{n}X_{ij}
$$&emsp;&emsp;代入$E[n_i^2]$中：
$$\begin{equation}\begin{aligned}
	E\left[n_i^2\right]=E\left[(\sum_{j=1}^{n}X_{ij})^2\right]
\end{aligned}\end{equation}$$&emsp;&emsp;然后下一步就可以参考一下小学时的$(a+b)^2$，就是把它拆成$(a+b)(a+b)$然后两两组合，下面也是一个道理，只是数比较多：
$$\begin{equation}\begin{aligned}
	=E\left[\sum_{j=1}^{n}\sum_{k=1}^{n}X_{ij}X_{ik}\right]
\end{aligned}\end{equation}$$&emsp;&emsp;下一步是把这些组合中平方的数抽出来(前面那一项是平方项，后面那一项是非平方项，至于为什么要这样拆，看下去就知道了，是要利用事件的独立性)：
$$\begin{equation}\begin{aligned}
	=E\left[\sum_{j=1}^{n}X_{ij}^2 + \sum_{1≤j≤n}\sum_{1≤k≤n\\\&ensp;k≠j}X_{ij}X_{ik}\right]
\end{aligned}\end{equation}$$&emsp;&emsp;然后根据线性性：
$$\begin{equation}\begin{aligned}
	=\sum_{j=1}^{n}E\left[X_{ij}^2\right] + \sum_{1≤j≤n}\sum_{1≤k≤n\\\&ensp;k≠j}E\left[X_{ij}X_{ik}\right]
\end{aligned}\end{equation}$$&emsp;&emsp;先看$E\left[X_{ij}^2 \right]$：
$$\begin{equation}\begin{aligned}
	E\left[X_{ij}^2 \right]&=1^2· \frac{1}{n}+0^2· \left(1-\frac{1}{n} \right) \\\
			       &=\frac{1}{n}
\end{aligned}\end{equation}$$
>&emsp;&emsp;作者：“至于为什么是这样，大佬们给我的解答是：
$$
	if&ensp;X_{i}=
	\begin{cases}
	a, &Pr(a) \\\
	b, &Pr(b) \\\
	···, &Pr(···) \\\
	\end{cases}
	&ensp;then&ensp;f\left(X_{i}\right)=
	\begin{cases}
	f(a), &Pr(a) \\\
	f(b), &Pr(b) \\\
	f(···), &Pr(···) \\\
	\end{cases}
$$

&emsp;&emsp;然后看$E\left[X_{ij}X_{ik} \right]$，因为这两个事件是独立的(互不影响)，所以它们乘积的期望等于它们期望的乘积(书附录的 C.24)也就是：
$$\begin{equation}\begin{aligned}
	E\left[X_{ij}X_{ik} \right] &=E\left[X_{ij}\right]E\left[X_{ik} \right] \\\
				    &=\frac{1}{n}·\frac{1}{n} \\\
				    &=\frac{1}{n^2}
\end{aligned}\end{equation}$$&emsp;&emsp;最后把这两个东西代回去，就得到：
$$\begin{equation}\begin{aligned}
	E\left[n_i^2\right] &=\sum_{j=1}^{n}E\left[X_{ij}^2\right] + \sum_{1≤j≤n}\sum_{1≤k≤n\\\&ensp;k≠j}E\left[X_{ij}X_{ik}\right] \\\
	&=\sum_{j=1}^{n}\frac{1}{n} + \sum_{1≤j≤n}\sum_{1≤k≤n\\\&ensp;k≠j}\frac{1}{n^2} \\\
	&=n·\frac{1}{n}+n(n-1)·\frac{1}{n^2} \\\
	&=1+\frac{n-1}{n} \\\ 
	&=2-\frac{1}{n} \\\
\end{aligned}\end{equation}$$&emsp;&emsp;再把这个代回最初的那条式子：
$$\begin{equation}\begin{aligned}
	E[T(n)]
	&=\theta(n)+\sum_{i=0}^{n-1}O(E\left[n_i^2\right]) \\\
	&=\theta(n)+\sum_{i=0}^{n-1}O(2-\frac{1}{n}) \\\
	&=\theta(n)+n·O(2-\frac{1}{n}) \\\
	&=\theta(n)+O(2n-1) \\\
	&=\theta(n)+O(n) \\\
	&= \theta(n)
\end{aligned}\end{equation}$$

# 总结
&emsp;&emsp;以上的几个排序算法都打破了$\Omega(nlgn)$这个界限，但是这样付出的代价就是要对输入的数进行限制，即假设这些数的类型；而且即使它们是$\theta(n)$，也不见得一定会比$\theta(nlgn)$的快速排序、归并排序快，因为它们的系数没有被表示出来，某些算法(比如基数排序)的隐藏在$\theta(n)$中的系数就比较大，在一定的范围内还是没有快排这一类的排序算法快的，当然，如果$n$特别特别大的话$\theta(n)$的算法还是会比较快的。
</br></br></br>
ps：相关链接	↓
</br>
&emsp;&emsp;[主定理(Master Theorem)笔记](https://blog.tover.xyz/2018/03/03/%E4%B8%BB%E5%AE%9A%E7%90%86%E6%B5%85%E8%B0%88/)
&emsp;&emsp;[Chapter_9 笔记](https://blog.tover.xyz/2018/03/16/Chapter9%E7%AC%94%E8%AE%B0/)
&emsp;&emsp;[Chapter_11 笔记](https://blog.tover.xyz/2018/03/28/Chapter11%E7%AE%80%E8%AE%B0/)







