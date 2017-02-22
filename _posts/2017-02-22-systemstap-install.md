---
layout: post
title:  "systemstap 安装"
date:   2017-02-22 17:28:45 +0800

tags:
- systemstap 

categories: notes
published: true
---
* 目录
{:toc}

## centos 系列


参考官方安装教程: 

[https://sourceware.org/systemtap/SystemTap_Beginners_Guide/using-systemtap.html#using-setup][user_guide_install]

如果是最近的`Fedora`版本系统也可以参考官方这里的安装方式：

[https://sourceware.org/systemtap/getinvolved.html](https://sourceware.org/systemtap/getinvolved.html)

## ubuntu的安装方式

###  安装systemstap机器运行时的库

	sudo apt-get install systemstap

###  安装内核相关的调试信息

发行版的内核调试信息镜像可在[http://ddebs.ubuntu.com/pool/main/l/linux/?C=M;O=D][kerneldebug_image]这里下载。

一定要找对应的内核版本和系统架构的，否则可能导致[错误][install_in_centos]。如果不确定内核版本和系统架构，可以使用uname命令可以查看内核版本(`uname -r`)、系统架构(`uname -m`)。下载对应的镜像然后使用 dpkg 进行安装：

	dpkg -i linux-image-4.4.0-62-generic-dbgsym_4.4.0-62.83_amd64.ddeb

## tips

对systemtap 是什么，能做什么，原理不熟悉的可以参考 [ "内核探测工具systemtap简介"][systemtap_introduction]

安装完后一定要用下面的两句命令测试一下，安装是否成功。 两个都要测试一下，第一个只要systemtap 安装成功，就可以成功运行，第二个必须是内核调试镜像安装成功后才能成功运行

```
# stap -ve 'probe begin { log("hello world") exit () }'
# stap -c df -e 'probe syscall.* { if (target()==pid()) log(name." ".argstr) }'
```

其他的一下参考文章

- [Install SystemTap in Ubuntu 14.04](http://blog.jeffli.me/blog/2014/10/10/install-systemtap-in-ubuntu-14-dot-04/)

[user_guide_install]: https://sourceware.org/systemtap/SystemTap_Beginners_Guide/using-systemtap.html#using-setup "using-systemtap"
[install_in_centos]: http://www.hi-roy.com/2016/07/27/CentOS7%E5%AE%89%E8%A3%85systemtap/ "CentOS7安装systemtap"
[systemtap_introduction]: http://www.cnblogs.com/hazir/p/systemtap_introduction.html "内核探测工具systemtap简介"
[kerneldebug_image]: http://ddebs.ubuntu.com/pool/main/l/linux/?C=M;O=D "kerneldebug_image"