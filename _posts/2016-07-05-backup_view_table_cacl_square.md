---
layout: post
title:  "利用查表法求某数的平方"
date:   2012-12-10 17:33:39 +0800
categories: 随笔 asm
published: true
---

题目：利用查表法求某数的平方
设计要求：已知平方数据表格，通过查表指令求某数的平方值。

分析：（1）表格存放在内存某段地址空间。（2）查表指令(换码指令)：XLAT


{% highlight asm linenos %}

assume ds:data

data segment

table db 4 dup(1,4,9)

data ends


code segment

sta:

mov ax,data

mov ds,ax

mov bx,offset table

mov al,0

xlat

call disPlay

mov ah,4ch

int 21h

disPlay:

xor di,di

mov bx,0b800h

mov es,bx

add al,30h

mov es:[di],al

ret

code ends

end sta


{% endhighlight %}


