"""
IRF chart: aggregate demand response (yd, % deviation) for three human-capital
related spending shocks.

Series (from docs/csvFiles/figureNumbers_yearly.csv):
  - Model_HumanCapital_epsi_cge___yd       (Human capital investment shock)
  - Model_HumanCapital_epsi_cgrd___yd      (R&D investment shock)
  - Model_HumanCapital_epsi_cgeCgrd___yd   (Joint human capital + R&D shock)
"""
import pandas as pd
import plotly.graph_objects as go
import plotly.io as pio
from fiscal_common import (
    load_config,
    load_chart_config,
    ensure_output_dir,
    resolve_from_config,
    smart_save_image,
)


SERIES = [
    ("Model_HumanCapital_epsi_cgeCgrd___yd",  "Joint human capital + R&D", "#E65100"),
    ("Model_HumanCapital_epsi_cge___yd",      "Human capital investment",  "#6A1B9A"),
    ("Model_HumanCapital_epsi_cgrd___yd",     "R&D investment",            "#2E7D32"),
]

PLOT_START_YEAR = 2026
X_TICKS = [2026, 2031, 2036, 2041, 2046, 2050]
# Show the first tick as full 4-digit year, abbreviate the rest to 2 digits.
X_TICK_LABELS = [str(X_TICKS[0])] + [f"{y % 100:02d}" for y in X_TICKS[1:]]

INPUT_CSV = "../../docs/csvFiles/figureNumbers_yearly.csv"
OUTPUT_STEM = "humanCapital_yd_IRF"


def load_data():
    df = pd.read_csv(resolve_from_config(INPUT_CSV))
    df = df.rename(columns={df.columns[0]: "date"})
    df["year"] = df["date"].str.extract(r"(\d{4})").astype(int)
    return df


def main():
    config = load_config()
    chart_cfg = load_chart_config()["styling"]
    output_dir = ensure_output_dir(config)

    df = load_data()
    df = df[df["year"] >= PLOT_START_YEAR]

    fig = go.Figure()

    for col, label, color in SERIES:
        fig.add_trace(
            go.Scatter(
                x=df["year"],
                y=df[col],
                mode="lines",
                name=label,
                line=dict(color=color, width=chart_cfg["line_widths"]["standard"]),
            )
        )

    margins = dict(chart_cfg["margins"])
    margins["t"] = 60

    fig.update_layout(
        template=chart_cfg["template"],
        width=chart_cfg["width"],
        height=chart_cfg["height"],
        margin=margins,
        font=dict(size=chart_cfg["font_size"]),
        legend=dict(
            orientation=chart_cfg["legend"]["orientation"],
            yanchor=chart_cfg["legend"]["yanchor"],
            y=chart_cfg["legend"]["y"],
            xanchor=chart_cfg["legend"]["xanchor"],
            x=chart_cfg["legend"]["x"],
            font=dict(size=chart_cfg["legend"]["font_size"]),
        ),
    )

    axes = chart_cfg["axes"]
    fig.update_xaxes(
        showgrid=axes["showgrid"],
        gridcolor=axes["gridcolor"],
        gridwidth=axes["gridwidth"],
        linecolor=axes["linecolor"],
        linewidth=axes["linewidth"],
        ticks=axes["ticks"],
        tickfont=dict(size=axes["tickfont_size"]),
        tickmode="array",
        tickvals=X_TICKS,
        ticktext=X_TICK_LABELS,
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

    figures_dir = output_dir / "figures"
    figures_dir.mkdir(parents=True, exist_ok=True)
    png_path = figures_dir / f"{OUTPUT_STEM}.png"
    html_path = figures_dir / f"{OUTPUT_STEM}.html"
    smart_save_image(fig, png_path)
    fig.write_html(html_path, auto_open=config["output_settings"].get("auto_open_html", False))
    print(f"  Saved {png_path.name} and {html_path.name}")

    csv_cols = ["year"] + [c for c, _, _ in SERIES]
    csv_data = df[csv_cols].copy()
    rename_map = {c: label for c, label, _ in SERIES}
    csv_data = csv_data.rename(columns=rename_map).round(3)
    csv_path = figures_dir / f"{OUTPUT_STEM}.csv"
    csv_data.to_csv(csv_path, index=False)
    print(f"  Exported data to {csv_path.name}")


if __name__ == "__main__":
    main()
