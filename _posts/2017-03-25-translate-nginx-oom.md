---
layout: post
title:  "translate-nginx-oom"
date:   2017-03-25 17:46:27 +0800
categories: 随笔
tags:
- openresty
- OOM
- debug
- strace
- 

published: true
---


[原文链接][original]

__在[lua-nginx-module][lua-nginx-moduleL1294] 中，一个内存相关的黑魔法导致冗余的大内存分配。__


最近我改变了一个线上的 Nginx 配置，导致OOM（Out of Memory） killer 在 Nginx 加载新配置的过程中 杀死了 Nginx 进程。这里是添加到配置中的行：

	lua_ssl_trusted_certificate /etc/ssl/certs/ca-certificates.crt;

这篇文章中我将会阐述我是如何找出这个问题的根本原因、记录在这个过程中我学习的用到的工具。这篇文章是由一点点的小事情组成的。在进行深入阅读前，我先列下我使用的软件栈：

- Openssl `1.0.2j`
- OS:`Ubuntu Trusty with Linux 3.19.0-80-generic`
- Nginx:`Openresty bundle 1.11.2`
- glibc:`Ubuntu EGLIBC 2.19-0ubuntu6.9`

我们从 OOM Killer 开始。它是一个 Linux 内核函数，当内核不能分配更多的内存空间的时候它将会被触发。OOM Killer 的任务是探测那个进程是对系统危害最大（参考[ https://linux-mm.org/OOM_Killer](https://linux-mm.org/OOM_Killer),获取更多关于坏评分是如何计算出来的信息），一旦检测出来，将会杀死进程、释放内存。这意味着 在我的这种情况中 ，Nginx 是在申请越来越多的内存，最终内核申请内存失败并且触发OOM Killer，杀死 Nginx 进程。到此为止，现在让我们看看 Nginx 做了什么当它重新加载新的配置的时候。可以使用 `strace` 做这件事。 这是一个非常棒的工具，能查看程序正在做什么而不用阅读它的源码。在我这种情况下，执行：

	sudo strace -p `cat /var/run/nginx.pid` -f

接着

	sudo /etc/inid.t/nginx reload

`-f` 选项告诉 `strace` 也要跟踪子进程。 在[http://jvns.ca/zines/#strace-zine.](http://jvns.ca/zines/#strace-zine.)你能看到一个对`strace`非常好的评价。下面是一个非常有趣的片段，执行完上面的命令后从`strace`中输出的。


```shell

[pid 31774] open("/etc/ssl/certs/ca-certificates.crt", O_RDONLY) = 5
[pid 31774] fstat(5, {st_mode=S_IFREG|0644, st_size=274340, ...}) = 0
[pid 31774] mmap(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x7f6dc8266000
[pid 31774] read(5, "-----BEGIN CERTIFICATE-----\nMIIH"..., 4096) = 4096
[pid 31774] read(5, "WIm\nfQwng4/F9tqgaHtPkl7qpHMyEVNE"..., 4096) = 4096
[pid 31774] read(5, "Ktmyuy/uE5jF66CyCU3nuDuP/jVo23Ee"..., 4096) = 4096
...<stripped for clarity>...
[pid 31774] read(5, "MqAw\nhi5odHRwOi8vd3d3Mi5wdWJsaWM"..., 4096) = 4096
[pid 31774] read(5, "dc/BGZFjz+iokYi5Q1K7\ngLFViYsx+tC"..., 4096) = 4096
[pid 31774] brk(0x26d3000)              = 0x26b2000
[pid 31774] mmap(NULL, 1048576, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x7f6c927c3000
[pid 31774] read(5, "/lmci3Zt1/GiSw0r/wty2p5g0I6QNcZ4"..., 4096) = 4096
[pid 31774] read(5, "iv9kuXclVzDAGySj4dzp30d8tbQk\nCAU"..., 4096) = 4096
...<stripped for clarity>...
[pid 31774] read(5, "ye8\nFVdMpEbB4IMeDExNH08GGeL5qPQ6"..., 4096) = 4096
[pid 31774] read(5, "VVNUIEVs\nZWt0cm9uaWsgU2VydGlmaWt"..., 4096) = 4004
[pid 31774] read(5, "", 4096)           = 0
[pid 31774] close(5)                    = 0
[pid 31774] munmap(0x7f6dc8266000, 4096) = 0

```
这段重复了很多次！有两行非常有意思。

	open("/etc/ssl/certs/ca-certificates.crt", O_RDONLY) = 5

这意味着是跟修改的配置（上面提到的修改）有关的操作，还有

	mmap(NULL, 1048576, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x7f6c927c3000

这个意味着内核被请求分配 1M 内存空间在`read`过程中间。在这个 `strace` 输出中，另一个有意思的细节是分配的内存从来没有执行`munmap`进行释放。注意在调用`close`后`0x7f6dc8266000`被传入`munmap`。这些事实让我相信 Nginx 发生了 内存泄露当`lua_ssl_trusted_certificate`这条指令被设置后（尽管我对底层调试几乎没有任何经验）。Nginx 发生了内存泄露，难道那还不让人兴奋？！不要这么兴奋。为了找出是Nginx 的那个组件发生了内存泄露，我决定使用 `gdb`。如果编译程序的时候打开了调试符号选项，`gdb`将会非常有用。如上所述，我使用的是 Nginx Openresty 套件。需要使用下面的命令开启调试符号选项重新编译：

	~/openresty-1.11.2.2 $ ./configure -j2 --with-debug --with-openssl=../openssl-1.0.2j/ --with-openssl-opt="-d no-asm -g3 -O0 -fno-omit-frame-pointer -fno-inline-functions"


`--with-openssl-opt="-d no-asm -g3 -O0 -fno-omit-frame-pointer -fno-inline-functions"`确保OpenSSL编译的时候也开启调试符号信息。现在已经在Openresty的可执行程序中带有了调试符号信息，我能通过`gdb`启动运行它并找到具体的触发上面提到的`mmap`调用的函数.


[original]: http://www.elvinefendi.com/2017/03/07/my-experience-with-lua-nginx-openssl-strace-gdb-glibc-and-linux-vm.html

[lua-nginx-moduleL1294]: https://github.com/openresty/lua-nginx-module/blob/37e5362088bd659e318aae568b268719bd0d6707/src/ngx_http_lua_module.c#L1294








