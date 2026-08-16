"""Government investment composition by country group, 2013-22.

Each COFOG division is mapped to the model's infrastructure or public
human-capital block. The paper figure uses P5L because it preserves the same
36-country coverage as OECD Government at a Glance Table J.10.4. P51G remains
in the source extract for robustness calculations.
"""
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
DATA = PROJECT_ROOT / "data" / "oecdGovernmentInvestmentByFunction.csv"
FIGURES_DIR = PROJECT_ROOT / "docs" / "2026-06_wp-imf" / "figures"

OUTPUT_STEM = "investmentCompositionBands"
TRANSACTION = "P5L"
FIRST_YEAR, LAST_YEAR = 2013, 2022
GROUPS = [
    ("Advanced Economies", "AE", "#1E88E5"),
    ("Emerging Market and Developing Economies", "EMDE", "#E67E22"),
]
BLOCKS = [
    ("Infrastructure and other public capital", "infrastructure_share"),
    ("Human-capital-related investment", "human_capital_share"),
]
INFRASTRUCTURE = {"GF01", "GF02", "GF03", "GF04", "GF05"}

WIDTH_PX, HEIGHT_PX = chart_render_px(OUTPUT_STEM, (15, 5.5))
DISPLAY_CM = chart_display_cm(OUTPUT_STEM, (15, 5.5))
FONT_FAMILY = "Palatino, 'Palatino Linotype', 'Book Antiqua', serif"
FONT_PX = font_px_for_pt(8, WIDTH_PX, DISPLAY_CM[0])
LEGEND_FONT_PX = font_px_for_pt(8, WIDTH_PX, DISPLAY_CM[0])
TITLE_FONT_PX = font_px_for_pt(9, WIDTH_PX, DISPLAY_CM[0])
BOX_TICK_FONT_PX = font_px_for_pt(7, WIDTH_PX, DISPLAY_CM[0])
LINE_WIDTH = 2.5
MEAN_LINE_WIDTH = 2.0
BAND_OPACITY = 0.15
TICK_YEARS = [2013, 2016, 2019, 2022]
TICK_LABELS = ["2013", "16", "19", "22"]


def rgba(hex_color, alpha):
    value = hex_color.lstrip("#")
    return (
        f"rgba({int(value[0:2], 16)},{int(value[2:4], 16)},"
        f"{int(value[4:6], 16)},{alpha})"
    )


def load_shares():
    data = pd.read_csv(DATA)
    data = data.loc[
        data["transaction"].eq(TRANSACTION)
        & data["year"].between(FIRST_YEAR, LAST_YEAR)
    ].copy()
    data["block"] = data["function"].map(
        lambda value: "infrastructure" if value in INFRASTRUCTURE else "human_capital"
    )
    shares = data.groupby(
        ["isocode", "group", "year", "block"], as_index=False
    )["value"].sum()
    shares = shares.pivot(
        index=["isocode", "group", "year"], columns="block", values="value"
    ).reset_index()
    shares["total"] = shares["infrastructure"] + shares["human_capital"]
    if shares["total"].le(0).any():
        raise ValueError("Non-positive total government investment in balanced sample")
    shares["infrastructure_share"] = (
        shares["infrastructure"] / shares["total"] * 100
    )
    shares["human_capital_share"] = (
        shares["human_capital"] / shares["total"] * 100
    )

    expected = {"AE": 29, "EMDE": 7}
    observed = shares.groupby(["group", "year"])["isocode"].nunique()
    for (group, _), count in observed.items():
        if count != expected[group]:
            raise ValueError(f"Unbalanced {group} sample: expected {expected[group]}, got {count}")
    return shares


def annual_band(shares, variable, group):
    grouped = shares.loc[shares["group"].eq(group)].groupby("year")[variable]
    return pd.DataFrame({
        "p25": grouped.quantile(0.25),
        "median": grouped.median(),
        "p75": grouped.quantile(0.75),
        "mean": grouped.mean(),
        "economies": grouped.count(),
    }).reset_index()


def add_panel(fig, shares, variable, time_col, box_col, show_legend, csv_rows):
    bands = {code: annual_band(shares, variable, code) for _, code, _ in GROUPS}

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
        ), row=1, col=time_col)

    for _, code, color in GROUPS:
        band = bands[code]
        fig.add_trace(go.Scatter(
            x=band["year"],
            y=band["median"],
            mode="lines",
            line=dict(color=color, width=LINE_WIDTH),
            name=f"{code}: median",
            legendgroup=f"{code}_median",
            legendrank=1 if code == "AE" else 3,
            showlegend=show_legend,
        ), row=1, col=time_col)
        fig.add_trace(go.Scatter(
            x=band["year"],
            y=band["mean"],
            mode="lines",
            line=dict(color=color, width=MEAN_LINE_WIDTH, dash="dot"),
            name=f"{code}: mean",
            legendgroup=f"{code}_mean",
            legendrank=2 if code == "AE" else 4,
            showlegend=show_legend,
        ), row=1, col=time_col)

        pooled = shares.loc[shares["group"].eq(code), variable]
        q1, q3 = pooled.quantile([0.25, 0.75])
        box_position = 0 if code == "AE" else 1
        fig.add_trace(go.Scatter(
            x=[
                box_position - 0.26, box_position + 0.26,
                box_position + 0.26, box_position - 0.26,
                box_position - 0.26,
            ],
            y=[q1, q1, q3, q3, q1],
            mode="lines",
            fill="toself",
            fillcolor=rgba(color, BAND_OPACITY),
            line=dict(color=color, width=1.5),
            showlegend=False,
            hovertemplate=(
                f"{code}<br>25th percentile: {q1:.1f}"
                f"<br>75th percentile: {q3:.1f}<extra></extra>"
            ),
        ), row=1, col=box_col)

        for value, dash, width, label in [
            (band["median"].mean(), "solid", LINE_WIDTH, "Mean annual median"),
            (band["mean"].mean(), "dot", MEAN_LINE_WIDTH, "Mean annual mean"),
        ]:
            fig.add_trace(go.Scatter(
                x=[box_position - 0.38, box_position + 0.38],
                y=[value, value],
                mode="lines",
                line=dict(color=color, width=width, dash=dash),
                showlegend=False,
                hovertemplate=f"{label}: %{{y:.1f}}<extra></extra>",
                cliponaxis=False,
            ), row=1, col=box_col)

        for _, observation in band.iterrows():
            csv_rows.append({
                "transaction": TRANSACTION,
                "variable": variable,
                "group": code,
                "year": int(observation["year"]),
                "p25": round(float(observation["p25"]), 4),
                "median": round(float(observation["median"]), 4),
                "p75": round(float(observation["p75"]), 4),
                "mean": round(float(observation["mean"]), 4),
                "economies": int(observation["economies"]),
            })


def main():
    shares = load_shares()
    fig = make_subplots(
        rows=1,
        cols=5,
        specs=[[{}, {}, None, {}, {}]],
        column_widths=[0.36, 0.12, 0.04, 0.36, 0.12],
        subplot_titles=(BLOCKS[0][0], "", BLOCKS[1][0], ""),
        horizontal_spacing=0.018,
    )

    csv_rows = []
    add_panel(fig, shares, BLOCKS[0][1], 1, 2, True, csv_rows)
    add_panel(fig, shares, BLOCKS[1][1], 4, 5, False, csv_rows)

    for time_col, box_col, time_axis in [(1, 2, "y"), (4, 5, "y3")]:
        fig.update_xaxes(
            range=[FIRST_YEAR - 0.25, LAST_YEAR + 0.25],
            tickvals=TICK_YEARS,
            ticktext=TICK_LABELS,
            showgrid=False,
            linecolor="black",
            linewidth=1.5,
            ticks="inside",
            row=1,
            col=time_col,
        )
        fig.update_yaxes(
            showgrid=True,
            gridcolor="rgba(0,0,0,0.15)",
            gridwidth=0.5,
            zeroline=False,
            linecolor="black",
            linewidth=1.5,
            ticks="inside",
            row=1,
            col=time_col,
        )
        fig.update_xaxes(
            range=[-0.5, 1.5],
            tickvals=[0, 1],
            ticktext=["AE", "EMDE"],
            tickfont=dict(size=BOX_TICK_FONT_PX),
            showgrid=False,
            linecolor="black",
            linewidth=1.5,
            ticks="",
            row=1,
            col=box_col,
        )
        fig.update_yaxes(
            matches=time_axis,
            showticklabels=False,
            tickfont=dict(size=BOX_TICK_FONT_PX),
            tickformat=".0f",
            showgrid=True,
            gridcolor="rgba(0,0,0,0.15)",
            gridwidth=0.5,
            zeroline=False,
            linecolor="black",
            linewidth=1.5,
            ticks="inside",
            side="right",
            row=1,
            col=box_col,
        )

    fig.update_xaxes(tickfont=dict(size=FONT_PX))
    fig.update_yaxes(tickfont=dict(size=FONT_PX), ticksuffix="%")
    fig.update_layout(
        template="simple_white",
        width=WIDTH_PX,
        height=HEIGHT_PX,
        margin=dict(l=52, r=14, t=92, b=24),
        font=dict(family=FONT_FAMILY, size=FONT_PX),
        legend=dict(
            orientation="h",
            yref="container",
            yanchor="top",
            y=0.99,
            xanchor="center",
            x=0.5,
            font=dict(size=LEGEND_FONT_PX),
            tracegroupgap=2,
        ),
    )
    for annotation in fig.layout.annotations:
        if annotation.text in {title for title, _ in BLOCKS}:
            annotation.font.size = TITLE_FONT_PX
    left_title_x = (fig.layout.xaxis.domain[0] + fig.layout.xaxis2.domain[1]) / 2
    right_title_x = (fig.layout.xaxis3.domain[0] + fig.layout.xaxis4.domain[1]) / 2
    title_annotations = [
        annotation for annotation in fig.layout.annotations
        if annotation.text in {title for title, _ in BLOCKS}
    ]
    title_annotations[0].x = left_title_x
    title_annotations[1].x = right_title_x

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
