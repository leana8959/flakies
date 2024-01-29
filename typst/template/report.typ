#import "@preview/big-todo:0.2.0" :  todo
#import "@preview/sourcerer:0.2.1":  code

#let conf(
  title  : "Hello World",
  author : "Léana CHIANG",
  lang   : "fr",
  doc
) = {
  assert(title != none,  message: "Must set title key")
  assert(author != none, message: "Must set author key")

  //////////////
  // Settings //
  //////////////
  set document(title: title, author: author)
  set page(
    header: locate(loc => {
      if loc.page() != 1 {
        set align(right)
        underline(if author != "" [#title - #author] else [#title])
      }
    }),
    numbering: "1 / 1",
    number-align: right,
  )
  set par(justify: true)
  set text(size: 13pt, lang: lang)
  set page(margin: (x: 40pt, y: 40pt))

  // heading numbering
  set heading(numbering: "I.1")

  // // Trailing numbering
  // show heading: it => [ #it.body #counter(heading).display()\ ]

  // // Dashed numbering
  // show heading: it => [ #counter(heading).display() - #it.body\ ]

  show ref: it => underline(emph(it))
  show link: it => underline(emph(it))

  // Highlight IPs
  show regex("((25[0-5]|(2[0-4]|1\d|[1-9]|)\d)\.?\b){4}"): it => {
    underline(text(fill: blue.lighten(20%), it))
  }

  show raw.where(block: true): block.with(
    fill      : white.darken(2%),
    radius    : 5pt,
    stroke    : 1pt + white.darken(25%),
    inset     : 5pt,
    width     : 100%,
    breakable : true,
  )

  ///////////////////////////////////
  // The actual document goes here //
  ///////////////////////////////////

  // Header
  [
    #set align(center)
    #text(22pt)[*#title*]\
    #text(13pt)[#author]
    #v(20pt)
  ]

  // Document
  doc
}
