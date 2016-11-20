---
layout: post
title:  "单片机：数码管显示0到9实验"
date:   2013-03-14 18:20:31 +0800
categories: 随笔
published: true
---

收获：


寻址方式.


存储器结构.


用到的指令：

mov movc movx 

dptr  cjne   djnz  

lcall   org   ajmp

ret


思路就是每个一会换成另外一个数。先前写的：

;显示电子钟的秒数的变化
org 0000h
ajmp main
org 0030h
main:
         mov p2,#7eh
         lcall Delay
         mov p2,#44h
         lcall Delay
         mov p2,#3dh
         lcall Delay
         mov p2,#6dh
         lcall Delay
         mov p2,#47h
         lcall Delay
         mov p2,#6bh
         lcall Delay
         mov p2,#7bh
         lcall Delay
         mov p2,#4ch
         lcall Delay
         mov p2,#7fh
         lcall Delay
         mov p2,#6fh
         lcall Delay
ajmp main
                 
Delay:
      mov r5,#0ah
      delay_3:mov r7,#0ffh
      delay_1:mov r6,#0ffh
             delay_2:djnz r6,delay_2
             djnz r7,delay_1
       djnz r5,delay_3
ret


后来利用在片内程序区查表的方法。实现了相同的功能。


org 000h
Ljmp main
org 0030h
main:
mov dptr,#table
             
mov r1,#00h
    loop:
     mov a,r1
     movc a,@a+dptr
     mov p2,a
     lcall Delay_650ms
     inc r1
     cjne r1,#0ah,loop
ajmp main
             
Delay_650ms:
            mov r7,#05h
            delay_1: mov r6,#0ffh
            delay_2: mov r5,#0ffh
            delay_3: djnz r5,delay_3
            djnz r6,delay_2
            djnz r7,delay_1
ret
             
table:
      db 7eh,44h,3dh,6dh,47h ;0 - 4
      db 6bh,7bh,4ch,7fh,6fh ;5 - 8

因为在片内程序存储区，用寄存器间接寻址的方法寻址时只能用dptr或pc配合使用，且movc 的操作数结果送到a里面去。


所以出现了，上面的一堆废话。并且用寄存器 r1 作为中间的变量进行暂存数据取到哪个位置了。


mov r1,#00h
loop:
     mov a,r1
     movc a,@a+dptr
     mov p2,a
     lcall Delay_650ms
     inc r1
cjne r1,#0ah,loop


收获：

        因为单片机为哈佛存储器结构，从用户角度来看单片机有程序存储空间，片内数据存储区，片外存储区。从程序区、还是从片内数据存储区、还是从片外数据存储区要用不同的指令，为：movc mov movx，三条不同的指令来实现。先前因为没有把这一点搞明白，在这里调试了几个小时：


原先写的错误的代码：


;数码管循环显示从0到9
org 0000h
ajmp main
org 0030h
main:
     mov r1,#table
     loop:
           mov a,@r1
           mov p2,a
           lcall Delay_650ms
           inc r1
           cjne r1,#0ah,loop
ajmp main
          
;延时
Delay_650ms:
         mov r7,#05h
         delay_1: mov r6,#0ffh
         delay_2: mov r5,#0ffh
         delay_3: djnz r5,delay_3
                  djnz r6,delay_2
                  djnz r7,delay_1
ret
;表格

主要的差别在：

mov a,@r1
mov p2,a

两句话上。直接把片内数据区的数值赋给了a。导致在a里面的结果一直是00h。唉。。