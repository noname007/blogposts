---
layout: post
title:  "使用composer vcs 构建私有资源库"
date:   2016-12-09 10:21:09 +0800
tags:
- composer
- php
categories: notes
published: true
---
* 目录
{:toc}
<!--
## 背景
很简单一件事，居然还跳进坑里面了，该死。
项目庞杂需要重构，要把基础的代码提出来。貌似可以以组件的方式可以搞一搞，选择 composer 解决依赖问题。但又有很大的业务针对性，代码不可以公开。故最后选择使用composer+git的方式构建私有资源。 -->


## composer repositories

根据[文档][1]可知，composer 资源库使用`repositories`属性字段来定义所使用的包资源。
- `packagist` 指定一个资源服务器，例如下面实例中用于指定 `Packagist / Composer 的中国全量镜像`
- `vcs` 版本控制仓库

<!--
- [`path`][2] 本地路径
 -->


### 例

      在now代码库中使用私有的base代码库

base 代码库的composer.json配置如下

{% highlight json linenos  %}

{
    "name": "vendor/base",
    "authors": [
        {
            "name": "soul11201",
            "email": "soul11201@gmail.com"
        }
    ],
    "require": {
        "phalcon/devtools": "^3.0"
    },
    "repositories": {
        "packagist": {
            "type": "composer",
            "url": "https://packagist.phpcomposer.com"
        }
    }
}

{% endhighlight  %}


now 代码库的composer.json配置如下

{% highlight json linenos  %}

{
    "name": "vendor2/now",
    "authors": [
        {
            "name": "soul11201",
            "email": "soul11201@gmail.com"
        }
    ],

 	"repositories": [
        {
            "type": "git",
            "url":  "url:vendor/base.git"
        }
    ],

    "require": {
    	"vendor/base":"dev-master"
    }
}

{% endhighlight  %}

* 注意保证now 中require key值和 base中的name 保持一致

<!-- ## 参考 -->
[1]: http://docs.phpcomposer.com/04-schema.html#repositories "composer repositories"
[2]: http://blog.inforere.com/?p=248 "composer从私有资源库安装"
[3]: http://www.phpno.com/private-packagist.html "如何实现利用免费资源打造公有库以及私有库"
[4]: http://www.jianshu.com/p/98c5b254a79e "作为PHP开发者请务必了解Composer"
[5]: http://docs.phpcomposer.com/04-schema.html#minimum-stability "composer minimum-stability"
