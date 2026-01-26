// /thesis.typ
// A Thesis Main Content File

// Import template and metadata
#import "template/lib.typ": *
#import "config/metadata.typ": data

// Load acronyms
#let acronyms = csv("content/acronyms.csv")

// Show document with thesis type
#show: document.with(..data, acronyms: acronyms, doc-type: "thesis")

// Content goes here
#include "content/tasks.typ"
#include "content/chapter01.typ"
#include "content/chapter02.typ"
#include "content/chapter03.typ"
#include "content/chapter04.typ"
#include "content/chapter05.typ"

// Show appendix
#show: appendix
#include "content/appendixA.typ"
#include "content/appendixB.typ"

// Show bibliography
#show: bibliography-page
#bibliography("content/bibliography.bib", title: "Tài Liệu Tham Khảo")
