#import "/themes/stargazer.typ": *
#import "fonts.typ": *

// MARK: Presentation Template
#let presentation(
  title: "",
  subtitle: "",
  author: "",
  date: datetime.today(),
  institution: "",
  body,
) = {
  // Theme Configuration
  show: stargazer-theme.with(
    aspect-ratio: "16-9",
    config-info(
      title: smallcaps(title),
      subtitle: subtitle,
      author: author,
      date: date,
      institution: institution,
    ),
    lang: "vi",
    config-colors(
      primary: rgb("#0778b5"),
      primary-dark: rgb("#004078"),
      secondary: rgb("#ffffff"),
      tertiary: rgb("#6709ea"),
      // Body text color
      neutral-lightest: rgb("#ffffff"),
      neutral-darkest: rgb("#20293F"),
    ),
  )

  // MARK: - Style Customization

  // List: Dùng marker là vòng tròn nhỏ có vòng.
  // TODO: Dùng gradient cho marker.
  set list(
    marker: move(dy: 0.15em, box(circle(radius: 0.2em, stroke: 0.2pt + rgb("#b51d69")))),
    indent: 0.5em,
  )

  // Set font
  set text(font: "Montserrat", weight: "light")

  // Set heading level 2
  show heading.where(level: 2): it => [
    #set align(left)
    #set text(font: "Montserrat", size: 24pt, weight: "regular")
    #block(
      width: 100%,
      stroke: (bottom: 0.5pt + rgb("#808080")),
      inset: (bottom: 0.5em),
      below: 0.8em,
    )[
      #smallcaps[#it.body]
    ]
  ]

  // Set heading level 3
  show heading.where(level: 3): it => [
    #set align(left)
    #set text(font: "Montserrat", size: 20pt, weight: "regular")
    #block(
      width: 100%,
      stroke: (bottom: 0.5pt + rgb("#808080")),
      inset: (bottom: 0.5em),
      below: 0.8em,
    )[
      #smallcaps[#it.body]
    ]
  ]

  // Set heading level 4
  show heading.where(level: 4): it => [
    #set align(left)
    #set text(font: "Montserrat", size: 16pt, weight: "regular")
    #block(
      width: 100%,
      stroke: (bottom: 0.5pt + rgb("#808080")),
      inset: (bottom: 0.5em),
      below: 0.8em,
    )[
      #smallcaps[#it.body]
    ]
  ]

  body
}
