-- pandoc/tables.lua

function Table(el)
  local n_cols = #el.colspecs
  
  -- 1. Construct the Column setting: (1fr,) * N
  -- This creates an array of N items, each being 1fr.
  -- Example for 6 cols: columns: (1fr, 1fr, 1fr, 1fr, 1fr, 1fr)
  local col_setting = string.format("columns: (1fr,) * %d", n_cols)

  -- 2. Construct Alignment
  -- Map Pandoc alignment to Typst alignment
  local align_map = {
    AlignLeft = "left",
    AlignRight = "right",
    AlignCenter = "center",
    AlignDefault = "left" -- Default to left
  }
  
  local align_items = {}
  for _, spec in ipairs(el.colspecs) do
    -- spec[1] is the alignment object
    table.insert(align_items, align_map[spec[1]] or "left")
  end
  local align_setting = "align: (" .. table.concat(align_items, ", ") .. ")"

  -- 3. Collect all cells (Headers + Body)
  local cells = {}

  -- Helper function to render cell content to Typst code
  local function add_cells(row_list)
    for _, row in ipairs(row_list) do
      for _, cell in ipairs(row.cells) do
        -- Render the inner content of the cell (preserves bold/italics)
        local content = pandoc.utils.stringify(cell) -- Fallback for simple text
        if #cell.contents > 0 then
           -- Use pandoc.write to keep formatting (requires Pandoc 2.19+)
           content = pandoc.write(pandoc.Pandoc(cell.contents), 'typst')
           -- Clean up: trim whitespace/newlines from the cell string
           content = content:gsub("^%s*(.-)%s*$", "%1")
        end
        table.insert(cells, "[" .. content .. "]")
      end
    end
  end

  -- Process Header
  add_cells(el.head.rows)
  
  -- Process Bodies
  for _, body in ipairs(el.bodies) do
    add_cells(body.body)
  end

  -- 4. Build the final Typst Code
  local typst_code = string.format(
    '#table(\n  %s,\n  %s,\n  %s\n)',
    col_setting,
    align_setting,
    table.concat(cells, ", ")
  )

  -- Return as a Raw Block so Pandoc doesn't touch it
  return pandoc.RawBlock('typst', typst_code)
end
