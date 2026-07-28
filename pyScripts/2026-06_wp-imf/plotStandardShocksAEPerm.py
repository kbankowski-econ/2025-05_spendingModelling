"""
Headline figure: transmission of permanent public-spending increases
(fig:standardShocks).

Advanced-economy impulse responses of the main model variables to the four
standard debt-financed expansion shocks, each a permanent +1 percent of GDP
increase in one spending instrument with no offsetting cut. Each shock is a step
that stays at +1 percent of GDP:

  - Government consumption      -> Model_HumanCapital_exp_gc_perm
  - Infrastructure investment  -> Model_HumanCapital_exp_igi_perm
  - Human capital investment   -> Model_HumanCapital_exp_ige_perm
  - R&D investment             -> Model_HumanCapital_exp_grd_perm

A 5x4 grid of percent deviations from steady state. Standalone: the only input
is docs/csvFiles/figureNumbers.csv; it writes PNG/PDF/HTML/CSV into
docs/2026-06_wp-imf/figures/. Requires pandas + plotly (with a Kaleido backend).
"""
from math import log1p
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

# (model directory, legend label, colour) — colours match the reallocation/HC
# figures: infra blue, human capital purple, R&D green, consumption neutral grey.
SHOCKS = [
    ("Model_HumanCapital_exp_gc_perm",  "Government consumption",     "#757575"),
    ("Model_HumanCapital_exp_igi_perm", "Infrastructure investment", "#1565C0"),
    ("Model_HumanCapital_exp_ige_perm", "Human capital investment",  "#6A1B9A"),
    ("Model_HumanCapital_exp_grd_perm", "R&D investment",            "#2E7D32"),
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
    # Row 2 - productive asset stocks (percent deviation).
    ("A",         "Adopted technology (A<sub>t</sub>)"),
    ("Kg",        "Public infrastructure (K<sup>GI</sup><sub>t</sub>)"),
    ("Kge",       "Educ./hlt capital (K<sup>GE</sup><sub>t</sub>)"),
    ("Kp",        "Private capital (K<sub>t</sub>)"),
    # Row 3 - labor and human-capital inputs (percent deviation).
    ("L",         "Labor supply (L<sub>t</sub>)"),
    ("H",         "Human capital stock (H<sub>t</sub>)"),
    ("N",         "Effective labor (N<sub>t</sub>)"),
    ("E",         "Education time (E<sub>t</sub>)"),
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

# Plot the 100 quarterly responses from impact through the 25-year horizon.
# Keep annual horizon labels, placing them at the corresponding quarter.
PLOT_HORIZON_QUARTERS = 100
IMPACT_QUARTER = 1
X_TICK_HORIZONS = [1, 10, 25]
X_TICKS = [log1p(IMPACT_QUARTER)] + [log1p(4 * h) for h in X_TICK_HORIZONS]
X_TICK_LABELS = ["1q"] + [f"{h}y" for h in X_TICK_HORIZONS]
X_AXIS_MIN = log1p(IMPACT_QUARTER)
X_AXIS_MAX = log1p(PLOT_HORIZON_QUARTERS)
X_AXIS_PAD = 0.02 * (X_AXIS_MAX - X_AXIS_MIN)
OUTPUT_STEM = "standardShocksAEPerm"

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
    date_parts = (
        df["date"].astype(str)
        .str.extract(r"(?P<year>\d{4})Q(?P<quarter>[1-4])")
        .astype(int)
    )
    period = 4 * date_parts["year"] + date_parts["quarter"]
    df["horizon_quarter"] = period - period.iloc[0]
    df = df.sort_values("horizon_quarter")
    return df[df["horizon_quarter"].between(IMPACT_QUARTER, PLOT_HORIZON_QUARTERS)]


def main():
    df = load_data()
    quarters = df["horizon_quarter"].values
    horizon_positions = [log1p(quarter) for quarter in quarters]
    impact_values = df.set_index("horizon_quarter").loc[IMPACT_QUARTER]

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
        panel_min = panel_max = None
        for model, label, color in SHOCKS:
            colname = f"{model}___{var}"
            if colname not in df.columns:
                continue
            values = df[colname].values
            series_min, series_max = values.min(), values.max()
            panel_min = series_min if panel_min is None else min(panel_min, series_min)
            panel_max = series_max if panel_max is None else max(panel_max, series_max)
            fig.add_trace(
                go.Scatter(
                    x=horizon_positions, y=values,
                    name=label, legendgroup=label,
                    line=dict(color=color, width=STYLE["line_width_standard"]),
                    showlegend=(idx == 0),   # one legend entry per shock
                    customdata=quarters,
                    hovertemplate=(
                        f"{label}<br>Quarter: %{{customdata}}"
                        "<br>Response: %{y:.3f}<extra></extra>"
                    ),
                ),
                row=row, col=col,
            )
        if (
            panel_min is not None
            and (panel_min != 0 or panel_max != 0)
            and (panel_min >= 0 or panel_max <= 0)
        ):
            fig.update_yaxes(rangemode="tozero", row=row, col=col)
        for model, label, color in SHOCKS:
            colname = f"{model}___{var}"
            if colname not in df.columns:
                continue
            fig.add_trace(
                go.Scatter(
                    x=[log1p(IMPACT_QUARTER)], y=[impact_values[colname]],
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
        range=[X_AXIS_MIN - X_AXIS_PAD, X_AXIS_MAX],
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

    # Tidy long-format export: one row per (quarter, shock, variable).
    records = []
    for var, title in (panel for panel in PANELS if panel is not None):
        for model, label, _ in SHOCKS:
            colname = f"{model}___{var}"
            if colname not in df.columns:
                continue
            for quarter, val in zip(quarters, df[colname].values):
                records.append({
                    "horizon_quarter": quarter,
                    "shock": label,
                    "variable": title,
                    "pct_dev": round(val, 3),
                })
    csv_path = FIGURES_DIR / f"{OUTPUT_STEM}.csv"
    pd.DataFrame(records).to_csv(csv_path, index=False)
    print(f"  Exported data to {csv_path.name}")


if __name__ == "__main__":
    main()
