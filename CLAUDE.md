# Project Instructions

## Commit Style
- Do not add Co-Authored-By lines to git commit messages.
- Keep commit messages concise (1–2 sentences).
- Use HEREDOC format for multi-line commit messages.

## Shell Commands
- Do not use compound shell commands (for/while/if loops, ;/&&-chained commands).
- Split independent operations into separate tool calls.
- Always run commands from the repo root or use absolute paths.

## Chart Conventions

### Dimensions (cm)
- Single full-width chart: 32 × 10
- Side-by-side pair (left/right): 15 × 10
- Triplet (left/middle/right): 10 × 10
- Height is always 10 cm.
- All PNGs rendered at scale=2 (192 DPI effective).

### Fonts (via chartConfig.json)
- Axis tick labels: `axes.tickfont_size` (14)
- Legend entries: `legend.font_size` (12)
- Value labels on bars/waterfalls: same as legend font
- Subplot titles: same as axis tick font
- Global layout font: `font_size` (20)

### Color Palette (purple-centered)
- Primary: `#6A1B9A` (purple)
- Primary light: `#CE93D8`
- Primary dark: `#4A148C`
- Secondary: `#1E88E5` (blue)
- Positive/good: `#00897B` (teal) — NOT green
- Negative/bad: `#E65100` (deep orange) — NOT red
- Neutral: `#757575` (gray)
- Palette: `["#00838F", "#5E35B1", "#6A1B9A", "#AD1457", "#E65100"]`

### Income Group Colors (consistent across charts)
- Global: `#6A1B9A` (purple, thickest line width 6)
- China: `#E53935` (red)
- US: `#00897B` (teal)
- Advanced Economies excl. US: `#1E88E5` (blue)
- Emerging Markets excl. China: `#FF9800` (orange)
- Low-Income Developing Countries: `#795548` (brown)

### Naming Conventions
- Use "US" (no periods, not "U.S." or "USA").
- Income groups: "Advanced Economies", "Emerging Markets", "Low-Income Developing Countries".
- Title Case for chart titles.
- Year ranges use en-dash: 2026–31.

## Project Structure

### Chart Management
- `chartTable.csv` is the single source of truth for all charts.
- Columns: id, pngFile, task, Title, Subtitle, Sources, Notes, Width, Height.
- Sources field starts with "Source:" (singular) or "Sources:" (plural).
- Notes field starts with "Note:".
- Only produce charts listed in chartTable.csv — no extras.
- Chart dimensions are driven by `get_chart_dims_px()` which reads from chartTable.csv.

### Script Organization
- Each project lives in `pyScripts/<project-name>/` with its own:
  - `tasks.py` (invoke task runner)
  - `chartConfig.json` (styling config)
  - `chartTable.csv` (chart registry)
  - `fiscal_common.py` (shared utilities)
  - `fiscal_config.json` (output path config)
- Output goes to `docu/<project-name>/`.
- Scripts from sibling projects can be imported via `APR26_SCRIPT_DIR`.

### Data
- Shared data lives in `data/fmData/`.
- Country metadata in `+environment/csvFiles/countryTable.csv`.
