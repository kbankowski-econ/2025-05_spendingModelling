"""Policy-experiment output gains from permanently closing efficiency gaps."""

from pathlib import Path

import pandas as pd
import plotly.graph_objects as go

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

STYLE = {
    "template": "simple_white",
    "margins": {"t": 40, "b": 30, "l": 25, "r": 25},
    "legend": {"orientation": "h", "xanchor": "center", "x": 0.5},
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

PANELS = [
    {
        "output_stem": "policyEfficiencyAE_yd",
        "series": [
            ("Model_HumanCapital_effgi_perm___yd", "Infrastructure", "#1565C0"),
            ("Model_HumanCapital_effge_perm___yd", "Human capital", "#6A1B9A"),
            ("Model_HumanCapital_effgrd_perm___yd", "R&D", "#2E7D32"),
        ],
    },
    {
        "output_stem": "policyEfficiencyEM_yd",
        "series": [
            ("EM_Model_HumanCapital_effgi_perm___yd", "Infrastructure", "#1565C0"),
            ("EM_Model_HumanCapital_effge_perm___yd", "Human capital", "#6A1B9A"),
        ],
    },
]

YEARS = [2026, 2030, 2040, 2050]
HORIZON_LABELS = ["1y", "5y", "15y", "25y"]
FONT_FAMILY = "Palatino, 'Palatino Linotype', 'Book Antiqua', serif"


def load_data():
    df = pd.read_csv(INPUT_CSV)
    df = df.rename(columns={df.columns[0]: "date"})
    df["year"] = df["date"].str.extract(r"(\d{4})").astype(int)
    return df[df["year"].isin(YEARS)].set_index("year").loc[YEARS]


def plot_panel(df, panel):
    output_stem = panel["output_stem"]
    width_px, height_px = chart_render_px(output_stem, (7.5, 5.0))
    display_cm = chart_display_cm(output_stem, (7.5, 5.0))
    font_px = font_px_for_pt(8, width_px, display_cm[0])
    legend_font_px = font_px_for_pt(7, width_px, display_cm[0])

    fig = go.Figure()
    for column, label, color in panel["series"]:
        fig.add_trace(
            go.Bar(
                x=HORIZON_LABELS,
                y=df[column].values,
                name=label,
                marker_color=color,
            )
        )

    fig.update_layout(
        template=STYLE["template"],
        width=width_px,
        height=height_px,
        margin=STYLE["margins"],
        font=dict(family=FONT_FAMILY, size=font_px),
        barmode="group",
        bargap=0.2,
        bargroupgap=0.05,
        legend=dict(
            orientation=STYLE["legend"]["orientation"],
            yref="container",
            yanchor="top",
            y=0.99,
            xanchor=STYLE["legend"]["xanchor"],
            x=STYLE["legend"]["x"],
            font=dict(size=legend_font_px),
        ),
    )

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

    FIGURES_DIR.mkdir(parents=True, exist_ok=True)
    png_path = FIGURES_DIR / f"{output_stem}.png"
    pdf_path = FIGURES_DIR / f"{output_stem}.pdf"
    html_path = FIGURES_DIR / f"{output_stem}.html"
    smart_save_image(fig, png_path, display_cm)
    write_pdf(fig, pdf_path, width_px, display_cm[0])
    fig.write_html(html_path, auto_open=False)

    export = pd.DataFrame({"horizon": HORIZON_LABELS})
    for column, label, _ in panel["series"]:
        export[label] = df[column].round(3).values
    export.to_csv(FIGURES_DIR / f"{output_stem}.csv", index=False)
    print(f"  Saved {png_path.name}, {pdf_path.name}, {html_path.name}, and CSV data")


def main():
    df = load_data()
    for panel in PANELS:
        plot_panel(df, panel)


if __name__ == "__main__":
    main()
