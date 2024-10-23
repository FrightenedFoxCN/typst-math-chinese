#import "@preview/showybox:2.0.2": *

#let change_footer_style(content, emphcolor, leading, qed) = if content != none {block(width: 100%, )[
    #align(left)[
        #set list(marker: (strong[•]))
        #set text(
            font: ("Times New Roman"),
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

#let chapter_numbering(..nums) = {
    if (nums.pos().len() == 1) {
        "Lecture " + numbering("1", ..nums) + ": "
    } else {
        numbering("1.1.1", ..nums)
    }
    
}

#let appendix_numbering(..nums) = {
    if (nums.pos().len() == 1) {
        "Appendix " + numbering("A", ..nums) + ": "
    } else {
        numbering("A.1.1", ..nums)
    }
}

#let change_body_style(counter, emphcolor, leading, supplement, heading) = block(width: 100%)[
    #if counter != none {
        counter.step()
    }
    #set list(marker: (text(emphcolor)[•]))
    #text(
        font: ("Times New Roman"),
        weight: "bold", 
        emphcolor)[
        #leading
        #if counter != none [
            #context counter.display()
        ]
        #if supplement != none [
            (#supplement)
        ]
    ]
    #heading
]

// 数学环境块
#let mathenv(
    term, // 正文 
    supplement, // 补充说明（括号里面的东西）
    counter, // 计数器，需要在模板中定义
    blockcolor, // 块颜色，指底色
    emphcolor, // 强调色，补充说明和编号的颜色
    leading // 编号前面写什么
) = showybox(
    frame: (
        body-color: blockcolor,
        radius: 0pt,
        border-color: blockcolor,
    ),
    breakable: true,
    change_body_style(counter, emphcolor, leading, supplement, term),
)

// 补充数学环境块，例如例子块
#let compmathenv(
    term, 
    supplement,
    counter,
    emphcolor,
    leading
) = showybox(
    frame: (
        body-color: white,
        radius: 0pt,
        border-color: emphcolor,
        dash: "dashed",
        thickness: (y: 1pt),
        inset: (x: 0em, y: 1em)
    ),
    breakable: true,
)[
    #set text(
        font: ("Times New Roman"),
    )
    #change_body_style(counter, emphcolor, leading, supplement, term)
]

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
) = showybox(
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
)


// 以下是一些预定义的环境块
#let defcounter = counter("def")
#let defblockcolor = rgb(220, 227, 248)
#let defemphcolor = rgb(31, 119, 184)

#let def(term, supplement: none, counter: defcounter) = mathenv(term, supplement, defcounter, defblockcolor, defemphcolor, "Definition")

#let rmcounter = counter("rm")
#let rmblockcolor = rgb(255, 237, 193)
#let rmemphcolor = rgb(215, 94, 106)

#let rm(term, supplement: none, counter: rmcounter) = mathenv(term, supplement, rmcounter, rmblockcolor, rmemphcolor, "Remark")

#let conjcounter = counter("conj")
#let conjblockcolor = rgb(255, 213, 206)
#let conjemphcolor = rgb(233, 66, 66)

#let conj(term, supplement: none, counter: conjcounter) = mathenv(term, supplement, conjcounter, conjblockcolor, conjemphcolor, "Conjecture")

#let egcounter = counter("eg")
#let egemphcolor = rgb(130, 110, 217)

#let eg(term, supplement: none, counter: egcounter) = compmathenv(term, supplement, egcounter, egemphcolor, "Example")

#let thmcounter = counter("thm")
#let thmblockcolor = rgb(209, 255, 226)
#let thmemphcolor = rgb(0, 134, 24)

#let thm(heading, proof: none, supplement: none) = mathenvWithCompanion(heading, supplement, thmcounter, thmemphcolor, thmblockcolor, "Theorem", "Pf.", proof, qed: true)

#let coro(heading, proof: none, supplement: none) = mathenvWithCompanion(heading, supplement, thmcounter, thmemphcolor, thmblockcolor, "Corollary", "Pf.", proof, qed: true)

#let prop(heading, proof: none, supplement: none) = mathenvWithCompanion(heading, supplement, thmcounter, thmemphcolor, thmblockcolor, "Proposition", "Pf.", proof, qed: true)

#let lemma(heading, proof: none, supplement: none) = mathenvWithCompanion(heading, supplement, thmcounter, thmemphcolor, thmblockcolor, "Lemma", "Pf.", proof, qed: true)

#let excounter = counter("ex")
#let exemphcolor = rgb(35, 155, 171)
#let exblockcolor = rgb(161, 255, 238)

#let ex(heading, solution: none, supplement: none) = mathenvWithCompanion(heading, supplement, excounter, exemphcolor, exblockcolor, "Exercise", "Sol.", solution)

#let endofchapter() = {
    // clearing all counters
    defcounter.update(0)
    rmcounter.update(0)
    egcounter.update(0)
    thmcounter.update(0)
    excounter.update(0)
    [#pagebreak()]
}

#let conf(doc) = {
    set heading (
        numbering: chapter_numbering
    )
    
    doc
}

#let set-appendix(doc) = {
    counter(heading).update(0)

    set heading (
        numbering: appendix_numbering
    )

    doc
}