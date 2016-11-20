---
layout: post
title:  "流水灯，利用循环左移指令"
date:   2013-03-12 18:15:35 +0800
categories: 随笔
published: true
---

用到的指令：rl，其只能以a为操作数

立即数#0feh,与0feh是有区别的。

;流水灯,每隔640ms
org 000h
ajmp main
org 030h
main:
      mov a,#0feh
      ;rl r0 只能以a为操作数
      
      L:mov P0,a
      rl a
      lcall delay_1s
ajmp L
      
;延时时间大概时间为640ms
Delay_1s:
         mov r7,#05h
         delay_1: mov r6,#0ffh
         delay_2: mov r5,#0ffh
         delay_3: djnz r5,delay_3
                  djnz r6,delay_2
                  djnz r7,delay_1
      
ret


