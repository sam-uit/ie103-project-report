# University Report & Thesis Template

This is a Typst template for university reports and thesis, refactored to a modular, professional book-like structure.

# Hướng Dẫn Nhanh

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

## Example

*   Please take a look at the example: [main.pdf](main.pdf).

## Usage

1.  **Clone/Copy** this directory.
2.  **Edit Metadata**: Open `metadata.typ` and key in your report's details (University, Course, Author, Assignment).
3.  **Edit Content**:
    *   Add your chapters/sections in the `content/` directory.
    *   You can use `.typ` files directly or `.md` files (which `make` will convert for you).
4.  **Edit Main**:
    *   Open `main.typ`.
    *   Include your new content files from the `content/` folder.
5.  **Compile**:
    *   Run `make` to build `main.pdf`.
    *   Run `make watch` to watch for changes and rebuild automatically.

## Structure

```
.
├── report.typ              # The REPORT format (edit this to assemble the report)
├── thesis.typ              # The THESIS format (edit this to assemble the thesis)
├── slides.typ              # The SLIDES format (edit this to assemble the slides)
├── metadata.typ            # Project metadata (formerly data.typ) - Edit this first!
├── assets/                 # Global assets (images, logos)
├── content/                # Content chapters/sections
│   ├── author.typ          # Author information
│   ├── quiz1.typ
│   └── ...
└── template/               # The template logic (formerly libs)
    ├── lib.typ             # Main template entry point & layout definition
    ├── fonts.typ           # Font definitions
    ├── utils.typ           # Helper functions (unheading, etc.)
    └── components/         # UI Components
        ├── callout.typ     # Callout boxes (Note, Warning, etc.)
        ├── table.typ       # Rounded table wrappers
        └── todo.typ        # TODO box component
```

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
