"""
Figure: transmission of standard public-spending shocks (fig:standardShocks).

Advanced-economy impulse responses of the main model variables to the four
standard debt-financed expansion shocks, each a permanent +1 percent of GDP
increase in one spending instrument with no offsetting cut:

  - Infrastructure investment  -> Model_HumanCapital_exp_igi
  - Human capital investment   -> Model_HumanCapital_exp_ige
  - R&D investment             -> Model_HumanCapital_exp_grd
  - Government consumption      -> Model_HumanCapital_exp_gc

A 3x4 grid of percent deviations from steady state. Standalone: the only input
is docs/csvFiles/figureNumbers_yearly.csv; it writes PNG/PDF/HTML/CSV into
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
INPUT_CSV = PROJECT_ROOT / "docs" / "csvFiles" / "figureNumbers_yearly.csv"
FIGURES_DIR = PROJECT_ROOT / "docs" / "2026-06_wp-imf" / "figures"

# --- Styling (inlined; matches the other working-paper figures) ---------------
STYLE = {
    "template": "simple_white",
    "margins": {"t": 70, "b": 22, "l": 54, "r": 12},  # top room for legend + gap to plots; left room for tick labels + block names
    "legend": {"orientation": "h", "xanchor": "center", "x": 0.5},
    "axes": {"linecolor": "black", "linewidth": 1.5, "ticks": "inside",
             "showgrid": True, "gridcolor": "rgba(0,0,0,0.15)", "gridwidth": 0.5,
             "zeroline": True, "zerolinewidth": 1.5},
    "line_width_standard": 2.5,
}

# (model directory, legend label, colour) — colours match the reallocation/HC
# figures: infra blue, human capital purple, R&D green, consumption neutral grey.
SHOCKS = [
    ("Model_HumanCapital_exp_igi", "Infrastructure investment", "#1565C0"),
    ("Model_HumanCapital_exp_ige", "Human capital investment",  "#6A1B9A"),
    ("Model_HumanCapital_exp_grd", "R&D investment",            "#2E7D32"),
    ("Model_HumanCapital_exp_gc",  "Government consumption",     "#757575"),
]

# (variable suffix, panel title); laid out row-major in a 4x4 grid, one thematic
# block per row. Units differ by row: the demand and supply rows are percent
# deviations; the nominal row is annualized percentage points; the fiscal row is
# percentage points of GDP. There are no y-axis unit labels by design -- the
# figure note spells out how each block's deviations are calculated.
PANELS = [
    # Row 1 - demand components (percent deviation)
    ("yd",        "Output (Y<sup>d</sup><sub>t</sub>)"),
    ("C",         "Consumption (C<sub>t</sub>)"),
    ("Ip",        "Private investment (I<sub>t</sub>)"),
    ("G",         "Government spending (G<sub>t</sub>)"),
    # Row 2 - production factors (percent deviation); the inputs to the output
    # equation Y = A^(vartheta-1) * Kg^aG * Kp^a * N^(1-a).
    ("AAt",       "Adopted technology (A<sub>t</sub>)"),
    ("Kg",        "Public infrastructure (K<sup>GI</sup><sub>t</sub>)"),
    ("Kp",        "Private capital (K<sub>t</sub>)"),
    ("N",         "Effective labor (N<sub>t</sub>)"),
    # Row 3 - labor decomposition (percent deviation): effective labor N = H * L.
    # Only two panels; the rest of the row is intentionally left blank (None).
    ("Lab",       "Labor supply (L<sub>t</sub>)"),
    ("H",         "Human capital stock (H<sub>t</sub>)"),
    None,
    None,
    # Row 4 - nominal block (annualized percentage points)
    ("PI_ann",    "Inflation (Π<sub>t</sub>)"),
    ("Rmp_ann",   "Policy rate (R<sup>mp</sup><sub>t</sub>)"),
    ("R_ann",     "Nominal bond rate (R<sub>t</sub>)"),
    ("rreal_ann", "Real interest rate (R<sub>t</sub>/Π<sub>t</sub>)"),
    # Row 5 - fiscal block (percentage points of GDP); primary deficit is a
    # composite budget flow with no single paper symbol (see eq:govbudget).
    ("pdef_pp",   "Primary deficit"),
    ("Trans_pp",  "Transfers (T<sub>t</sub>)"),
    ("by_pp",     "Debt-to-GDP ratio (d<sub>t</sub>)"),
    None,
]

NCOLS = 4
NROWS = 5

# Block name printed vertically on the left of each row (top to bottom).
BLOCKS = ["Demand", "Supply", "Labor", "Nominal", "Fiscal"]

PLOT_START_YEAR = 2026
X_TICKS = [2026, 2038, 2050]
# Show the first tick as full 4-digit year, abbreviate the rest to 2 digits.
X_TICK_LABELS = [str(X_TICKS[0])] + [f"{y % 100:02d}" for y in X_TICKS[1:]]
OUTPUT_STEM = "standardShocksAE"

# Both sizes come from chartTable.csv: render = original chart size (canvas,
# controls fonts/quality); display = size shown in the paper (aspect preserved).
WIDTH_PX, HEIGHT_PX = chart_render_px(OUTPUT_STEM, (15.0, 18.75))
DISPLAY_CM = chart_display_cm(OUTPUT_STEM, (15.0, 18.75))

# Font matching the paper: Palatino (the paper's mathpazo), sized so the chart
# text renders at a fixed point size on the page (recomputed from render/display).
TARGET_FONT_PT = 7   # axis ticks; a touch smaller given the dense 3x4 grid
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
    df["year"] = df["date"].astype(str).str.extract(r"(\d{4})").astype(int)
    df = df.sort_values("year")
    return df[df["year"] >= PLOT_START_YEAR]


def main():
    df = load_data()
    years = df["year"].values

    fig = make_subplots(
        rows=NROWS, cols=NCOLS,
        subplot_titles=[(panel[1] if panel else "") for panel in PANELS],
        horizontal_spacing=0.06, vertical_spacing=0.075,
    )

    for idx, panel in enumerate(PANELS):
        row, col = idx // NCOLS + 1, idx % NCOLS + 1
        if panel is None:  # intentionally blank slot — hide its empty axes
            fig.update_xaxes(visible=False, row=row, col=col)
            fig.update_yaxes(visible=False, row=row, col=col)
            continue
        var = panel[0]
        for model, label, color in SHOCKS:
            colname = f"{model}___{var}"
            if colname not in df.columns:
                continue
            fig.add_trace(
                go.Scatter(
                    x=years, y=df[colname].values,
                    name=label, legendgroup=label,
                    line=dict(color=color, width=STYLE["line_width_standard"]),
                    showlegend=(idx == 0),   # one legend entry per shock
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
            yref="container", yanchor="top", y=0.99,  # pin to figure top, no blank band
            xanchor=STYLE["legend"]["xanchor"],
            x=STYLE["legend"]["x"],
            font=dict(size=LEGEND_FONT_PX),
            tracegroupgap=2,  # tighten the gap between (wrapped) legend rows
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

    # Tidy long-format export: one row per (year, shock, variable).
    records = []
    for var, title in (panel for panel in PANELS if panel is not None):
        for model, label, _ in SHOCKS:
            colname = f"{model}___{var}"
            if colname not in df.columns:
                continue
            for yr, val in zip(years, df[colname].values):
                records.append({"year": yr, "shock": label, "variable": title,
                                "pct_dev": round(val, 3)})
    csv_path = FIGURES_DIR / f"{OUTPUT_STEM}.csv"
    pd.DataFrame(records).to_csv(csv_path, index=False)
    print(f"  Exported data to {csv_path.name}")


if __name__ == "__main__":
    main()
