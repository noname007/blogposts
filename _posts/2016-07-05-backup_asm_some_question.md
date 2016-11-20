---
layout: post
title:  "微机原理学习-一些问题总结"
date:    2012-12-15 17:40:40 +0800
categories: 随笔
published: true
---

1.cmp al,30

a) 是al - 30 还是30 - al?

i. Al- 30

2.ROR ROL,sal,sar,shr是怎么移动的?

rar 算术右移

先移位，最高位仍为原来的数

1000 0001  0----> 1100 0000  1

1000 0000  0----->

1000 0001 0 ----> 0100 0000 1

3.02 int 21 al接收不到字符

;2004级

assume ds:data,cs:code

data segment

buffer db 20,?

s db 20 dup('?'),'$'

buffer2 db ?

data ends

code segment

start:

;初始化

mov ax,data

mov ds,ax

;从键盘读

lea dx,buffer

mov ah,0ah

int 21h

call huanhang

;读入要删除的字符

;从键盘输入的字符无法接收到al中。

mov al,'b'

;mov ah,1

;int 21h

;删除

lea si,s

lea di,s

mov cl,[buffer+1]

and ch,00h

and dh,00h

  again: 

  cmp al,[si]

  jz del

mov bl,[si]

mov [di],bl

inc di

  del:

  inc si

  loop again

  

  mov bl,'$'

  mov [di],bl

  

  ;显示

lea dx,s

mov ah,9

int 21h

mov ax,4c00h

int 21h

huanhang:

mov dx,0ah

mov ah,2

int 21h

mov dx,0dh

int 21h

ret

code  ends

end start

4.字符串输出。功能输出问题

DATAS SEGMENT

    BUFFER DB 20

           DB ?

    S DB 20 DUP(?),'$'

    TET DB 'ABCDEGAGAAG','$'

    HUAN DB 0DH,0AH,'$'

    ;此处输入数据段代码  

DATAS ENDS

STACKS SEGMENT

    ;此处输入堆栈段代码

STACKS ENDS

CODES SEGMENT

    ASSUME CS:CODES,DS:DATAS,SS:STACKS

START:

    MOV AX,DATAS

    MOV DS,AX

 

;MOV DX,OFFSET BUFFER

    LEA DX,BUFFER

    MOV AH,0AH

   INT 21H

   

    ;LEA SI,[BUFFER+2]

    ;MOV DI,160

    ;MOV CL,[BUFFER+1]

   ;AND CH,00H

   ;CALL DIS

   

   ; 调用9号功能不能正确显示

    MOV DX,OFFSET BUFFER

    MOV AH,9

    INT 21H

    

    MOV AH,4CH

    INT 21H

    

    DIS: 

    MOV BX,0B800H

    MOV ES,BX

    AG:

 MOV AL,[SI]

 MOV ES:[DI],AL

 ADD DI,2

 INC SI

    LOOP AG

    RET

    

CODES ENDS

    END START

5. 2- (-5)

      2    0000 0010

   00fb   1111 1011(-5) 

               111