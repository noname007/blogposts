---
layout: post
title:  "显示时间"
date:   2012-12-02 17:21:56 +0800
categories:  随笔 asm
published: true
---


用汇编在屏幕窗口中显示时间

{% highlight asm linenos %}

;al存放从cmos的ram中读取的数据，ah中存放数据显示的格式。
;es:di 用来指定在屏幕中那个位置显示，以何种样式。

assume cs:code,ds:data
data segment

data ends

code segment
  s:
  mov bx,0b800h 
  mov es,bx
  
 from:
  mov di,160*11+80   ;es:[di]，di用来存放开始的位置；
 ;显示时间
  mov ah,':'         ;;;;;
  
  mov al,4
  out 70h,al
  in al,71h
  ;取时
  call display
  call dis_maohao
  ;取分钟
  mov al,2
  out 70h,al
  in al,71h
  
  call display
  call dis_maohao
  ;取秒
  mov al,0
  out 70h,al
  in al,71h
  
  call display
  
  ;显示年份与月份
  mov ah,'/'
  mov di,12*160+80
  
     ;取年份
  mov al,9
  out 70h,al
  in al,71h
  call display
  call dis_maohao
  ;取月份
  mov al,8
  out 70h,al
  in al,71h
  call display
  call dis_maohao  
  ;取日期
  mov al,7
  out 70h,al
  in al,71h
  call display
 jmp from
 mov ax,4c00h
 int 21h
 ;子函数
 display:
   push ax
   mov cl,4
   shr al,cl
   add al,48
   call display_son
   pop ax
   and al,0fh
   add al,48
   call display_son
  ret
 display_son:
  ;将al中的数据显示在screen中
  mov byte ptr es:[di],al
  inc di
  mov byte ptr es:[di],01000010b
  inc di
  
  ret
 dis_maohao:
  mov byte ptr es:[di],ah
  inc di
  mov byte ptr es:[di],01000010b
  inc di
  ret  
code ends
end s



{% endhighlight %}


