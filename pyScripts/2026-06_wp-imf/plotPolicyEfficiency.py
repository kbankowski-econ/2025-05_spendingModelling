"""Reproduce the FM spending-efficiency panels with the latest model export."""

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
INPUT_CSV = PROJECT_ROOT / "docs" / "csvFiles" / "figureNumbers_yearly.csv"
FIGURES_DIR = PROJECT_ROOT / "docs" / "2026-06_wp-imf" / "figures"
TARGET_YEAR = 2050
FONT_FAMILY = "Palatino, 'Palatino Linotype', 'Book Antiqua', serif"

STYLE = {
    "template": "simple_white",
    "margins": {"t": 24, "b": 24, "l": 34, "r": 8},
    "axes": {
        "linecolor": "black",
        "linewidth": 1.5,
        "ticks": "inside",
        "showgrid": True,
        "gridcolor": "rgba(0,0,0,0.15)",
        "gridwidth": 0.5,
        "zeroline": True,
        "zerolinewidth": 1.5,
    },
}

AE_SERIES = [
    (
        "Infrastructure<br>investment",
        "Model_HumanCapital_epsi_igeff25y",
        "Model_HumanCapital_epsi_ig",
        "#1565C0",
    ),
    (
        "Human capital<br>investment",
        "Model_HumanCapital_epsi_cgeeff25y",
        "Model_HumanCapital_epsi_cge",
        "#6A1B9A",
    ),
    (
        "R&D<br>spending",
        "Model_HumanCapital_epsi_cgrd_eff25y",
        "Model_HumanCapital_epsi_cgrd",
        "#2E7D32",
    ),
]

EMDE_SUBPLOTS = [
    {
        "title": "Infrastructure investment",
        "color": "#1565C0",
        "scenarios": [
            (
                "by 2050",
                "EM_Model_HumanCapital_epsiigeff25y",
                "EM_Model_HumanCapital_epsiig",
                "EM_Model_HumanCapital_epsiigeff25ylow",
                "EM_Model_HumanCapital_epsiiglow",
            ),
            (
                "by 2040",
                "EM_Model_HumanCapital_epsiigeff30y",
                "EM_Model_HumanCapital_epsiig",
                "EM_Model_HumanCapital_epsiigeff30ylow",
                "EM_Model_HumanCapital_epsiiglow",
            ),
        ],
    },
    {
        "title": "Human capital investment",
        "color": "#6A1B9A",
        "scenarios": [
            (
                "by 2050",
                "EM_Model_HumanCapital_epsicgeeff25y",
                "EM_Model_HumanCapital_epsicge",
                "EM_Model_HumanCapital_epsicgeeff25ylow",
                "EM_Model_HumanCapital_epsicgelow",
            ),
            (
                "by 2040",
                "EM_Model_HumanCapital_epsicgeeff30y",
                "EM_Model_HumanCapital_epsicge",
                "EM_Model_HumanCapital_epsicgeeff30ylow",
                "EM_Model_HumanCapital_epsicgelow",
            ),
        ],
    },
]

BAR_NAME = "Closing the gap in the baseline"
MARKER_NAME = "Efficiency improvement from a higher initial gap"


def load_target_row():
    df = pd.read_csv(INPUT_CSV)
    df = df.rename(columns={df.columns[0]: "date"})
    df["year"] = df["date"].str.extract(r"(\d{4})").astype(int)
    return df[df["year"] == TARGET_YEAR].iloc[0]


def output_paths(output_stem):
    FIGURES_DIR.mkdir(parents=True, exist_ok=True)
    return (
        FIGURES_DIR / f"{output_stem}.png",
        FIGURES_DIR / f"{output_stem}.pdf",
        FIGURES_DIR / f"{output_stem}.html",
        FIGURES_DIR / f"{output_stem}.csv",
    )


def save_figure(fig, output_stem, width_px, display_cm, csv_data):
    png_path, pdf_path, html_path, csv_path = output_paths(output_stem)
    smart_save_image(fig, png_path, display_cm)
    write_pdf(fig, pdf_path, width_px, display_cm[0])
    fig.write_html(html_path, auto_open=False)
    csv_data.to_csv(csv_path, index=False)
    print(f"  Saved {png_path.name}, {pdf_path.name}, {html_path.name}, and CSV data")


def add_row_labels(fig, font_px, debt_axis):
    """Rotated row labels anchored at the plot-area edge and offset by a fixed
    pixel xshift (as in plotEfficiencyIRF.py), so both rows' labels align."""
    row_labels = (
        ("Output", sum(fig.layout.yaxis.domain) / 2),
        ("Debt-to-GDP Ratio", sum(debt_axis.domain) / 2),
    )
    for text, y in row_labels:
        fig.add_annotation(
            text=text,
            textangle=-90,
            xref="paper",
            yref="paper",
            x=0,
            y=y,
            xshift=-36,
            showarrow=False,
            xanchor="center",
            yanchor="middle",
            font=dict(family=FONT_FAMILY, size=font_px),
        )


def apply_axes(fig, font_px):
    axes = STYLE["axes"]
    fig.update_xaxes(
        showgrid=False,
        linecolor=axes["linecolor"],
        linewidth=axes["linewidth"],
        ticks=axes["ticks"],
        tickfont=dict(size=font_px),
        title=None,
    )
    fig.update_yaxes(
        rangemode="tozero",
        showgrid=axes["showgrid"],
        gridcolor=axes["gridcolor"],
        gridwidth=axes["gridwidth"],
        zeroline=axes["zeroline"],
        zerolinewidth=axes["zerolinewidth"],
        zerolinecolor="black",
        linecolor=axes["linecolor"],
        linewidth=axes["linewidth"],
        ticks=axes["ticks"],
        tickfont=dict(size=font_px),
        title=None,
    )


def plot_ae(row):
    output_stem = "policyEfficiencyAE_yd"
    width_px, height_px = chart_render_px(output_stem, (7.5, 7.0))
    display_cm = chart_display_cm(output_stem, (7.5, 7.0))
    font_px = font_px_for_pt(7, width_px, display_cm[0])

    def diffs(variable):
        return [
            row[f"{efficiency}___{variable}"] - row[f"{baseline}___{variable}"]
            for _label, efficiency, baseline, _color in AE_SERIES
        ]

    fig = make_subplots(
        rows=2,
        cols=1,
        shared_xaxes=True,
        row_heights=[2 / 3, 1 / 3],
        vertical_spacing=0.10,
    )
    for subplot_row, variable in ((1, "yd"), (2, "by_yss")):
        fig.add_trace(
            go.Bar(
                x=[label for label, *_ in AE_SERIES],
                y=diffs(variable),
                marker_color=[color for *_, color in AE_SERIES],
                showlegend=False,
            ),
            row=subplot_row,
            col=1,
        )
    fig.update_layout(
        template=STYLE["template"],
        width=width_px,
        height=height_px,
        # Same vertical margins as the EMDE panel (which needs them for its
        # legend and subplot titles), so the rows of both panels align on the
        # page.
        margin={"t": 72, "b": 35, "l": 48, "r": 8},
        font=dict(family=FONT_FAMILY, size=font_px),
        bargap=0.35,
    )
    apply_axes(fig, font_px)
    add_row_labels(fig, font_px, fig.layout.yaxis2)

    csv_data = pd.DataFrame(
        {
            "category": [label.replace("<br>", " ") for label, *_ in AE_SERIES],
            "additional_gain_2050": [round(value, 3) for value in diffs("yd")],
            "additional_debt_2050": [round(value, 3) for value in diffs("by_yss")],
        }
    )
    save_figure(fig, output_stem, width_px, display_cm, csv_data)


def plot_emde(row):
    output_stem = "policyEfficiencyEM_yd"
    width_px, height_px = chart_render_px(output_stem, (7.5, 7.0))
    display_cm = chart_display_cm(output_stem, (7.5, 7.0))
    font_px = font_px_for_pt(6.5, width_px, display_cm[0])
    legend_font_px = font_px_for_pt(6.2, width_px, display_cm[0])
    title_font_px = font_px_for_pt(6.5, width_px, display_cm[0])

    fig = make_subplots(
        rows=2,
        cols=2,
        shared_xaxes=True,
        row_heights=[2 / 3, 1 / 3],
        subplot_titles=[subplot["title"] for subplot in EMDE_SUBPLOTS] + ["", ""],
        horizontal_spacing=0.19,
        vertical_spacing=0.10,
    )
    records = []
    for col, subplot in enumerate(EMDE_SUBPLOTS, start=1):
        labels = [scenario[0] for scenario in subplot["scenarios"]]
        color = subplot["color"]
        values = {}
        for subplot_row, variable in ((1, "yd"), (2, "by_yss")):
            values[variable] = {
                "baseline": [
                    row[f"{scenario[1]}___{variable}"]
                    - row[f"{scenario[2]}___{variable}"]
                    for scenario in subplot["scenarios"]
                ],
                "higher_gap": [
                    row[f"{scenario[3]}___{variable}"]
                    - row[f"{scenario[4]}___{variable}"]
                    for scenario in subplot["scenarios"]
                ],
            }
            fig.add_trace(
                go.Bar(
                    x=labels,
                    y=values[variable]["baseline"],
                    marker_color=color,
                    showlegend=False,
                ),
                row=subplot_row,
                col=col,
            )
            fig.add_trace(
                go.Scatter(
                    x=labels,
                    y=values[variable]["higher_gap"],
                    mode="markers",
                    marker=dict(symbol="circle", size=10, color=color),
                    showlegend=False,
                ),
                row=subplot_row,
                col=col,
            )

        for idx, label in enumerate(labels):
            records.append(
                {
                    "instrument": subplot["title"],
                    "closure_horizon": label,
                    "calibrated_gap": round(values["yd"]["baseline"][idx], 3),
                    "higher_initial_gap": round(values["yd"]["higher_gap"][idx], 3),
                    "calibrated_gap_debt": round(
                        values["by_yss"]["baseline"][idx], 3
                    ),
                    "higher_initial_gap_debt": round(
                        values["by_yss"]["higher_gap"][idx], 3
                    ),
                }
            )

    neutral = "#757575"
    fig.add_trace(
        go.Bar(
            x=[None],
            y=[None],
            marker_color=neutral,
            name=BAR_NAME,
            showlegend=True,
        ),
        row=1,
        col=1,
    )
    fig.add_trace(
        go.Scatter(
            x=[None],
            y=[None],
            mode="markers",
            marker=dict(symbol="circle", size=10, color=neutral),
            name=MARKER_NAME,
            showlegend=True,
        ),
        row=1,
        col=1,
    )

    for annotation in fig.layout.annotations:
        annotation.font = dict(family=FONT_FAMILY, size=title_font_px)
        annotation.y += 0.07

    fig.update_layout(
        template=STYLE["template"],
        width=width_px,
        height=height_px,
        margin={"t": 72, "b": 35, "l": 48, "r": 8},
        font=dict(family=FONT_FAMILY, size=font_px),
        bargap=0.45,
        legend=dict(
            orientation="h",
            yref="container",
            yanchor="top",
            y=0.99,
            xanchor="center",
            x=0.5,
            font=dict(size=legend_font_px),
        ),
    )
    apply_axes(fig, font_px)
    add_row_labels(fig, font_px, fig.layout.yaxis3)
    save_figure(
        fig,
        output_stem,
        width_px,
        display_cm,
        pd.DataFrame(records),
    )


def main():
    row = load_target_row()
    plot_ae(row)
    plot_emde(row)


if __name__ == "__main__":
    main()
