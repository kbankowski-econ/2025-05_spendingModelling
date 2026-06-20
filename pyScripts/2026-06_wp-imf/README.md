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

Each figure has **two independent sizes** in `chartTable.csv`, both in
**centimetres**:

- **`RenderWidth` / `RenderHeight`** — the *original chart size*: the plotly
  canvas the chart is drawn on, which controls font sizes and resolution. The
  script converts this to pixels (cm × 96 DPI, then `scale=2`).
- **`DisplayWidth` / `DisplayHeight`** — the size the figure appears at in the
  paper. Applied via a `pHYs` DPI tag (in `wp_charts.smart_save_image`) so a bare
  `\includegraphics{...}` renders it there, aspect preserved.

The two are independent. To make a figure **smaller in the paper without changing
its fonts**, lower only `DisplayWidth`/`DisplayHeight`. To give a chart **more
drawing room** (e.g. so a crowded legend fits), raise `RenderWidth`/`RenderHeight`.
Edit a row and rerun; no `.tex` or code change needed. If the CSV (or a column) is
missing, each script falls back to built-in defaults.

## Output

All scripts write `<stem>.png`, `<stem>.html`, and `<stem>.csv` into
`docs/2026-06_wp-imf/figures/` — the directory the paper's `\includegraphics`
calls read from. Paths are resolved relative to each script's own location, so
they work regardless of the current working directory.

## Running

`tasks.py` (invoke) is the single entry point; it runs the scripts in this
folder, which read `chartTable.csv`:

```bash
invoke run-all                   # exportData (MATLAB) + regenerate every figure
invoke plot-reallocation-ae      # one figure
invoke --list                    # all tasks
```

You can also run a script directly: `python plotReallocationAE.py` (run from this
folder, or otherwise keep `wp_charts.py` and `chartTable.csv` alongside it so the
shared helpers import). Either way each chart's `.html` auto-opens in the browser.

Requires `invoke`, `pandas`, `numpy`, `plotly`, and a Kaleido backend for PNG
export. PNGs are written only when their bytes change (to avoid needless churn).
