# Working-paper figure scripts (`2026-06_wp-imf`)

Scripts that regenerate the figures in `draftPaper.tex`. They are copies of the
scripts in `pyScripts/2026-04_spendingModelling/`, reworked so this folder is
self-contained: the former `fiscal_common.py` / `chartConfig.json` /
`fiscal_config.json` dependencies are gone. Styling is inlined per script; the
only two shared pieces both live in this folder — `wp_charts.py` (the
`chart_dims_px` and `smart_save_image` helpers) and `chartTable.csv` (chart
sizes). Each script's only data input is its source CSV.

| Script | Figure | Data file |
|---|---|---|
| `plotDiffusionAE.py` | Technology diffusion (`fig:diffusion`) | `docs/csvFiles/figureNumbers_yearly.csv` |
| `plotReallocationAE.py` | Reallocation, panel a — AE (`fig:reallocation`) | `docs/csvFiles/figureNumbers_yearly.csv` |
| `plotReallocationEM.py` | Reallocation, panel b — EMDE | `docs/csvFiles/figureNumbers_yearly.csv` |
| `plotEfficiencyAE.py` | Spending efficiency, panel a — AE (`fig:efficiency`) | `docs/csvFiles/figureNumbers_yearly.csv` |
| `plotEfficiencyEM.py` | Spending efficiency, panel b — EMDE | `docs/csvFiles/figureNumbers_yearly.csv` |
| `plotHumanCapitalIRFs.py` | Human capital + R&D mix (`fig:humanCapital`) | `docs/csvFiles/figureNumbers_yearly.csv` |
| `plotEfficiencyBands.py` | Efficiency bands by income group (App. B, `fig:efficiencyBands`) | IMF staff efficiency estimates (`DATA_DIR` in the script) |

## Chart dimensions (`chartTable.csv`)

The `Width` and `Height` columns (in **centimetres**) set each figure's **display
size in the paper** — the size a bare `\includegraphics{...}` renders it at, with
aspect preserved (the image fits inside that box). Edit a row's cm and rerun to
resize that figure; no `.tex` or code change needed.

This is purely a display change. Each chart is rendered at a **fixed internal
canvas** (`WIDTH_PX, HEIGHT_PX` in the script — 560×360 for the panels, 900×620
for the bands), which is what controls font sizes and quality. The PNG is then
tagged (via a `pHYs` chunk in `wp_charts.smart_save_image`) with the DPI that
makes that high-resolution bitmap appear at the requested cm size. So shrinking a
figure leaves its fonts and layout untouched — it just scales the whole image
down. If the CSV (or a row) is missing, each script falls back to a built-in
default cm.

## Output

All scripts write `<stem>.png`, `<stem>.html`, and `<stem>.csv` into
`docs/2026-06_wp-imf/figures/` — the directory the paper's `\includegraphics`
calls read from. Paths are resolved relative to each script's own location, so
they work regardless of the current working directory.

## Running

```bash
python plotReallocationAE.py     # one figure (run from this folder)
python run_all.py                # all seven (via subprocess)
```

Run scripts from this folder (or otherwise keep `wp_charts.py` and
`chartTable.csv` alongside them) so the shared helpers import.

Requires `pandas`, `numpy`, `plotly`, and a Kaleido backend for PNG export.
PNGs are written only when their bytes change (to avoid needless churn).
