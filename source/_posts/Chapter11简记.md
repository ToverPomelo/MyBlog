---
title: Chapter_11 简记
date: 2018-03-28 14:37:36
tags: 
	- 算法导论
categories:
	- Algorithm算法相关
src: 1.jpg
---
&emsp;&emsp;算法导论第十一章——哈希表。
<!--more-->

# 11.1 直接寻址(Direct-address)
&emsp;&emsp;这个比较好理解，对于一堆数据，要把它们放进direct-address table的话，首先要给每一个数据绑定一个不同的key，就好像C语言中的结构体，然后每一个数据作为对应key的satellite data。
&emsp;&emsp;接下来建一个大小大于等于最大key值的数组，作为direct-address table，然后把satellite data(或者说整个结构体)放在数组的下标为对应key值的地方($T[key]$)。
![上图比较好了解](deemo1.jpg)
![几种操作](deemo2.jpg)
&emsp;&emsp;这种结构的插入、删除、搜索跟数组的操作一样，花费时间是$O(1)$。
&emsp;&emsp;但是有一种情况就是，如果在选择key值时集中选择较大的数的话(就是选的key值没有尽量地填满整个表)，就会出现表(数组)很大，但是前面却空了很多的情况，换句话来说就是浪费了空间。

# 11.2 哈希表
&emsp;&emsp;为了解决上面直接寻址的浪费空间问题，我们可以制定一套规则$h$，使的对应key值的数据不是放在$T[key]$，而是放在$T[h(key)]$中，这样的话，table的大小就不用局限在大于等于最大的key值了。这样改进来的表叫做哈希表(Hash tables)，其对应的规则叫做哈希方程(Hash Functions)。
![哈希表](deemo3.jpg)
&emsp;&emsp;这样改进以后又带来了另一个问题，因为哈希表$T$的大小是固定的，而取key值的域$U$是无限大的，所以无论哈希方程怎么取，都会有两个key被放在同一个格(slot)的情况，这种情况叫做碰撞(Collision)。
&emsp;&emsp;一种解决碰撞的方法叫做Chaining，就是当多个key被放到同一个slot时，就把它们串成链表。其对应的插入、删除、搜索是：先根据哈希方程找到对应的slot，然后用链表的操作来插入、删除、搜索对应slot中的链表的对应结点。
![Chaining](deemo4.jpg)
![对应的操作](deemo5.jpg)

## 搜索的分析
&emsp;&emsp;在分析前要做一些准备工作。
&emsp;&emsp;对于一个有$m$个slot、存放了$n$个元素的哈希表，我们定义它的负载系数(load factor)为$\alpha = n/m$。
&emsp;&emsp;由于哈希方程的选择参差不齐，我们还要对所选的哈希方程做一些假设：所选的哈希方程运算时花费的时间是$O(1)$、对于所给的每一个元素都会被等概率地分发到$m$个slot中、元素被分发时跟已经在表中的元素独立(与插入的顺序无关)。其中满足后两个的叫做"simple uniform hashing"
&emsp;&emsp;有了上面的假设就可以算出一个slot中链表长度的期望值：先选定一个slot，这样的话每一个元素被插入这个slot的概率是$1/m$，总共有$n$个元素，所以这个slot中链表长度的期望就是
$$
	E[length] = n·\frac{1}{m} = \frac{n}{m} = \alpha 
$$&emsp;&emsp;也就是期望的长度就是load factor($\alpha$)。其他的slot也是同理。

### Theorem 11.1
&emsp;&emsp;通过Chaining处理碰撞的哈希表中，搜索失败时花费的平均时间是$\theta(1+\alpha)$。证明：
&emsp;&emsp;失败的话其实就是找到对应的slot，然后遍历完整个链表。根据上面的假设，找slot时花费的时间是$O(1)$；又因为链表的期望长度是$\alpha$，所以遍历链表用的时间是$\theta(\alpha)$。加起来就是
$$
	$\theta(1+\alpha)$
$$

### Theorem 11.2
&emsp;&emsp;通过Chaining处理碰撞的哈希表中，搜索成功时花费的平均时间也是$\theta(1+\alpha)$。证明：
&emsp;&emsp;搜索成功的话就是找到对应的slot，然后遍历链表知道找到所需要的元素。在证明前首先要明确一下元素插入链表时的顺序：新的元素是插在链表的前面那部分的，书上p260页的上方有原文：
```text
	Because new elements are placed at the front of the list, elements before x in the list were all inserted after x was inserted.
```

&emsp;&emsp;所以要知道某个slot中的某个元素x前面有多少个元素(或是找到x前要遍历多少个元素)的话，只需要知道x插入这个slot后，x后面的元素还有多少个是插到跟x相同的slot中，因为链表中新的元素都是被插在链表的前面部分。
&emsp;&emsp;在算有多少元素会被hash到跟x相同的slot中时，还要定义一个指示器变量：
$$
	X_{ij} = I\\{h(k_i) = h(k_j) \\}
$$&emsp;&emsp;表示两个不同元素$k_i$和$k_j$被hash到同一个slot这个事件，由于前面假设每个元素hash到每个slot是等概率的，所以就得到$E[X_{ij}=1/m]$。
&emsp;&emsp;所以在找到所需要的元素时要遍历(书上说的是examine)的元素的平均个数是：
$$
	E\left[\frac{1}{n}\sum^n_{i=1}\left(1+\sum^n_{j=i+1}X_{ij} \right) \right]
$$&emsp;&emsp;解释一下这个公式：$\sum^n_{i=1}$就是考虑搜索的所有情况(就是$n$个元素的情况)；$\frac{1}{n}$就是在所有的情况中取一个平均值；$1$就是要找(或者说找到)的那个元素；$\sum^n_{j=i+1}X_{ij}$就是按顺序来时第$i$个元素后面还有多少个元素会和第$i$个元素hash到同一个slot中(就是上面说的，链表中第$i$个元素前面有多少个元素)；$E$就是求期望了。
&emsp;&emsp;接下来就是对这个这个公式化简：
![化简](deemo6.jpg)
&emsp;&emsp;加上找这个slot时花费的$O(1)$，最终得到的搜索成功时花费的平均时间是：
$$
	\theta(1+1+\alpha/2-\alpha/2n) = \theta(1+\alpha)
$$

# 哈希方程(Hash functions)
&emsp;&emsp;用Chaining处理碰撞时有一个缺陷，如果所有元素都hash到同一个slot中的话，哈希表就会退化为链表，原本搜索花费的$\theta(1+\alpha)$或是$\theta(1)$时间就会增加到$\theta(n)$。虽然正常来说这种情况发生的几率很小，但是如果被一些图谋不轨的人利用的话就可以发起“Hash碰撞式拒绝服务攻击”(大概是这个名字吧)：攻击者精心挑选特定的值(比如他知道你的源码)使得它们都被hash到同一个slot中，使哈希表退化成链表，增加了程序的运行时间知道服务器崩溃。
&emsp;&emsp;在谈其他的解决碰撞的方法前，首先说一下哈希方程：
&emsp;&emsp;在创造一个好的哈希方程前，首先要知道好的哈希方程应该有哪些特点，我根据我不多的经验总结了一下(其实就是simple uniform hashing加上一堆废话)：
```text
	①元素会被hash到每一个slot中，而且到每个slot中的概率相等(1/m)
	②一个元素被hash到某一个slot时与表中的元素独立(与hash的顺序无关)
	③方程计算得要快($O(1)$)
	④尽量避免碰撞
```

&emsp;&emsp;还有方程处理的时候尽量处理数字(自然数)，如果输入的元素是字符或字符串的话可以按一定的规则把它转化为数字，比如ASCII。

## The division method
&emsp;&emsp;方程如下：
$$
	h(k) = k&ensp;mod&ensp;m
$$
&emsp;&emsp;$k$就是key的大小了，$m$就是哈希表的大小。因为取了$m$的模，所以明显key会有可能落在每一个slot中，而且落在每一个slot中的概率相等，满足simple uniform hashing。
&emsp;&emsp;用这种哈希方程时对$m$的选择要特别注意：要尽量避免$2$的次方的数($2^p$)，原因是取$2^p$的模，其实就是取这一个数的比特串的低$p$位(从计算机的角度看)。换句话说就是哈希方程的结果是由低$p$位这样的少数的比特决定的。
&emsp;&emsp;更好的做法是key的每一个比特都对哈希方程的结果有影响，比如说选择一个不接近$2^p$的素数作为$m$。书上给了个例子是$m=701$：
![Example](deemo7.jpg)

## The multiplication method
&emsp;&emsp;如果一定要选$m$是$2$的次方的话，可以尝试另一种哈希方程，先上公式：
$$
	h(k) = ⌊m(kA&ensp;mod&ensp;1)⌋
$$&emsp;&emsp;其中，$k$是key，$m$是哈希表长度，$A$是一个在0到1之间的值($0<A<1$)。可以看出，$A$取得合理的话，元素是可以均匀地被hash到表中的，书上给的一个建议是$A$取黄金比例($A≈(\sqrt{5}-1)/2$)。
&emsp;&emsp;书上还给了一个计算的例子，因为是简记(- -)，所以我贴个图就算了：
![图](deemo8.jpg)
![原文](deemo9.jpg)
&emsp;&emsp;值得注意的是最后$r_0$取前面的$14$位时，因为$ro$展开成二进制时是不足32位(前面假设的机器字长)，所以在$r_0$转换成二进制后要在前面补$0$直到够32位。书上的答案$h(k)=67$是正确的。

## Universal hashing(全域哈希)
&emsp;&emsp;全域哈希是一种可以解决上面说的“Hash碰撞式拒绝服务攻击”的一种方法，它解决的套路是选哈希方程的时候不是选固定的方程，而是在一个哈希方程集合($ℋ$)中随机地选择一个哈希方程，这样的话攻击者就算知道这个集合具体是什么，也不知道被选出来的哈希方程是什么，因为是随机的。
&emsp;&emsp;集合里面的哈希方程也不是乱塞进去的，这个集合要符合一定的规则：任意选两个key，$k$和$l$，这个集合里面随机选出来的哈希方程要有小于等于$1/m$的概率使它们发生冲突。也可以说成集合中使$k$和$l$发生冲突的
哈稀函数的个数不多于$|ℋ|/m$个，其中$|ℋ|$是集合中函数的个数。
![原文](deemo10.jpg)

### Theorem 11.3
&emsp;&emsp;使用全域哈希并用Chaining的方法处理碰撞时：若key k不在表中，那么k应该要到的slot中的链表的长度的期望值($E[n_{h(k)}]$)最多为$\alpha = n/m$；如果k在表中的话，$E[n_{h(k)}]$最多为$1+\alpha$。证明：
&emsp;&emsp;首先定义指示器变量$X_{kl} = I\\{h(k)=h(l)\\}$，表示不同的key，$k$和$l$发生碰撞这个事件。根据全域哈希的定义，$k$和$l$发生碰撞的概率是不小于$1/m$的，所以就是($Pr$指的是概率)：
$$
	Pr\\{h(k)=h(l)\\}≤1/m
$$&emsp;&emsp;也就是：
$$
	E[X_{kl}]≤1/m
$$&emsp;&emsp;然后又定义随机变量$Y_k$，表示在$k$应该被hash到的slot中的key的个数(或说链表长度)。得到$Y_k$与$X_{kl}$的关系：
$$
	Y_k = \sum_{l∈T \\\ l≠k}X_{kl}
$$&emsp;&emsp;求个期望：
![](deemo11.jpg)
&emsp;&emsp;然后就要分$k$在不在表中的两种情况：
&emsp;&emsp;如果$k$不在表中的话，$k$应该在的那个slot的元素个数就是$Y_k$；整个表($T$)中的元素个数(注意$k$不在表中)是$n$，所以就是：
$$
	E[n_{h(k)}] = E[Y_k] ≤ n/m = \alpha
$$&emsp;&emsp;如果$k$在表中的话，$k$所在的那个slot的元素个数就是$Y_k$加上自身，就是$Y_k+1$；整个表的元素个数减去$k$就是$n-1$，所以就是：
$$
	E[n_{h(k)}] = E[Y_k]+1 ≤ (n-1)/m+1 = 1+\alpha-1/m < 1+\alpha
$$
![原文](deemo12.jpg)
&emsp;&emsp;这个theorem想告诉我们的是如果哈希方程随机选的话，每个slot的链表都有差不多$\alpha$的期望长度，所以攻击者想把哈希表退化成链表的话就行不通了。

### 哈希方程集合的设计
&emsp;&emsp;按照前面说的全域哈希的定义，书上给了一个设计哈希方程集合的例子，先上公式：
$$
	h_{ab}(k) = ((ak+b)&ensp;mod&ensp;p)&ensp;mod&ensp;m
$$&emsp;&emsp;其中，$k$是key值，$m$是哈希表的长度，$p$是一个大于$m$的素数，$a$是一个属于小于$p$的正整数($a∈ℤ^\*_p$，$ℤ_p=\\{0,1,···,p-1\\}$)，$b$是一个小于$p$的有理数($b∈ℤ\_p$)。选择哈希方程的随机性就表现在选择的$a$和$b$的不同。这个集合也可以表示为($ℋ\_{pm}$含有$p(p-1)$个方程)：
$$
	ℋ\_{pm} = \\{h_{ab}:a∈ℤ^\*\_p&ensp;and&ensp;b∈ℤ\_p \\}
$$&emsp;&emsp;下面证明这个方程符合全域哈希：

### Theorem 11.5
&emsp;&emsp;(由于涉及到我还没有学的数论，而且这个是简记！所以贴个图算了)
![原文的证明](deemo13.jpg)

# 开放寻址(Open addressing)
&emsp;&emsp;开放寻址是另外一种处理碰撞的方法，与Chaining不同，开放寻址不用创造额外的链表，而是把碰撞的元素放在表的其他slot中。因为没有用到链表，所以没有用到指针之类的，这样的话就省了不少空间。
&emsp;&emsp;具体的做法可以看成是一个哈希方程的集合(也叫做探测序列)$〈h(k,0),h(k,1),···,h(k,m-1)〉$，hash的时候先从$h(k,0)$开始，如果没有碰撞的话那就这样了；如果发生碰撞的话，那就使用哈希方程$h(k,1)$，如果还是有碰撞的话就用$h(k,2)$...一直到用完或者没有发生碰撞。
&emsp;&emsp;从上面的做法也可以看出这个哈希方程集合的一个性质：对于一个key，集合中的所有不同的方程要把它hash满整个哈希表(或者说$h(k,0),h(k,1),···,h(k,m-1)$覆盖整个表)。

## 几种操作
&emsp;&emsp;关于开放寻址的哈希方程后面再讲，下面先讲开放寻址的几种操作：

### 插入操作
&emsp;&emsp;上代码：
![代码](deemo14.jpg)
&emsp;&emsp;其中NIL表示的是slot为空(没有元素，不会碰撞)。代码的意思很简单，就是顺序地尝试方程集合中的每一个方程(像上面说的)，知道没有碰撞或者方程用完，根据上面的那个性质，这些方程会覆盖整个表，所以方程用完的话就是表满了。

### 搜索操作
&emsp;&emsp;先上代码：
![代码](deemo15.jpg)
&emsp;&emsp;这个其实跟插入一样，顺序地尝试集合中的所有方程，如果方程指向的slot中的元素与所搜索的元素不符的话就用下一个方程，知道所用的方程指向的slot为空或者方程用完。

### 删除操作
&emsp;&emsp;值得一提的是上面的插入操作是适用于没有删除的情况的(其实可以认为那两种操作是没有考虑删除的，只是搜索的话在考虑删除时也适用。。)，考虑删除的话插入操作要做小小的修改。
&emsp;&emsp;首先解释不作修改的话会有怎样的冲突：如果删除一个slot中的元素时把它标记为空(NIL)的话，假设现在要搜索一个key，这个key在插入时是使用第六个方程($h(key,5)$)插入的，如果$h(key,3)$被删除了并标记为NIL的话，在搜索key的时候就只会搜索到$h(key,2)$，而忽略了$h(key,4)$和$h(key,5)$。
&emsp;&emsp;为了解决这个尴尬的情况，书上给的解决方法是：删除时不把slot标记为空(NIL)，而是把它标记为已删除(DELETED)。继续上面的例子，这样的话搜索到$h(key,3)$时因为它不是NIL，所以搜索不会停止(结合搜索的代码来看)，后面的两个元素也就不会被忽略了。
&emsp;&emsp;但这样的话就带来另外一个缺陷：如果不对插入作修改的话，那些标记为DELETED的slot(是空的，可以插入元素)就会被略过，这样的话空间就会被浪费。所以对插入的操作就是代码第四行中的"if T[j]==NIL"改为"if T[j]==NIL or DELETED"，也就是判断能不能被插入而不是是否标记为空。
>&emsp;&emsp;作者：“如果删除得比较多的话，Open addressing占用的空间会增多，而且根据书说的，搜索的时间就不依赖与$\alpha$(多于的意思)。所以如果删除得比较多的话，考虑Chaining会更好。”

## 开放寻址的哈希方程
&emsp;&emsp;下面说一下这些神奇的哈希方程集合(探测序列)。首先提一下Uniform hashing。

### Uniform hashing
&emsp;&emsp;Uniform hashing是一种理想状态：对于每一个key，它们的探测序列会等可能地得到$〈0,1,···,m-1〉$中的$m!$种(排列，$A^m_m$)序列的一种。
&emsp;&emsp;完美的Uniform hashing是很难实现的，但是可以实现大约的Uniform hashing，比如下面会说的Double hashing。

### Linear probing(一次探测)
&emsp;&emsp;先上公式：
$$
	h(k,i)=(h'(k)+i)&ensp;mod&ensp;m
$$&emsp;&emsp;其中，$k$是key值，$i$是选方程时那个$0$到$m-1$的顺序，$h'(k)$是另外一个哈希方程(不是求导！)，$m$是表的长度。
&emsp;&emsp;公式的意思是先用$h'(k)$找出$h(k,0)$时的slot，如果碰撞的话就探测这个slot的下一个slot，再碰撞就再下一个...直到用完方程，注意$mod&ensp;m$表示探测完表中最后一个slot的话就探测表的第一个slot。
&emsp;&emsp;这样做的话有一个缺点：当碰撞时，因为只是选择碰撞的slot的下一个，所以随着碰撞增多，这些已经有元素的slot会连成一片连续的区域，叫做主要集群(primary clustering，没有图，自己脑补。。)。这样的话是不利的，这一片区域的下一个空的slot(脑补，就是那个...)在下一次被hash到的几率会增大，因为只要$h'(k)$指向主要集群中的slot的话，最终$h(k,i)$都会指向这一个空slot。令主要集群的长度为$i$的话，这个空slot被hash的概率是
$$
	(i+1)/m
$$&emsp;&emsp;就是主要集群的slot个数加上这个slot本身除以表长度。

### Quadratic probing(二次探测)
&emsp;&emsp;出现上面的主要集群的原因其实就是因为一次探测的步长(每次探测时间隔的slot)为1，二次探测其实相当于一次探测增加了步长，从而解决了主要集群的问题。先上公式：
$$
	h(k,i) = (h'(k)+c_1i+c_2i^2)&ensp;mod&ensp;m
$$&emsp;&emsp;在这里多出的$c_1$和$c_2$是两个正的常数，凭借这两个常数，二次探测的步长从$1$被拉长到：
$$\begin{equation}\begin{aligned}
	& c_1i+c_2i^2-[c_1(i-1)+c_2(i-1)^2]
=	& 2c_2i+c_1-c_2 
\end{aligned}\end{equation}$$&emsp;&emsp;这样的话就避免了主要集群问题。这里还要注意一个问题，$c_1$和$c_2$不是随便取的，为了满足探测序列可以覆盖表中的所有slot，$c_1$和$c_2$必须要精心挑选(结合$m$)。举个反例：
&emsp;&emsp;如果$2c_2=m$且$c_1-c_2=0$($c_1$和$c_2$相等)的话,那么步长就是：
$$\begin{equation}\begin{aligned}
	& 2c_2i+c_1-c_2 
=	& mi
\end{aligned}\end{equation}$$&emsp;&emsp;因为探测到表最后的slot的话下一个会反过来探测表最前的slot，所以步长也可化为：
$$\begin{equation}\begin{aligned}
	& mi&ensp;mod&ensp;m
=	& 0
\end{aligned}\end{equation}$$&emsp;&emsp;步长为$0$的话就是整个探测序列都是同一个slot了(最极端的情况)。反正挑选$c_1$和$c_2$时小心点就是了。
&emsp;&emsp;书上还提了一个叫做二次集群(secondary clustering)的东西：当探测两个key($k_1$、$k_2$)的起点($h(k,0)$，也就是$h'(k)$)相同的话，$k_1$和$k_2$的探测序列是相同的，因为$c_1$和$c_2$确定下来的话，探测序列中每一段的步长都是确定(相同)的。

### Double hashing(二重哈希)
&emsp;&emsp;正如上面所说的，一次探测和$c_1$、$c_2$已经选定的二次探测的序列中，每一段($i$取$0,1,···,m-1$时)的步长都是固定的，所以这个序列其实是由起点($h(k,0)$)决定的，就是选好起点后按固定的步长一直加上去。
&emsp;&emsp;这样的话，序列的种数(不同的序列的个数)就是起点的个数，就是$\theta(m)$(严谨一点，用$\theta$)，这样的话离上面的Uniform hashing就比较远，为了更接近Uniform hashing，书上给了一种叫二重哈希的方法：
$$
	h(k,i)=(h_1(k)+ih_2(k))&ensp;mod&ensp;m
$$&emsp;&emsp;$h_1(k)$和$h_2(k)$是两个辅助的哈希方程，可以看出$h_1(k)$决定了探测序列的起点，$h_2(k)$决定了探测序列的步长，这样的话起点就有$m$种，步长有$m$种，$m·m=m^2$($h_1(k)$和$h_2(k)$都是hash到这个表中的哈希方程，所以都是有$m$种情况)，所以就有$\theta(m^2)$种序列，更接近Uniform hashing的$m!$。
&emsp;&emsp;如果要探测序列覆盖到整个表(用符号表示就是：对于任意$i≠j$，都有$h(k,i)≠h(k,j)$)的话，最好是$h_2$与$m$互素。证明(涉及到一些模的运算法则)：
&emsp;&emsp;如果：
$$
	i≠j
$$&emsp;&emsp;两边乘上$h_2(k)$：
$$
	ih_2(k)≠jh_2(k)
$$&emsp;&emsp;当$m$是素数，才有这个式子必然成立：
$$
	ih_2(k)&ensp;mod&ensp;m≠jh_2(k)&ensp;mod&ensp;m
$$&emsp;&emsp;两边都加上相同的$h_1(k)$，不影响取模后的结果：
$$
	(h_1(k)+ih_2(k))&ensp;mod&ensp;m≠(h_1(k)+jh_2(k))&ensp;mod&ensp;m
$$&emsp;&emsp;这个式子也就是：
$$
	h(k,i)≠h(k,j)
$$&emsp;&emsp;证毕。书上还给了一个例子：
![](deemo16.jpg)

## 分析
&emsp;&emsp;下面的分析都是基于Uniform hashing的。
&emsp;&emsp;还有一点是因为所有元素都是在一个哈希表中的，没有用到链表等外部结构，所以有$\alpha=n/m<1$。

### Theorem 11.6
&emsp;&emsp;一次失败的搜索中，探测次数的期望最多是$1/(1-\alpha)$，证明：
&emsp;&emsp;首先用随机变量$X$表示在一次失败的搜索中探测的次数，用$m$表示总slot个数，用$n$表示slot中已经有被塞进元素的slot的个数。
&emsp;&emsp;那么，第一次探测是必然要发生的(总得找至少一个slot吧)，即探测一次发生的概率是：
$$
	Pr\\{X≥1\\} = 1
$$&emsp;&emsp;注意用$≥$而不是$=$，可以理解为$Pr\\{X<1\\}=0$，$Pr\\{X≥1\\}=1-Pr\\{X<1\\}$。
&emsp;&emsp;探测两次的话，就是在探测第一次时发生碰撞，碰撞的概率是$n/m$(已经有元素的slot数/总slot数)，所以：
$$
	Pr\\{X≥2\\} = \frac{n}{m}
$$&emsp;&emsp;探测三次的话就是在探测第二次时发生了碰撞，这个碰撞的概率是$(n-1)/(m-1)$，即剩下的slot有$m-1$个，剩下的被占的slot有$n-1$个，剩下是指除去之前被探测过的，所以：
$$
	Pr\\{X≥3\\} = \frac{n}{m}·\frac{n-1}{m-1}
$$&emsp;&emsp;这样一直下去的话：
$$\begin{equation}\begin{aligned}
	Pr\\{X≥i\\} &= \frac{n}{m}·\frac{n-1}{m-1}···\frac{n-i+2}{m-i+2} \\\
		    &≤ \left(\frac{n}{m} \right)^{i-1} \\\
		    &= \alpha^{i-1}
\end{aligned}\end{equation}$$&emsp;&emsp;然后利用附录中的($C.25$)公式进行求期望，($C.25$)其实就是根据期望的定义进行一些转化：

![化简](deemo_1.0.jpg)

![($C.25$)](deemo17.jpg)
&emsp;&emsp;其中最后一步就是等比数列求和而已...而最后化出来的结果还可以转化为$m/(m-n)$，即slot的总数除以空slot的数量，为什么呢，我也不知道...

### Theorem 11.7
&emsp;&emsp;往Open addressing的哈希表中插入一个元素需要的平均$1/(1-\alpha)$次探测。证明：
&emsp;&emsp;(跟搜索不成功的一样，就是搜到最后为空就插进去)

### Theorem 11.8
&emsp;&emsp;一次成功的搜索中探测的次数的期望最多是：
$$
	\frac{1}{\alpha}ln\frac{1}{1-\alpha}
$$&emsp;&emsp;证明：
&emsp;&emsp;首先如果搜索$k$时搜索成功的话，就代表$k$是插入成功的了。假设$k$是第$i+1$个被插入的元素的话，搜索$k$时探测次数的期望最多是：
$$
	\frac{1}{1-i/m} = \frac{m}{m-i}
$$&emsp;&emsp;最坏情况其实就是最后一个元素才探测到$k$，跟有$i$个元素时探测失败的情况差不多，只是$i$个元素探测失败时最后一个是空，而这里最后一个是$k$。
&emsp;&emsp;所以把所有的key的探测次数最大值的期望求一个平均，就是：
$$
	\frac{1}{n}\sum^{n-1}{i=0}\frac{m}{m-i}
$$&emsp;&emsp;然后化简：
![化简](deemo18.jpg)

## Rehashing
&emsp;&emsp;用Open addressing的时候，因为没用借助链表等外部结构，所以这种哈希表最终会满的。即使没有满，当表中的元素特别多是，$\alpha$就会增大，而上面求出来的搜索和插入的期望值都是跟$\alpha$有关的，$\alpha$越大，开销越大，这样的话表中的元素越多就越不利。
&emsp;&emsp;解决问题的方法就是当$\alpha$较大时(大于$0.5$左右)就rehashing，就是重新建一个哈希表，把旧表的元素重新hash进去。新表的长度最好是原表的2倍或3倍左右(没记错的话)，因为rehashing也是要代价的，所以rehashing的次数越少越好，如果每次都只是增加一个slot的话...

# 完美哈希(Perfect hashing)
&emsp;&emsp;完美哈希适用于元素是静态(static，即元素是固定的，不会插入也不会删除)的时候，它搜索时的最坏情况是$O(1)$。
![Perfect hashing例子](deemo19.jpg)
&emsp;&emsp;如上图所示，在一个哈希表$T$中的每一个slot都存放一个数组，这些数组除了前三位外其余的位置都是用来存放额外的哈希表$S_i$。在前三位中，第一位$m_i$是$S_i$中元素个数的平方，第二位和第三位的$a_i$和$b_i$是指$S_i$所用的Universal hashing对应的$a$和$b$，就是前面说过得：
$$
	h_{ab}(k) = ((ak+b)&ensp;mod&ensp;p)&ensp;mod&ensp;m
$$

## 分析
&emsp;&emsp;（···略···） 
</br></br></br>
ps：相关链接	↓
</br>
&emsp;&emsp;[主定理(Master Theorem)笔记](https://blog.tover.xyz/2018/03/03/%E4%B8%BB%E5%AE%9A%E7%90%86%E6%B5%85%E8%B0%88/)
&emsp;&emsp;[Chapter_8 笔记](https://blog.tover.xyz/2018/03/14/Chapter8%E7%AC%94%E8%AE%B0/)
&emsp;&emsp;[Chapter_9 笔记](https://blog.tover.xyz/2018/03/16/Chapter9%E7%AC%94%E8%AE%B0/)












































