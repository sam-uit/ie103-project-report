// #import "@preview/touying:0.6.1": *
// #import themes.aqua: *
#import "config/metadata.typ": *
#import "themes/aqua.typ": *
#import "template/fonts.typ": *

#show: aqua-theme.with(
  aspect-ratio: "16-9",
  // Thông tin, đề tài
  config-info(
    title: [BÁO CÁO ĐỒ ÁN],
    subtitle: [HỆ THỐNG QUẢN LÝ ĐẶT PHÒNG],
    author: [NHÓM 02],
    date: "Tháng 01, 2026",
    institution: [TRƯỜNG ĐẠI HỌC CÔNG NGHỆ THÔNG TIN],
  ),
  // Màu sắc, theming
  config-colors(
    primary: rgb("#003F88"),
    primary-light: rgb("#2159A5"),
    primary-lightest: rgb("#F2F4F8"),
    neutral-lightest: rgb("#FFFFFF"),
  ),
)

// Block code style with Line Numbering
#show raw.where(block: true): it => align(start)[
  #block(
    radius: 8pt,
    fill: luma(240),
    inset: 0pt,
    stroke: none,
    breakable: false,
    width: 100%,
    clip: true,
  )[
    #text(font: code-font, size: 1em)[
      #grid(
        columns: (auto, 1fr),
        inset: (x, y) => {
          let v = 1em
          let inner = 0.5em
          let outer = 1.5em
          if x == 0 { (top: v, bottom: v, left: outer, right: inner) } else {
            (top: v, bottom: v, left: inner, right: outer)
          }
        },
        stroke: (x, y) => if x == 0 { (right: 1pt + luma(300)) } else { none },
        align: (right, left),
        // Line number column
        align(right, text(fill: gray)[
          #for i in range(1, it.text.split("\n").len() + 1) [ #i \ ]
        ]),
        // Code content column
        it,
      )
    ]
  ]
]

// #set text(font: "Lora")

// List: Dùng marker là vòng tròn nhỏ có vòng.
// TODO: Dùng gradient cho marker.
#set list(
  marker: move(dy: 0.15em, box(circle(radius: 0.2em, stroke: 0.2pt + rgb("#b51d69")))),
  indent: 0.5em,
)

// Set heading level 2
#show heading.where(level: 2): it => [
  #set align(left)
  #set text(font: "Montserrat", size: 24pt, weight: "regular")
  #block(
    width: 100%,
    // stroke: (bottom: 0.5pt + rgb("#808080")),
    inset: (bottom: 0.5em),
    below: 0.8em,
  )[
    #smallcaps[#it.body]
  ]
]

// Set font
#set text(font: "Montserrat", weight: "light")
  // Set heading level 3
  #show heading.where(level: 3): it => [
    #set align(left)
    #set text(font: "Montserrat", size: 18pt, weight: "regular")
    #block(
      // width: 100%,
      stroke: (bottom: 0.5pt + rgb("#808080")),
      inset: (bottom: 0.5em),
      below: 0.8em,
    )[
      #smallcaps[#it.body]
    ]
  ]

#title-slide()

#include "content/outline.typ"

// #outline-slide()

// = The Section

// == Slide Title

// #lorem(40)

// #focus-slide[
//   Another variant with primary color in background...
// ]

== Cảm Ơn

#slide(self => [
  #align(center + horizon)[
    #set text(size: 3em, weight: "bold", fill: self.colors.primary)
    Xin Cảm Ơn!
  ]
])
