"""
Line chart (Jamaica case deck): additional EMDE output gain over time from
gradually closing spending-efficiency gaps, for infrastructure and human
capital, at two closure horizons. The line-chart companion to the grouped
bars in plotEfficiencyEM.py (FM panel 4): each line is the difference
between the efficiency-closing scenario and the corresponding
reallocation-only baseline (the bar chart's low-initial-gap case).
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


# (label, efficiency-scenario column, baseline column, color, dash)
SERIES = [
    ("Infrastructure, closing by 2050",
     "EM_Model_HumanCapital_epsiigeff25y___yd",
     "EM_Model_HumanCapital_epsiig___yd",
     "#1565C0", "solid"),
    ("Infrastructure, closing by 2040",
     "EM_Model_HumanCapital_epsiigeff30y___yd",
     "EM_Model_HumanCapital_epsiig___yd",
     "#1565C0", "dash"),
    ("Human capital, closing by 2050",
     "EM_Model_HumanCapital_epsicgeeff25y___yd",
     "EM_Model_HumanCapital_epsicge___yd",
     "#6A1B9A", "solid"),
    ("Human capital, closing by 2040",
     "EM_Model_HumanCapital_epsicgeeff30y___yd",
     "EM_Model_HumanCapital_epsicge___yd",
     "#6A1B9A", "dash"),
]

# Legend shows the dash styles only (grey), as the colors are the same as in
# the companion bar chart: blue infrastructure, purple human capital.
LEGEND_ENTRIES = [("Closing by 2050", "solid"), ("Closing by 2040", "dash")]

FIRST_YEAR = 2025
LAST_YEAR = 2050
# Convention: first label as full yyyy, the rest as two-digit yy.
TICK_YEARS = [2030, 2035, 2040, 2045, 2050]
TICK_LABELS = [str(TICK_YEARS[0])] + [f"{y % 100:02d}" for y in TICK_YEARS[1:]]

INPUT_CSV = "../../csvFiles/figureNumbers_yearly.csv"
OUTPUT_STEM = "efficiencyEM_yd_lines"


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
    df = df[(df["year"] >= FIRST_YEAR) & (df["year"] <= LAST_YEAR)].sort_values("year")

    fig = go.Figure()
    for label, scenario_col, base_col, color, dash in SERIES:
        fig.add_trace(
            go.Scatter(
                x=df["year"],
                y=df[scenario_col] - df[base_col],
                name=label,
                mode="lines",
                line=dict(color=color, width=chart_cfg["line_widths"]["standard"], dash=dash),
                showlegend=False,
            )
        )

    legend_color = chart_cfg["colors"].get("neutral", "#757575")
    for label, dash in LEGEND_ENTRIES:
        fig.add_trace(
            go.Scatter(
                x=[None], y=[None],
                name=label,
                mode="lines",
                line=dict(color=legend_color, width=chart_cfg["line_widths"]["standard"], dash=dash),
                showlegend=True,
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
        showgrid=False,
        linecolor=axes["linecolor"],
        linewidth=axes["linewidth"],
        ticks=axes["ticks"],
        tickfont=dict(size=axes["tickfont_size"]),
        tickvals=TICK_YEARS,
        ticktext=TICK_LABELS,
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

    csv_data = pd.DataFrame({"year": df["year"].values})
    for label, scenario_col, base_col, _, _ in SERIES:
        csv_data[label] = (df[scenario_col] - df[base_col]).round(3).values
    csv_path = figures_dir / f"{OUTPUT_STEM}.csv"
    csv_data.to_csv(csv_path, index=False)
    print(f"  Exported data to {csv_path.name}")


if __name__ == "__main__":
    main()
