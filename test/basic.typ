#import "../template.typ": *

#show: doc => conf(doc)

= 引言

这是一份中文的测试文稿。

文本测试

#emph[这是一个强调块]

$ a^2 + b^2 = c^2 $ <pydagoras>

#strong[这一部分被加粗了]

#quote(author: "作者")[这是一段非常非常非常非常非常长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长的引文。]

#quote()[这是一段非常非常非常非常非常长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长的引文，不知道谁说的。]

#quote(author: "作者")[
    这是一段很短的引文。
]

== 下面的小节使用小数字 <numeral>

#lorem(50)

#lorem(100)

== 继续到下一节

#quote()[#lorem(30)]

我们可以引用 @numeral 来证明 @pydagoras。下面的 @cauchy

$ (a^2 + b^2)(c^2 + d^2) >= ((a c)^2 + (b d)^2)^2 $ <cauchy>

是它的一个自然推广。

== 下面这一节测试一些数学模块

#def(supplement: "对象")[以下是定义的内容。] <defobject>

我们可以引用一个定义，例如上面的 @defobject 给出了对对象的定义。而下面的 @defcategory 给出了对范畴的定义。@thm_ref 则给出了……

#def(supplement: "范畴")[
    我们称以下资料构成一个范畴…… 

    #lorem(50)
] <defcategory>

#def[如果想要在定义中使用列表，我们希望：

- 对于 bullet list 的 marker
- 它的颜色也是定义的强调色
- 例如在此是蓝色

+ 对于 numbered list 我们
+ 希望也是如此
+ 但是目前参照其源代码中 `numbering` 的写法
+ 看起来还没法实现
]

#thm(
    [这里是一个定理。], 
    proof: [这里是它的证明。],
    supplement: "这里是补充说明"
) <thm_ref>

#thm(
    [这里是一个没有证明的定理。], 
    supplement: "这里是补充说明"
)

#rm[
    这是一个注记。

    #lorem(50)
]

#pagebreak()

#eg(supplement: "这里是一个例子")[
    我们也可以在这里加上一个例子，它由虚线和正文分隔开，字体为楷体以示区分。
]

== 这里测试一下代码块

```rs
fn helloworld() {
    println!("helloworld!");
}
```

== 这里测试一些额外功能的可能性

/ 范畴: @defcategory
/ 对象: @defobject