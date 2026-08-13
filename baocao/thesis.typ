// /thesis.typ
// A Thesis Main Content File

// Import template and metadata
#import "template/lib.typ": *

// TODO: Use YAML instead of Typst code
// #import "config/metadata.typ": data
#let properties = yaml("config/config.yaml")

// document metada
#let metadata = properties.at("metadata")
#let university = metadata.at("university")
#let course = metadata.at("course")
#let instructor = metadata.at("instructor")
#let author = metadata.at("author")
#let assignment = metadata.at("assignment")

// Load acronyms
#let acronyms = csv("content/acronyms.csv")

// Show document with thesis type
#show: document.with(
    university: university,
    course: course,
    instructor: instructor,
    author: author,
    assignment: assignment,
    acronyms: acronyms,
    doc-type: "thesis",
    preamble: (
        summary: false,
        acknowledgement: true,
        comment: true,
        forewords: true
    )
)

// Đặt font cho code ở 0.8 để tiết kiệm không gian.
// TODO: Cập nhật raw text size vào template.
#show raw: set text(size: 0.8em)

// Content goes here
#include "content/chapter01.typ"
#include "content/chapter02.typ"
#include "content/chapter02-01-chucnangnghiepvu.typ"
#include "content/chapter02-02-quytacnghiepvu.typ"
#include "content/chapter02-03-mohinhquanniem.typ"
#include "content/chapter02-04-mohinhlogic.typ"
#include "content/chapter02-05-ketluan.typ"
#include "content/chapter03.typ"
#include "content/chapter04.typ"
#include "content/chapter04-01-xulythongtin.typ"
#include "content/chapter04-02-antoanthongtin.typ"
#include "content/chapter04-03-trinhbaythongtin.typ"
#include "content/chapter04-04-chucnangcuahethong.typ"
#include "content/chapter05.typ"

// Show appendix
#show: appendix
#include "content/appendixA.typ"
#include "content/appendixB.typ"

// Show bibliography
#show: bibliography-page
#bibliography("content/bibliography.yaml", title: "Tài Liệu Tham Khảo", style: "ieee")
