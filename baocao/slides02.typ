// #import "@preview/touying:0.6.1": *
// #import themes.aqua: *
#import "config/metadata.typ": *
#import "themes/aqua.typ": *
#import "template/fonts.typ": *

#show: aqua-theme.with(
  aspect-ratio: "16-9",
  // Thông tin, đề tài
  config-info(
    title: [Dell Data Center Infrastructure],
    subtitle: [Performance, Reliable, & Handy Operation],
    author: [Minh Nguyen - Enterprise Engineer],
    date: "01/2026",
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

#set text(font: body-font, size: 20pt)

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

// List: Dùng marker là vòng tròn nhỏ có vòng.
// TODO: Dùng gradient cho marker.
#set list(
  marker: move(dy: 0.25em, box(circle(radius: 0.2em, stroke: 0.2pt + rgb("#b51d69")))),
  indent: 0.5em,
)

// Set heading level 2
// #show heading.where(level: 2): it => [
//   #set align(left)
//   #set text(font: "Montserrat", size: 24pt, weight: "regular")
//   #block(
//     width: 100%,
//     // stroke: (bottom: 0.5pt + rgb("#808080")),
//     inset: (bottom: 0.5em),
//     below: 0.8em,
//   )[
//     #smallcaps[#it.body]
//   ]
// ]

// Set font
// #set text(font: "Montserrat", weight: "light")
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

= Topology

== A No Single Point Of Failure Environment

#align(center)[
  #image("content/dell/01-topology.png", height: auto)
]

= Server

== PowerEdge R670

#align(center)[
    #table(
        columns: (100%),
        inset: (top: 0.6em, bottom: 0.6em),
        align: (left),
        stroke: (
            bottom: 0.5pt + gradient.linear(red, blue, green),
            top: none,
            left: none,
            right: none,
        ),
        [*2x PowerEdge 760*: #text(fill: orange)[#sym.arrow.t#sym.arrow.t] Performance; #text(fill: orange)[#sym.arrow.b] space, #text(fill: orange)[#sym.arrow.b] power consumption.]
    )
]

#table(
columns: (45%, 55%),
inset: (bottom: 0.6em),
align: (left, left),
stroke: (
    bottom: 0.5pt + gradient.linear(red, blue, green),
    top: none,
    left: none,
    right: none,
),
[- 1U],
[- 2x Xeon 6 6517P (3.2GHz, 16C/32T)],
[- 8x 32GB DDR5 (256GB)],
[- 2x 480GB Enterprise-grade SSDs],
[- 4x 10/25GbE],
[- 2x 32GB FC ports HBA]
)

#image("content/dell/dell-per670.png")

= Storage

== PowerStore - An Enterprise Ready Storage

#align(center)[
    #table(
        columns: (100%),
        inset: (bottom: 0.6em),
        align: (left),
        stroke: (
            bottom: 0.5pt + gradient.linear(red, blue, green),
            top: none,
            left: none,
            right: none,
        ),
        [*2x PowerStore 500T*: Fast and Reliable.]
    )
    #image("content/dell/powerstore-500T.png", height: 29%)
]

#grid(
  columns: (40%, 60%),
  gutter: 0.4em,
  table(
    columns: (100%),
    inset: (bottom: 0.4em),
    align: (left, left),
    stroke: (
        bottom: 0.5pt + gradient.linear(red, blue, green),
        top: none,
        left: none,
        right: none,
    ),
    [- 2U],
    [- 6x 32GB DDR5 (192GB)],
    [- 15x 1.92TB NVMe SSDs],
    [- 4x 10/25GbE],
    [- 4x 32GbE FC ports]
  ),
  table(
  columns: (50%, 30%, 20%),
  inset: (bottom: 0.4em),
  align: (left, right, left),
  stroke: (
      bottom: 0.5pt + gradient.linear(red, blue, green),
      top: none,
      left: none,
      right: none,
  ),
  [- Effective Capacity\*], [32.36], [TB],
  [- Usable Capacity], [20.06], [TB],
  [- Raw Capacity], [28.67], [TB],
  [- Data Reduction], [1.61:1], [],
  [- Total Drive Count], [15], [drives]
  ),
  grid.cell(colspan: 2)[#text(size: 10pt)[\*: Usable capacity is the capacity available after RAID & operation overhead. With a Data Reduction Ratio of 1.61:1, 20.06 TB x 1.61 gives approximately #text(fill: orange)[32.36 TB] of #emph[effective capacity]. This means we can store up to #text(fill: orange)[32.36 TB] of data.]]
)

== PowerStore -- Key Features Overview

#table(
columns: (50%, 50%),
inset: (bottom: 0.4em),
align: (left, left),
stroke: (
    bottom: 0.5pt + gradient.linear(red, blue, green),
    top: none,
    left: none,
    right: none,
),
[- *All-Flash NVMe*], [#emph[ultra-low latency] & #emph[high performance]],
[- *Active-active controllers (A/B)*], [with #emph[load-balanced] data paths],
[- *No downtime upgrades*], [for #emph[both] hardware and software],
[- *Up to 5:1*], [Data Reduction Ratio, more #emph[space]],
[- *Scale-up and scale-out*], [more #emph[flexibility], non-disruptive scaling],
[- *All features included*], [#emph[NO additional licenses] required]
)

#align(center)[
  #image("content/dell/powerstore-500T-02.png", height: 30%)
  #smallcaps[Designed for *99.9999% availability*]
]

== Metro Volume on PowerStore

#table(
columns: (49%, 51%),
inset: (bottom: 0.4em),
align: (center, center),
gutter: 10pt,
stroke: (
    bottom: 0.5pt + gradient.linear(red, blue, green),
    top: none,
    left: none,
    right: none,
),
[*Normal Operation*],
[*Metro Volume 1 Failure*],
)

#align(center)[
  #image("content/dell/powerstore-metro-volumes.png")
]

#grid(
  columns: (100%),
  gutter: 0.4em,
  [#text(size: 0.8em)[- PowerStore Metro Volume provides #emph[active-active], #emph[high-availability] storage across two PowerStore systems.]],
  [#text(size: 0.8em)[- If one PowerStore goes down, the hosts can #emph[still access the volume from the other system].]]
)

= Data Protection

= Operation

== Centralized Monitoring with Dell AIOps

== Licenses & Services

// #include "content/outline.typ"

// #outline-slide()

// = The Section

// == Slide Title

// #lorem(40)

// #focus-slide[
//   Another variant with primary color in background...
// ]

== Thank You

#slide(self => [
  #align(center + horizon)[
    #text(size: 3em, weight: "bold", fill: self.colors.primary)[Xin Cảm Ơn!]
    #line(length: 30%, stroke: 0.5pt + gradient.linear(red, blue, green))
    #text(size: 2em, weight: "bold", fill: self.colors.primary)[Q&A?]
  ]
])
