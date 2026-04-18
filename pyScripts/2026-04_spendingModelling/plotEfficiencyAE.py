"""
Simple bar chart (Panel 3 of the replication figure): additional AE output
gain in 2050 from gradually closing spending-efficiency gaps over 25 years,
measured as (eff25y scenario) minus (baseline shock) for each expenditure
category. Bars sorted descending by size.
"""
import pandas as pd
import plotly.graph_objects as go
from fiscal_common import (
    load_config,
    load_chart_config,
    ensure_output_dir,
    resolve_from_config,
    smart_save_image,
)


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
INPUT_CSV = "../../docs/csvFiles/figureNumbers_yearly.csv"
OUTPUT_STEM = "efficiencyAE_yd"


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

    margins = dict(chart_cfg["margins"])
    margins["t"] = 60

    fig.update_layout(
        template=chart_cfg["template"],
        width=chart_cfg["width"],
        height=chart_cfg["height"],
        margin=margins,
        font=dict(size=chart_cfg["font_size"]),
        bargap=0.35,
    )

    axes = chart_cfg["axes"]
    fig.update_xaxes(
        showgrid=False,
        linecolor=axes["linecolor"],
        linewidth=axes["linewidth"],
        ticks=axes["ticks"],
        tickangle=0,
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

    figures_dir = output_dir / "figures"
    figures_dir.mkdir(parents=True, exist_ok=True)
    png_path = figures_dir / f"{OUTPUT_STEM}.png"
    html_path = figures_dir / f"{OUTPUT_STEM}.html"
    smart_save_image(fig, png_path)
    fig.write_html(html_path, auto_open=config["output_settings"].get("auto_open_html", False))
    print(f"  Saved {png_path.name} and {html_path.name}")

    csv_data = pd.DataFrame({"category": labels, "additional_gain_2050": [round(v, 3) for v in values]})
    csv_path = figures_dir / f"{OUTPUT_STEM}.csv"
    csv_data.to_csv(csv_path, index=False)
    print(f"  Exported data to {csv_path.name}")


if __name__ == "__main__":
    main()
