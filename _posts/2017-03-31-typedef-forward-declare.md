---
layout: post
title:  "c 中的 forward-declare"
date:   2017-03-31 18:13:27 +0800
categories: notes
published: true
---
* 目录
{:toc}

有下面一段构建列表 c 语言代码：

```c
typedef struct List *List;
struct List
{
  List next;
};
```

懵逼了吗？没有的话，说明你的水平比我高，不用看了。:)

开始简单的解释一下：·不一定对 :)




http://stackoverflow.com/questions/3988041/how-to-define-a-typedef-struct-containing-pointers-to-itself

http://stackoverflow.com/questions/7474774/why-does-typdef-struct-struct-s-s-s-containing-a-pointer-to-same-type-c

https://gcc.gnu.org/onlinedocs/gcc-3.3/gcc/Type-Attributes.html

http://stackoverflow.com/questions/804894/forward-declaration-of-a-typedef-in-c