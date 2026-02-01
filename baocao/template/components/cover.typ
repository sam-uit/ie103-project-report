#import "/template/fonts.typ": *
#import "/template/utils.typ": static

// MARK: Cover Page
// Khai báo một macro để tạo trang bìa
#let cover-page(
  university: (:),
  assignment: (:),
  course: (:),
  instructor: "",
  author: (:),
  // Chỉ định đường dẫn trực tiếp, hoặc pass university.logo
  // logo-path: none,
  logo_image: "🏛️",
) = {
  align(center)[
    // MARK: University Name
    #if university.name != "" [
      #text(font: heading-font, size: 18pt, weight: "regular", fill: black.lighten(50%))[#upper(university.name)] \
      #v(0.2em)
    ]
    #if university.college != "" [
      #text(font: heading-font, size: 18pt, weight: "regular", fill: black.lighten(50%))[#upper(university.college)] \
      #v(0.2em)
    ]
    // #if university.center != "" [
    //   #text(font: heading-font, size: 16pt, weight: "regular", fill: black.lighten(50%))[#upper(university.center)] \
    //   #v(0.2em)
    // ]
    #if university.faculty != "" [
      #text(font: heading-font, size: 16pt, weight: "regular", fill: black.lighten(50%))[#upper(university.faculty)] \
      #v(0.2em)
    ]

    #block(
      width: 80%,
      stroke: (bottom: 0.5pt + gradient.linear(red, blue, angle: 45deg)),
      inset: (bottom: 0.5em),
    )

    // MARK: University Logo
    #v(0.3em)
    #stack(
      dir: ltr,
      spacing: 1em,
      // Nếu logo được chỉ định, sử dụng giá trị đó
      if university.keys().contains("logo") and university.logo != "" {
        image(static(university.logo), width: 5cm)
        // Nếu không thì sử dụng logo mặc định
      } else {
        box(height: 3cm, width: 3cm, stroke: 0.5pt + black.lighten(90%), radius: 50%, fill: none)[
          #align(center + horizon)[
            #text(size: 40pt, fill: black.lighten(80%))[#logo_image]
          ]
        ]
      },
    )
    #v(1em)

    // MARK: Title
    // Sử dụng block để tạo khung cho title và subtitle
    // Stroke: chỉ hiển thị ở phía trên và dưới
    #block(
      radius: 2pt,
      inset: (left: 2em, right: 2em, top: 4em, bottom: 4em),
      stroke: (
        bottom: 2pt + gradient.linear(teal, blue, angle: 45deg),
        // left: 2pt + gradient.linear(teal, blue, angle: 45deg),
        // right: 2pt + gradient.linear(teal, blue, angle: 45deg),
        top: 2pt + gradient.linear(teal, blue, angle: 45deg),
      ),
      width: 100%,
    )[
      #stack(
        dir: ttb,
        spacing: 2em, // Khoảng cách (vspace) giữa title và subtitle
        text(font: heading-font, size: 20pt, weight: "regular")[
          #smallcaps[#assignment.title]
        ],
        if assignment.subtitle != none and assignment.subtitle != "" {
          text(font: heading-font, size: 28pt, weight: "regular")[
            #assignment.subtitle
          ]
        },
      )
    ]
  ]

  // Thêm khoảng trống (vspace) giữa title và summary box
  v(4em)

  // MARK: Summary Box
  block(
    radius: 8pt,
    fill: rgb(248, 250, 252),
    stroke: 1pt + gradient.linear(teal, blue, angle: 45deg),
    inset: 1.5em,
    width: 100%,
  )[
    #grid(
      // Cố tình để lệch sang trái để tạo cảm giác cân bằng
      // Cột trái chiếm 40% chiều rộng, cột phải chiếm 60% chiều rộng
      columns: (40%, 60%),
      // Khoảng cách giữa các cột là 1em
      column-gutter: 1em,
      // Khoảng cách giữa các hàng là 1em
      row-gutter: 1em,
      // Căn chỉnh các cột là right (trái căn phải) và left (phải căn trái)
      align: (right, left),
      // Cột bên trái chứa danh sách thông tin
      [
        #list(
          marker: none,
          [Mã Môn:],
          [Tên Môn:],
          [Lớp:],
          [Giảng Viên:],
          [Thực Hiện:],
        )
      ],
      // Cột bên phải chứa giá trị
      [
        #list(
          marker: none,
          [#course.id],
          [#course.name],
          [#course.class],
          [#instructor],
          [#author.name],
        )
      ],
    )

    #v(2em)

    // MARK: Place & Date
    // Hiển thị Ngày tháng và Nơi thực hiện
    // Mặc định là today()
    #align(center)[
      #assignment.date
    ]
    #v(0.8em)
  ]
}
