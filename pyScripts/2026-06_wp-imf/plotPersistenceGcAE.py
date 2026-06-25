"""
Appendix figure: the government-consumption shock under different AR(1)
PERSISTENCE in the canonical New Keynesian benchmark (fig:persistenceGc).

Companion to plotDurationGcAE (and plotSimplifiedGcAE), using the IDENTICAL 5x4
block layout (Demand / Supply / Labor / Nominal / Fiscal). The model is fixed (the
from-scratch canonical NK, Model_NK); the lines are four AR(1) persistences of the
SAME +1 percent of GDP government-consumption impulse. The shock path is
epsi_gc_t = impact * rho^(t-1) (an explicit sequence, not a change to the model's
rules):

  - rho = 0     (one-period)            -> Model_NK_exp_gc_ar0
  - rho = 0.5                           -> Model_NK_exp_gc_ar50
  - rho = 0.9                           -> Model_NK_exp_gc_ar90
  - rho = 0.99  (effectively permanent) -> Model_NK_exp_gc_ar99

The textbook NK model has no capital, technology, human-capital or fiscal-detail
variables, so the panels for those variables are left as blank space (their axes
and titles are hidden), exactly mirroring the simplification figure's grid.

The point is the wealth-effect mechanism behind the deflation: a less persistent
shock carries a smaller negative wealth effect on labor supply, so inflation and
the real wage RISE on impact at low persistence (rho = 0, 0.5) but FALL at high
persistence. The deflation is increasing in the shock's persistence.

Reads the QUARTERLY export (docs/csvFiles/figureNumbers.csv): the impact dynamics
of the low-persistence shocks live inside a single year, so yearly (Q1) sampling
would miss the impact sign. It writes PNG/PDF/HTML/CSV into
docs/2026-06_wp-imf/figures/. Requires pandas + plotly (with a Kaleido backend).
"""
from pathlib import Path

import pandas as pd
import plotly.graph_objects as go
from plotly.subplots import make_subplots

from wp_charts import chart_render_px, chart_display_cm, font_px_for_pt, smart_save_image, write_pdf

# --- Paths (resolved from this file; the data CSV is the only external input) -
SCRIPT_DIR = Path(__file__).resolve().parent
PROJECT_ROOT = SCRIPT_DIR.parents[1]
INPUT_CSV = PROJECT_ROOT / "docs" / "csvFiles" / "figureNumbers.csv"  # quarterly
FIGURES_DIR = PROJECT_ROOT / "docs" / "2026-06_wp-imf" / "figures"

# --- Styling (inlined; matches the other working-paper figures) ---------------
STYLE = {
    "template": "simple_white",
    "margins": {"t": 86, "b": 22, "l": 54, "r": 12},  # top room for legend + gap to plots; left room for tick labels + block names
    "legend": {"orientation": "h", "xanchor": "center", "x": 0.5},
    "axes": {"linecolor": "black", "linewidth": 1.5, "ticks": "inside",
             "showgrid": True, "gridcolor": "rgba(0,0,0,0.15)", "gridwidth": 0.5,
             "zeroline": True, "zerolinewidth": 1.5},
    "line_width_standard": 2.5,
}

# (model directory, legend label, colour) -- one fixed model (the canonical NK),
# four AR(1) PERSISTENCES, ordered low -> high (purple gradient, darker = more
# persistent). rho is the greek small letter rho.
SERIES = [
    ("Model_NK_exp_gc_ar0",  "ρ = 0",     "#CE93D8"),
    ("Model_NK_exp_gc_ar50", "ρ = 0.5",   "#AB47BC"),
    ("Model_NK_exp_gc_ar90", "ρ = 0.9",   "#7B1FA2"),
    ("Model_NK_exp_gc_ar99", "ρ = 0.99",  "#4A148C"),
]

# IDENTICAL grid to plotSimplifiedGcAE: (variable suffix, panel title), row-major
# in a 5x4 grid, one thematic block per row. The canonical NK lacks most of these
# variables (no capital, technology, human capital, or fiscal detail); those
# panels are left as blank space. Units differ by row: demand/supply/labor are
# percent deviations, the nominal row annualized percentage points, the fiscal
# row percentage points of steady-state GDP.
PANELS = [
    # Row 1 - demand components (percent deviation)
    ("yd",        "Output (Y<sup>d</sup><sub>t</sub>)"),
    ("C",         "Consumption (C<sub>t</sub>)"),
    ("Ip",        "Private investment (I<sub>t</sub>)"),
    # The textbook NK has no aggregate G; its only spending is consumption, so
    # map Gc into the government-spending panel (the shock itself, by duration).
    ("Gc",        "Government spending (G<sub>t</sub>)"),
    # Row 2 - production factors (percent deviation)
    ("AAt",       "Adopted technology (A<sub>t</sub>)"),
    ("Kg",        "Public infrastructure (K<sup>GI</sup><sub>t</sub>)"),
    ("Kp",        "Private capital (K<sub>t</sub>)"),
    ("N",         "Effective labor (N<sub>t</sub>)"),
    # Row 3 - labor decomposition (percent deviation): effective labor N = H * L.
    ("Lab",       "Labor supply (L<sub>t</sub>)"),
    ("H",         "Human capital stock (H<sub>t</sub>)"),
    None,
    None,
    # Row 4 - nominal block (annualized percentage points)
    ("PI_ann",    "Inflation (Π<sub>t</sub>)"),
    ("Rmp_ann",   "Policy rate (R<sup>mp</sup><sub>t</sub>)"),
    ("R_ann",     "Nominal bond rate (R<sub>t</sub>)"),
    ("rreal_ann", "Real interest rate (R<sub>t</sub>/Π<sub>t</sub>)"),
    # Row 5 - fiscal block (percentage points of steady-state GDP)
    ("pdef_yss",  "Primary deficit"),
    ("Trans_yss", "Transfers (T<sub>t</sub>)"),
    ("by_yss",    "Debt-to-GDP ratio (d<sub>t</sub>)"),
    None,
]

NCOLS = 4
NROWS = 5

# Block name printed vertically on the left of each row (top to bottom).
BLOCKS = ["Demand", "Supply", "Labor", "Nominal", "Fiscal"]

# Quarterly window: start at the pre-shock steady state and run ~12 years, long
# enough for the permanent line to settle and the temporary lines to revert.
PLOT_START_YEAR = 2025.0
PLOT_END_YEAR = 2037.0
X_TICKS = [2026, 2030, 2035]
X_TICK_LABELS = ["1y", "5y", "10y"]
OUTPUT_STEM = "persistenceGcAE"

# Both sizes come from chartTable.csv: render = original chart size (canvas,
# controls fonts/quality); display = size shown in the paper (aspect preserved).
WIDTH_PX, HEIGHT_PX = chart_render_px(OUTPUT_STEM, (15.0, 18.75))
DISPLAY_CM = chart_display_cm(OUTPUT_STEM, (15.0, 18.75))

# Font matching the paper: Palatino (the paper's mathpazo), sized so the chart
# text renders at a fixed point size on the page (recomputed from render/display).
TARGET_FONT_PT = 7   # axis ticks; a touch smaller given the dense grid
FONT_FAMILY = "Palatino, 'Palatino Linotype', 'Book Antiqua', serif"
FONT_PX = font_px_for_pt(TARGET_FONT_PT, WIDTH_PX, DISPLAY_CM[0])
LEGEND_FONT_PT = 8
LEGEND_FONT_PX = font_px_for_pt(LEGEND_FONT_PT, WIDTH_PX, DISPLAY_CM[0])
TITLE_FONT_PT = 8    # subplot titles
TITLE_FONT_PX = font_px_for_pt(TITLE_FONT_PT, WIDTH_PX, DISPLAY_CM[0])
BLOCK_FONT_PT = 10   # left-side block names
BLOCK_FONT_PX = font_px_for_pt(BLOCK_FONT_PT, WIDTH_PX, DISPLAY_CM[0])


def load_data():
    df = pd.read_csv(INPUT_CSV)
    df = df.rename(columns={df.columns[0]: "date"})
    # Quarterly dates like "2025Q3" -> a float year (2025.5) for the x-axis.
    q = df["date"].astype(str).str.extract(r"(\d{4})Q(\d)")
    df["year"] = q[0].astype(int) + (q[1].astype(int) - 1) / 4.0
    df = df.dropna(subset=["year"]).sort_values("year")
    return df[(df["year"] >= PLOT_START_YEAR) & (df["year"] <= PLOT_END_YEAR)]


def _panel_has_data(df, var):
    """True if any duration series has this variable (the canonical NK lacks
    most of the full model's variables; those panels are left blank)."""
    return any(f"{model}___{var}" in df.columns for model, _, _ in SERIES)


def main():
    df = load_data()
    years = df["year"].values

    # Titles only on panels that exist AND have data; blank everywhere else so
    # the missing-variable cells read as clean blank space.
    titles = []
    for panel in PANELS:
        if panel is None or not _panel_has_data(df, panel[0]):
            titles.append("")
        else:
            titles.append(panel[1])

    fig = make_subplots(
        rows=NROWS, cols=NCOLS,
        subplot_titles=titles,
        horizontal_spacing=0.06, vertical_spacing=0.075,
    )

    for idx, panel in enumerate(PANELS):
        row, col = idx // NCOLS + 1, idx % NCOLS + 1
        # Blank slot: intentionally empty (None) or a variable the model lacks.
        if panel is None or not _panel_has_data(df, panel[0]):
            fig.update_xaxes(visible=False, row=row, col=col)
            fig.update_yaxes(visible=False, row=row, col=col)
            continue
        var = panel[0]
        for model, label, color in SERIES:
            colname = f"{model}___{var}"
            if colname not in df.columns:
                continue
            fig.add_trace(
                go.Scatter(
                    x=years, y=df[colname].values,
                    name=label, legendgroup=label,
                    line=dict(color=color, width=STYLE["line_width_standard"]),
                    showlegend=(idx == 0),   # one legend entry per duration
                ),
                row=row, col=col,
            )

    # Subplot titles: Palatino at the title point size.
    for annotation in fig["layout"]["annotations"]:
        annotation["font"] = dict(family=FONT_FAMILY, size=TITLE_FONT_PX)

    # Block name down the left of each row: vertical, uppercase, on a grey chip,
    # centered on the row band and set close to the charts.
    for r, block in enumerate(BLOCKS, start=1):
        idx = (r - 1) * NCOLS + 1
        axis_name = "yaxis" + ("" if idx == 1 else str(idx))
        y0, y1 = fig.layout[axis_name].domain
        fig.add_annotation(
            text=block.upper(), textangle=-90,
            xref="paper", yref="paper", x=0, y=(y0 + y1) / 2,
            xshift=-40, showarrow=False, xanchor="center", yanchor="middle",
            font=dict(family=FONT_FAMILY, size=BLOCK_FONT_PX, color="#424242"),
            bgcolor="#E6E6E6", borderpad=2,
        )

    fig.update_layout(
        template=STYLE["template"],
        width=WIDTH_PX,
        height=HEIGHT_PX,
        margin=STYLE["margins"],
        font=dict(family=FONT_FAMILY, size=FONT_PX),
        legend=dict(
            orientation=STYLE["legend"]["orientation"],
            yref="container", yanchor="top", y=0.99,
            xanchor=STYLE["legend"]["xanchor"],
            x=STYLE["legend"]["x"],
            font=dict(size=LEGEND_FONT_PX),
            tracegroupgap=2,
        ),
    )

    axes = STYLE["axes"]
    fig.update_xaxes(
        tickvals=X_TICKS, ticktext=X_TICK_LABELS,
        showgrid=False, linecolor=axes["linecolor"], linewidth=axes["linewidth"],
        ticks=axes["ticks"], tickfont=dict(size=FONT_PX),
    )
    fig.update_yaxes(
        showgrid=axes["showgrid"], gridcolor=axes["gridcolor"], gridwidth=axes["gridwidth"],
        zeroline=axes["zeroline"], zerolinewidth=axes["zerolinewidth"], zerolinecolor="black",
        linecolor=axes["linecolor"], linewidth=axes["linewidth"],
        ticks=axes["ticks"], tickfont=dict(size=FONT_PX),
    )
    # Re-hide the blank cells: the global update_*axes above re-enabled them.
    for idx, panel in enumerate(PANELS):
        if panel is None or not _panel_has_data(df, panel[0]):
            row, col = idx // NCOLS + 1, idx % NCOLS + 1
            fig.update_xaxes(visible=False, row=row, col=col)
            fig.update_yaxes(visible=False, row=row, col=col)

    FIGURES_DIR.mkdir(parents=True, exist_ok=True)
    png_path = FIGURES_DIR / f"{OUTPUT_STEM}.png"
    pdf_path = FIGURES_DIR / f"{OUTPUT_STEM}.pdf"
    html_path = FIGURES_DIR / f"{OUTPUT_STEM}.html"
    smart_save_image(fig, png_path, DISPLAY_CM)
    write_pdf(fig, pdf_path, WIDTH_PX, DISPLAY_CM[0])  # vector PDF at the display size
    fig.write_html(html_path, auto_open=True)
    print(f"  Saved {png_path.name}, {pdf_path.name} and {html_path.name}")

    # Tidy long-format export: one row per (year, duration, variable).
    records = []
    for var, title in (panel for panel in PANELS if panel is not None):
        for model, label, _ in SERIES:
            colname = f"{model}___{var}"
            if colname not in df.columns:
                continue
            for yr, val in zip(years, df[colname].values):
                records.append({"year": round(yr, 2), "duration": label, "variable": title,
                                "pct_dev": round(val, 3)})
    csv_path = FIGURES_DIR / f"{OUTPUT_STEM}.csv"
    pd.DataFrame(records).to_csv(csv_path, index=False)
    print(f"  Exported data to {csv_path.name}")


if __name__ == "__main__":
    main()
