// /report.typ
// A Report Main Content File

// Import template and metadata
#import "template/lib.typ": *
#import "config/metadata.typ": data

// Show document with report type
#show: document.with(..data, doc-type: "report")

// Content goes here
#include "content/chapter01.typ"
#include "content/chapter02.typ"
#include "content/chapter03.typ"
#include "content/chapter04.typ"
#include "content/chapter05.typ"

// Show appendix
#show: appendix
#include "content/appendixA.typ"

// Show bibliography
#show: bibliography-page
#bibliography("content/bibliography.bib", title: "Tài Liệu Tham Khảo")
