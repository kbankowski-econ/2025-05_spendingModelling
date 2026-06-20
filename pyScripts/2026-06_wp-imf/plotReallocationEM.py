"""
Figure: EMDE reallocation (panel b of fig:reallocation).

Grouped bar chart of EMDE output response (yd, % deviation from baseline) to two
expenditure-reallocation shocks, at four horizons (no R&D channel for EMDEs).

Shocks:
  - Infrastructure investment -> EM_Model_HumanCapital_epsiig
  - Human capital investment  -> EM_Model_HumanCapital_epsicge

Standalone: this script has no local-module dependencies. Its only input is the
data file docs/csvFiles/figureNumbers_yearly.csv; it writes the PNG/HTML/CSV
into docs/2026-06_wp-imf/figures/. Requires pandas + plotly (with a Kaleido
backend for PNG export).
"""
from pathlib import Path

import pandas as pd
import plotly.graph_objects as go
import plotly.io as pio

# --- Paths (resolved from this file; the data CSV is the only external input) -
SCRIPT_DIR = Path(__file__).resolve().parent
PROJECT_ROOT = SCRIPT_DIR.parents[1]
INPUT_CSV = PROJECT_ROOT / "docs" / "csvFiles" / "figureNumbers_yearly.csv"
FIGURES_DIR = PROJECT_ROOT / "docs" / "2026-06_wp-imf" / "figures"

# --- Styling (inlined from the former chartConfig.json) -----------------------
STYLE = {
    "template": "simple_white",
    "font_size": 22,
    "width": 560,
    "height": 360,
    "margins": {"t": 60, "b": 30, "l": 25, "r": 25},
    "legend": {"orientation": "h", "yanchor": "bottom", "y": 1.02,
               "xanchor": "center", "x": 0.5, "font_size": 14},
    "axes": {"linecolor": "black", "linewidth": 1.5, "ticks": "inside",
             "showgrid": True, "gridcolor": "rgba(0,0,0,0.15)", "gridwidth": 0.5,
             "zeroline": True, "zerolinewidth": 1.5, "tickfont_size": 16},
}

SERIES = [
    ("EM_Model_HumanCapital_epsiig___yd",   "Infrastructure investment", "#1565C0"),
    ("EM_Model_HumanCapital_epsicge___yd",  "Human capital investment",  "#6A1B9A"),
]

YEARS = [2026, 2030, 2040, 2050]
# Convention: first label as full yyyy, the rest as two-digit yy.
YEAR_LABELS = [str(YEARS[0])] + [f"{y % 100:02d}" for y in YEARS[1:]]
OUTPUT_STEM = "reallocationEM_yd"


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
    df = df[df["year"].isin(YEARS)].sort_values("year")

    fig = go.Figure()
    for col, label, color in SERIES:
        fig.add_trace(
            go.Bar(
                x=YEAR_LABELS,
                y=df.set_index("year").loc[YEARS, col].values,
                name=label,
                marker_color=color,
            )
        )

    fig.update_layout(
        template=STYLE["template"],
        width=STYLE["width"],
        height=STYLE["height"],
        margin=STYLE["margins"],
        font=dict(size=STYLE["font_size"]),
        barmode="group",
        bargap=0.2,
        bargroupgap=0.05,
        legend=dict(
            orientation=STYLE["legend"]["orientation"],
            yanchor=STYLE["legend"]["yanchor"],
            y=STYLE["legend"]["y"],
            xanchor=STYLE["legend"]["xanchor"],
            x=STYLE["legend"]["x"],
            font=dict(size=STYLE["legend"]["font_size"]),
        ),
    )

    axes = STYLE["axes"]
    fig.update_xaxes(
        showgrid=False,
        linecolor=axes["linecolor"],
        linewidth=axes["linewidth"],
        ticks=axes["ticks"],
        tickfont=dict(size=axes["tickfont_size"]),
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
        tickfont=dict(size=axes["tickfont_size"]),
        title=None,
    )

    FIGURES_DIR.mkdir(parents=True, exist_ok=True)
    png_path = FIGURES_DIR / f"{OUTPUT_STEM}.png"
    html_path = FIGURES_DIR / f"{OUTPUT_STEM}.html"
    smart_save_image(fig, png_path)
    fig.write_html(html_path, auto_open=False)
    print(f"  Saved {png_path.name} and {html_path.name}")

    csv_cols = ["year"] + [c for c, _, _ in SERIES]
    csv_data = df[csv_cols].copy()
    rename_map = {c: label for c, label, _ in SERIES}
    csv_data = csv_data.rename(columns=rename_map).round(3)
    csv_path = FIGURES_DIR / f"{OUTPUT_STEM}.csv"
    csv_data.to_csv(csv_path, index=False)
    print(f"  Exported data to {csv_path.name}")


if __name__ == "__main__":
    main()
