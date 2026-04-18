---
name: add-chart
description: Add a new chart to a project — creates the plotting script, registers it in chartTable.csv and tasks.py, and generates the PNG.
user-invocable: true
---

# Add Chart Skill

When the user asks to add a new chart to a project, follow these steps:

1. **Identify the project** from the context (e.g., `pyScripts/2026-04_FM-DF-outreach/`).

2. **Create the plotting script** in the project directory:
   - Import from `fiscal_common`: `load_config, resolve_from_config, ensure_output_dir, load_chart_config, get_chart_dims_px`
   - Use `get_chart_dims_px("<filename>.png")` for layout dimensions.
   - Apply the outreach palette from `chartConfig.json` (colors, axes.tickfont_size, legend.font_size).
   - Save PNG with `scale=2`, plus SVG, HTML, and CSV.
   - Do not produce extra charts not in chartTable.csv.

3. **Add a task** to `tasks.py`:
   - Define `@task` function pointing to the local script via `SCRIPT_DIR`.
   - Add to the `run_all` pre-dependencies if appropriate.

4. **Add a row to `chartTable.csv`** with:
   - `id`: slide number (e.g., `slide_28` for single, `slide_28_left` for panel).
   - `pngFile`: path relative to repo root.
   - `task`: task function name.
   - `Title`: Title Case, no line breaks.
   - `Subtitle`: in parentheses, e.g., `(Percent of GDP)`.
   - `Sources`: prefixed with `Source:` or `Sources:`.
   - `Notes`: prefixed with `Note:`.
   - `Width`: 32 (single), 15 (pair), 10 (triple).
   - `Height`: always 10.

5. **Run the task** and verify dimensions match the CSV.

6. **Commit** with a concise message (no Co-Authored-By).
