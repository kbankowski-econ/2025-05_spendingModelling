"""
Overview panel (advanced economy): impulse responses of the main model variables
to the four standard debt-financed expansion shocks, each a permanent +1% of GDP
increase in one spending instrument with no offsetting cut.

  - Infrastructure investment  -> Model_HumanCapital_exp_igi
  - Human capital investment   -> Model_HumanCapital_exp_ige
  - R&D investment             -> Model_HumanCapital_exp_grd
  - Government consumption      -> Model_HumanCapital_exp_gc

Reads the yearly export docs/csvFiles/figureNumbers_yearly.csv (2025-2050) and
writes a 3x4 grid of % deviations to the working-paper figures directory.
"""
import pandas as pd
import plotly.graph_objects as go
from plotly.subplots import make_subplots
from fiscal_common import (
    load_config,
    load_chart_config,
    ensure_output_dir,
    resolve_from_config,
    smart_save_image,
)

INPUT_CSV = "../../docs/csvFiles/figureNumbers_yearly.csv"
OUTPUT_STEM = "standardShocksAE"

# (model directory, legend label, colour)
SHOCKS = [
    ("Model_HumanCapital_exp_igi", "Infrastructure investment", "#1565C0"),
    ("Model_HumanCapital_exp_ige", "Human capital investment",  "#6A1B9A"),
    ("Model_HumanCapital_exp_grd", "R&D investment",            "#2E7D32"),
    ("Model_HumanCapital_exp_gc",  "Government consumption",     "#757575"),
]

# (variable suffix, panel title); laid out row-major in a 3x4 grid.
PANELS = [
    ("yd",  "Aggregate demand (yd, % dev.)"),
    ("C",   "Household consumption (C, % dev.)"),
    ("Ip",  "Private investment (Ip, % dev.)"),
    ("Igi", "Gov. investment (Igi, % dev.)"),
    ("Gc",  "Gov. consumption (Gc, % dev.)"),
    ("Ige", "Gov. human-capital exp. (Ige, % dev.)"),
    ("Grd", "Gov. R&D expenditure (Grd, % dev.)"),
    ("H",   "Human capital stock (H, % dev.)"),
    ("Lab", "Total labor supply (Lab, % dev.)"),
    ("E",   "Time in education (E, % dev.)"),
    ("TFP", "TFP (% dev.)"),
    ("AAt", "Adopted technology (AAt, % dev.)"),
]

NCOLS = 4
NROWS = 3
TICK_YEARS = [2025, 2030, 2035, 2040, 2045, 2050]
# Convention: first label as full yyyy, the rest as two-digit yy.
TICK_TEXT = [str(TICK_YEARS[0])] + [f"{y % 100:02d}" for y in TICK_YEARS[1:]]


def load_data():
    df = pd.read_csv(resolve_from_config(INPUT_CSV))
    df = df.rename(columns={df.columns[0]: "date"})
    df["year"] = df["date"].astype(str).str.extract(r"(\d{4})").astype(int)
    return df.sort_values("year")


def main():
    config = load_config()
    chart_cfg = load_chart_config()["styling"]
    axes = chart_cfg["axes"]
    df = load_data()
    years = df["year"].values

    fig = make_subplots(
        rows=NROWS, cols=NCOLS,
        subplot_titles=[title for _, title in PANELS],
        horizontal_spacing=0.06, vertical_spacing=0.10,
    )

    for idx, (var, _title) in enumerate(PANELS):
        row, col = idx // NCOLS + 1, idx % NCOLS + 1
        for model, label, color in SHOCKS:
            colname = f"{model}___{var}"
            if colname not in df.columns:
                continue
            fig.add_trace(
                go.Scatter(
                    x=years, y=df[colname].values,
                    name=label, legendgroup=label,
                    line=dict(color=color, width=2.5),
                    showlegend=(idx == 0),   # one legend entry per shock
                ),
                row=row, col=col,
            )

    fig.update_annotations(font_size=14)   # subplot titles

    fig.update_layout(
        template=chart_cfg["template"],
        width=1180, height=760,
        margin=dict(t=70, b=30, l=35, r=20),
        font=dict(size=14),
        legend=dict(
            orientation="h", yanchor="bottom", y=1.04,
            xanchor="center", x=0.5, font=dict(size=15),
        ),
    )
    fig.update_xaxes(
        tickvals=TICK_YEARS, ticktext=TICK_TEXT,
        showgrid=False, linecolor=axes["linecolor"], linewidth=axes["linewidth"],
        ticks=axes["ticks"], tickfont=dict(size=11),
    )
    fig.update_yaxes(
        showgrid=axes["showgrid"], gridcolor=axes["gridcolor"], gridwidth=axes["gridwidth"],
        zeroline=axes["zeroline"], zerolinewidth=axes["zerolinewidth"], zerolinecolor="black",
        linecolor=axes["linecolor"], linewidth=axes["linewidth"],
        ticks=axes["ticks"], tickfont=dict(size=11),
    )

    figures_dir = ensure_output_dir(config) / "figures"
    figures_dir.mkdir(parents=True, exist_ok=True)
    png_path = figures_dir / f"{OUTPUT_STEM}.png"
    smart_save_image(fig, png_path)
    print(f"  Saved {png_path}")


if __name__ == "__main__":
    main()
