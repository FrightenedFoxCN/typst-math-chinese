#let chinesenumber(num, standalone: false) = if num < 11 {
    ("零", "一", "二", "三", "四", "五", "六", "七", "八", "九", "十").at(num)
} else if num < 100 {
    if calc.rem(num, 10) == 0 {
        chinesenumber(calc.floor(num / 10)) + "十"
    } else if num < 20 and standalone {
        "十" + chinesenumber(calc.rem(num, 10))
    } else {
        chinesenumber(calc.floor(num / 10)) + "十" + chinesenumber(calc.rem(num, 10))
    }
} else if num < 1000 {
    let left = chinesenumber(calc.floor(num / 100)) + "百"
    if calc.rem(num, 100) == 0 {
        left
    } else if calc.rem(num, 100) < 10 {
        left + "零" + chinesenumber(calc.rem(num, 100))
    } else {
        left + chinesenumber(calc.rem(num, 100))
    }
} else {
    let left = chinesenumber(calc.floor(num / 1000)) + "千"
    if calc.rem(num, 1000) == 0 {
        left
    } else if calc.rem(num, 1000) < 10 {
        left + "零" + chinesenumber(calc.rem(num, 1000))
    } else if calc.rem(num, 1000) < 100 {
        left + "零" + chinesenumber(calc.rem(num, 1000))
    } else {
        left + chinesenumber(calc.rem(num, 1000))
    }
}

#let chinesenumbering(..nums, location: none, brackets: false) = locate(loc => {
    let actual_loc = if location == none { loc } else { location }
    if nums.pos().len() == 1 {
      "第" + chinesenumber(nums.pos().first(), standalone: true) + "章"
    } else {
      numbering("1.1", ..nums)
    }
}) // 中文编号

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

#let mathenv(term, 
    supplement,
    counter,
    blockcolor,
    emphcolor,
    leading
) = figure(
    block(
        width: 100%,
        fill: blockcolor,
        inset: 8pt,
    )[
        #counter.step()
        #align(left)[
            #set list(marker: (strong[•]))
            #show strong: set text(emphcolor) 
            #strong[
                #leading #counter.display()
                #if supplement != none [
                    （#supplement）
                ]
            ]
            #term
        ]
    ],
    kind: leading,
    supplement: [#leading]
)

#let defcounter = counter("def")

#let defblockcolor = rgb(220, 227, 248)
#let defemphcolor = rgb(31, 119, 184)

#let def(term, supplement: none, counter: defcounter) = mathenv(term, supplement, defcounter, defblockcolor, defemphcolor, "定义")

#let thmcounter = counter("thm")

#let thmblockcolor = rgb(209, 255, 226)
#let thmemphcolor = rgb(41, 142, 88)

#let thm(term, supplement: none, counter: thmcounter) = mathenv(term, supplement, thmcounter, thmblockcolor, thmemphcolor, "定理")

#let rmcounter = counter("rm")

#let rmblockcolor = rgb(255, 237, 193)
#let rmemphcolor = rgb(215, 94, 106)

#let rm(term, supplement: none, counter: rmcounter) = mathenv(term, supplement, rmcounter, rmblockcolor, rmemphcolor, "注记")

#let conf(doc) = {
    set heading (
        numbering: chinesenumbering
    )

    set math.equation (
        numbering: "(1)"
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
        font: ("Times New Roman", "KaiTi")
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

    show ref: it => {
        let eq = math.equation
        let el = it.element
        if el != none {
            if el.func() == heading {
                // for heading
                link(el.location(), [第 #numbering(
                        el.numbering, ..counter(heading).at(el.location())
                    ) 节])
            } else if el.func() == eq {
                link(el.location(), [公式 #numbering(
                        el.numbering, ..counter(eq).at(el.location())
                    )])
            } else if el.func() == figure {
                link(el.location(), [#el.supplement #numbering(el.numbering, ..el.counter.at(el.location()))])
            }
        } else {
            it
        }
    }

    doc
}