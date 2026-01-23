# University Report & Thesis Template

Đây là một template để tạo báo cáo và luận án, slides cho Trường Đại Học Công Nghệ Thông Tin TP. Hồ Chí Minh. Định dạng là [Typst](https://typst.app/).

# CẢNH BÁO

> [!WARNING]
> - **KHÔNG** bao giờ merge các branch báo cáo: `report-xxx`, `report/xxx`, vv.. vào `main`.
> - Chỉ merge các branch về chức năng: `feat/xxx`, `fix/xxx`, vv.. vào `main`.

## Tại Sao Cần Template Này?

- Nhất quán trong typography (fonts, size, heading, vv..), style (màu sắc), bố cục cho toàn bộ văn bản.
- Khả năng hợp tác giữa nhiều thành viên, vì các file nội dung được chia nhỏ.
- Git-friendly, lưu trữ, theo dõi phiên bản và thay đổi với git.
- Tự động tạo Table of Contents, List of Figures, List of Tables, và hơn thế.
- Phù hợp cho một văn bản chuyên nghiệp, đặc biệt là academic.
- Phương châm: *Code as XXX*, *XXX* ở đây là báo cáo, slides, luận án.

## Tại Sao Lại Là Typst?

- Nhanh, cực kỳ nhanh.
- Đơn giản, dễ dùng, nhẹ nhàng hơn $LaTeX$/$TeX$.
- Nhất quán, nhanh nhẹ hơn bất kỳ word processor nào (Google Docs, Microsoft Word).

## Các Ví Dụ

- [`report.pdf`](report.pdf): Báo cáo.
- [`thesis.pdf`](thesis.pdf): Luận án.
- [`slides.pdf`](slides.pdf): Slides.

## Hướng Dẫn Nhanh

Cách dùng:

1. Clone/Fork repo này.
2. Tạo 1 branch mới tương ứng, ví dụ `IE103-BTTH5`.
3. Sửa file `config/metadata.typ` để thay đổi thông tin của báo cáo.
4. Sửa file `author/author.typ` để thay đổi thông tin của tác giả/nhóm.
5. Bắt đầu thêm nội dung tại `content/`.
6. Chạy `make watch` để xem thay đổi.

Lưu ý:

- Fonts cần dùng được lưu tại `template/fonts/`.
- Biên dịch với fonts (nếu chưa cài đặt trên máy):

```bash
typst compile report.typ --font-path template/fonts
```

Yêu cầu:

- Typst: [https://typst.app/](https://typst.app/)
- Pandoc: [https://pandoc.org](https://pandoc.org)
- `entr`: `brew install entr`
- `make`: Pre-installed by default (mostly).

## Resources

- [Thesis Structure - AthenaCheck](https://athenacheck.nl/en/knowledge-base/writing/thesis-structure/thesis-structure)

## Cách Tổ Chức

- `template`:
    - Chứa các file template chính.
    - `fonts.typ`: Định nghĩa các font.
    - `utils.typ`: Các hàm helper.
    - `components/`: Các component UI.
    - `libs.typ`: File chính để lắp ráp các component.
    - `libreport.typ`, `libthesis.typ`, `libslides.typ`: Template chính cho các loại file tương ứng.
- `report.typ`, `thesis.typ`, `slides.typ`: File chính để biên dịch.
- `author/`: Chứa thông tin tác giả.
- `config/`: Chứa thông tin cấu hình.
    - `metadata.typ`: Thông tin báo cáo.
- `content/`: Chứa các file nội dung.
    - `content/assets`: Chứa các file tĩnh cho nội dung: `.png`, `.svg`, vv..
    - `content/diagrams` (Code as Diagrams): Thư mục chứa các đồ họa, đồ thị đặc trưng cho nội dung.

## Features

*   **Modular Design**: Content, metadata, and styling are separated.
*   **Professional Layout**: Rounded tables, clean typography, code blocks with line numbers and vertical separators.
*   **Automated Elements**: auto-generated Table of Contents, List of Figures, List of Tables.
*   **Makefile Support**:
    *   `make`: Compiles the project.
    *   `make watch`: Live updates.
    *   `make clean`: Cleans up generated files.
    *   (Optional) Auto-converts `content/*.md` to `.typ` if you prefer writing Markdown.

## Requirements

### Fonts

- Please refer to the [template/fonts.typ](template/fonts.typ) for a list of required fonts.
- Font types:
    - Sans: Montserrat, Google Sans, etc.
    - Serif: Lora, Source Serif, etc.
    - Mono: Iosevka, Fira Code, etc.
- Font paths:
    - Sans: `template/fonts/`
    - Serif: `template/fonts/`
    - Mono: `template/fonts/`

```bash
typst compile report.typ --font-path template/fonts
typst compile thesis.typ --font-path template/fonts
typst compile slides.typ --font-path template/fonts
```

### Tools

- Typst: [https://typst.app/](https://typst.app/)
- Pandoc: [https://pandoc.org](https://pandoc.org)
- `entr`: `brew install entr`
- `make`: Pre-installed by default (mostly).

## Slides

### Color Palettes

- Thay đổi và thêm bảng màu tại: [`template/libslides.typ`](template/libslides.typ).
    - `config-colors`

```rust
    config-colors(
      primary: rgb("#6C5CE7"), // Màu chính, nơi hiện các heading (góc trên - trái).
      primary-dark: rgb("#4834D4"), // Màu chính đậm hơn, của header và 2 ô bên trái trái footer.
      secondary: rgb("#ffffff"),
      tertiary: rgb("#55EFC4"), // Màu được blend/gradient từ màu chính ở trên dần sang phải.
      neutral-lightest: rgb("#ffffff"), // Màu chữ.
      neutral-darkest: rgb("#2D3436"), // Màu của header và 2 ô bên trái footer.
    ),
```

#### Future Tech

```rust
    config-colors(
      primary: rgb("#2d73be"),        // Azure Blue - Sáng, năng động
      primary-dark: rgb("#0051A8"),   // Darker Blue - Dùng cho điểm nhấn
      secondary: rgb("#ffffff"),
      tertiary: rgb("#05807a"),       // Teal/Cyan - Tạo gradient rất đẹp với màu Blue
      neutral-lightest: rgb("#ffffff"),
      neutral-darkest: rgb("#2c3e50"), // Midnight Blue nhạt
    ),
```

#### Eco Smart

```rust
    config-colors(
      primary: rgb("#009688"),        // Persian Green - Điềm đạm
      primary-dark: rgb("#004D40"),
      secondary: rgb("#ffffff"),
      tertiary: rgb("#8BC34A"),       // Light Green - Tạo sự tươi mới
      neutral-lightest: rgb("#ffffff"),
      neutral-darkest: rgb("#455A64"), // Blue Grey - Nhẹ nhàng hơn màu đen
    ),
```

#### Neural Network

- Style của Gemini.

```rust
    config-colors(
      primary: rgb("#6c0ef0"),        // Deep Purple - Đậm nhưng tươi
      primary-dark: rgb("#3700B3"),
      secondary: rgb("#ffffff"),
      tertiary: rgb("#e53087"),       // Pink Accent - Tạo gradient tím-hồng rất modern
      neutral-lightest: rgb("#ffffff"),
      neutral-darkest: rgb("#1a1a1a"), // Gần như đen, tạo độ sâu mà không bị ám màu xanh
    ),
```

#### Classic Academic

```rust
    config-colors(
      primary: rgb("#1454de"),
      primary-dark: rgb("#004078"),
      secondary: rgb("#ffffff"),
      tertiary: rgb("#8b3de5"),
      // Body text color
      neutral-lightest: rgb("#ffffff"),
      neutral-darkest: rgb("#1e1180"),
    ),
```

#### Unamed

```rust
    config-colors(
      primary: rgb("#1d7c92"),
      primary-dark: rgb("#093c48"),
      secondary: rgb("#FFE2AF"),
      tertiary: rgb("#FFE2AF"),
      // Body text color
      neutral-lightest: rgb("#ffffff"),
      neutral-darkest: rgb("#023855"),
    ),
```
