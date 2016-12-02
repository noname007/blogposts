---
layout: post
title:  "jekyll 搭建小记"
date:   2016-11-11 19:59:19 +0800
categories: notes
published: true
---

* 目录
{:toc}

<!-- 命令行下安装 -->

## 安装依赖环境
- ruby
- gem
- nodejs
- python
- pygements

### ubuntu 使用rvm 来安装


{% highlight sh linenos %}


curl -sSL https://rvm.io/mpapis.asc | gpg --import -

curl -L https://raw.githubusercontent.com/wayneeseguin/rvm/master/binscripts/rvm-installer  | bash -s stable --ruby  

sudo apt-get sudo apt-get install nodejs

{%endhighlight%}


### windows 下安装

[下载](http://rubyinstaller.org/downloads/) `Ruby`、`DevKit`，并分别安装

#### 安装gem

进入DevKit目录，运行命令

{% highlight sh linenos %}

ruby dk.rb init
ruby dk.rb install

{%endhighlight%}


## 安装jekyll

- 换成国内的gem源


	`gem sources --add http://gems.ruby-china.org/ --remove https://rubygems.org/ -V`


	`gem install liquid kramdown jekyll pygments.rb`


## 参考

- http://blog.csdn.net/fnzsjt/article/details/41729463

- http://www.jianshu.com/p/609e1197754c

- https://segmentfault.com/q/1010000000261050
