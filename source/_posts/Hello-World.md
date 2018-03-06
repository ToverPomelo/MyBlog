---
title: Hello World!
date: 2017-12-24 12:35:55
tags: c
categories: C\C++编程相关
src: 1.jpg
---
按照惯例，通常都是从"Hello World!"开始的，所以，<!--more-->上代码：
# c版本代码
```c
#include<stdio.h>
#include<time.h>
#include<stdlib.h>
#define NUM 14
int font_rand();
char word[NUM]="Hello World!";
int main()
{
    srand((unsigned)time(NULL));
    printf("\n\t");
    for(int i=0;i<NUM;++i)
    {
        font_rand();
        printf("%c",word[i]);
    }
    printf("\e[0m""\n\n"); 

    return 0;
}

/********************************/

int font_rand()
{
    switch(rand()%16)
    {
        case 0:printf("\e[01;30m"); break; 
        case 1:printf("\e[01;31m"); break;
        case 2:printf("\e[01;32m"); break;
        case 3:printf("\e[01;33m"); break;
        case 4:printf("\e[01;34m"); break;
        case 5:printf("\e[01;35m"); break;
        case 6:printf("\e[01;36m"); break;
        case 7:printf("\e[01;37m"); break;
        case 8:printf("\e[00;30m"); break; 
        case 9:printf("\e[00;31m"); break;
        case 10:printf("\e[00;32m"); break;
        case 11:printf("\e[00;33m"); break;
        case 12:printf("\e[00;34m"); break;
        case 13:printf("\e[00;35m"); break;
        case 14:printf("\e[00;36m"); break;
        case 15:printf("\e[00;37m"); break;
        default: break;
    }
}
```
# 解析
&emsp;&emsp;就是通过转移字符改变字体的颜色。 </br>
&emsp;&emsp;先把字符串存进数组“word”中，通过函数“font_rand()”随机选取一种颜色，然后每改变一次颜色打印“word”中一个字符，最后把颜色改为白色。（Terminal的字体颜色） </br>
&emsp;&emsp;测试环境: Ubuntu 17.10 </br>
![](deemo.png)
