"""
Figure: AE spending efficiency (panel a of fig:efficiency).

Simple bar chart of the additional AE output gain in 2050 from gradually closing
spending-efficiency gaps over 25 years, measured as (eff25y scenario) minus
(baseline shock) for each expenditure category. Bars sorted ascending.

Standalone: this script has no local-module dependencies. Its only input is the
data file docs/csvFiles/figureNumbers_yearly.csv; it writes the PNG/HTML/CSV
into docs/2026-06_wp-imf/figures/. Requires pandas + plotly (with a Kaleido
backend for PNG export).
"""
from pathlib import Path

import pandas as pd
import plotly.graph_objects as go

from wp_charts import chart_render_px, chart_display_cm, font_px_for_pt, smart_save_image, write_pdf

# --- Paths (resolved from this file; the data CSV is the only external input) -
SCRIPT_DIR = Path(__file__).resolve().parent
PROJECT_ROOT = SCRIPT_DIR.parents[1]
INPUT_CSV = PROJECT_ROOT / "docs" / "csvFiles" / "figureNumbers_yearly.csv"
FIGURES_DIR = PROJECT_ROOT / "docs" / "2026-06_wp-imf" / "figures"

# --- Styling (inlined from the former chartConfig.json) -----------------------
STYLE = {
    "template": "simple_white",
    "font_size": 22,
    "margins": {"t": 20, "b": 30, "l": 25, "r": 25},  # no legend: trim top space
    "axes": {"linecolor": "black", "linewidth": 1.5, "ticks": "inside",
             "showgrid": True, "gridcolor": "rgba(0,0,0,0.15)", "gridwidth": 0.5,
             "zeroline": True, "zerolinewidth": 1.5, "tickfont_size": 16},
}

# (label, with-efficiency column, baseline-shock column, color)
SERIES = [
    ("Infrastructure<br>investment",
     "Model_HumanCapital_epsi_igeff25y___yd",
     "Model_HumanCapital_epsi_ig___yd",
     "#1565C0"),
    ("Human capital<br>investment",
     "Model_HumanCapital_epsi_cgeeff25y___yd",
     "Model_HumanCapital_epsi_cge___yd",
     "#6A1B9A"),
    ("R&D<br>spending",
     "Model_HumanCapital_epsi_cgrd_eff25y___yd",
     "Model_HumanCapital_epsi_cgrd___yd",
     "#2E7D32"),
]

TARGET_YEAR = 2050
OUTPUT_STEM = "efficiencyAE_yd"

# Both sizes come from chartTable.csv: render = original chart size (canvas,
# controls fonts/quality); display = size shown in the paper (aspect preserved).
WIDTH_PX, HEIGHT_PX = chart_render_px(OUTPUT_STEM, (14.82, 9.53))
DISPLAY_CM = chart_display_cm(OUTPUT_STEM, (14.82, 9.53))

# Font matching the paper: Palatino (the paper's mathpazo), sized so the chart
# text renders at a fixed point size on the page (recomputed from render/display).
TARGET_FONT_PT = 8
FONT_FAMILY = "Palatino, 'Palatino Linotype', 'Book Antiqua', serif"
FONT_PX = font_px_for_pt(TARGET_FONT_PT, WIDTH_PX, DISPLAY_CM[0])


def load_data():
    df = pd.read_csv(INPUT_CSV)
    df = df.rename(columns={df.columns[0]: "date"})
    df["year"] = df["date"].str.extract(r"(\d{4})").astype(int)
    return df


def main():
    df = load_data()
    row = df[df["year"] == TARGET_YEAR].iloc[0]

    bars = [
        (label, row[with_eff] - row[baseline], color)
        for label, with_eff, baseline, color in SERIES
    ]
    bars.sort(key=lambda b: b[1])

    labels = [b[0] for b in bars]
    values = [b[1] for b in bars]
    colors = [b[2] for b in bars]

    fig = go.Figure(
        go.Bar(
            x=labels,
            y=values,
            marker_color=colors,
            showlegend=False,
        )
    )

    fig.update_layout(
        template=STYLE["template"],
        width=WIDTH_PX,
        height=HEIGHT_PX,
        margin=STYLE["margins"],
        font=dict(family=FONT_FAMILY, size=FONT_PX),
        bargap=0.35,
    )

    axes = STYLE["axes"]
    fig.update_xaxes(
        showgrid=False,
        linecolor=axes["linecolor"],
        linewidth=axes["linewidth"],
        ticks=axes["ticks"],
        tickangle=0,
        tickfont=dict(size=FONT_PX),
        title=None,
    )
    fig.update_yaxes(
        showgrid=axes["showgrid"],
        gridcolor=axes["gridcolor"],
        gridwidth=axes["gridwidth"],
        zeroline=axes["zeroline"],
        zerolinewidth=axes["zerolinewidth"],
        zerolinecolor="black",
        linecolor=axes["linecolor"],
        linewidth=axes["linewidth"],
        ticks=axes["ticks"],
        tickfont=dict(size=FONT_PX),
        title=None,
    )

    FIGURES_DIR.mkdir(parents=True, exist_ok=True)
    png_path = FIGURES_DIR / f"{OUTPUT_STEM}.png"
    pdf_path = FIGURES_DIR / f"{OUTPUT_STEM}.pdf"
    html_path = FIGURES_DIR / f"{OUTPUT_STEM}.html"
    smart_save_image(fig, png_path, DISPLAY_CM)
    write_pdf(fig, pdf_path, WIDTH_PX, DISPLAY_CM[0])  # vector PDF at the display size
    fig.write_html(html_path, auto_open=True)
    print(f"  Saved {png_path.name}, {pdf_path.name} and {html_path.name}")

    csv_data = pd.DataFrame({"category": labels, "additional_gain_2050": [round(v, 3) for v in values]})
    csv_path = FIGURES_DIR / f"{OUTPUT_STEM}.csv"
    csv_data.to_csv(csv_path, index=False)
    print(f"  Exported data to {csv_path.name}")


if __name__ == "__main__":
    main()
