"""Country-group evidence underlying the steady-state calibration targets.

The figure is structured as a 3x2 panel for the six target categories in Table 2.
Real GDP growth, government consumption, and government investment are populated
from the WEO calibration database; the remaining three panels are placeholders.

For each populated panel, solid lines are equal-country group medians and shaded
areas are the 25th--75th percentile range. Circles mark the 2023 medians, and
open diamonds show the corresponding model targets.

In:  WEO_calib_enhanced.dta
Out: docs/2026-06_wp-imf/figures/calibrationDataBands.{png,pdf,html,csv}
"""
from argparse import ArgumentParser
from pathlib import Path

import pandas as pd
import plotly.graph_objects as go
from plotly.subplots import make_subplots

from wp_charts import (
    chart_display_cm,
    chart_render_px,
    font_px_for_pt,
    smart_save_image,
    write_pdf,
)

SCRIPT_DIR = Path(__file__).resolve().parent
PROJECT_ROOT = SCRIPT_DIR.parents[1]
FIGURES_DIR = PROJECT_ROOT / "docs" / "2026-06_wp-imf" / "figures"
DEFAULT_WEO = Path(
    "/Users/kk/Developer/2025-09_FM-conjunctural/data/fmData/"
    "WEO_calib_enhanced.dta"
)

OUTPUT_STEM = "calibrationDataBands"
FIRST_YEAR, LAST_YEAR = 2000, 2023
REF_YEAR = 2023
MIN_PEERS = 10

GROUPS = [
    ("Advanced Economies", "AE", "#1E88E5"),
    ("Emerging Market and Developing Economies", "EMDE", "#E67E22"),
]
GROUP_MAP = {
    "Advanced": "AE",
    "Emerging": "EMDE",
    "Low-Income": "EMDE",
}

PANELS = [
    ("Real GDP growth", "g_real", "Percent"),
    ("Government consumption", "ncg_gdp", "Percent of GDP"),
    ("Government investment", "nfig_gdp", "Percent of GDP"),
    ("Consumption tax", None, None),
    ("Labor income tax", None, None),
    ("Public debt", None, None),
]
TARGETS = {
    "g_real": {"AE": 1.6, "EMDE": 3.0},
    "ncg_gdp": {"AE": 18.0, "EMDE": 14.0},
    # Infrastructure plus human-capital investment; public R&D is not fixed investment.
    "nfig_gdp": {"AE": 3.0 + 1.45, "EMDE": 5.0 + 2.0},
}

BAND_OPACITY = 0.15
LINE_WIDTH = 2.5
TICK_YEARS = [2000, 2005, 2010, 2015, 2020, 2023]
TICK_LABELS = ["2000", "05", "10", "15", "20", "23"]

WIDTH_PX, HEIGHT_PX = chart_render_px(OUTPUT_STEM, (15, 15))
DISPLAY_CM = chart_display_cm(OUTPUT_STEM, (15, 15))
FONT_FAMILY = "Palatino, 'Palatino Linotype', 'Book Antiqua', serif"
FONT_PX = font_px_for_pt(8, WIDTH_PX, DISPLAY_CM[0])
LEGEND_FONT_PX = font_px_for_pt(7, WIDTH_PX, DISPLAY_CM[0])
TITLE_FONT_PX = font_px_for_pt(9, WIDTH_PX, DISPLAY_CM[0])


def rgba(hex_color, alpha):
    value = hex_color.lstrip("#")
    return (
        f"rgba({int(value[0:2], 16)},{int(value[2:4], 16)},"
        f"{int(value[4:6], 16)},{alpha})"
    )


def load_data(path):
    columns = ["year", "devClass", "g_real", "ncg_gdp", "nfig_gdp"]
    data = pd.read_stata(path, columns=columns, convert_categoricals=False)
    data["group"] = data["devClass"].map(GROUP_MAP)
    data = data.dropna(subset=["group"])
    return data[data["year"].between(FIRST_YEAR, LAST_YEAR)].copy()


def group_band(data, variable, group):
    grouped = data.loc[data["group"].eq(group)].groupby("year")[variable]
    band = pd.DataFrame({
        "p25": grouped.quantile(0.25),
        "p50": grouped.quantile(0.50),
        "p75": grouped.quantile(0.75),
        "n": grouped.count(),
    })
    return band.loc[band["n"].ge(MIN_PEERS)].reset_index()


def add_populated_panel(fig, data, variable, row, col, show_group_legend, csv_rows):
    bands = {code: group_band(data, variable, code) for _, code, _ in GROUPS}

    for _, code, color in GROUPS:
        band = bands[code]
        years = band["year"].tolist()
        fig.add_trace(go.Scatter(
            x=years + years[::-1],
            y=band["p75"].tolist() + band["p25"].tolist()[::-1],
            fill="toself",
            fillcolor=rgba(color, BAND_OPACITY),
            line=dict(color="rgba(0,0,0,0)"),
            hoverinfo="skip",
            showlegend=False,
        ), row=row, col=col)

    for name, code, color in GROUPS:
        band = bands[code]
        if band.empty or not band["year"].eq(REF_YEAR).any():
            raise ValueError(f"Missing {REF_YEAR} {code} observations for {variable}")

        fig.add_trace(go.Scatter(
            x=band["year"],
            y=band["p50"],
            mode="lines",
            line=dict(color=color, width=LINE_WIDTH),
            name=name,
            legendgroup=code,
            showlegend=show_group_legend,
        ), row=row, col=col)

        reference = float(band.loc[band["year"].eq(REF_YEAR), "p50"].iloc[0])
        fig.add_trace(go.Scatter(
            x=[REF_YEAR],
            y=[reference],
            mode="markers",
            marker=dict(color=color, size=8, symbol="circle"),
            showlegend=False,
            hoverinfo="skip",
            cliponaxis=False,
        ), row=row, col=col)
        fig.add_trace(go.Scatter(
            x=[REF_YEAR],
            y=[TARGETS[variable][code]],
            mode="markers",
            marker=dict(color=color, size=9, symbol="diamond-open", line=dict(width=2)),
            name="Table 2 target",
            legendgroup="target",
            showlegend=show_group_legend and code == "AE",
            hoverinfo="skip",
            cliponaxis=False,
        ), row=row, col=col)

        for _, obs in band.iterrows():
            csv_rows.append({
                "variable": variable,
                "group": code,
                "year": int(obs["year"]),
                "p25": round(float(obs["p25"]), 4),
                "p50": round(float(obs["p50"]), 4),
                "p75": round(float(obs["p75"]), 4),
                "economies": int(obs["n"]),
                "table2_target": TARGETS[variable][code],
            })


def main():
    parser = ArgumentParser()
    parser.add_argument("--weo", type=Path, default=DEFAULT_WEO)
    args = parser.parse_args()
    data = load_data(args.weo)

    fig = make_subplots(
        rows=3,
        cols=2,
        subplot_titles=tuple(title for title, _, _ in PANELS),
        horizontal_spacing=0.08,
        vertical_spacing=0.13,
    )

    csv_rows = []
    for index, (_, variable, unit) in enumerate(PANELS):
        row, col = index // 2 + 1, index % 2 + 1
        if variable is not None:
            add_populated_panel(
                fig, data, variable, row, col,
                show_group_legend=(index == 0),
                csv_rows=csv_rows,
            )
            fig.update_xaxes(
                range=[FIRST_YEAR, LAST_YEAR + 1],
                tickvals=TICK_YEARS,
                ticktext=TICK_LABELS,
                showgrid=False,
                linecolor="black",
                linewidth=1.5,
                ticks="inside",
                row=row,
                col=col,
            )
            fig.update_yaxes(
                title_text=unit,
                showgrid=True,
                gridcolor="rgba(0,0,0,0.15)",
                gridwidth=0.5,
                zeroline=True,
                zerolinecolor="black",
                zerolinewidth=1.2,
                linecolor="black",
                linewidth=1.5,
                ticks="inside",
                row=row,
                col=col,
            )
        else:
            fig.add_trace(go.Scatter(
                x=[0.5],
                y=[0.5],
                mode="text",
                text=["To be added"],
                textfont=dict(size=FONT_PX, color="#7A7A7A"),
                hoverinfo="skip",
                showlegend=False,
            ), row=row, col=col)
            fig.update_xaxes(visible=False, range=[0, 1], row=row, col=col)
            fig.update_yaxes(visible=False, range=[0, 1], row=row, col=col)

    fig.update_xaxes(tickfont=dict(size=FONT_PX))
    fig.update_yaxes(tickfont=dict(size=FONT_PX), title_font=dict(size=FONT_PX))
    fig.update_layout(
        template="simple_white",
        width=WIDTH_PX,
        height=HEIGHT_PX,
        margin=dict(l=42, r=14, t=70, b=24),
        font=dict(family=FONT_FAMILY, size=FONT_PX),
        legend=dict(
            orientation="h",
            yanchor="bottom",
            y=1.045,
            xanchor="center",
            x=0.5,
            font=dict(size=LEGEND_FONT_PX),
        ),
    )
    for annotation in fig.layout.annotations:
        if annotation.text in {title for title, _, _ in PANELS}:
            annotation.font.size = TITLE_FONT_PX

    FIGURES_DIR.mkdir(parents=True, exist_ok=True)
    png_path = FIGURES_DIR / f"{OUTPUT_STEM}.png"
    pdf_path = FIGURES_DIR / f"{OUTPUT_STEM}.pdf"
    html_path = FIGURES_DIR / f"{OUTPUT_STEM}.html"
    csv_path = FIGURES_DIR / f"{OUTPUT_STEM}.csv"
    smart_save_image(fig, png_path, DISPLAY_CM)
    write_pdf(fig, pdf_path, WIDTH_PX, DISPLAY_CM[0])
    fig.write_html(str(html_path), auto_open=True)
    pd.DataFrame(csv_rows).to_csv(csv_path, index=False, lineterminator="\n")
    print(f"  Saved {png_path.name}, {pdf_path.name}, {html_path.name}, and {csv_path.name}")


if __name__ == "__main__":
    main()
