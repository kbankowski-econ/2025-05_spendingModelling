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
import plotly.io as pio
from plotly.subplots import make_subplots

# --- Paths (resolved from this file; the data CSV is the only external input) -
SCRIPT_DIR = Path(__file__).resolve().parent
PROJECT_ROOT = SCRIPT_DIR.parents[1]
INPUT_CSV = PROJECT_ROOT / "docs" / "csvFiles" / "figureNumbers_yearly.csv"
FIGURES_DIR = PROJECT_ROOT / "docs" / "2026-06_wp-imf" / "figures"

# --- Styling (inlined from the former chartConfig.json) -----------------------
STYLE = {
    "template": "simple_white",
    "font_size": 22,
    "margins": {"t": 140, "b": 30, "l": 25, "r": 25},  # headroom for legend+titles
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

# --- Chart dimensions from the config database (chartTable.csv, in cm) --------
CONFIG_CSV = SCRIPT_DIR / "chartTable.csv"
_CM_TO_PX = 37.795275591  # 1 cm at 96 DPI; rendered at scale=2 -> 192 DPI
DEFAULT_CM = (14.82, 9.53)


def chart_dims_px(stem, default_cm):
    """Return (width_px, height_px) for a chart, reading Width/Height (in cm)
    from chartTable.csv by matching pngFile. Falls back to default_cm if the
    config file or row is missing, so the script still runs standalone."""
    import csv
    width_cm, height_cm = default_cm
    if CONFIG_CSV.exists():
        with CONFIG_CSV.open(newline="", encoding="utf-8") as handle:
            for row in csv.DictReader(handle):
                if Path(row.get("pngFile", "")).name == f"{stem}.png":
                    width_cm, height_cm = float(row["Width"]), float(row["Height"])
                    break
    return round(width_cm * _CM_TO_PX), round(height_cm * _CM_TO_PX)


WIDTH_PX, HEIGHT_PX = chart_dims_px(OUTPUT_STEM, DEFAULT_CM)


def smart_save_image(fig, output_path, scale=2):
    """Write the PNG only if its bytes changed (avoids needless churn)."""
    new_bytes = pio.to_image(fig, format="png", scale=scale)
    if output_path.exists() and output_path.read_bytes() == new_bytes:
        print(f"  [SmartSave] Skipping {output_path.name} (no changes)")
        return False
    output_path.write_bytes(new_bytes)
    print(f"  [SmartSave] Updating {output_path.name}")
    return True


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
        font=dict(size=STYLE["font_size"]),
        bargap=0.45,
        legend=dict(
            orientation=STYLE["legend"]["orientation"],
            yanchor="bottom",
            y=1.32,
            xanchor=STYLE["legend"]["xanchor"],
            x=STYLE["legend"]["x"],
            font=dict(size=STYLE["legend"]["font_size"]),
        ),
    )

    # Subplot titles use the regular tick font size; nudge them up to open
    # a little more breathing room between the title and the subplot.
    for annotation in fig["layout"]["annotations"]:
        annotation["font"] = dict(size=STYLE["axes"]["tickfont_size"])
        annotation["y"] = annotation["y"] + 0.11

    axes = STYLE["axes"]
    for col in (1, 2):
        fig.update_xaxes(
            showgrid=False,
            linecolor=axes["linecolor"],
            linewidth=axes["linewidth"],
            ticks=axes["ticks"],
            tickangle=0,
            tickfont=dict(size=axes["tickfont_size"]),
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
            tickfont=dict(size=axes["tickfont_size"]),
            title=None,
            row=1, col=col,
        )

    FIGURES_DIR.mkdir(parents=True, exist_ok=True)
    png_path = FIGURES_DIR / f"{OUTPUT_STEM}.png"
    html_path = FIGURES_DIR / f"{OUTPUT_STEM}.html"
    smart_save_image(fig, png_path)
    fig.write_html(html_path, auto_open=False)
    print(f"  Saved {png_path.name} and {html_path.name}")

    csv_data = pd.DataFrame(csv_rows)
    csv_path = FIGURES_DIR / f"{OUTPUT_STEM}.csv"
    csv_data.to_csv(csv_path, index=False)
    print(f"  Exported data to {csv_path.name}")


if __name__ == "__main__":
    main()
