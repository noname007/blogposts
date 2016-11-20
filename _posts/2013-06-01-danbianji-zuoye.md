---
layout: post
title:  "单片机上机题目"
date:   2013-06-01 00:00:00 +0800
categories: 随笔
published: true
---

我再也不想写汇编了，写了这么长时间了，还是写不出来易读的代码。读C，还能凑合着读出来一句话，读这玩意，就是在读一个个的字母。       

实验题编程参考

1．  设无符号数x存于内部RAM的VAR的单元，y存于FUNC单元，有如下函数时式

                        x   ，   x≥40

                  y=    2x  ，   20＜x＜40

                        x   ，   x≤20

   设2x仍为一字节数，编写计算此函数的程序。


{% highlight asm linenos %}

    ljmp main
    org 0030h
main:
    mov a,#30
    cjne a,#40,lp1
    ljmp res
lp1:
    jnc res
    cjne a,#20,lp2
    ljmp res
lp2:
    jc res
    rlc a
res:
    mov 31h,a

{% endhighlight %}

2．  编写8位BCD数加法的程序。设被加数存于内部RAM的30H～33H单元，加数存于40H～43H单元，相加结果存于50H～53H单元，数据按低字节在前的顺序排列。

   
{% highlight asm linenos %}

ajmp main
;org 30h
;db 05,01,06,03
;org 40h
;db 1,2,3,4
 
main:
    mov r0,#30h
    mov r1,#40h
    mov r3,#50h
    mov r7,#4
    clr c
    mov sp,#30h
     
loop_n:
   ;mov 不能同时是rn @ri 或是直接地址
    mov a,@r0    
    addc a,@r1                         
    da a
    mov @r0,a
     
    inc r1
    inc r0
    djnz r7,loop_n
 
    mov r7,4
    mov r0,#30h
    mov r1,#50h
again:
      mov a,@r0
      mov @r1,a
      djnz r7,again
       
{% endhighlight %}  

3．  设在43H～40H单元有4个BCD码，它们为（43H）03，（42H）06，（41H）01，（40H）05。即为一个3615（十进制数），请把它们转换成二进制数，并存入R3R2中。

   
{% highlight asm linenos %}
ajmp main
org 0030h
main:
    mov r0,#43h
    acall bcd2b
    mov b,#100
    mul ab
    mov r2,a
    mov r3,b
 
    dec r0
    acall bcd2b
    add a,r2
    ;add a,
    mov r2,a
    mov a,r3
    addc a,#00h
    mov r3,a
here:ajmp here
bcd2b:
    mov a,@r0
    mov b,#0ah
    mul ab
    dec r0
    addc a,@r0
ret
{% endhighlight %}

4． 设有一个16位二进制数0E1FH存放在（R3R2）中，请将其转换成BCD数，并存放在44H～40H单元中。

方法：D15×215 + D14×214   … + D1×2 + D0

(((((((((((((((D15×2 + D14)×2 + D13)× 2 + D12)×2  … 

+ D1）×2 + D0       ；红字部分对应下面红字程序

{% highlight asm linenos %}

ajmp main
;
;解题思路：先将r3r2中存的十六进制数0e1f,按照每位的方式拆开为，0,e,1,f存入到30开始的位置
;然后用模拟的方法模拟除k求余法求出十进制的形式
;
;
;
org 0030h
main:
    mov r0,#30h
    mov sp,#3fh
 
    mov r3,#0eh
    mov r2,#1fh
    mov a,r2
    acall trans
    mov a,r3
    acall trans
    mov r6,#04h
 
modd:
    mov r0,#33h
    mov a,#00h
    mov b,#00h
    acall loop_mod
    push b
    ; 进栈时sp先加1再进数;
    djnz r6,modd
 
here:ajmp here
 
loop_mod:
    mov r7,#04
    loop_mod_n:
    mov b,#10h
    mul ab
    mov b,#0ah
    add a,@r0
    div ab
    mov @r0,a
    mov a,b
    dec r0
    djnz r7,loop_mod_n
ret
 
trans:
    push a
    anl a,#0fh
    mov @r0,a
    inc r0
 
    pop a
    swap a
    anl a,#0fh
    mov @r0,a
    inc r0
ret

{% endhighlight %}

5． 在单片机内部RAM 50H～57H单元中存放着8个单字节无符号数，编程求它们的和（双字节），放在R1R2中，将其均值(只取整数)放在R3中。

{% highlight asm linenos %}

ajmp main
org 0030h
main:
    ;init
    acall init
    mov a,#0ffh
    copy:
        mov @r0,a
        ;inc a
        inc r0
    djnz r7,copy
    acall init
 
    ;add
    ;sum
add_loop:
    add a,@r0
    jnc next
    inc r1
    next:
    inc r0
    djnz r7,add_loop
 
    ;averge
    mov r2,a
    mov r7,#3
yiwei:
    mov a,r1
    rrc a
    mov r1,a
    mov a,r2
    rrc a
    mov r2,a
    clr c
    djnz r7,yiwei
here:ajmp here
 
init:
    mov r7,#8
    mov r0,#50h
    mov a,#0
    mov r1,#0
    mov r2,#0
ret

{% endhighlight %}

6. 将30H单元的二进制数转换成ASCII码放入40H（低位）、41H（高位）单元中。

{% highlight asm linenos %}

ajmp main
 
org 0030h
main:
    mov r0,#40h
    mov a,30h
 
    push a
    acall trans
    pop a
    swap a
    acall trans
 
here:ajmp here
 
trans:  
        anl a,#0fh
        clr c
        cjne a,#0ah,san
        sjmp hex
    san:    
        jnc hex
        add a,#30h
        sjmp out_here
    hex:
        add a,#40h
 
    out_here:
        mov @r0,a
        inc r0
        nop
ret

{% endhighlight %}


7. 将40H（低位）、41H（高位）的ASCII码转换成二进制数放入30H单元中。

{% highlight asm linenos %}

ajmp main
org 0030h
main:
    mov a,40h
    anl a,#0fh
    mov 40h,a
    mov a,41h
    anl a,#0fh
    swap a
    add a,40h
    mov 30h,a
here:ajmp here

{% endhighlight %}

8．将30H中的bcd码转换成二进制数。

{% highlight asm linenos %}

MOV A,30H
ANL A,#0FH
MOV R0,A
MOV A,30H
SWAP A
MOV B,#10
MUL AB
ADD A,R0

{% endhighlight %}

