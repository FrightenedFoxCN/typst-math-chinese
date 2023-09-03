# 为中文数学文档准备的 typst 模板

[typst 官方网址](https://typst.app/docs)

[typst 官方仓库](https://github.com/typst/typst)

参考了[北京大学的 typst 论文模板](https://github.com/lucifer1004/pkuthss-typst)的一些写法。

## 如何使用这个模板

首先，参照官方指示配置好 typst 环境，也可以使用网页版。

然后引入模板：

```
#import "../template.typ": conf, quote, def, thm, rm

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