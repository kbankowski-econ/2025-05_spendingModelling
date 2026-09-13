"""Government budget allocations for R&D (GBARD) by country group, 2013-23.

GBARD in percent of GDP, documenting the public R&D spending target (Grdy):
solid lines are country-group medians, dotted lines GDP-weighted averages,
shaded areas the 25th-75th percentile range; the right panel pools the
country-year observations.

In:  data/oecdGbard.csv (national currency, millions; retrieveOECDGbard.py),
     data/world_imf2026.dta (WEO GDP in national currency),
     WEO_calib_enhanced.dta (WEO GDP in US dollars, for weights).
Out: figures/gbardBands.png/.pdf/.html/.csv
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
DATA = PROJECT_ROOT / "data" / "oecdGbard.csv"
WORLD = PROJECT_ROOT / "data" / "world_imf2026.dta"
DEFAULT_WEO = Path(
    "/Users/kk/Developer/2025-09_FM-conjunctural/data/fmData/"
    "WEO_calib_enhanced.dta"
)

OUTPUT_STEM = "gbardBands"
FIRST_YEAR, LAST_YEAR = 2013, 2023
GROUPS = [
    ("Advanced Economies", "AE", "#1E88E5"),
    ("Emerging Market and Developing Economies", "EMDE", "#E67E22"),
]

WIDTH_PX, HEIGHT_PX = chart_render_px(OUTPUT_STEM, (15, 5.5))
DISPLAY_CM = chart_display_cm(OUTPUT_STEM, (15, 5.5))
FONT_FAMILY = "Palatino, 'Palatino Linotype', 'Book Antiqua', serif"
FONT_PX = font_px_for_pt(8, WIDTH_PX, DISPLAY_CM[0])
LEGEND_FONT_PX = font_px_for_pt(8, WIDTH_PX, DISPLAY_CM[0])
BOX_TICK_FONT_PX = font_px_for_pt(7, WIDTH_PX, DISPLAY_CM[0])
LINE_WIDTH = 2.5
WEIGHTED_LINE_WIDTH = 2.0
BAND_OPACITY = 0.15
TICK_YEARS = [2013, 2018, 2023]
TICK_LABELS = ["2013", "18", "23"]


def rgba(hex_color, alpha):
    value = hex_color.lstrip("#")
    return (
        f"rgba({int(value[0:2], 16)},{int(value[2:4], 16)},"
        f"{int(value[4:6], 16)},{alpha})"
    )


def load_shares(weo_path):
    gbard = pd.read_csv(DATA)
    gbard = gbard[gbard["year"].between(FIRST_YEAR, LAST_YEAR)].copy()

    world = pd.read_stata(
        WORLD, columns=["ISO3", "year", "GDP_LCU"], convert_categoricals=False
    )
    world["year"] = world["year"].astype(int)
    world = world.rename(columns={"ISO3": "isocode"})
    shares = gbard.merge(world, on=["isocode", "year"], how="left", validate="one_to_one")
    if shares["GDP_LCU"].isna().any() or shares["GDP_LCU"].le(0).any():
        missing = shares.loc[shares["GDP_LCU"].isna() | shares["GDP_LCU"].le(0),
                             ["isocode", "year"]]
        raise ValueError(f"Missing or non-positive WEO GDP (LCU):\n{missing}")
    # GBARD in millions of national currency; GDP_LCU in billions.
    shares["gbard_gdp"] = 100 * shares["value"] / (shares["GDP_LCU"] * 1000)

    weights = pd.read_stata(
        weo_path, columns=["isocode", "year", "ngdpd"], convert_categoricals=False
    )
    weights = weights.loc[
        weights["year"].between(FIRST_YEAR, LAST_YEAR)
        & weights["isocode"].isin(shares["isocode"]),
    ]
    shares = shares.merge(weights, on=["isocode", "year"], how="left",
                          validate="one_to_one")
    if shares["ngdpd"].isna().any() or shares["ngdpd"].le(0).any():
        raise ValueError("Missing or non-positive WEO GDP weights")
    return shares


def annual_band(shares, group):
    group_shares = shares.loc[shares["group"].eq(group)].copy()
    grouped = group_shares.groupby("year")["gbard_gdp"]
    band = pd.DataFrame({
        "p25": grouped.quantile(0.25),
        "median": grouped.median(),
        "p75": grouped.quantile(0.75),
        "economies": grouped.count(),
    })
    group_shares["weighted_value"] = group_shares["gbard_gdp"] * group_shares["ngdpd"]
    weighted = group_shares.groupby("year").agg(
        weighted_value=("weighted_value", "sum"),
        weight=("ngdpd", "sum"),
    )
    weighted["gdp_weighted_average"] = weighted["weighted_value"] / weighted["weight"]
    return band.join(weighted[["gdp_weighted_average"]]).reset_index()


def main():
    parser = ArgumentParser()
    parser.add_argument("--weo", type=Path, default=DEFAULT_WEO)
    args = parser.parse_args()
    shares = load_shares(args.weo)

    fig = make_subplots(
        rows=1, cols=2,
        column_widths=[0.82, 0.14],
        horizontal_spacing=0.025,
    )

    csv_rows = []
    bands = {code: annual_band(shares, code) for _, code, _ in GROUPS}

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
        ), row=1, col=1)

    for _, code, color in GROUPS:
        band = bands[code]
        fig.add_trace(go.Scatter(
            x=band["year"], y=band["median"],
            mode="lines",
            line=dict(color=color, width=LINE_WIDTH),
            name=f"{code}: median",
            legendgroup=f"{code}_median",
            legendrank=1 if code == "AE" else 3,
        ), row=1, col=1)
        fig.add_trace(go.Scatter(
            x=band["year"], y=band["gdp_weighted_average"],
            mode="lines",
            line=dict(color=color, width=WEIGHTED_LINE_WIDTH, dash="dot"),
            name=f"{code}: GDP-weighted average",
            legendgroup=f"{code}_weighted",
            legendrank=2 if code == "AE" else 4,
        ), row=1, col=1)

        pooled = shares.loc[shares["group"].eq(code), "gbard_gdp"]
        q1, q3 = pooled.quantile([0.25, 0.75])
        box_position = 0 if code == "AE" else 1
        fig.add_trace(go.Scatter(
            x=[box_position - 0.26, box_position + 0.26,
               box_position + 0.26, box_position - 0.26, box_position - 0.26],
            y=[q1, q1, q3, q3, q1],
            mode="lines",
            fill="toself",
            fillcolor=rgba(color, BAND_OPACITY),
            line=dict(color=color, width=1.5),
            showlegend=False,
            hovertemplate=(
                f"{code}<br>25th percentile: {q1:.2f}"
                f"<br>75th percentile: {q3:.2f}<extra></extra>"
            ),
        ), row=1, col=2)
        for value, dash, width, label in [
            (band["median"].mean(), "solid", LINE_WIDTH, "Mean annual median"),
            (band["gdp_weighted_average"].mean(), "dot", WEIGHTED_LINE_WIDTH,
             "Mean annual GDP-weighted average"),
        ]:
            fig.add_trace(go.Scatter(
                x=[box_position - 0.38, box_position + 0.38],
                y=[value, value],
                mode="lines",
                line=dict(color=color, width=width, dash=dash),
                showlegend=False,
                hovertemplate=f"{label}: %{{y:.2f}}<extra></extra>",
                cliponaxis=False,
            ), row=1, col=2)

        for _, observation in band.iterrows():
            csv_rows.append({
                "group": code,
                "year": int(observation["year"]),
                "p25": round(float(observation["p25"]), 4),
                "median": round(float(observation["median"]), 4),
                "p75": round(float(observation["p75"]), 4),
                "economies": int(observation["economies"]),
                "gdp_weighted_average": round(
                    float(observation["gdp_weighted_average"]), 4
                ),
            })

    fig.update_xaxes(
        range=[FIRST_YEAR - 0.25, LAST_YEAR + 0.25],
        tickvals=TICK_YEARS, ticktext=TICK_LABELS,
        showgrid=False, linecolor="black", linewidth=1.5, ticks="inside",
        tickfont=dict(size=FONT_PX),
        row=1, col=1,
    )
    fig.update_yaxes(
        showgrid=True, gridcolor="rgba(0,0,0,0.15)", gridwidth=0.5,
        zeroline=False, linecolor="black", linewidth=1.5, ticks="inside",
        tickfont=dict(size=FONT_PX), rangemode="tozero",
        row=1, col=1,
    )
    fig.update_xaxes(
        range=[-0.5, 1.5], tickvals=[0, 1], ticktext=["AE", "EMDE"],
        tickfont=dict(size=BOX_TICK_FONT_PX),
        showgrid=False, linecolor="black", linewidth=1.5, ticks="",
        row=1, col=2,
    )
    fig.update_yaxes(
        matches="y", showticklabels=False,
        showgrid=True, gridcolor="rgba(0,0,0,0.15)", gridwidth=0.5,
        zeroline=False, linecolor="black", linewidth=1.5, ticks="inside",
        side="right",
        row=1, col=2,
    )

    fig.update_layout(
        template="simple_white",
        width=WIDTH_PX,
        height=HEIGHT_PX,
        margin=dict(l=52, r=14, t=64, b=24),
        font=dict(family=FONT_FAMILY, size=FONT_PX),
        legend=dict(
            orientation="h",
            yref="container", yanchor="top", y=0.99,
            xanchor="center", x=0.5,
            font=dict(size=LEGEND_FONT_PX),
            tracegroupgap=2,
        ),
    )

    FIGURES_DIR = PROJECT_ROOT / "docs" / "2026-06_wp-imf" / "figures"
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
