"""
Simple bar chart (Panel 6 of the replication figure): AE output gain in 2050
from the 50/50 human-capital + R&D mix, at three levels of technology
diffusion. Bars sorted ascending by effect.
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


# (label, column)
SERIES = [
    ("Limited diffusion<br>of technology in<br>private sector",
     "Model_HumanCapital_epsicgrd_cge_limt___yd"),
    ("Policy mix<br>(baseline)",
     "Model_HumanCapital_epsi_cgeCgrd___yd"),
    ("Improved diffusion<br>of technology in<br>private sector",
     "Model_HumanCapital_epsicgrd_cge_adt___yd"),
]

BAR_COLOR = "#1565C0"  # blue
TARGET_YEAR = 2050
INPUT_CSV = "../../docs/csvFiles/figureNumbers_yearly.csv"
OUTPUT_STEM = "diffusionAE_yd"


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

    bars = [(label, row[col]) for label, col in SERIES]
    bars.sort(key=lambda b: b[1])

    labels = [b[0] for b in bars]
    values = [b[1] for b in bars]

    fig = go.Figure(
        go.Bar(
            x=labels,
            y=values,
            marker_color=BAR_COLOR,
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

    csv_data = pd.DataFrame({
        "scenario": [lbl.replace("<br>", " ") for lbl in labels],
        "yd_2050": [round(v, 3) for v in values],
    })
    csv_path = figures_dir / f"{OUTPUT_STEM}.csv"
    csv_data.to_csv(csv_path, index=False)
    print(f"  Exported data to {csv_path.name}")


if __name__ == "__main__":
    main()
