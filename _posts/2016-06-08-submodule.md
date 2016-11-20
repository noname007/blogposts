---
layout: post
title:  "git submodule 笔记"
date:   2016-06-08 12:14:28 +0800
categories: git submodule
---

1 .   添加 submodule

```shell

    git submodule add git-url local-path

    git commit -am"add submodule to git project" //

    git push

    git submodule init

```

2 . clone  带有submodule  的仓库 repos1

```shell

    git clone repos-1-url repos

    cd repos

    git submodule init

    git submodule update

```

3 .  git 项目中修改 submodule



```shell

    cd submodule-path

    git checkout master

    ...do somthing modify...

     git commit -am"do modify"

     git push

    cd respo-root-path

    git commit -am"update submodule"

    git push

```



4 . 主项目更新 其他人 对  submodule做的修改

   

```shell

    cd repos－submodule－path 

    git checkout master

    git pull



    //git submodule foreach git pull

    .....

    cd repos-paht

    git commit  -am"update submodule reference" //commit id

    git push

```








-  记录 submodule 引用的仓库

-  记录submodule在主项目中的目录位置

- 记录submodule 的commit id











http://www.kafeitu.me/git/2012/03/27/git-submodule.html




