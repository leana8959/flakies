#let conf(
    title      : none,
    author     : none,
    lang       : none,
    sender     : none,
    receipient : none,
    place      : none,
    ps         : none,
    doc,
) = {
    // Settings
    set document(title: title, author: author)
    set par(justify: true)
    set text(size: 14pt, lang: lang, font: "Latin Modern Roman")
    // set text(size: 14pt, lang: lang, font: "Sans Forgetica") // For proofreading

    show link: it => underline(text(style: "italic", fill: rgb("#4E7BD6"), it))

    // Sender / receiver
    {
        let date = datetime.today().display("[day]/[month]/[year]")
        set text(size: 12pt)
        stack(
            stack(dir: ltr, sender, align(right + horizon, place + ", " + date)),
            v(10%),
            align(right, block(receipient)),
        )
    }

    v(10%)

    // Header
    {
        set align(center)
        text(font:"Latin Modern Roman Caps")[*Objet: #title*]
        v(2%)
    }

    // Document
    doc

    // Signature
    v(5%)
    align(right, text(size: 14pt, author))
    v(5%)

    // ps
    ps
}
