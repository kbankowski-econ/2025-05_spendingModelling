"""
Jamaica case deck: spending-efficiency gaps over time — the emerging-market
interquartile band with Jamaica overlaid, for infrastructure, health and
education (3x1 panel).

For each sector the shaded band is the 25th-75th percentile of the eff_gap
across all emerging-market (EM) economies in each year, with the EM median as
the centre line; the blue line is Jamaica. Circles mark the 2023 values (the
reference year intended for the calibration) on the EM median and on Jamaica;
only Jamaica's value is labelled. Companion to scoreEvolution.py.

Data: IMF staff efficiency estimates (2025-04-14),
[SECTOR]_inefficiency-scores.csv, eff_gap column.
"""
import pandas as pd
import numpy as np
import plotly.graph_objects as go
from plotly.subplots import make_subplots
from fiscal_common import load_config, load_chart_config, ensure_output_dir

# Use the updated efficiency estimates (the Developer copy), which now carry the
# Jamaica infrastructure series; the older Documents copy lacks INF for Jamaica.
DATA_DIR = "/Users/kk/Developer/2025-05_fmEfficiencyScores/code-output/2025-04-14-efficiency-estimates"

SECTORS = ["INF", "HLT", "EDU"]
SECTOR_TITLES = {"INF": "Infrastructure", "HLT": "Health", "EDU": "Education"}

JAM_ISO = "JAM"
PEER_INCOME = "EM"          # emerging-market peer group (Jamaica's class)
MIN_PEERS = 10              # minimum peers in a year to draw the band
FIRST_YEAR, LAST_YEAR = 2000, 2024

# Convention: first tick as full yyyy, the rest as two-digit yy.
TICK_YEARS = [2000, 2005, 2010, 2015, 2020]
TICK_LABELS = [str(TICK_YEARS[0])] + [f"{y % 100:02d}" for y in TICK_YEARS[1:]]

Y_RANGE = [0.0, 0.7]
Y_TICKS = [0.0, 0.2, 0.4, 0.6]

OUTPUT_STEM = "efficiencyBandsJAM"

# Reference year highlighted as the intended calibration period.
REF_YEAR = 2023


def sector_frames(sector):
    """Return (band_df, jam_df) for a sector: per-year EM percentiles and the
    Jamaica eff_gap series, both clipped to [FIRST_YEAR, LAST_YEAR]."""
    df = pd.read_csv(
        f"{DATA_DIR}/{sector}_inefficiency-scores.csv",
        usecols=["iso3c", "country", "year", "income", "eff_gap"],
    )
    df = df.dropna(subset=["eff_gap"])
    df = df[(df["year"] >= FIRST_YEAR) & (df["year"] <= LAST_YEAR)]

    peers = df[df["income"] == PEER_INCOME]
    grp = peers.groupby("year")["eff_gap"]
    band = pd.DataFrame({
        "p25": grp.quantile(0.25),
        "p50": grp.quantile(0.50),
        "p75": grp.quantile(0.75),
        "n": grp.size(),
    })
    band = band[band["n"] >= MIN_PEERS].reset_index()

    jam = df[df["iso3c"] == JAM_ISO][["year", "eff_gap"]].sort_values("year")
    return band, jam


def main():
    config = load_config()
    cfg = load_chart_config()["styling"]
    output_dir = ensure_output_dir(config)

    band_color = cfg["colors"]["neutral"]       # grey
    band_rgb = "117, 117, 117"
    jam_color = cfg["colors"]["secondary"]       # blue
    lw = cfg["line_widths"]

    fig = make_subplots(
        rows=1, cols=3,
        subplot_titles=tuple(SECTOR_TITLES[s] for s in SECTORS),
        shared_yaxes=True,
        horizontal_spacing=0.035,
    )

    csv_rows = []
    for col, sector in enumerate(SECTORS, start=1):
        band, jam = sector_frames(sector)
        first_panel = (col == 1)
        years = band["year"].tolist()

        # IQR band (p75 out, p25 back)
        fig.add_trace(go.Scatter(
            x=years + years[::-1],
            y=band["p75"].tolist() + band["p25"].tolist()[::-1],
            fill="toself",
            fillcolor=f"rgba({band_rgb}, 0.22)",
            line=dict(color="rgba(0,0,0,0)"),
            hoverinfo="skip",
            name="Emerging markets, 25–75th pct",
            showlegend=first_panel,
        ), row=1, col=col)

        # EM median
        fig.add_trace(go.Scatter(
            x=years, y=band["p50"],
            mode="lines",
            line=dict(color=band_color, width=lw["median"], dash="dot"),
            name="Emerging-market median",
            showlegend=first_panel,
        ), row=1, col=col)

        # Jamaica line
        fig.add_trace(go.Scatter(
            x=jam["year"], y=jam["eff_gap"],
            mode="lines",
            line=dict(color=jam_color, width=lw["thick"]),
            name="Jamaica",
            showlegend=first_panel,
        ), row=1, col=col)

        # Circle the 2023 value on the EM median (grey, unlabelled).
        bref = band[band["year"] == REF_YEAR]
        if not bref.empty:
            fig.add_trace(go.Scatter(
                x=[REF_YEAR], y=[float(bref["p50"].iloc[0])],
                mode="markers",
                marker=dict(color=band_color, size=8),
                showlegend=False, hoverinfo="skip",
            ), row=1, col=col)

        # Circle the 2023 value on Jamaica (blue, labelled).
        jref = jam[jam["year"] == REF_YEAR]
        if not jref.empty:
            v = float(jref["eff_gap"].iloc[0])
            fig.add_trace(go.Scatter(
                x=[REF_YEAR], y=[v],
                mode="markers+text",
                marker=dict(color=jam_color, size=8),
                text=[f"{v:.2f}"],
                textposition="top center",
                textfont=dict(size=12, color=jam_color),
                showlegend=False, hoverinfo="skip",
            ), row=1, col=col)

        # collect tidy CSV
        for _, r in band.iterrows():
            csv_rows.append({"sector": sector, "year": int(r["year"]),
                             "em_p25": round(r["p25"], 4), "em_p50": round(r["p50"], 4),
                             "em_p75": round(r["p75"], 4), "jamaica": np.nan})
        for _, r in jam.iterrows():
            csv_rows.append({"sector": sector, "year": int(r["year"]),
                             "em_p25": np.nan, "em_p50": np.nan, "em_p75": np.nan,
                             "jamaica": round(r["eff_gap"], 4)})

    axes = cfg["axes"]
    fig.update_xaxes(
        range=[FIRST_YEAR, LAST_YEAR + 2], tickvals=TICK_YEARS, ticktext=TICK_LABELS,
        showgrid=False, linecolor=axes["linecolor"], linewidth=axes["linewidth"],
        ticks=axes["ticks"], tickfont=dict(size=13),
    )
    fig.update_yaxes(
        range=Y_RANGE, tickvals=Y_TICKS,
        showgrid=True, gridcolor=axes["gridcolor"], gridwidth=axes["gridwidth"],
        zeroline=True, zerolinewidth=axes["zerolinewidth"], zerolinecolor="black",
        linecolor=axes["linecolor"], linewidth=axes["linewidth"],
        ticks=axes["ticks"], tickfont=dict(size=13),
    )

    fig.update_layout(
        template=cfg["template"], width=1000, height=340,
        margin=dict(l=30, r=12, t=58, b=24), font=dict(size=14),
        legend=dict(orientation="h", yanchor="bottom", y=1.12,
                    xanchor="center", x=0.5, font=dict(size=13)),
    )
    for annot in fig.layout.annotations:
        if annot.text in SECTOR_TITLES.values():
            annot.font.size = 15

    figures_dir = output_dir / "figures"
    figures_dir.mkdir(parents=True, exist_ok=True)
    png_path = figures_dir / f"{OUTPUT_STEM}.png"
    html_path = figures_dir / f"{OUTPUT_STEM}.html"
    fig.write_image(str(png_path), width=1000, height=340, scale=2)
    fig.write_html(str(html_path), auto_open=config["output_settings"].get("auto_open_html", False))
    print(f"  Saved {png_path.name} and {html_path.name}")

    csv_path = figures_dir / f"{OUTPUT_STEM}.csv"
    pd.DataFrame(csv_rows).to_csv(csv_path, index=False)
    print(f"  Exported data to {csv_path.name}")


if __name__ == "__main__":
    main()
