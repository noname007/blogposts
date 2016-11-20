---
layout: post
title:  "大小写转换"
date:   2012-12-10 17:35:52 +0800
categories: 随笔 asm
published: true
---

大小写转换 

{% highlight asm linenos %}

assume cs:code,ds:data,ss:stack


stack segment

db 128 dup('?')

stack ends


data segment

db 8 dup('abcdABCD')

big db 64 dup('?')

small db 64 dup('?')

data ends


code segment

sta:

mov ax,data

mov ds,ax

mov ax,stack

mov ss,ax

mov ax,0b800h

mov es,ax

call toBig

call toSmall

xor di,di

push di

xor si,si

call dis_play

lea si,big

mov di,160

call dis_play

lea si,small

mov di,320

call dis_play

mov ah,4ch

int 21h

toBig:

mov cx,64

lea di,big

xor si,si

again_1:

mov al,[si]

and al,0dfh

mov [di],al

inc si

inc di

loop again_1

ret

toSmall:

mov cx,64

lea di,small

xor si,si

again_3:

mov al,[si]

or al,20h

mov [di],al

inc si

inc di

loop again_3

ret

dis_play:

mov cx,64

again:

mov al,[si]

mov es:[di],al

add di,2

inc si

loop again

ret

code ends

end sta
{% endhighlight%}
