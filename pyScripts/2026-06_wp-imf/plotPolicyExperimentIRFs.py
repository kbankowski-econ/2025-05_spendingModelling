"""
Appendix: detailed transmission of the policy experiments (fig:reallocationIRFs
and fig:efficiencyIRFsEM).

Two 5x4 grids in the layout of the standard-shock transmission figure
(plotStandardShocksAEPerm.py):

  1. reallocationIRFs   - the three AE reallocation experiments of Figure 5: a
     permanent +1 percent of GDP shift into infrastructure, human capital, or
     R&D, each funded by a cut in public consumption. Solid lines; colors match
     Figure 5.
  2. efficiencyIRFsAE   - the three standard AE experiments of Figure 6,
     panel a: the same AE reallocations combined with a gradual closure of the
     calibrated efficiency gaps over 25 years. Full response paths, same
     formatting.

Standalone: the only input is docs/csvFiles/figureNumbers.csv; writes
PNG/PDF/HTML/CSV into docs/2026-06_wp-imf/figures/.
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

# --- Styling (matches plotStandardShocksAEPerm.py) ----------------------------
STYLE = {
    "template": "simple_white",
    "margins": {"t": 86, "b": 22, "l": 54, "r": 12},
    "legend": {"orientation": "h", "xanchor": "center", "x": 0.5},
    "axes": {"linecolor": "black", "linewidth": 1.5, "ticks": "inside",
             "showgrid": True, "gridcolor": "rgba(0,0,0,0.15)", "gridwidth": 0.5,
             "zeroline": True, "zerolinewidth": 1.5},
    "line_width_standard": 2.5,
}

NEUTRAL = "#757575"

# (model directory, instrument label, colour, dash, show instrument legend entry)
# Colors match Figure 5: infrastructure blue, human capital purple, R&D green.
# AE experiments only, all solid; the EMDE efficiency figure below uses dotted.
REALLOCATION_SERIES = [
    ("Model_HumanCapital_epsi_ig",    "Infrastructure investment", "#1565C0", "solid", True),
    ("Model_HumanCapital_epsi_cge",   "Human capital investment",  "#6A1B9A", "solid", True),
    ("Model_HumanCapital_epsi_cgrd",  "R&D spending",              "#2E7D32", "solid", True),
]

EFFICIENCY_SERIES = [
    ("Model_HumanCapital_epsi_igeff25y",    "Infrastructure investment", "#1565C0", "solid", True),
    ("Model_HumanCapital_epsi_cgeeff25y",   "Human capital investment",  "#6A1B9A", "solid", True),
    ("Model_HumanCapital_epsi_cgrd_eff25y", "R&D spending",              "#2E7D32", "solid", True),
]

# Panel layout identical to the standard-shock transmission figure.
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
    # Row 5 - fiscal block (quarterly-GDP pp for flows; annual-GDP pp for debt)
    ("pdef_yss",  "Primary deficit-to-GDP ratio"),
    ("T_yss", "Transfers-to-GDP ratio"),
    ("by_yss",    "Debt-to-GDP ratio (b<sub>t</sub>)"),
    None,
]

NCOLS = 4
NROWS = 5
BLOCKS = ["Demand", "Prod. stocks", "Labor", "Prices & rates", "Fiscal"]

PLOT_HORIZON_QUARTERS = 100
IMPACT_QUARTER = 1
X_TICK_HORIZONS = [1, 10, 25]
X_TICKS = [log1p(IMPACT_QUARTER)] + [log1p(4 * h) for h in X_TICK_HORIZONS]
X_TICK_LABELS = ["1q"] + [f"{h}y" for h in X_TICK_HORIZONS]
X_AXIS_MIN = log1p(IMPACT_QUARTER)
X_AXIS_MAX = log1p(PLOT_HORIZON_QUARTERS)
X_AXIS_PAD = 0.02 * (X_AXIS_MAX - X_AXIS_MIN)

DEFAULT_SIZE_CM = (15.0, 18.75)
FONT_FAMILY = "Palatino, 'Palatino Linotype', 'Book Antiqua', serif"
TARGET_FONT_PT = 7
LEGEND_FONT_PT = 8
TITLE_FONT_PT = 8
BLOCK_FONT_PT = 10


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


def series_key(model, label):
    economy = "EMDE" if model.startswith("EM_") else "AE"
    return f"{economy}: {label}"


def build_figure(df, series, style_keys, output_stem):
    quarters = df["horizon_quarter"].values
    horizon_positions = [log1p(quarter) for quarter in quarters]
    impact_values = df.set_index("horizon_quarter").loc[IMPACT_QUARTER]

    width_px, height_px = chart_render_px(output_stem, DEFAULT_SIZE_CM)
    display_cm = chart_display_cm(output_stem, DEFAULT_SIZE_CM)
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
        if panel is None:
            fig.update_xaxes(visible=False, row=row, col=col)
            fig.update_yaxes(visible=False, row=row, col=col)
            continue
        var = panel[0]
        panel_min = panel_max = None
        for model, label, color, dash, show_legend in series:
            colname = f"{model}___{var}"
            if colname not in df.columns:
                continue
            values = df[colname].values
            series_min, series_max = values.min(), values.max()
            panel_min = series_min if panel_min is None else min(panel_min, series_min)
            panel_max = series_max if panel_max is None else max(panel_max, series_max)
            key = series_key(model, label)
            fig.add_trace(
                go.Scatter(
                    x=horizon_positions, y=values,
                    name=label, legendgroup=label,
                    line=dict(color=color, width=STYLE["line_width_standard"], dash=dash),
                    showlegend=(idx == 0 and show_legend),
                    customdata=quarters,
                    hovertemplate=(
                        f"{key}<br>Quarter: %{{customdata}}"
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
        for model, label, color, dash, show_legend in series:
            colname = f"{model}___{var}"
            if colname not in df.columns:
                continue
            key = series_key(model, label)
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
                    hovertemplate=f"{key}<br>Q1: %{{y:.3f}}<extra></extra>",
                ),
                row=row, col=col,
            )

    # Grey legend keys explaining the solid/dotted economy encoding.
    for key_label, dash in style_keys:
        fig.add_trace(
            go.Scatter(
                x=[None], y=[None], mode="lines",
                name=key_label, legendgroup=key_label,
                line=dict(color=NEUTRAL, width=STYLE["line_width_standard"], dash=dash),
                showlegend=True, hoverinfo="skip",
            ),
            row=1, col=1,
        )

    for annotation in fig["layout"]["annotations"]:
        annotation["font"] = dict(family=FONT_FAMILY, size=title_font_px)

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
            yref="container", yanchor="top", y=0.99,
            xanchor=STYLE["legend"]["xanchor"],
            x=STYLE["legend"]["x"],
            font=dict(size=legend_font_px),
            tracegroupgap=2,
        ),
    )

    axes = STYLE["axes"]
    fig.update_xaxes(
        tickvals=X_TICKS, ticktext=X_TICK_LABELS,
        range=[X_AXIS_MIN - X_AXIS_PAD, X_AXIS_MAX],
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
    write_pdf(fig, pdf_path, width_px, display_cm[0])
    fig.write_html(html_path, auto_open=True)
    print(f"  Saved {png_path.name}, {pdf_path.name} and {html_path.name}")

    records = []
    for var, title in (panel for panel in PANELS if panel is not None):
        for model, label, _color, _dash, _show in series:
            colname = f"{model}___{var}"
            if colname not in df.columns:
                continue
            key = series_key(model, label)
            for quarter, val in zip(quarters, df[colname].values):
                records.append({
                    "horizon_quarter": quarter,
                    "experiment": key,
                    "variable": title,
                    "pct_dev": round(val, 3),
                })
    csv_path = FIGURES_DIR / f"{output_stem}.csv"
    pd.DataFrame(records).to_csv(csv_path, index=False)
    print(f"  Exported data to {csv_path.name}")


def main():
    df = load_data()
    build_figure(df, REALLOCATION_SERIES, [], "reallocationIRFs")
    build_figure(df, EFFICIENCY_SERIES, [], "efficiencyIRFsAE")


if __name__ == "__main__":
    main()
