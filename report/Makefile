# Ý Tưởng:
# - Các file MD trong thư mục content sẽ được chuyển thành file TYP tương ứng.
# - Makefile sẽ tự động tạo lại file TYP nếu file MD thay đổi.
# - Makefile sẽ tự động tạo lại file PDF nếu file TYP thay đổi.

# Idea:
# - Markdown files in `content/` are converted to Typst files.
# - Makefile regenerates Typst files if MD files change.
# - Makefile regenerates PDF files if Typst files change.

# Define source and destination lists
MD_FILES := $(wildcard content/*.md)
TYP_FILES := $(MD_FILES:.md=.typ)

# Config and Filters
CONFIG := pandoc/pandoc.yaml
FILTERS := pandoc/vietnamese-slugs.lua pandoc/vspacing.lua

# Definition of files to watch
# Includes: Markdown, Config/Filters, and Typst templates
# Removed main.typ, added report.typ, thesis.typ
WATCH_FILES := $(MD_FILES) $(FILTERS) $(CONFIG) template/ report.typ thesis.typ slides.typ

.PHONY: all clean typ watch report thesis slides

# Default target: Build all PDFs
all: report.pdf thesis.pdf slides.pdf

# Target: Only convert MD to TYP (no PDF compile)
typ: $(TYP_FILES)

# Rule to create .typ from .md
# Added config and filters as prerequisites so it rebuilds if scripts change
%.typ: %.md $(CONFIG) $(FILTERS)
	pandoc -d $(CONFIG) "$<" -o "$@"

# Report PDF
report.pdf: report.typ $(TYP_FILES)
	typst compile report.typ --font-path template/fonts

# Thesis PDF
thesis.pdf: thesis.typ $(TYP_FILES)
	typst compile thesis.typ --font-path template/fonts

# Slides PDF
slides.pdf: slides.typ
	typst compile slides.typ --font-path template/fonts

# Clean build artifacts
clean:
	rm -f report.pdf thesis.pdf slides.pdf main.pdf
	# rm -f content/*.typ

# WATCH MODE
# Finds all relevant files and runs 'make all' on change
watch:
	@echo "Started watching with entr..."
	@find config content author pandoc template . -maxdepth 2 -name "*.md" -o -name "*.typ" -o -name "*.lua" -o -name "*.yaml" \
	| entr -r $(MAKE) all
