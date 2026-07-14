#import "@preview/ctheorems:1.1.3": *

#let theorem-title-font = ("Times New Roman", "Heiti SC")
#let theorem-companion-font = ("Times New Roman", "Kaiti SC")

#let make-boxed-theorem(
  identifier,
  heading,
  blockcolor,
  emphcolor,
  stroke: none,
  inset: (x: 1.2em, y: 0.8em),
  body-font: none,
  base: none,
  base_level: none,
) = thmbox(
  identifier,
  heading,
  width: 95%,
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
  titlefmt: title => text(font: theorem-title-font, emphcolor)[#title],
  namefmt: name => text(font: theorem-title-font, emphcolor)[（#name）],
  bodyfmt: body => [
    #if body-font != none {
      set text(font: body-font, style: "normal")
    }
    #set list(marker: (text(emphcolor)[•]))
    #set enum(numbering: n => text(emphcolor)[#n])
    #body
  ],
)

#let make-companion-theorem(
  identifier,
  heading,
  blockcolor,
  emphcolor,
  base: none,
  base_level: none,
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
        width: 95%,
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
            #text(font: theorem-title-font, emphcolor)[#title]
            #if name != none [
              #text(font: theorem-title-font, emphcolor)[（#name）]
            ]
            #h(0.5em)
            #body
          ],
          if companion != none {
            block(width: 100%, fill: white, inset: (x: 1.2em, y: 0.8em), breakable: true)[
              #set text(font: theorem-companion-font, style: "normal")
              #set list(marker: (strong[•]))
              #text(emphcolor)[#companion-label]
              #h(0.5em)
              #companion
              #if qed [
                #h(1fr)#sym.qed
              ]
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
    #set text(font: ("Times New Roman", "Songti SC"))
    #set par(first-line-indent: 2em)
    #show par: set block(spacing: 0.65em)
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
#let def(term, supplement: none, counter: none) = definition-env(supplement)[#term]

#let rmblockcolor = rgb(255, 237, 193)
#let rmemphcolor = rgb(215, 94, 106)

#let remark-env = make-boxed-theorem("remark", "注记", rmblockcolor, rmemphcolor)
#let rm(term, supplement: none, counter: none) = remark-env(supplement)[#term]

#let conjblockcolor = rgb(255, 213, 206)
#let conjemphcolor = rgb(233, 66, 66)

#let conjecture-env = make-boxed-theorem("conjecture", "猜想", conjblockcolor, conjemphcolor)
#let conj(term, supplement: none, counter: none) = conjecture-env(supplement)[#term]

#let egemphcolor = rgb(130, 110, 217)

#let example-env = make-boxed-theorem(
  "example",
  "例",
  white,
  egemphcolor,
  stroke: (paint: egemphcolor, thickness: 2pt, dash: "dashed"),
  inset: (x: 1.2em, y: 1em),
  body-font: theorem-companion-font,
)
#let eg(term, supplement: none, counter: none) = example-env(supplement)[#term]

#let thmblockcolor = rgb(209, 255, 226)
#let thmemphcolor = rgb(0, 134, 24)

#let theorem-env = make-companion-theorem("theorem", "定理", thmblockcolor, thmemphcolor)
#let corollary-env = make-companion-theorem("theorem", "推论", thmblockcolor, thmemphcolor)
#let lemma-env = make-companion-theorem("theorem", "引理", thmblockcolor, thmemphcolor)

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

#let exemphcolor = rgb(35, 155, 171)
#let exblockcolor = rgb(161, 255, 238)

#let exercise-env = make-companion-theorem("exercise", "习题", exblockcolor, exemphcolor)
#let ex(heading, solution: none, supplement: none) = exercise-env(
  supplement,
  companion: solution,
  companion-label: "解答",
)[#heading]

#let theorem-ref-color(identifier) = if identifier == "definition" {
  defemphcolor
} else if identifier == "remark" {
  rmemphcolor
} else if identifier == "conjecture" {
  conjemphcolor
} else if identifier == "example" {
  egemphcolor
} else if identifier == "exercise" {
  exemphcolor
} else {
  thmemphcolor
}

#let endofchapter() = {
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
  show: thmrules.with(qed-symbol: $qed$)

  set text(
    font: ("Times New Roman", "Songti SC"),
  )

  show emph: set text(
    font: ("Times New Roman", "Kaiti SC"),
    style: "italic",
  )

  show strong: set text(
    font: ("Times New Roman", "Heiti SC"),
    weight: "bold",
  )

  show raw: set text(
    font: ("JetBrainsMono NF", "Menlo", "DejaVu Sans Mono"),
  )

  set enum(
    indent: 2em,
  )

  set list(
    indent: 2em,
  )

  show ref: it => {
    let el = it.element
    if el != none and el.func() == figure and el.kind == "thmenv" {
      let supplement = el.supplement
      if it.citation.supplement != none {
        supplement = it.citation.supplement
      }

      let loc = el.location()
      let thms = query(selector(<meta:thmenvcounter>).after(loc))
      let identifier = thms.first().value
      let number = thmcounters.at(thms.first().location()).at("latest")
      let refbody = [#supplement~#numbering(el.numbering, ..number)]
      link(
        it.target,
        text(
          font: theorem-title-font,
          weight: "bold",
          theorem-ref-color(identifier),
          refbody,
        ),
      )
    } else {
      it
    }
  }

  doc
}
