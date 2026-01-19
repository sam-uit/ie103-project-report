// MARR: imports

#import "template/lib.typ": *
#import "config/metadata.typ": *

// MARK: Document Settings
#set document(
  title: data.assignment.title,
  author: data.author.name,
  description: data.assignment.subtitle,
  keywords: (data.course.id, data.course.name),
  date: datetime.today(),
)

// MARK: THE TARGET for BACK TO TOP
#metadata("top") <top>

// MARK: The Template Details Page
#show: university-assignment.with(
  university: data.university,
  course: data.course,
  author: data.author,
  instructor: data.instructor,
  assignment: data.assignment,
)

// MARK: Callouts Examples
// Feel free to remove this section if not needed

#include "template/callout-examples.typ"

#pagebreak()

// MARK: AUTHOR INFO
#include "author/author.typ"

#pagebreak()

// IMPORTANT Switch page number style and reset its counter
#set page(numbering: "1")
#counter(page).update(1)

// MARK: MAIN CONTENT
// Page break between chapters

#include "content/quiz1.typ"

#pagebreak()
#include "content/quiz2.typ"

#pagebreak()
#include "content/quiz3.typ"

#pagebreak()
#include "content/quiz4.typ"

// Appendix

#pagebreak()
#include "content/appendixA.typ"

#pagebreak()
#include "content/appendixB.typ"

// Bibliography
#pagebreak()
#include "content/bibliography.typ"

// THE END
