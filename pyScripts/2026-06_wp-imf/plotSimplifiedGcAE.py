"""
Appendix figures: the government-consumption shock under progressive model
simplification. The permanent version is the primary robustness exercise
(fig:simplifiedGc); the default AR(1) version is its temporary counterpart.

Same 5x4 block layout as plotStandardShocksAE, but the six lines are MODELS
(not shocks): the full model, four step-by-step simplifications, and the
from-scratch canonical NK benchmark, each hit by the same +1-percent-of-GDP
government-consumption shock with no offsetting spending cut.

By default the script uses the AR(1) variants. With --permanent it uses the
corresponding _perm models and writes simplifiedGcAEPerm.*.

Pinned channels show as flat lines (e.g. adopted technology under "No R&D").
Standalone: the only input is docs/csvFiles/figureNumbers.csv; it writes
PNG/PDF/HTML/CSV into docs/2026-06_wp-imf/figures/. Requires pandas + plotly
(with a Kaleido backend).
"""
import argparse
from pathlib import Path

import pandas as pd
import plotly.graph_objects as go
from plotly.subplots import make_subplots

from wp_charts import chart_render_px, chart_display_cm, font_px_for_pt, smart_save_image, write_pdf

# --- Paths (resolved from this file; the data CSV is the only external input) -
SCRIPT_DIR = Path(__file__).resolve().parent
PROJECT_ROOT = SCRIPT_DIR.parents[1]
INPUT_CSV = PROJECT_ROOT / "docs" / "csvFiles" / "figureNumbers.csv"
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

# (model directory, legend label, colour) -- the six lines are the full model,
# four progressive simplifications, and the canonical NK benchmark.
BASE_SERIES = [
    ("Model_HumanCapital_exp_gc", "Full model",                 "#6A1B9A"),
    ("Model_Simple1_exp_gc",      "No R&D",                     "#1E88E5"),
    ("Model_Simple2_exp_gc",      "No R&D, no human capital",   "#00897B"),
    ("Model_Simple3_exp_gc",      "NK with capital",            "#E65100"),
    ("Model_Simple4_exp_gc",      "Textbook NK (no capital)",   "#C62828"),
    ("Model_NK_exp_gc",           "Canonical NK (from scratch)","#212121"),
]

# (variable suffix, panel title); laid out row-major in a 5x4 grid, one thematic
# block per row. Units differ by panel: demand, supply, labor, and marginal cost
# are percent deviations; rates are annualized percentage points; fiscal variables
# are percentage points of steady-state GDP. The figure note states these units.
PANELS = [
    # Row 1 - demand components (percent deviation)
    ("yd",        "Output (Y<sup>d</sup><sub>t</sub>)"),
    ("C",         "Consumption (C<sub>t</sub>)"),
    ("Ip",        "Private investment (I<sub>t</sub>)"),
    ("G",         "Government spending (G<sub>t</sub>)"),
    # Row 2 - production factors (percent deviation); the inputs to the output
    # equation Y = A^(vartheta-1) * Kg^aG * Kp^a * N^(1-a).
    ("A",         "Adopted technology (A<sub>t</sub>)"),
    ("Kg",        "Public infrastructure (K<sup>GI</sup><sub>t</sub>)"),
    ("Kp",        "Private capital (K<sub>t</sub>)"),
    ("N",         "Effective labor (N<sub>t</sub>)"),
    # Row 3 - labor decomposition (percent deviation): effective labor N = H * L.
    # Only two panels; the rest of the row is intentionally left blank (None).
    ("L",         "Labor supply (L<sub>t</sub>)"),
    ("H",         "Human capital stock (H<sub>t</sub>)"),
    None,
    None,
    # Row 4 - nominal block (marginal cost in percent; rates in annualized pp)
    ("mc",        "Real marginal cost (mc<sub>t</sub>)"),
    ("PI_ann",    "Inflation (Π<sub>t</sub>)"),
    ("R_ann",     "Nominal interest rate (R<sub>t</sub>)"),
    ("rreal_ann", "Real interest rate (R<sub>t</sub>/Π<sub>t</sub>)"),
    # Row 5 - fiscal block (percentage points of steady-state GDP); primary
    # deficit is a composite budget flow with no single paper symbol (see
    # eq:govbudget). Debt service (dserv_yss) is computed and exported but not
    # plotted here.
    ("pdef_yss",  "Primary deficit"),
    ("T_yss", "Transfers (T<sub>t</sub>)"),
    ("by_yss",    "Debt-to-GDP ratio (b<sub>t</sub>)"),
    None,
]

NCOLS = 4
NROWS = 5

# Block name printed vertically on the left of each row (top to bottom).
BLOCKS = ["Demand", "Supply", "Labor", "Nominal", "Fiscal"]

# Plot the pre-shock observation and the subsequent 100 quarterly responses.
# Keep annual horizon labels, placing them at the corresponding quarter.
PLOT_HORIZON_QUARTERS = 100
IMPACT_QUARTER = 1
X_TICK_HORIZONS = [1, 10, 25]
X_TICKS = [4 * h for h in X_TICK_HORIZONS]
X_TICK_LABELS = [f"{h}y" for h in X_TICK_HORIZONS]
OUTPUT_STEM = "simplifiedGcAE"
TARGET_FONT_PT = 7   # axis ticks; a touch smaller given the dense grid
FONT_FAMILY = "Palatino, 'Palatino Linotype', 'Book Antiqua', serif"
LEGEND_FONT_PT = 8
TITLE_FONT_PT = 8    # subplot titles
BLOCK_FONT_PT = 10   # left-side block names


def load_data():
    df = pd.read_csv(INPUT_CSV)
    df = df.rename(columns={df.columns[0]: "date"})
    date_parts = (
        df["date"].astype(str)
        .str.extract(r"(?P<year>\d{4})Q(?P<quarter>[1-4])")
        .astype(int)
    )
    period = 4 * date_parts["year"] + date_parts["quarter"]
    df["horizon_quarter"] = period - period.iloc[0]
    df = df.sort_values("horizon_quarter")
    return df[df["horizon_quarter"].between(0, PLOT_HORIZON_QUARTERS)]


def main(permanent=False):
    df = load_data()
    quarters = df["horizon_quarter"].values
    impact_values = df.set_index("horizon_quarter").loc[IMPACT_QUARTER]
    suffix = "_perm" if permanent else ""
    series = [(f"{model}{suffix}", label, color) for model, label, color in BASE_SERIES]
    output_stem = f"{OUTPUT_STEM}{'Perm' if permanent else ''}"

    # Both sizes come from chartTable.csv: render = original chart size (canvas,
    # controls fonts/quality); display = size shown in the paper (aspect preserved).
    width_px, height_px = chart_render_px(output_stem, (15.0, 18.75))
    display_cm = chart_display_cm(output_stem, (15.0, 18.75))
    font_px = font_px_for_pt(TARGET_FONT_PT, width_px, display_cm[0])
    legend_font_px = font_px_for_pt(LEGEND_FONT_PT, width_px, display_cm[0])
    title_font_px = font_px_for_pt(TITLE_FONT_PT, width_px, display_cm[0])
    block_font_px = font_px_for_pt(BLOCK_FONT_PT, width_px, display_cm[0])

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
        for model, label, color in series:
            colname = f"{model}___{var}"
            if colname not in df.columns:
                continue
            fig.add_trace(
                go.Scatter(
                    x=quarters, y=df[colname].values,
                    name=label, legendgroup=label,
                    line=dict(color=color, width=STYLE["line_width_standard"]),
                    showlegend=(idx == 0),   # one legend entry per model
                ),
                row=row, col=col,
            )
        for model, label, color in series:
            colname = f"{model}___{var}"
            if colname not in df.columns:
                continue
            fig.add_trace(
                go.Scatter(
                    x=[IMPACT_QUARTER], y=[impact_values[colname]],
                    name=label, legendgroup=label,
                    mode="markers",
                    marker=dict(
                        symbol="circle", size=6, color=color,
                        line=dict(color="white", width=0.75),
                    ),
                    showlegend=False,
                    hovertemplate=f"{label}<br>Q1: %{{y:.3f}}<extra></extra>",
                ),
                row=row, col=col,
            )

    # Subplot titles: Palatino at the title point size.
    for annotation in fig["layout"]["annotations"]:
        annotation["font"] = dict(family=FONT_FAMILY, size=title_font_px)

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
            font=dict(family=FONT_FAMILY, size=block_font_px, color="#424242"),
            bgcolor="#E6E6E6", borderpad=2,
        )

    fig.update_layout(
        template=STYLE["template"],
        width=width_px,
        height=height_px,
        margin=STYLE["margins"],
        font=dict(family=FONT_FAMILY, size=font_px),
        legend=dict(
            orientation=STYLE["legend"]["orientation"],
            yref="container", yanchor="top", y=0.99,  # pin to figure top, no blank band
            xanchor=STYLE["legend"]["xanchor"],
            x=STYLE["legend"]["x"],
            font=dict(size=legend_font_px),
            tracegroupgap=2,  # tighten the gap between (wrapped) legend rows
        ),
    )

    axes = STYLE["axes"]
    fig.update_xaxes(
        tickvals=X_TICKS, ticktext=X_TICK_LABELS,
        showgrid=False, linecolor=axes["linecolor"], linewidth=axes["linewidth"],
        ticks=axes["ticks"], tickfont=dict(size=font_px),
    )
    fig.update_yaxes(
        showgrid=axes["showgrid"], gridcolor=axes["gridcolor"], gridwidth=axes["gridwidth"],
        zeroline=axes["zeroline"], zerolinewidth=axes["zerolinewidth"], zerolinecolor="black",
        linecolor=axes["linecolor"], linewidth=axes["linewidth"],
        ticks=axes["ticks"], tickfont=dict(size=font_px),
    )

    FIGURES_DIR.mkdir(parents=True, exist_ok=True)
    png_path = FIGURES_DIR / f"{output_stem}.png"
    pdf_path = FIGURES_DIR / f"{output_stem}.pdf"
    html_path = FIGURES_DIR / f"{output_stem}.html"
    smart_save_image(fig, png_path, display_cm)
    write_pdf(fig, pdf_path, width_px, display_cm[0])  # vector PDF at the display size
    fig.write_html(html_path, auto_open=True)
    print(f"  Saved {png_path.name}, {pdf_path.name} and {html_path.name}")

    # Tidy long-format export: one row per (quarter, model, variable).
    records = []
    for var, title in (panel for panel in PANELS if panel is not None):
        for model, label, _ in series:
            colname = f"{model}___{var}"
            if colname not in df.columns:
                continue
            for quarter, val in zip(quarters, df[colname].values):
                records.append({
                    "horizon_quarter": quarter,
                    "model": label,
                    "variable": title,
                    "pct_dev": round(val, 3),
                })
    csv_path = FIGURES_DIR / f"{output_stem}.csv"
    pd.DataFrame(records).to_csv(csv_path, index=False)
    print(f"  Exported data to {csv_path.name}")


if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument(
        "--permanent", action="store_true",
        help="plot the permanent government-consumption shock",
    )
    main(permanent=parser.parse_args().permanent)
