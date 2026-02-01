// /thesis.typ
// A Thesis Main Content File

// Import template and metadata
#import "template/lib.typ": *
#import "config/metadata.typ": data

// Load acronyms
#let acronyms = csv("content/acronyms.csv")

// Show document with thesis type
#show: document.with(..data, acronyms: acronyms, doc-type: "thesis")

// Đặt font cho code ở 0.8 để tiết kiệm không gian.
// TODO: Cập nhật raw text size vào template.
#show raw: set text(size: 0.8em)

// Content goes here
#include "content/chapter01.typ"
#include "content/chapter02.typ"
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
