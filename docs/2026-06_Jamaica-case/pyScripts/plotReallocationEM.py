"""
Jamaica case deck (local copy): grouped bar chart of the EMDE output response
(yd, % deviation from baseline) to two expenditure-reallocation shocks, at four
horizons. Ported from pyScripts/2026-04_spendingModelling so the deck's bar
charts can be tailored for Jamaica independently of the FM-panel project.

Shocks:
  - Infrastructure investment -> EM_Model_HumanCapital_epsiig
  - Human capital investment  -> EM_Model_HumanCapital_epsicge
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


SERIES = [
    ("EM_Model_HumanCapital_epsiig___yd",   "Infrastructure investment", "#1565C0"),
    ("EM_Model_HumanCapital_epsicge___yd",  "Human capital investment",  "#6A1B9A"),
]

YEARS = [2026, 2030, 2040, 2050]
# Convention: first label as full yyyy, the rest as two-digit yy.
YEAR_LABELS = [str(YEARS[0])] + [f"{y % 100:02d}" for y in YEARS[1:]]

INPUT_CSV = "../../csvFiles/figureNumbers_yearly.csv"
OUTPUT_STEM = "reallocationEM_yd"
WATERMARK = "Fiscal Monitor, October 2025"


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
    df = df[df["year"].isin(YEARS)].sort_values("year")

    fig = go.Figure()
    label_font = chart_cfg["legend"]["font_size"]
    for s, (col, label, color) in enumerate(SERIES):
        yvals = df.set_index("year").loc[YEARS, col].values
        fig.add_trace(
            go.Bar(
                x=YEAR_LABELS,
                y=yvals,
                name=label,
                marker_color=color,
            )
        )
        # Value labels on a light-yellow background. Grouped bars sit at the
        # category index, offset by +/-0.2 for the two series.
        xoff = -0.2 if s == 0 else 0.2
        for i, v in enumerate(yvals):
            fig.add_annotation(
                x=i + xoff, y=v, text=f"{v:.1f}", showarrow=False, yshift=10,
                font=dict(size=label_font, color=color),
                bgcolor="#FFF9C4", borderpad=2,
            )

    margins = dict(chart_cfg["margins"])
    margins["t"] = 60

    fig.update_layout(
        template=chart_cfg["template"],
        width=chart_cfg["width"],
        height=chart_cfg["height"],
        margin=margins,
        font=dict(size=chart_cfg["font_size"]),
        barmode="group",
        bargap=0.2,
        bargroupgap=0.05,
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

    # Source watermark (faint diagonal overlay).
    fig.add_annotation(
        text=WATERMARK, xref="paper", yref="paper", x=0.5, y=0.45,
        showarrow=False, textangle=-20,
        font=dict(size=40, color="#9E9E9E"), opacity=0.25,
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
