// #import "@preview/touying:0.6.1": *
// #import themes.aqua: *
#import "config/metadata.typ": *
#import "themes/aqua.typ": *

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

// Set font
#set text(font: "Montserrat", weight: "light")
  // Set heading level 3
  #show heading.where(level: 3): it => [
    #set align(left)
    #set text(font: "Montserrat", size: 20pt, weight: "regular")
    #block(
      width: 100%,
      // stroke: (bottom: 0.5pt + rgb("#808080")),
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
    THANK YOU.
  ]
])
