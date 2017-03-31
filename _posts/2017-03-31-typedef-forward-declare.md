---
layout: post
title:  "c 中的 forward-declare"
date:   2017-03-31 18:13:27 +0800
categories: notes
published: true
---
* 目录
{:toc}


>欢迎邮件交流

有下面一段构建列表 c 语言代码：



```c
typedef struct List * List;
struct List
{
  List next;
};
```

懵逼了吗？没有的话，说明你的水平比我高，不用看了。:)

`struct tag{...};`tag 可以为任意标识符，关键字（int,if)除外

`typedef A B` A 可以为任意类型，前提是编译器能算出来所占用的内存空间。
B 可以为任意标识符，关键字（int,if)除外。`typedef struct List List` 就不合法，`struct List` 内存占用多少信息无法获知。

下面是两段验证程序：

- [1.c](https://github.com/noname007/mooc163-compiler/blob/master/c/poc/forward-declare/1.c)
- [2.c](https://github.com/noname007/mooc163-compiler/blob/master/c/poc/forward-declare/2.c)

你可能会有疑问`struct L` `L` 是怎么区分开的?但是其实也很容易想明白，你说呢:)


## c++ 不能这么玩

参考资料里面也有提及到。不信可以试下。自行观看下面的编译过程。

```shell
gcc 1.c -v #cc1
g++ 1.c -v #cc1plus
```





## 总结
有个用途就是做数据隐藏，在一个头文件中只写如下代码（抄自参考资料）：

```c
typedef struct Node Node;
Node * list_new(void);
Node * list_append(Node *head, Node *new_tail);
size_t list_length(const Node *head);
```

从中可以看出，即使此前从未声明过的类型，也不会对编译有多大影响。从这里做个简单的结论，`编译器能获得类型占用多少内存空间信息，要比在此前获得其定义声明信息更加重要。`


---
## 参阅资料

- http://stackoverflow.com/questions/3988041/how-to-define-a-typedef-struct-containing-pointers-to-itself

- http://stackoverflow.com/questions/7474774/why-does-typdef-struct-struct-s-s-s-containing-a-pointer-to-same-type-c

- http://stackoverflow.com/questions/804894/forward-declaration-of-a-typedef-in-c
<!-- - https://gcc.gnu.org/onlinedocs/gcc-3.3/gcc/Type-Attributes.html -->