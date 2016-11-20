---
layout: post
title:  "“冒泡法”对一组数进行排序"
date:    2012-12-10 17:38:24 +0800
categories: 随笔 asm
published: true
---


题目：“冒泡法”对一组数进行排序。

无序字符表：ASDFGHJKLWERTYUIO4683

设计要求：按代码值大小升序或降序排列，并显示排序前后字符表。


{% highlight asm linenos %}

assume ds:data,cs:code


data segment

table db 'ASDFGHJKLWERTYUIO4683'

len = $ -table 

data ends


code segment

sta:

mov ax,data

mov ds,ax

mov bx,0b800h

mov es,bx

xor di,di

call disPlay

mov cx,len

again:

xor si,si

mov di,1

push cx

mov cx,len-1

again_2:

mov al,[si]

cmp al,[di]

jb donot

mov ah,[di]

mov [si],ah

mov [di],al

donot:nop

inc di

inc si

loop again_2

pop cx

loop again

mov di,160

call disPlay

mov ah,4ch

int 21h

disPlay:

xor si,si

mov cx,len

again_3:

mov al,[si]

mov es:[di],al

add di,2

inc si

loop again_3

ret

code ends

end sta


{% endhighlight %}