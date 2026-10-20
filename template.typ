#import "@preview/ctheorems:1.1.3": *

#let chapter_numbering(nums) = {
  numbering("第一章", nums)
}

#let lecture_numbering_inner(nums) = {
  numbering("第一讲", nums)
}

#let lecture_numbering(..nums) = {
  if nums.pos().len() == 1 {
    lecture_numbering_inner(nums.pos().first())
  } else {
    numbering("1.1", ..nums)
  }
}

// 编号方式
#let chinese_numbering(..nums) = {
  if nums.pos().len() == 1 {
    chapter_numbering(nums.pos().first())
  } else {
    numbering("1.1", ..nums)
  }
}

#let appendix_numbering(..nums) = {
  if nums.pos().len() == 1 {
    numbering("附录 A", ..nums)
  } else {
    numbering("A.1", ..nums)
  }
}

#let set-appendix(doc) = {
  counter(heading).update(0)

  set heading(
    numbering: appendix_numbering,
  )

  doc
}

// 字体组：Typst 按字形逐个回退，因此每组先列西文字体、再列中文字体，
// 否则中文字体自带的西文字形会抢先生效。中文优先使用 macOS 系统字体，
// 缺失时回退到开源的 Noto CJK / 霞鹜文楷。
#let latin-fonts = ("Times New Roman", "TeX Gyre Termes")
#let song-fonts = (..latin-fonts, "Songti SC", "Noto Serif CJK SC")
#let hei-fonts = (..latin-fonts, "Heiti SC", "Noto Sans CJK SC")
#let kai-fonts = (..latin-fonts, "Kaiti SC", "LXGW WenKai", "Noto Serif CJK SC")
#let mono-fonts = ("JetBrains Mono", "JetBrainsMono NF", "Menlo", "DejaVu Sans Mono", "Noto Sans Mono CJK SC")

// 旧名称，保留以兼容已有笔记
#let theorem-title-font = hei-fonts
#let theorem-companion-font = kai-fonts

#let make-boxed-theorem(
  identifier,
  heading,
  blockcolor,
  emphcolor,
  stroke: none,
  inset: (x: 1.2em, y: 0.8em),
  body-font: none,
  base: "heading",
  base_level: 1,
) = thmbox(
  identifier,
  heading,
  fill: blockcolor,
  stroke: if stroke == none { blockcolor } else { stroke },
  radius: 0pt,
  inset: inset,
  breakable: true,
  base: base,
  base_level: base_level,
  supplement: heading,
  padding: (top: 0.45em, bottom: 0.45em),
  separator: [#h(0.5em)],
  titlefmt: title => text(font: hei-fonts, emphcolor, weight: "bold")[#h(-2em) #title],
  namefmt: name => text(font: hei-fonts, emphcolor, weight: "bold")[（#name）],
  bodyfmt: body => [
    #if body-font != none {
      set text(font: body-font, style: "normal")
    }
    #set list(marker: (text(emphcolor)[•]))
    #set enum(numbering: n => text(emphcolor)[#n])
    #body
    // this parbreak is important for typesetting
    #parbreak()
  ],
)

#let make-companion-theorem(
  identifier,
  heading,
  blockcolor,
  emphcolor,
  base: "heading",
  base_level: 1,
) = thmenv(
  identifier,
  base,
  base_level,
  (name, number, body, companion: none, companion-label: "证明", qed: false) => {
    
    let title = heading
    if number != none {
      title += number
    }

    pad(top: 0.45em, bottom: 0.45em)[
      #block(
        width: 100%,
        stroke: blockcolor + 2pt,
        radius: 0pt,
        inset: 0pt,
        breakable: true,
      )[
        #stack(
          dir: ttb,
          spacing: 0pt,
          block(width: 100%, fill: blockcolor, inset: (x: 1.2em, y: 0.8em), breakable: true)[
            #set list(marker: (text(emphcolor)[•]))
            #set enum(numbering: n => text(emphcolor)[#n])
            #text(font: hei-fonts, emphcolor, weight: "bold")[#h(-2em)#title]
            #if name != none [
              #text(font: hei-fonts, emphcolor, weight: "bold")[（#name）]
            ]
            #h(0.5em)
            #body
            #parbreak()
          ],
          if companion != none {
            block(width: 100%, fill: white, inset: (x: 1.2em, y: 0.8em), breakable: true)[
              #h(-2em)
              #set text(font: kai-fonts, style: "normal")
              #set list(marker: (strong[•]))
              #text(emphcolor, weight: "bold")[#companion-label]
              #h(0.5em)
              #companion
              #if qed [
                #h(1fr)#sym.qed
              ]
              #parbreak()
            ]
          } else { none },
        )
      ]
    ]
  }
).with(supplement: heading)

// 引文块的颜色
#let quoteblockcolor = rgb(239, 240, 243)

// 引文块的格式比较特殊，单独设定
#let quote(term, author: none) = align(center)[
  #block(
    width: 80%,
    fill: quoteblockcolor,
    inset: 8pt,
  )[
    #set align(left)
    #set text(font: song-fonts)
    #set par(first-line-indent: (amount: 2em, all: true), spacing: 0.65em)
    #term
    #align(right)[
      #if author != none [
        —— #author
      ]
    ]
  ]
]

// 以下是一些预定义的环境块
#let defblockcolor = rgb(220, 227, 248)
#let defemphcolor = rgb(31, 119, 184)

#let definition-env = make-boxed-theorem("definition", "定义", defblockcolor, defemphcolor)
#let def(term, supplement: none) = definition-env(supplement)[#term]

#let rmblockcolor = rgb(255, 237, 193)
#let rmemphcolor = rgb(215, 94, 106)

#let remark-env = make-boxed-theorem("remark", "注记", rmblockcolor, rmemphcolor)
#let rm(term, supplement: none) = remark-env(supplement)[#term]

#let conjblockcolor = rgb(255, 213, 206)
#let conjemphcolor = rgb(233, 66, 66)

#let conjecture-env = make-boxed-theorem("conjecture", "猜想", conjblockcolor, conjemphcolor)
#let conj(term, supplement: none) = conjecture-env(supplement)[#term]

#let egemphcolor = rgb(130, 110, 217)

#let example-env = make-boxed-theorem(
  "example",
  "例",
  white,
  egemphcolor,
  stroke: (y: (paint: egemphcolor, thickness: 1pt, dash: "dashed")),
  inset: (x: 1.2em, y: 1em),
  body-font: kai-fonts,
)
#let eg(term, supplement: none) = example-env(supplement)[#term]

#let thmblockcolor = rgb(209, 255, 226)
#let thmemphcolor = rgb(0, 134, 24)

#let theorem-env = make-companion-theorem("theorem", "定理", thmblockcolor, thmemphcolor)
#let corollary-env = make-companion-theorem("theorem", "推论", thmblockcolor, thmemphcolor)
#let lemma-env = make-companion-theorem("theorem", "引理", thmblockcolor, thmemphcolor)
#let proposition-env = make-companion-theorem("theorem", "命题", thmblockcolor, thmemphcolor)

#let thm(heading, proof: none, supplement: none) = theorem-env(
  supplement,
  companion: proof,
  companion-label: "证明",
  qed: true,
)[#heading]

#let coro(heading, proof: none, supplement: none) = corollary-env(
  supplement,
  companion: proof,
  companion-label: "证明",
  qed: true,
)[#heading]

#let lemma(heading, proof: none, supplement: none) = lemma-env(
  supplement,
  companion: proof,
  companion-label: "证明",
  qed: true,
)[#heading]

#let prop(heading, proof: none, supplement: none) = proposition-env(
  supplement,
  companion: proof,
  companion-label: "证明",
  qed: true,
)[#heading]

#let exemphcolor = rgb(35, 155, 171)
#let exblockcolor = rgb(161, 255, 238)

#let exercise-env = make-companion-theorem("exercise", "习题", exblockcolor, exemphcolor)
#let ex(heading, solution: none, supplement: none) = exercise-env(
  supplement,
  companion: solution,
  companion-label: "解答",
)[#heading]

#let theorem-ref-colors = (
  definition: defemphcolor,
  remark: rmemphcolor,
  conjecture: conjemphcolor,
  example: egemphcolor,
  exercise: exemphcolor,
)
#let theorem-ref-color(identifier) = theorem-ref-colors.at(identifier, default: thmemphcolor)

// 以字体 font 排版 body，并对其中的汉字做缩放和基线偏移，
// 使其字面高度、中线与当前环境的汉字一致（如楷体证明中的黑体引用）。
// 校正量由实测“国”字的墨迹边界得到，因此对任意字体组合都适用。
#let cjk-aligned(body, font: hei-fonts, weight: "bold") = context {
  let probe(..args) = {
    let edge(top, bottom) = measure(text(..args, top-edge: top, bottom-edge: bottom)[国]).height
    (top: edge("bounds", "baseline"), bottom: edge("baseline", "bounds"))
  }
  let host = probe()
  let target = probe(font: font, weight: weight)
  let scale = (host.top + host.bottom) / (target.top + target.bottom)
  // 中线 = (上沿 - 下沿) / 2；baseline 为正时文字下移
  let shift = (target.top - target.bottom) * scale / 2 - (host.top - host.bottom) / 2
  set text(font: font, weight: weight)
  show regex("\p{Han}+"): set text(size: scale * 1em, baseline: shift)
  body
}

#let todo(it) = block(fill: yellow, inset: 4pt, text(red, strong(it)))

#let noindent = h(-2em)

#let endofchapter() = {
  [#pagebreak()]
}

#let makecontent() = [
  #show heading: set align(center)
  #outline(title: [目录])
  #pagebreak()
]

#let conf(doc, chapter_numbering: chinese_numbering) = {
  show: thmrules.with(qed-symbol: $qed$)

  set text(font: song-fonts)
  show emph: set text(font: kai-fonts)
  show strong: set text(font: hei-fonts)
  show raw: set text(font: mono-fonts)

  set par(
    leading: 1em,
    first-line-indent: (amount: 2em, all: true),
  )

  set enum(indent: 2em)
  set list(indent: 2em)

  // 引用标题时只显示编号（如“第一章”“2.1”），不加“节”等前缀
  set heading(numbering: chapter_numbering, supplement: none)
  show heading: set text(font: hei-fonts, weight: "bold")
  show heading: set block(below: 15pt) // 小层级与正文的距离
  show heading.where(level: 1): set block(below: 25pt) // 大层级与正文的距离

  // 定理类引用：编号由 ctheorems 生成，这里只负责字体和着色。
  // 引用用黑体，但汉字按所在段落（正文宋体、证明楷体）校正大小和基线。
  show ref: it => {
    let el = it.element
    if el == none or el.func() != figure or el.kind != "thmenv" {
      return it
    }
    let identifier = query(selector(<meta:thmenvcounter>).after(el.location())).first().value
    set text(fill: theorem-ref-color(identifier))
    cjk-aligned(it)
  }

  show math.equation: set block(breakable: true)

  doc
}
