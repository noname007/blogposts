---
layout: post
title:  "字符数组与字符串指针区别"
date:   2017-02-18 21:27:40 +0800
categories: notes
published: true
---
* 目录
{:toc}


## 先来意淫一下

群里大神分享了一个Stackoverflow上`字符数组与字符串指针数组的差别`的问答，感觉回答中说的都不太到我的心坎里，故也来凑下热闹。以下面代码为样例，从以下两个层次来说：

- 类型
- 内存分配


```c
#include <stdio.h>
#include <stdlib.h>

int main(int argc, char * argv[])
{

    char * p = "good morning";
    char h[] = "hello world";
    printf("%s\n",p);
    printf("%s\n",h);
    return 0;
}
```


    char * p = "good morning";
    char h[] = "hello world";
    

### 类型（语义）

从c语言种对两种类型使用时的感受来说，存在`char h[]`<==> `char * const h`这种等价关系。对于程序员来说，`使用`时候的差别也主要体现在 `char * const h` 中的多出的`const`的差别。

### 内存分配（语义的实现）

一般来说局部变量，其在内存中都是分配都在栈上。然指针指向的具体值则是分配在堆上。所以两种类型的另外一种差别就是差在`多一次访存`。



    
## 看看到底汇编长啥样

###  总结

    总结据说该放最后，但我还是把它提上来了。：）

原先我还担心高级别的优化，会把我上面的代码，堆上的也优化到栈上，故编译了两个优化级别的，其实并没有。反而都是验证了我上面的两个想法。

核心代码如下

```

//预先分配一个空闲栈，32字节
subl	$32, %esp

// char * p 这个局部变量 
movl	$LC0, (%esp) 

//char h[] 这个局部变量，下面这几个魔数就是 hello world 
movl	$1819043176, 20(%esp)
movl	$1870078063, 24(%esp)
movl	$6581362, 28(%esp)

//意外之获，c 中 printf 格式有换行,底层调用就是_puts，去掉换行就变成了另外一个：）
//_puts输出 栈顶存放的指针 所指向的字符串
call	_puts

//-----
leal	20(%esp), %eax
movl	%eax, (%esp)
call	_puts

```	

### 环境信息

 - 系统环境：`window + MinGw gcc 5.3.0` 
 
 - 编译命令: ` gcc -m32 -S -O0 Untitled1.c`

```
$ gcc -v
Using built-in specs.
COLLECT_GCC=C:\MinGW\bin\gcc.exe
COLLECT_LTO_WRAPPER=c:/mingw/bin/../libexec/gcc/mingw32/5.3.0/lto-wrapper.exe
Target: mingw32
Configured with: ../src/gcc-5.3.0/configure --build=x86_64-pc-linux-gnu --host=mingw32 --prefix=/mingw --disable-win32-registry --target=mingw32 --with-arch=i586 --enable-languages=c,c++,objc,obj-c++,fortran,ada --enable-static --enable-shared --enable-threads --with-dwarf2 --disable-sjlj-exceptions --enable-version-specific-runtime-libs --with-libintl-prefix=/mingw --enable-libstdcxx-debug --with-tune=generic --enable-libgomp --disable-libvtv --enable-nls : (reconfigured) ../src/gcc-5.3.0/configure --build=x86_64-pc-linux-gnu --host=mingw32 --prefix=/mingw --disable-win32-registry --target=mingw32 --with-arch=i586 --enable-languages=c,c++,objc,obj-c++,fortran,ada --enable-static --enable-shared --enable-threads --with-dwarf2 --disable-sjlj-exceptions --enable-version-specific-runtime-libs --with-libiconv-prefix=/mingw --with-libintl-prefix=/mingw --enable-libstdcxx-debug --with-tune=generic --enable-libgomp --disable-libvtv --enable-nls
Thread model: win32
gcc version 5.3.0 (GCC)

```



### 二级优化 -O2



    gcc -m32 -S -O2 Untitled1.c   -o 2.s
    
    

```

	.file	"Untitled1.c"
	.def	___main;	.scl	2;	.type	32;	.endef
	.section .rdata,"dr"
LC0:
	.ascii "good morning\0"
	.section	.text.unlikely,"x"
LCOLDB1:
	.section	.text.startup,"x"
LHOTB1:
	.p2align 4,,15
	.globl	_main
	.def	_main;	.scl	2;	.type	32;	.endef
_main:
LFB21:
	.cfi_startproc
	pushl	%ebp
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	movl	%esp, %ebp
	.cfi_def_cfa_register 5
	andl	$-16, %esp
	subl	$32, %esp
	call	___main
	movl	$LC0, (%esp)
	movl	$1819043176, 20(%esp)
	movl	$1870078063, 24(%esp)
	movl	$6581362, 28(%esp)
	call	_puts
	leal	20(%esp), %eax
	movl	%eax, (%esp)
	call	_puts
	xorl	%eax, %eax
	leave
	.cfi_restore 5
	.cfi_def_cfa 4, 4
	ret
	.cfi_endproc
LFE21:
	.section	.text.unlikely,"x"
LCOLDE1:
	.section	.text.startup,"x"
LHOTE1:
	.ident	"GCC: (GNU) 5.3.0"
	.def	_puts;	.scl	2;	.type	32;	.endef
```






### 未优化  -O0

    gcc -m32 -S -O0 Untitled1.c   -o 2.s


```

	.file	"Untitled1.c"
	.def	___main;	.scl	2;	.type	32;	.endef
	.section .rdata,"dr"
LC0:
	.ascii "good morning\0"
	.text
	.globl	_main
	.def	_main;	.scl	2;	.type	32;	.endef
_main:
LFB12:
	.cfi_startproc
	pushl	%ebp
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	movl	%esp, %ebp
	.cfi_def_cfa_register 5
	andl	$-16, %esp
	subl	$32, %esp
	call	___main
	movl	$LC0, 28(%esp)
	movl	$1819043176, 16(%esp)
	movl	$1870078063, 20(%esp)
	movl	$6581362, 24(%esp)
	movl	28(%esp), %eax
	movl	%eax, (%esp)
	call	_puts
	leal	16(%esp), %eax
	movl	%eax, (%esp)
	call	_puts
	movl	$0, %eax
	leave
	.cfi_restore 5
	.cfi_def_cfa 4, 4
	ret
	.cfi_endproc
LFE12:
	.ident	"GCC: (GNU) 5.3.0"
	.def	_puts;	.scl	2;	.type	32;	.endef


```





