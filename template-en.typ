#import "@preview/ctheorems:1.1.3": *

#let theorem-font = ("Times New Roman")

#let is_in_appendix = state("is_in_appendix", false)

#let make-boxed-theorem(
    identifier,
    heading,
    blockcolor,
    emphcolor,
    border: none,
    stroke: none,
    inset: (x: 1.2em, y: 0.8em),
    base: context if is_in_appendix.get() {"appendix"} else {"heading"},
    base_level: 1,
) = thmbox(
    identifier,
    heading,
    fill: blockcolor,
    stroke: if stroke == none {
        if border == none { blockcolor } else { border }
    } else {
        stroke
    },
    radius: 0pt,
    inset: inset,
    breakable: true,
    base: base,
    base_level: base_level,
    supplement: heading,
    padding: (top: 0.45em, bottom: 0.45em),
    separator: [#h(0.5em)],
    titlefmt: title => text(font: theorem-font, weight: "bold", emphcolor)[#title],
    namefmt: name => text(font: theorem-font, weight: "bold", emphcolor)[(#name)],
    bodyfmt: body => [
        #set text(font: theorem-font)
        #set list(marker: (text(emphcolor)[•]))
        #set enum(numbering: n => text(emphcolor)[#n.])
        #body
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
    (name, number, body, companion: none, companion-label: "Pf.", qed: false) => {
        let title = heading
        if number != none {
            title += " " + number
        }

        pad(top: 0.45em, bottom: 0.45em)[
            #block(
                width: 100%,
                stroke: blockcolor + 2pt,
                radius: 0pt,
                inset: 0pt,
                breakable: true,
            )[
                #stack(dir: ttb, spacing: 0pt,
                    block(width: 100%, fill: blockcolor, inset: (x: 1.2em, y: 0.8em), breakable: true)[
                        #set text(font: theorem-font)
                        #set list(marker: (text(emphcolor)[•]))
                        #set enum(numbering: n => text(emphcolor)[#n.])
                        #text(font: theorem-font, weight: "bold", emphcolor)[#title]
                        #if name != none [
                            #text(font: theorem-font, weight: "bold", emphcolor)[(#name)]
                        ]
                        #h(0.5em)
                        #body
                    ],
                    if companion != none {
                        block(width: 100%, fill: white, inset: (x: 1.2em, y: 0.8em), breakable: true)[
                            #set text(font: theorem-font)
                            #set list(marker: (strong[•]))
                            #set enum(numbering: n => text(emphcolor)[#n.])
                            #text(emphcolor, weight: "bold")[#companion-label]
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

// 以下是一些预定义的环境块
#let defcounter = counter("def")
#let defblockcolor = rgb(220, 227, 248)
#let defemphcolor = rgb(31, 119, 184)

#let definition-env = make-boxed-theorem("definition", "Definition", defblockcolor, defemphcolor)
#let def(term, supplement: none, counter: defcounter) = definition-env(supplement)[#term]

#let rmcounter = counter("rm")
#let rmblockcolor = rgb(255, 237, 193)
#let rmemphcolor = rgb(215, 94, 106)

#let remark-env = make-boxed-theorem("remark", "Remark", rmblockcolor, rmemphcolor)
#let rm(term, supplement: none, counter: rmcounter) = remark-env(supplement)[#term]

#let conjcounter = counter("conj")
#let conjblockcolor = rgb(255, 213, 206)
#let conjemphcolor = rgb(233, 66, 66)

#let conjecture-env = make-boxed-theorem("conjecture", "Conjecture", conjblockcolor, conjemphcolor)
#let conj(term, supplement: none, counter: conjcounter) = conjecture-env(supplement)[#term]

#let egcounter = counter("eg")
#let egemphcolor = rgb(130, 110, 217)

#let example-env = make-boxed-theorem(
    "example",
    "Example",
    white,
    egemphcolor,
    stroke: (paint: egemphcolor, thickness: 2pt, dash: "dashed"),
    inset: (x: 1.2em, y: 1em),
)
#let eg(term, supplement: none, counter: egcounter) = example-env(supplement)[#term]

#let thmcounter = counter("thm")
#let thmblockcolor = rgb(209, 255, 226)
#let thmemphcolor = rgb(0, 134, 24)

#let theorem-env = make-companion-theorem("theorem", "Theorem", thmblockcolor, thmemphcolor)
#let corollary-env = make-companion-theorem("theorem", "Corollary", thmblockcolor, thmemphcolor)
#let lemma-env = make-companion-theorem("theorem", "Lemma", thmblockcolor, thmemphcolor)

#let thm(heading, proof: none, supplement: none) = theorem-env(
    supplement,
    companion: proof,
    companion-label: "Pf.",
    qed: true,
)[#heading]

#let coro(heading, proof: none, supplement: none) = corollary-env(
    supplement,
    companion: proof,
    companion-label: "Pf.",
    qed: true,
)[#heading]

#let lemma(heading, proof: none, supplement: none) = lemma-env(
    supplement,
    companion: proof,
    companion-label: "Pf.",
    qed: true,
)[#heading]

#let excounter = counter("ex")
#let exemphcolor = rgb(35, 155, 171)
#let exblockcolor = rgb(161, 255, 238)

#let exercise-env = make-companion-theorem("exercise", "Exercise", exblockcolor, exemphcolor)
#let ex(heading, solution: none, supplement: none) = exercise-env(
    supplement,
    companion: solution,
    companion-label: "Sol.",
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

#let conf(doc, chapter_numbering: chapter_numbering) = {
    show: thmrules.with(qed-symbol: $qed$)
    set heading(
        numbering: chapter_numbering
    )

    set page(
        number-align: bottom + right,
        numbering: "1"
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
                    font: theorem-font,
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

#let appendices_counter = counter("appendix")

#let set-appendix(doc) = {
    is_in_appendix.update(true)
    
    appendices_counter.update(0)
    counter(heading).update(0)

    set heading(
        numbering: appendix_numbering
    )

    doc
}
