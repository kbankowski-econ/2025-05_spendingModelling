"""
Appendix figure: the government-consumption shock under different shock
DURATIONS in the canonical New Keynesian benchmark (fig:durationGc).

Companion to plotSimplifiedGcAE: there the lines were models (full -> canonical
NK) under one permanent shock; here the model is fixed (the from-scratch
canonical NK, Model_NK) and the lines are three shock durations of the SAME
+1 percent of GDP government-consumption impulse:

  - 1-year shock (4 quarters)   -> Model_NK_exp_gc_d4
  - 5-year shock (20 quarters)  -> Model_NK_exp_gc_d20
  - Permanent shock             -> Model_NK_exp_gc

The point is the wealth-effect mechanism behind the deflation: a shorter shock
carries a smaller negative wealth effect on labor supply, so the real wage (=
marginal cost) and inflation RISE on impact for the 1-year shock but FALL for
longer-lived shocks. The deflation is increasing in the shock's persistence.

Unlike the yearly simplified figure, this reads the QUARTERLY export
(docs/csvFiles/figureNumbers.csv): the 1-year shock's impact dynamics live
inside a single year, so yearly (Q1) sampling would miss the impact sign. It
writes PNG/PDF/HTML/CSV into docs/2026-06_wp-imf/figures/. Requires pandas +
plotly (with a Kaleido backend).
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
    "margins": {"t": 70, "b": 22, "l": 54, "r": 12},  # top room for legend; left room for tick labels + block names
    "legend": {"orientation": "h", "xanchor": "center", "x": 0.5},
    "axes": {"linecolor": "black", "linewidth": 1.5, "ticks": "inside",
             "showgrid": True, "gridcolor": "rgba(0,0,0,0.15)", "gridwidth": 0.5,
             "zeroline": True, "zerolinewidth": 1.5},
    "line_width_standard": 2.5,
}

# (model directory, legend label, colour) -- one fixed model (the canonical NK),
# three shock DURATIONS, ordered short -> permanent.
SERIES = [
    ("Model_NK_exp_gc_d4",  "1-year shock (4 quarters)",  "#1E88E5"),
    ("Model_NK_exp_gc_d20", "5-year shock (20 quarters)", "#E65100"),
    ("Model_NK_exp_gc",     "Permanent shock",            "#6A1B9A"),
]

# (variable suffix, panel title); laid out row-major in a 2x4 grid, one block per
# row. The canonical NK has no capital/technology/fiscal-detail variables, so the
# panels are the ones the textbook model actually has. Top row is percent
# deviations; bottom row mixes the real wage (percent) with annualized
# percentage-point rates -- units are spelled out in the figure note.
PANELS = [
    # Row 1 - quantities (percent deviation)
    ("yd",        "Output (Y<sup>d</sup><sub>t</sub>)"),
    ("C",         "Consumption (C<sub>t</sub>)"),
    ("Gc",        "Government consumption (G<sup>c</sup><sub>t</sub>)"),
    ("N",         "Effective labor (N<sub>t</sub>)"),
    # Row 2 - prices and rates: the real wage equals marginal cost in this model
    # (constant returns), so it is the Phillips-curve driver; inflation and the
    # two rates are annualized percentage points.
    ("W_real",    "Real wage = marginal cost (W<sub>t</sub>)"),
    ("PI_ann",    "Inflation (Π<sub>t</sub>)"),
    ("Rmp_ann",   "Policy rate (R<sup>mp</sup><sub>t</sub>)"),
    ("rreal_ann", "Real interest rate (R<sub>t</sub>/Π<sub>t</sub>)"),
]

NCOLS = 4
NROWS = 2

# Block name printed vertically on the left of each row (top to bottom).
BLOCKS = ["Quantities", "Prices"]

# Quarterly window: start at the pre-shock steady state and run ~12 years, long
# enough for the permanent line to settle and the temporary lines to revert.
PLOT_START_YEAR = 2025.0
PLOT_END_YEAR = 2037.0
X_TICKS = [2026, 2030, 2035]
X_TICK_LABELS = ["1y", "5y", "10y"]
OUTPUT_STEM = "durationGcAE"

# Both sizes come from chartTable.csv: render = original chart size (canvas,
# controls fonts/quality); display = size shown in the paper (aspect preserved).
WIDTH_PX, HEIGHT_PX = chart_render_px(OUTPUT_STEM, (15.0, 9.0))
DISPLAY_CM = chart_display_cm(OUTPUT_STEM, (15.0, 9.0))

# Font matching the paper: Palatino (the paper's mathpazo), sized so the chart
# text renders at a fixed point size on the page (recomputed from render/display).
TARGET_FONT_PT = 7   # axis ticks
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


def main():
    df = load_data()
    years = df["year"].values

    fig = make_subplots(
        rows=NROWS, cols=NCOLS,
        subplot_titles=[panel[1] for panel in PANELS],
        horizontal_spacing=0.06, vertical_spacing=0.14,
    )

    for idx, panel in enumerate(PANELS):
        row, col = idx // NCOLS + 1, idx % NCOLS + 1
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
    for var, title in PANELS:
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
