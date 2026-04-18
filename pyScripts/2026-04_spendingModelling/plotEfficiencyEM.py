"""
1x2 panel (Panel 4 of the replication figure): additional EMDE output gain
in 2050 from gradually closing spending-efficiency gaps, for infrastructure
(left) and human capital (right), at two closure horizons. Bars show the
baseline (low-initial-gap) response; circle markers show the counterpart
when the initial gap is higher ("low" model variant).
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
INPUT_CSV = "../../docs/csvFiles/figureNumbers_yearly.csv"
OUTPUT_STEM = "efficiencyEM_yd"


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
    legend_color = chart_cfg["colors"].get("neutral", "#757575")
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

    margins = dict(chart_cfg["margins"])
    margins["t"] = 140  # extra headroom for legend + subplot titles

    fig.update_layout(
        template=chart_cfg["template"],
        width=chart_cfg["width"],
        height=chart_cfg["height"],
        margin=margins,
        font=dict(size=chart_cfg["font_size"]),
        bargap=0.45,
        legend=dict(
            orientation=chart_cfg["legend"]["orientation"],
            yanchor="bottom",
            y=1.32,
            xanchor=chart_cfg["legend"]["xanchor"],
            x=chart_cfg["legend"]["x"],
            font=dict(size=chart_cfg["legend"]["font_size"]),
        ),
    )

    # Subplot titles use the regular tick font size; nudge them up to open
    # a little more breathing room between the title and the subplot.
    for annotation in fig["layout"]["annotations"]:
        annotation["font"] = dict(size=chart_cfg["axes"]["tickfont_size"])
        annotation["y"] = annotation["y"] + 0.11

    axes = chart_cfg["axes"]
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

    figures_dir = output_dir / "figures"
    figures_dir.mkdir(parents=True, exist_ok=True)
    png_path = figures_dir / f"{OUTPUT_STEM}.png"
    html_path = figures_dir / f"{OUTPUT_STEM}.html"
    smart_save_image(fig, png_path)
    fig.write_html(html_path, auto_open=config["output_settings"].get("auto_open_html", False))
    print(f"  Saved {png_path.name} and {html_path.name}")

    csv_data = pd.DataFrame(csv_rows)
    csv_path = figures_dir / f"{OUTPUT_STEM}.csv"
    csv_data.to_csv(csv_path, index=False)
    print(f"  Exported data to {csv_path.name}")


if __name__ == "__main__":
    main()
