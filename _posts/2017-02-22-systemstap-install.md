---
layout: post
title:  "systemtap 安装 总结"
date:   2017-02-22 17:28:45 +0800

tags:
- systemstap 

categories: notes
published: true
---
* 目录
{:toc}

<!-- ## systemtap 是什么 -->

systemtap 是一个动态调试工具，春哥的一句话形容的很好，是一种线上活体检测技术。对于动态追踪技术的简述，参看[睿哥的文章][DTrace]，写的真好，不再赘述。

<!-- ## 安装 -->

如果从未接触过，安装还是挺头疼的。我这里做了一个[Makefile](https://github.com/noname007/script/blob/master/systemtap/Makefile)，执行一条命令，喝杯水，等一会可能就装好了 :) 。分别在`fedora 25`跟 `ubuntu 16.04`测试成功。

    pr is always welcome

记得把这个文件夹都下下来，里面有个C文件是用来测试对用户态的程序追踪能否进行。先前一直用官方Beginner手册的例子来测试，

```shell
stap -d /bin/ls --ldd \
-e 'probe process("ls").function("xmalloc") {print_usyms(ubacktrace())}' \
-c "ls /"
```

经过一番排查，参考邮件列表讨论  https://sourceware.org/ml/systemtap/2012-q3/msg00226.html 初步推测 样例有问题，并不能同通用。 应该是有的系统把ls的符号信息干掉了(ubuntu)，有的没有（fedora）。 

所以自己重新写了一个 用户态的程序测试。


ubuntu 16.04
```shell
make deb-systemtap
sudo su root
source /etc/profile.d/devops.sh 
make systemtap-check
```

fedora 25

```shell
make fedora-systemtap
sudo su root
make systemtap-check
```


如果 ubuntu 系统，测试过程中出现 些类型找不到，那么需要`安装内核相关的调试信息`请参考下面的内容进行安装。

如果选用fedora 系统，你会发现这是最省心的安装系统，可能也是官方支持最好的。

## 2017.04.03 以前总结的

### centos 系列


参考官方安装教程: 

[https://sourceware.org/systemtap/SystemTap_Beginners_Guide/using-systemtap.html#using-setup][user_guide_install]

如果是最近的`Fedora`版本系统也可以参考官方这里的安装方式：

[https://sourceware.org/systemtap/getinvolved.html](https://sourceware.org/systemtap/getinvolved.html)

### ubuntu的安装方式

apt-get 方式

	sudo apt-get install systemstap

####  安装内核相关的调试信息

发行版的内核调试信息镜像可在[http://ddebs.ubuntu.com/pool/main/l/linux/?C=M;O=D][kerneldebug_image]这里下载。

一定要找对应的内核版本和系统架构的，否则可能导致[错误][install_in_centos]。如果不确定内核版本和系统架构，可以使用uname命令可以查看内核版本(`uname -r`)、系统架构(`uname -m`)。下载对应的镜像然后使用 dpkg 进行安装：

	dpkg -i linux-image-4.4.0-62-generic-dbgsym_4.4.0-62.83_amd64.ddeb

### tips

<!-- 对，能做什么，原理不熟悉的可以参考 [ "内核探测工具systemtap简介"][systemtap_introduction]。 -->

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

[DTrace]: https://riboseyim.github.io/2016/11/26/DTrace/ "动态追踪技术：Linux喜迎DTrace"