---
layout: post
title:  "二分查找"
date:   2013-04-06 12:14:28 +0800
categories: 
---

```c
int query(int *a, int xy,int begin,int end)
{
    int i = (begin + end)/2;
    
    if(begin <= end){
    
        if(xy == a[i])return i;
    
        else if(xy > a[i]) query(xy,i+1,end);
    
        else  query(xy,begin,i - 1);
    }   
}
```

上面是先前写的二分查找的程序，最终返回的值是乱七八糟的。原本以为是编译器有问题，后来发现是函数又问题，漏掉了return，自己还是没理解透递归。下面是正确的二分查找。

```c
int query(int *a,int xy,int begin,int end)
{
    int i = (begin + end)/2;
   
    if(begin <= end){
   
        if(xy == a[i])return i;
   
        else if(xy > a[i]) return query(xy,i+1,end);
   
        else return  query(xy,begin,i - 1);
    }   
}
```

后来又发现一个问题，漏掉处理当查询不到时这种情况的处理：

```c
int query(int *a, int xy,int begin,int end)
{
    int i = (begin + end)/2;
    
    if(begin <= end){
    
        if(xy == a[i])return i;
    
        else if(xy > a[i]) query(xy,i+1,end);
    
        else  query(xy,begin,i - 1);
    }else{
        return -1;
    }
}
```

