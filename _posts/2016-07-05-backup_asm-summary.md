---
layout: post
title:  "单片机指令简单总结"
date:   2013-03-12 18:18:50 +0800
categories: 随笔
published: true
---

　　
  
立即寻址:MOV A,#05H
     
直接寻址:MOV A,06H
     
寄存器寻址：MOV A,Rn
      
寄存器间接寻址：MOV A,@R0 / @R1
     
变址寻址：MOV A,@A+DPTR
     
位寻址: SETB 27H.5////3DH
     
一：数据传输类：
     
1.  片内数据传输指令：MOV
　　片外数据传输指令：MOVX
　　程序存储器访问指令：MOVC，又叫查表指令。PC,DPTR
2.堆栈操作指令：
　　PUSH  SP
　　POP   
交换指令：
XCH
XCHD
SWAP
二：算术运算类
　　加法指令：ADD,ADDC必须有A,且结果送回到A
　　ADD     A ，   
　　ADDC   A ，
　　INC
　　减法指令：
　　SUBB
　　DEC
   十进制调整指令：
　　DA
三：逻辑运算类指令
　　与：ANL
　　或：ORL
　　异或：XRL
　　对累加器A的指令：取反：CPL  A，清零：CLR A
　　循环移位指令：
　　左移：RL
　　右移：RR
　　循环左移：RLC
　　循环右移：RRC
     
　　控制转移类：
　　无条件转移指令：LJMP，AJMP，LJMP
　　条件转移指令：  JZ,      JNZ,        CJNE,   DJNZ    JMP
　　子程序条用及返回指令：
　　LCALL,        ACALL       RET     RETI
　　空操作指令：
　　NOP
四：布尔运算指令：
　　位数据传送指令(针对CY)：MOV  C,BIT
　　位修改指令：CLR   CPL  SETB
　　位逻辑运算：ORL,ANL
　　位转移指令(bit cy)：JC JNC JB JNB JBC