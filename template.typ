#import "@preview/showybox:1.1.0": *

#let chinese_number(num, standalone: false) = if num < 11 {
    ("零", "一", "二", "三", "四", "五", "六", "七", "八", "九", "十").at(num)
} else if num < 100 {
    if calc.rem(num, 10) == 0 {
        chinese_number(calc.floor(num / 10)) + "十"
    } else if num < 20 and standalone {
        "十" + chinese_number(calc.rem(num, 10))
    } else {
        chinese_number(calc.floor(num / 10)) + "十" + chinese_number(calc.rem(num, 10))
    }
} else if num < 1000 {
    let left = chinese_number(calc.floor(num / 100)) + "百"
    if calc.rem(num, 100) == 0 {
        left
    } else if calc.rem(num, 100) < 10 {
        left + "零" + chinese_number(calc.rem(num, 100))
    } else {
        left + chinese_number(calc.rem(num, 100))
    }
} else {
    let left = chinese_number(calc.floor(num / 1000)) + "千"
    if calc.rem(num, 1000) == 0 {
        left
    } else if calc.rem(num, 1000) < 10 {
        left + "零" + chinese_number(calc.rem(num, 1000))
    } else if calc.rem(num, 1000) < 100 {
        left + "零" + chinese_number(calc.rem(num, 1000))
    } else {
        left + chinese_number(calc.rem(num, 1000))
    }
}

// 在这里改变章节标题
#let chapter_numbering(nums) = {
    "第" + chinese_number(nums, standalone: true) + "章"
    // "Lecture " + str(nums)
}

// 编号方式
#let chinese_numbering(..nums, location: none) = locate(loc => {
    let actual_loc = if location == none { loc } else { location }
    if nums.pos().len() == 1 {
      chapter_numbering(nums.pos().first())
    } else {
      numbering("1.1", ..nums)
    }
})


// 脚注的格式修改
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

// 正文的格式修改
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

// 引文块的颜色
#let quoteblockcolor = rgb(239, 240, 243)

// 引文块的格式比较特殊，单独设定
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
            thickness: (y: 1pt, rest: 0pt),
            inset: (x: 0em, y: 1em)
        ),
        breakable: true,
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
        change_body_style(counter, emphcolor, leading1, supplement, heading)
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

#let conf(doc, chapter_numbering: chapter_numbering) = {
    set heading (
        numbering: chinese_numbering
    )

    show heading: it => block(
        below: {
            if it.level == 1 {
                25pt // 大层级与正文的距离
            } else {
                15pt // 小层级与正文的距离
            }
        },
    )[
        #set text (
            font: ("Times New Roman", "SimHei"), // 标题字体
            weight: "regular"
        )
        #counter(heading).display()
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

    show ref: it => {
        let eq = math.equation
        let el = it.element
        if el != none {
            if el.func() == heading {
                // for heading
                link(el.location(), [第 #numbering(
                        el.numbering, ..counter(heading).at(el.location())
                    ) 节])
            // } else if el.func() == eq {
            //     link(el.location(), [公式 #numbering(
            //             el.numbering, ..counter(eq).at(el.location())
            //         )])
            } else if el.func() == figure {
                link(el.location(), [#el.supplement #numbering(el.numbering, ..el.counter.at(el.location()))])
            }
        } else {
            it
        }
    }

    doc
}