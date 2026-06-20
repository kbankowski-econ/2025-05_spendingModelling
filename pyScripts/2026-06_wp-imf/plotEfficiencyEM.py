"""
Figure: EMDE spending efficiency (panel b of fig:efficiency).

1x2 panel of the additional EMDE output gain in 2050 from gradually closing
spending-efficiency gaps, for infrastructure (left) and human capital (right),
at two closure horizons. Bars show the baseline (low-initial-gap) response;
circle markers show the counterpart when the initial gap is higher ("low"
model variant).

Standalone: this script has no local-module dependencies. Its only input is the
data file docs/csvFiles/figureNumbers_yearly.csv; it writes the PNG/HTML/CSV
into docs/2026-06_wp-imf/figures/. Requires pandas + plotly (with a Kaleido
backend for PNG export).
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

# --- Styling (inlined from the former chartConfig.json) -----------------------
STYLE = {
    "template": "simple_white",
    "font_size": 22,
    "margins": {"t": 90, "b": 30, "l": 25, "r": 25},  # headroom for legend+titles
    "legend": {"orientation": "h", "xanchor": "center", "x": 0.5, "font_size": 14},
    "axes": {"linecolor": "black", "linewidth": 1.5, "ticks": "inside",
             "showgrid": True, "gridcolor": "rgba(0,0,0,0.15)", "gridwidth": 0.5,
             "zeroline": True, "zerolinewidth": 1.5, "tickfont_size": 16},
    "neutral_color": "#757575",
}

# Each subplot shares the same structure; only column prefixes change.
SUBPLOTS = [
    {
        "title": "Infrastructure investment",
        "color": "#1565C0",
        "scenarios": [
            ("by 2050",
             "EM_Model_HumanCapital_epsiigeff25y___yd",
             "EM_Model_HumanCapital_epsiig___yd",
             "EM_Model_HumanCapital_epsiigeff25ylow___yd",
             "EM_Model_HumanCapital_epsiiglow___yd"),
            ("by 2040",
             "EM_Model_HumanCapital_epsiigeff30y___yd",
             "EM_Model_HumanCapital_epsiig___yd",
             "EM_Model_HumanCapital_epsiigeff30ylow___yd",
             "EM_Model_HumanCapital_epsiiglow___yd"),
        ],
    },
    {
        "title": "Human capital investment",
        "color": "#6A1B9A",
        "scenarios": [
            ("by 2050",
             "EM_Model_HumanCapital_epsicgeeff25y___yd",
             "EM_Model_HumanCapital_epsicge___yd",
             "EM_Model_HumanCapital_epsicgeeff25ylow___yd",
             "EM_Model_HumanCapital_epsicgelow___yd"),
            ("by 2040",
             "EM_Model_HumanCapital_epsicgeeff30y___yd",
             "EM_Model_HumanCapital_epsicge___yd",
             "EM_Model_HumanCapital_epsicgeeff30ylow___yd",
             "EM_Model_HumanCapital_epsicgelow___yd"),
        ],
    },
]

BAR_NAME = "Closing the gap in the baseline"
MARKER_NAME = "Efficiency improvement from a higher initial gap"

TARGET_YEAR = 2050
OUTPUT_STEM = "efficiencyEM_yd"

# Both sizes come from chartTable.csv: render = original chart size (canvas,
# controls fonts/quality); display = size shown in the paper (aspect preserved).
WIDTH_PX, HEIGHT_PX = chart_render_px(OUTPUT_STEM, (14.82, 9.53))
DISPLAY_CM = chart_display_cm(OUTPUT_STEM, (14.82, 9.53))

# Font matching the paper: Palatino (the paper's mathpazo), sized so the chart
# text renders at a fixed point size on the page (recomputed from render/display).
TARGET_FONT_PT = 8
FONT_FAMILY = "Palatino, 'Palatino Linotype', 'Book Antiqua', serif"
FONT_PX = font_px_for_pt(TARGET_FONT_PT, WIDTH_PX, DISPLAY_CM[0])
LEGEND_FONT_PT = 7   # legend smaller than the 8pt tick labels
LEGEND_FONT_PX = font_px_for_pt(LEGEND_FONT_PT, WIDTH_PX, DISPLAY_CM[0])
TITLE_FONT_PT = 9    # subplot titles a touch larger than the tick labels
TITLE_FONT_PX = font_px_for_pt(TITLE_FONT_PT, WIDTH_PX, DISPLAY_CM[0])


def load_data():
    df = pd.read_csv(INPUT_CSV)
    df = df.rename(columns={df.columns[0]: "date"})
    df["year"] = df["date"].str.extract(r"(\d{4})").astype(int)
    return df


def main():
    df = load_data()
    row = df[df["year"] == TARGET_YEAR].iloc[0]

    fig = make_subplots(
        rows=1, cols=2,
        subplot_titles=[sp["title"] for sp in SUBPLOTS],
        horizontal_spacing=0.12,
    )

    csv_rows = []
    for col_idx, sp in enumerate(SUBPLOTS, start=1):
        labels      = [s[0] for s in sp["scenarios"]]
        values      = [row[s[1]] - row[s[2]] for s in sp["scenarios"]]
        marker_vals = [row[s[3]] - row[s[4]] for s in sp["scenarios"]]

        # Real traces keep each subplot's own color; the legend swatches come
        # from the neutral-grey dummy traces added after this loop, so they
        # work for both blue (infrastructure) and purple (human capital).
        color = sp["color"]
        fig.add_trace(
            go.Bar(
                x=labels,
                y=values,
                marker_color=color,
                showlegend=False,
            ),
            row=1, col=col_idx,
        )
        fig.add_trace(
            go.Scatter(
                x=labels,
                y=marker_vals,
                mode="markers",
                marker=dict(
                    symbol="circle",
                    size=14,
                    color=color,
                    line=dict(color=color, width=2),
                ),
                showlegend=False,
            ),
            row=1, col=col_idx,
        )

        for lbl, v, m in zip(labels, values, marker_vals):
            csv_rows.append({
                "shock": sp["title"],
                "scenario": lbl.replace("<br>", " "),
                "gain_low_initial_gap": round(v, 3),
                "gain_high_initial_gap": round(m, 3),
            })

    # Legend-only dummy traces in neutral grey so the legend swatches cover
    # both the blue (infrastructure) and purple (human capital) subplots.
    legend_color = STYLE["neutral_color"]
    fig.add_trace(
        go.Bar(
            x=[None], y=[None],
            marker_color=legend_color,
            name=BAR_NAME,
            showlegend=True,
        ),
        row=1, col=1,
    )
    fig.add_trace(
        go.Scatter(
            x=[None], y=[None],
            mode="markers",
            marker=dict(
                symbol="circle",
                size=14,
                color=legend_color,
                line=dict(color=legend_color, width=2),
            ),
            name=MARKER_NAME,
            showlegend=True,
        ),
        row=1, col=1,
    )

    fig.update_layout(
        template=STYLE["template"],
        width=WIDTH_PX,
        height=HEIGHT_PX,
        margin=STYLE["margins"],
        font=dict(family=FONT_FAMILY, size=FONT_PX),
        bargap=0.45,
        legend=dict(
            orientation=STYLE["legend"]["orientation"],
            yanchor="bottom",
            y=1.30,
            xanchor=STYLE["legend"]["xanchor"],
            x=STYLE["legend"]["x"],
            font=dict(size=LEGEND_FONT_PX),
        ),
    )

    # Subplot titles use the regular tick font size; nudge them up to open
    # a little more breathing room between the title and the subplot.
    for annotation in fig["layout"]["annotations"]:
        annotation["font"] = dict(size=TITLE_FONT_PX)
        annotation["y"] = annotation["y"] + 0.11

    axes = STYLE["axes"]
    for col in (1, 2):
        fig.update_xaxes(
            showgrid=False,
            linecolor=axes["linecolor"],
            linewidth=axes["linewidth"],
            ticks=axes["ticks"],
            tickangle=0,
            tickfont=dict(size=FONT_PX),
            title=None,
            row=1, col=col,
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
            row=1, col=col,
        )

    FIGURES_DIR.mkdir(parents=True, exist_ok=True)
    png_path = FIGURES_DIR / f"{OUTPUT_STEM}.png"
    pdf_path = FIGURES_DIR / f"{OUTPUT_STEM}.pdf"
    html_path = FIGURES_DIR / f"{OUTPUT_STEM}.html"
    smart_save_image(fig, png_path, DISPLAY_CM)
    write_pdf(fig, pdf_path, WIDTH_PX, DISPLAY_CM[0])  # vector PDF at the display size
    fig.write_html(html_path, auto_open=True)
    print(f"  Saved {png_path.name}, {pdf_path.name} and {html_path.name}")

    csv_data = pd.DataFrame(csv_rows)
    csv_path = FIGURES_DIR / f"{OUTPUT_STEM}.csv"
    csv_data.to_csv(csv_path, index=False)
    print(f"  Exported data to {csv_path.name}")


if __name__ == "__main__":
    main()
