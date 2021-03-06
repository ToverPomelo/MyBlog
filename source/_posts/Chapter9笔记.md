---
title: Chapter_9 笔记
date: 2018-03-16 10:27:13
tags: 
	- 算法导论
categories:
	- Algorithm算法相关
src: 1.jpg
---
&emsp;&emsp;算法导论第九章笔记——几个运行时间是线性的选择算法。
<!--more-->
&emsp;&emsp;同样，这一章的某些算法分析需要前面第五章的概率分析和随机算法的知识。

# 9.1 最大值与最小值
&emsp;&emsp;这一节的开头给出了一个小学生都懂的找最大值或最小值的算法，就是每两个数比较，大(小)的留下，小(大)的就舍弃：
![小学生都懂啦！](deemo1.jpg)
&emsp;&emsp;可以看出，这里一共比较了$n-1$次，如果要同时找出最大值和最小值的话就总共是$2n-2$次，有没有比较次数更少的方法？书上就给了一种：
&emsp;&emsp;先是取定两个变量$max$和$min$，作用跟上面算法的“$min$”作用相同，就是程序运行完后它们分别是最大值和最小值。这里因为要照顾后面的操作，$max$和$min$的初始取值要分为输入的数的个数是奇数或偶数两种情况：①如果输入的数的个数是奇数的话，就把第一个数同时赋给$max$和$min$；②如果输入的数的个数是偶数的话，就先把前面两个数比较一次，然后大的给$max$，小的给$min$。
&emsp;&emsp;经过上面的操作后，剩下的数的个数就是偶数了，接下来把剩下的数分成两个一组，那就总共有$⌊(n-1)/2⌋$组。然后每一组中先是两个数自己进行一次比较，然后大的跟$max$比较，如果比$max$大就取代$max$；同样，小的就跟$min$比较，如果比$min$小就取代$min$。每一组都比较完后，$max$和$min$就是结果了。
![看这个图可能比较好了解](deemo2.jpg)
&emsp;&emsp;另外书上没有给出这个算法的伪代码(可能太简单了- -)，在这里我自己补了个(c++版)：
```c++
#include<iostream>
#define N 19  //数组的长度
using namespace std;

//要找的数组
int arr[N] = {1,42,532,12,5,0,21,2,41,4,14,215,62,75,2,4263,5817,615,12}; 

int main()
{
    int max,min;  //像上面说的
    if(N%2 == 0)  //偶数时
    {
	//也是像上面说的，只不过我拿了最后的两个数
        if(arr[N-1] > arr[N-2])  
        {
            max = arr[N-1];
            min = arr[N-2];
        }    
        else
        {
            max = arr[N-2];
            min = arr[N-1];
        }
    }
    else  //奇数是，拿了最后一个数
    {
        max = arr[N-1];
        min = arr[N-1];
    }

    //两个两个数地扫
    for(int i=0;i<N-1;i+=2)
    {
	//后面就跟上面说的一样了
        if(arr[i] > arr[i+1])
        {
            if(arr[i] > max)
                max = arr[i];
            if(arr[i+1] < min)
                min = arr[i+1];
        }
        else
        {
            if(arr[i] < min)
                min = arr[i];
            if(arr[i+1] > max)
            max = arr[i+1];
        }
    }

    //把结果打印出来
    cout<<"max: "<<max<<endl;
    cout<<"min: "<<min<<endl;

	return 0; //良好习惯
}
```

&emsp;&emsp;接下来对这个算法进行分析，在分好的组中，每一组都进行了三次比较，即在分好的组中进行比较的总次数为：
$$
	3⌊(n-1)/2⌋
$$&emsp;&emsp;当$n$是奇数时，多出来的那一个数不用比较，而且$⌊(n-1)/2⌋=⌊n/2⌋$所以总的比较次数就是：
$$
	3⌊n/2⌋
$$&emsp;&emsp;当$n$是偶数时，多出来的前面那两个数进行了一次比较，而且$⌊(n-1)/2⌋=(n-2)/2$，所以总的比较次数就是：
$$\begin{equation}\begin{aligned}
	3⌊(n-1)/2⌋+1 &= 3(n-2)/2+1
		    &= 3n/2-2
\end{aligned}\end{equation}$$&emsp;&emsp;可以看出无论$n$是奇数还是偶数，都有一个上界：
$$
	3⌊n/2⌋
$$

# 9.2 期望是线性的选择算法
&emsp;&emsp;要选择一个数(第i大的数)比寻找最值复杂得多，最容易想到的就是先把数组排好序，然后直接找就行了，但是这样的话最快也是$\theta(nlgn)$，书上提供了一种跟快排类似的选择算法($O(n)$)快速排序的建议先去了解一下。
![先上代码](deemo3.jpg)
&emsp;&emsp;$A$就是数组$A$，$p$和$r$分别是数组的第一个元素和最后一个元素，$i$就是要寻找第$i$个元素。
&emsp;&emsp;首先如果$p$等于$r$的话，就说明数组中只有哦一个元素，直接返回那个元素就行了(代码的1、2行)。
&emsp;&emsp;第3行就是跟快排的partition一样了，返回的$q$就是主元(pivot，pivot前面的都比它小，后面的都比它大)。第4行中的$k$就是说$q$是数组中的第$k$个元素(也可以把它看成$q$前面的长度，注意数组有可能是子数组)。所以第5行中就看看$i$与$k$是否相等，相等的话说明$A[q]$是第$i$个元素，直接返回它就行了。
&emsp;&emsp;剩下的7、8、9行就是递归地查找了。如果$i<k$的话说明第$i$个元素在pivot的左边，所以递归pivot左边的子数组；如果$i>k$(或≥)的话，说明第$i$大的数在pivot的右边，所以递归右边的子数组，注意此时原数组的第$i$个元素就是子数组的第$i-k$个元素。
&emsp;&emsp;为什么这样可行？就是跟快排一样啦。(此处省略1000字)

## 算法分析
&emsp;&emsp;这个算法的最坏情况跟快排一样是$\theta(n^2)$，就是pivot每次都是最大值或最小值(不过这种情况发生的几率不大)。平均情况(期望)下是$O(n)$，下面是证明：
&emsp;&emsp;首先设指示器变量$X_k$，表示子数组中有确定的$k$个元素这个事件，其实换句话说就是在原数组中选定一个$k$的事件，因为在原数组中选定一个pivot后子数组的长度就已经确定了。然后因为$k$是在$n$个数中找出来的，抽到每一个的概率都一样，这样$X_k$的期望也很明显：
$$
	E\left[X_k \right] = 1/n
$$&emsp;&emsp;为了找出这个算法的上界，书上还做了一些假设：每一次partition后，要找的第$i$数都会落在元素较多的那个子数组(也就是比较坏的情况了)。然后就得到递归式：
$$\begin{equation}\begin{aligned}
	 T(n) &≤ \sum_{k=1}^nX_k·\left(T(max(k-1,n-k)) + O(n) \right) \\\
	      &= \sum_{k=1}^nX_k·T(max(k-1,n-k)) + O(n)
\end{aligned}\end{equation}$$&emsp;&emsp;这里对$X_k$求和的话比较有趣，上面说了$X_k$就等同于在$n$个数中取一个$k$，取了一个$k$后，就不会取其他数了，也就是对$X_k$的求和中，只有一个会是$1$，其他的都是$0$。这个求和也可以看作是选择一个$k$，然后$T(max(k-1,n-k))$就是对所选的$k$所确定的那个子数组(按上面假设是较长的那个)进行递归。$O(n)$就是除了递归剩下的了(好像partition是$O(n)$的吧)。因为是假设每次递归较长的子数组，所以这里就有一个放大，所以用了$≤$。
&emsp;&emsp;接下来求$T(n)$的期望：
$$\begin{equation}\begin{aligned}
	E\left[T(n) \right] &≤ E\left[\sum_{k=1}^nX_k·T(max(k-1,n-k)) +O(n) \right] \\\
			    &= \sum_{k=1}^nE\left[X_k·T(max(k-1,n-k)) \right] +O(n) \\\
			    &= \sum_{k=1}^nE\left[X_k \right]·E\left[T(max(k-1,n-k)) \right] +O(n) \\\
			    &= \sum_{k=1}^n\frac{1}{n}·E\left[T(max(k-1,n-k)) \right] +O(n) \\\
\end{aligned}\end{equation}$$&emsp;&emsp;根据线性性、事件独立(书附录公式C.24)然后把$E[X_k]=1/n$代进去就可以得到上面的化简。问题是为什么$X_k$与$T(max(k-1,n-k))$是独立的？因为$X_k$是一个事件(发生为$1$，不发生为$0$)，而$T(max(k-1,n-k))$是对一个长度进行递归，无论事件发不发生，$max(k-1,n-k)$这个长度都是不变的，也就是整个$T(max(k-1,n-k))$都是不变的，一句话(废话)就是两个东西互不影响。
&emsp;&emsp;化简后比较难搞的就是$T(max(k-1,n-k))$这个东西，书上把它分成了两种情况：
![](deemo4.jpg)
&emsp;&emsp;然后莫名其妙地就得到这条公式：
$$
	E\left[T(n) \right] ≤ \frac{2}{n}\sum_{k=⌊n/2⌋}^{n-1}E\left[T(k) \right] + O(n)
$$&emsp;&emsp;其实这中间有一个二倍(对称)关系：
$$
	E\left[T(max(k-1,n-k)) \right] = 2\sum_{k=⌊n/2⌋}^{n-1}E\left[T(k) \right]
$$
![抽象派！](deemo5.jpg)
&emsp;&emsp;画了一幅图来方便理解，把一个数组分成两半，对于其中一边(比如右边)的任意$k$，可以得到对应的 长度_1 ，在数组的另一边总可以对称地找到一个$k'$，使得其对应的 长度_2 与 长度_1 相同，这样的话，选到$k$和$k'$的情况就是一样(对称)的了。上面的公式就是用右半边代替了左半边(用两个右半边代替整个数组),注意求和符号上的$n$变成了$n-1$，所以$T(k-1)$b变成了$T(k)$。
&emsp;&emsp;接下来的就更迷了，用了一个叫代换法(substitution)的方法(我觉得也想归纳法)。首先假设$T(n)$的期望是$O(n)$，根据$O(n)$的定义就是存在一个常数$c$和$n_0$，使得当$n>n_0$时，有$E[T(n)]≤cn$，书上还假设了当$n<n_0$时，$T(n)=O(1)$，(就是当数比较小时可以看成是常数？书上原文是"We assume
that $T(n)=O(1)$ for n less than some constant")，这个$n_0$是后面会求出来的。对于上面公式的那个$O(n)$也是同样的处理方法，只是常数换成了$a$：$≤an$。
&emsp;&emsp;然后公式就变成了：
$$\begin{equation}\begin{aligned}
	E[T(n)] &≤ \frac{2}{n}\sum_{k=⌊n/2⌋}^{n-1}ck + an \\\
		&= \frac{2c}{n} \left( \sum_{k=1}^{n-1}k - \sum_{1}^{k=⌊n/2⌋-1}k \right) + an \\\
		&= \frac{2c}{n} \left( \frac{(n-1)n}{2}-\frac{(⌊n/2⌋-1)⌊n/2⌋}{2} \right) +an
\end{aligned}\end{equation}$$&emsp;&emsp;没毛病，接下来利用关系$n/2-1<⌊n/2⌋$化简(放缩)：
$$\begin{equation}\begin{aligned}
		&≤ \frac{2c}{n} \left( \frac{(n-1)n}{2}-\frac{(n/2-2)(n/2-1)}{2} \right) +an \\\
		&= \frac{2c}{n} \left( \frac{(n^2-n}{2}-\frac{n^2/4-3n/2+2}{2} \right) +an \\\
		&= \frac{c}{n} \left(\frac{3n^2}{4}+\frac{n}{2}-2 \right) +an \\\
		&= c \left(\frac{3n}{4}+\frac{1}{2}-\frac{2}{n} \right) +an 
\end{aligned}\end{equation}$$&emsp;&emsp;基本运算，接下来因为$\frac{2}{n}$不好处理，把它放缩掉：
$$\begin{equation}\begin{aligned}
		&≤ \frac{3cn}{4}+\frac{c}{2} +an \\\
		&= cn-(\frac{cn}{4}-\frac{c}{2}-an)
\end{aligned}\end{equation}$$&emsp;&emsp;继续，因为要符合上面的假设，所以要：
$$\begin{equation}\begin{aligned}
		cn-(\frac{cn}{4}-\frac{c}{2}-an) &≤ cn \\\
		\frac{cn}{4}-\frac{c}{2}-an &≥ 0 \\\
		n\left(\frac{c}{4}-a \right) &≥ \frac{c}{2} \\\
		n &≥ \frac{c/2}{c/4-a} \\\
		  &= \frac{2c}{c-4a}
\end{aligned}\end{equation}$$&emsp;&emsp;所以说当前面说的那个$n_0$取$\frac{2c}{c-4a}$的话，假设就成立。
&emsp;&emsp;也就是这个算法的时间复杂度的期望是$O(n)$。

# 9.3 最坏情况下是线性的选择算法
&emsp;&emsp;这个算法可以说是上面算法的改进版。避免了上面pivot每次取到最大或最小导致$\theta(n^2)$最坏情况的尴尬。
![书上例子](deemo6.jpg)
&emsp;&emsp;对于输入的数，首先按五个一组分成$⌊n/5⌋$，然后多出来凑不够5个的就独立成一组，总共$⌈n/5⌉$组。(每一组就是上面图中的一列)
&emsp;&emsp;然后对每一组中的5个数用插入排序进行排序(只有5个这么少，可以看成是$\theta(1)$)，排好序后，就可以很容易地找到每一组的中位数(第3个嘛。。图中的白圈)。然后再用这个算法本身，递归地找出每一组的中位数们的中位数(可以理解为找图中白圈的数的中位数)，令这个中位数为$x$，因为后面的步骤都还没说完，这里的递归可能让人难以接受，但如果这是个合理的选择算法的话，找中位数就是找第$n/2$大的数，这样也没什么问题吧。
&emsp;&emsp;下面就是进行partition，图中标记的箭头是从大的数指向小的数的，可以看出右下角那阴影部分的数是确定大于$x$的，所以如果要找的数(位置)小于$x$(的位置)的话，下一次递归的子数组就可以把这一部分确定比$x$大的数砍掉；同理，右上角可以找到一堆数确定比$x$小，如果要找的数(的位置)大于$x$(的位置)的话，递归的子数组就可以不要这一部分。如果要找的数(的位置)恰好是$x$(的位置)，那就返回$x$。
&emsp;&emsp;剩下的就和 9.2 的类似了，一直递归，然后就找到了。
![原文](deemo7.jpg)

## 算法分析
&emsp;&emsp;这个算法有两次用了递归：
&emsp;&emsp;第一次就是找中位数的中位数时，递归的长度就是中位数的个数(组数)$⌈n/5⌉$。
&emsp;&emsp;第二次就是找数的时候，这个的递归长度就有点麻烦(结合图来看可能比较好)。首先无论怎么取，被阴影覆盖的数的个数(覆盖的意思就是递归时要被去掉的数)至少有组数的一半(取上界)这么多个，也就是至少$\lceil\frac{1}{2}\lceil\frac{n}{5}\rceil\rceil$个。然后有两组是比较特殊的：$x$所在的那一组和不足5个数的那一组，特殊之处是它们被阴影圈起来的数的个数存在不足3个的情况，为了准确，把这两组减掉。好了，剩下的组中被阴影圈起来的数都有且仅有3个了，所以最后得到被阴影圈起来的数的个数至少是：
$$
	3\left( \lceil\frac{1}{2}\lceil\frac{n}{5}\rceil\rceil-2 \right) ≥ \frac{3n}{10}-6
$$&emsp;&emsp;当然这里只是取了个下界，虽然当数比较小的时候放缩得比较严重(还会是负数)，不过不影响结果就好。上面是要被除去的数的个数，用总数$n$减去被除去的数就是剩下的数了：
$$
	n-\frac{3n}{10}-6 = \frac{7n}{10}+6
$$&emsp;&emsp;这个就是第二次递归的长度的上界了。
&emsp;&emsp;上面的两次递归加上找中位数时花费了$O(n)$，就得到总的递归式：
$$
	T(n) ≤ T(⌈n/5⌉)+T\left(\frac{7n}{10}+6\right) + O(n)
$$&emsp;&emsp;接下来用跟上一节相同的代入法：假设这个算法的时间复杂度是$O(n)$，就是假设存在常数$c$，当$n>n_0$时，$T(n)≤cn$，$O(n)$同样地用$an$放缩(代替)：
$$
	T(n) ≤ c⌈n/5⌉+c(7n/10+6)+an
$$&emsp;&emsp;利用关系$⌈n⌉≤n+1$去掉上界：
$$\begin{equation}\begin{aligned}
		&≤ cn/5+c+7cn/10+6c+an \\\
		&= 9cn/10+7c+an \\\
		&= cn+(-cn/10+7n+an) 
\end{aligned}\end{equation}$$&emsp;&emsp;要满足$T(n)≤cn$：
$$\begin{equation}\begin{aligned}
		cn+(-cn/10+7n+an) &≤ cn \\\
		-cn/10+7c+an	  &≤ 0 \\\
		c(n/10-7)	  &≥ an 
\end{aligned}\end{equation}$$&emsp;&emsp;到这里要想求$c$的话就要把$(n/10-7)$移到右边去，因为是不等式，所以要考虑$(n/10-7)$的正负问题，所以假设$(n/10-7)>0$(为什么假设是正？因为还有一个要求的是满足$n>n_0$的$n_0$)，也就是假设$n>70$，移项后得到：
$$\begin{equation}\begin{aligned}
	c &≥ an/(n/10-7) \\\
	c &≥ 10a(n/(n-70))
\end{aligned}\end{equation}$$&emsp;&emsp;接下来书上是把$n_0$取了$140$，然后得到关系$n/(n-70)≤2$，最后得到确定的$c≥20a$使得假设成立，也就是这个算法的时间复杂度是$O(n)$。
&emsp;&emsp;同时，书上也说了，这个$140$是瞎取的，其实只要取到一个大于$70$的数，然后把确定的$c$求出来就行了。(取$70$的两倍，的确是挺方便的- -)
>&emsp;&emsp;作者：“有个大佬告诉我，因为这个算法取pivot的时候是取排在$7/10$($3/10$)的数，所以不会取到最大或最小的数”

# 总结
&emsp;&emsp;以上例子告诉了我们：最容易想到的不会是最好的，最好的通常都是你想不到的！
</br></br></br>
ps：相关链接	↓
</br>
&emsp;&emsp;[主定理(Master Theorem)笔记](https://blog.tover.xyz/2018/03/03/%E4%B8%BB%E5%AE%9A%E7%90%86%E6%B5%85%E8%B0%88/)
&emsp;&emsp;[Chapter_8 笔记](https://blog.tover.xyz/2018/03/14/Chapter8%E7%AC%94%E8%AE%B0/)
&emsp;&emsp;[Chapter_11 笔记](https://blog.tover.xyz/2018/03/28/Chapter11%E7%AE%80%E8%AE%B0/)





















