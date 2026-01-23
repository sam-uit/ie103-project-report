#import "template/libslides.typ": *
#import "config/metadata.typ": *
#import "@preview/numbly:0.1.0": numbly

#show: presentation.with(
  title: data.assignment.title,
  subtitle: data.assignment.subtitle,
  author: data.author.name,
  date: datetime.today(),
  institution: data.course.name,
)

// MARK: - Title Slide
#title-slide()

// Unordered List of Content
// #outline-slide()

// MARK: - Nội Dung Chính
#include "content/contents.typ"

// MARK: - Kết Thúc

= Q&A

#focus-slide[
  #smallcaps(lorem(10))
]

#ending-slide(title: [Thank You!])[Questions?]
