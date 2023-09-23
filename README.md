# 为中文数学文档准备的 typst 模板

[typst 官方网址](https://typst.app/docs)

[typst 官方仓库](https://github.com/typst/typst)

参考了[北京大学的 typst 论文模板](https://github.com/lucifer1004/pkuthss-typst)的一些写法。

## 如何使用这个模板

首先，参照官方指示配置好 typst 环境，也可以使用网页版。

然后引入模板：

```
#import "../template.typ": conf, quote, def, thm, rm, eg

#show: doc => conf(doc)
```

在第一行中将路径修改为从本文件到 template 的相对路径，引入的模块中，`conf` 是必须的，其它模块的介绍参见下文。

## 具体功能

可以在 `test/basic.typ` 中找到下述所有功能的实例。

### 中文字体和排版支持

- 中文标识章节。
- 使用黑体标题，用黑体替代加粗，楷体替代强调（倾斜）。

### 额外功能

- `quote` 模块提供引文块，可选地提供 `author` 参数给出作者。
- `def` 等数学模块均继承自 `mathenv`，可选地提供标号后的附注。可以引入 `mathenv` 自定义额外的数学块，需要自行给定配色方案。
- `thm` 利用 `showybox` 实现，写证明和定理不再需要分开了。其他部分也会陆续改用此种实现方式。
- 补充了 `makecontent` 和 `endofchapter` 两个指令，用来方便地创建目录、结束章节。

### 待完成

- [ ] 公式的引用必须要求给公式打上标号，但有时候标号显示会带来麻烦，所以暂时删掉了；
- [x] 其它定理的同义词：引理、推论等；
- [x] 猜想、问题；
- [ ] 配色调整；
- [x] 代码风格整理；
- [x] 用 `showybox` 重写其他的环境；
- [ ] 处理好 counter 的问题。