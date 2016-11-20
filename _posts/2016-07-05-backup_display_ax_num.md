---
layout: post
title:  "ax中的十六进制数据以ascii码的形式显示出来"
date:   2013-04-05 17:57:50 +0800
categories: 随笔
published: true
---

ax中的十六进制数据以ascii码的形式显示出来 

{% highlight asm linenos %}

assume cs:code,ds:data
   
data segment
    mem db 4 dup(?),'$'
data ends
   
code segment
    start:
    mov ax,data
    mov ds,ax
    lea di,mem
       
    mov ax,2a49h
       
    call tiaoAL
    mov al,ah
    call tiaoAL
       
    lea dx,mem
    mov ah,09h
    int 21h
       
    mov ah,4ch
    int 21h
       
    tiaoAL:
        push ax
        call tiao
        mov [di],al
        inc di
        pop ax
           
        mov cl,4
        shr al,cl
        call tiao
        mov [di],al
        inc di
    ret
       
       
    tiao:
        and al,0fh
        daa
        add al,0f0h
        adc al,40h
    ret
code ends
end start
{% endhighlight %}
