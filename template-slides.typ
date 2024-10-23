#import "@preview/showybox:2.0.2": *

#let change_footer_style(content, emphcolor, leading, qed) = if content != none {block(width: 100%, )[
    #align(left)[
        #set list(marker: (strong[•]))
        #set text(
            font: ("Times New Roman", "KaiTi"),
            style: "normal"
        )
        #[
            #set text(emphcolor)
            #leading
        ]
        #content
    ]
    #if qed {
        align(right)[#sym.qed]
    }
]} else {
    ""
}

#let change_body_style(counter, emphcolor, leading, supplement, heading) = block(width: 100%)[
    #if counter != none {
        counter.step()
    }
    #set list(marker: (text(emphcolor)[•]))
    #text(font: ("Times New Roman", "SimHei"), emphcolor)[
        #leading
        #if counter != none [
            #counter.display()
        ]
        #if supplement != none [
            （#supplement）
        ]
    ]
    #heading
]

#let quoteblockcolor = rgb(239, 240, 243)

#let quote(term, author: none) = align(center)[
    #block(
        width: 80%,
        fill: quoteblockcolor,
        inset: 8pt,
    )[
        #set align (left)
        #set text (
            font: ("Times New Roman", "FangSong")
        )
        #set par (
            first-line-indent: 2em
        )
        #show par: set block(
            spacing: 0.65em
        )
        #term
        #align(right)[
            #if author != none [
                —— #author
            ]
        ]
    ]
]

// 数学环境块
#let mathenv(
    term, // 正文 
    supplement, // 补充说明（括号里面的东西）
    counter, // 计数器，需要在模板中定义
    blockcolor, // 块颜色，指底色
    emphcolor, // 强调色，补充说明和编号的颜色
    leading // 编号前面写什么
) = figure(
    showybox(
        frame: (
            body-color: blockcolor,
            radius: 0pt,
            border-color: blockcolor,
        ),
        breakable: true,
        width: 95%,
        change_body_style(counter, emphcolor, leading, supplement, term),
    ),
    kind: leading,
    supplement: [#leading]
)

// 补充数学环境块，例如例子块
#let compmathenv(
    term, 
    supplement,
    counter,
    emphcolor,
    leading
) = figure(
    showybox(
        frame: (
            body-color: white,
            radius: 0pt,
            border-color: emphcolor,
            dash: "dashed",
            thickness: (y: 1pt),
            inset: (x: 0em, y: 1em)
        ),
        breakable: true,
        width: 95%,
    )[
        #set text(
                font: ("Times New Roman", "KaiTi"),
                style: "normal"
        )
        #change_body_style(counter, emphcolor, leading, supplement, term)
    ],
    kind: leading,
    supplement: [#leading]
)

// 带证明/解答的环境块
#let mathenvWithCompanion(
    heading, // 正文
    supplement, 
    counter,
    emphcolor, 
    blockcolor, 
    leading1, // 第一块的编号提示词
    leading2, // 第二块的编号提示词
    content, // 第二块的内容
    qed: false // 是否需要有 qed 标识
) = figure(
    showybox(
        frame: (
            body-color: blockcolor,
            radius: 0pt,
            border-color: blockcolor,
            footer-color: white
        ),
        footer-style: (
            color: black
        ),
        breakable: true,
        footer: change_footer_style(content, emphcolor, leading2, qed),
        change_body_style(counter, emphcolor, leading1, supplement, heading),
        width: 95%
    ),
    kind: leading2,
    supplement: [#leading1]
)

// 以下是一些预定义的环境块
#let defcounter = counter("def")
#let defblockcolor = rgb(220, 227, 248)
#let defemphcolor = rgb(31, 119, 184)

#let def(term, supplement: none, counter: defcounter) = mathenv(term, supplement, defcounter, defblockcolor, defemphcolor, "定义")

#let rmcounter = counter("rm")
#let rmblockcolor = rgb(255, 237, 193)
#let rmemphcolor = rgb(215, 94, 106)

#let rm(term, supplement: none, counter: rmcounter) = mathenv(term, supplement, rmcounter, rmblockcolor, rmemphcolor, "注记")

#let conjcounter = counter("conj")
#let conjblockcolor = rgb(255, 213, 206)
#let conjemphcolor = rgb(233, 66, 66)

#let conj(term, supplement: none, counter: conjcounter) = mathenv(term, supplement, conjcounter, conjblockcolor, conjemphcolor, "猜想")

#let egcounter = counter("eg")
#let egemphcolor = rgb(130, 110, 217)

#let eg(term, supplement: none, counter: egcounter) = compmathenv(term, supplement, egcounter, egemphcolor, "例")

#let thmcounter = counter("thm")
#let thmblockcolor = rgb(209, 255, 226)
#let thmemphcolor = rgb(0, 134, 24)

#let thm(heading, proof: none, supplement: none) = mathenvWithCompanion(heading, supplement, thmcounter, thmemphcolor, thmblockcolor, "定理", "证明", proof, qed: true)

#let coro(heading, proof: none, supplement: none) = mathenvWithCompanion(heading, supplement, thmcounter, thmemphcolor, thmblockcolor, "推论", "证明", proof, qed: true)

#let lemma(heading, proof: none, supplement: none) = mathenvWithCompanion(heading, supplement, thmcounter, thmemphcolor, thmblockcolor, "引理", "证明", proof, qed: true)

#let excounter = counter("ex")
#let exemphcolor = rgb(35, 155, 171)
#let exblockcolor = rgb(161, 255, 238)

#let ex(heading, solution: none, supplement: none) = mathenvWithCompanion(heading, supplement, excounter, exemphcolor, exblockcolor, "习题", "解答", solution)

#let endofchapter() = {
    // clearing all counters
    defcounter.update(0)
    rmcounter.update(0)
    egcounter.update(0)
    thmcounter.update(0)
    excounter.update(0)
    [#pagebreak()]
}

#let makecontent() = [
    #show outline: set heading(
        numbering: (..nums) => "",
    )
    #outline(title: align(center)[目录])

    #pagebreak()
    #counter(heading).update(0)
]

#let conf(doc) = {
    show heading: it => block(
        below: {
            if it.level == 1 {
                25pt // 大层级与正文的距离
            } else {
                40pt // 小层级与正文的距离
            }
        },
    )[
        #set text (
            font: ("Jetbrains Mono", "SimHei"), // 标题字体
            weight: "regular"
        )
        #it.body
    ]

    set text(
        font: ("Times New Roman", "SimSun")
    )

    show emph: set text (
        font: ("Times New Roman", "KaiTi"),
    )

    show strong: set text (
        font: ("Times New Roman", "SimHei")
    )

    show raw: set text (
        font: ("Consolas")
    )

    set enum(
        indent: 2em,
    )

    set list(
        indent: 2em,
    )

    show figure: set block(breakable: true)

    doc
}