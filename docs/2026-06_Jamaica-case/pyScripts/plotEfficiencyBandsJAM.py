"""
Jamaica case deck: spending-efficiency gaps over time — interquartile bands by
income group (advanced economies, emerging markets, low-income) with Jamaica
overlaid, for infrastructure, health and education (3x1 panel).

For each sector and income group the shaded band is the 25th-75th percentile of
the eff_gap across that group's economies in each year, with the group median as
the centre line; the thick blue line is Jamaica. Circles mark the 2023 values
(the reference year intended for the calibration) on each group median and on
Jamaica; only Jamaica's value is labelled. Companion to scoreEvolution.py.

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

# Income groups: (label, income code, pale colour for the band + median line,
# full colour for the 2023 marker circle). Lines and bands stay pale so
# Jamaica's bold blue stands out; only the 2023 circles use the saturated tone.
GROUPS = [
    ("Advanced economies", "AE", "#80CBC4", "#00897B"),   # teal
    ("Emerging markets", "EM", "#FFCC80", "#FB8C00"),      # orange (Jamaica's group)
    ("Low-income", "LIC", "#EF9A9A", "#E53935"),           # red
]
BAND_OPACITY = 0.18

JAM_ISO = "JAM"
MIN_PEERS = 10              # minimum countries in a group-year to draw the band
FIRST_YEAR, LAST_YEAR = 2000, 2024

# Convention: first tick as full yyyy, the rest as two-digit yy.
TICK_YEARS = [2000, 2005, 2010, 2015, 2020]
TICK_LABELS = [str(TICK_YEARS[0])] + [f"{y % 100:02d}" for y in TICK_YEARS[1:]]

Y_RANGE = [0.0, 0.7]
Y_TICKS = [0.0, 0.2, 0.4, 0.6]

OUTPUT_STEM = "efficiencyBandsJAM"

# Reference year highlighted as the intended calibration period.
REF_YEAR = 2023

# Open the interactive HTML in the browser after generating (overrides the
# shared fiscal_config auto_open_html flag, for this chart only).
AUTO_OPEN = True


def rgba(hexcol, alpha):
    h = hexcol.lstrip("#")
    return f"rgba({int(h[0:2],16)},{int(h[2:4],16)},{int(h[4:6],16)},{alpha})"


def load_sector(sector):
    """Return (df, jam_df): the cleaned sector data clipped to the year window,
    and Jamaica's eff_gap series."""
    df = pd.read_csv(
        f"{DATA_DIR}/{sector}_inefficiency-scores.csv",
        usecols=["iso3c", "country", "year", "income", "eff_gap"],
    )
    df = df.dropna(subset=["eff_gap"])
    df = df[(df["year"] >= FIRST_YEAR) & (df["year"] <= LAST_YEAR)]
    jam = df[df["iso3c"] == JAM_ISO][["year", "eff_gap"]].sort_values("year")
    return df, jam


def group_band(df, code):
    """Per-year 25/50/75 percentiles for one income group, where the group has
    at least MIN_PEERS countries that year."""
    grp = df[df["income"] == code].groupby("year")["eff_gap"]
    band = pd.DataFrame({
        "p25": grp.quantile(0.25),
        "p50": grp.quantile(0.50),
        "p75": grp.quantile(0.75),
        "n": grp.size(),
    })
    return band[band["n"] >= MIN_PEERS].reset_index()


def main():
    config = load_config()
    cfg = load_chart_config()["styling"]
    output_dir = ensure_output_dir(config)

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
        df, jam = load_sector(sector)
        first_panel = (col == 1)
        bands = {code: group_band(df, code) for _, code, _, _ in GROUPS}

        # Shaded IQR bands (background, no legend entry).
        for _, code, pale, _ in GROUPS:
            b = bands[code]
            yrs = b["year"].tolist()
            fig.add_trace(go.Scatter(
                x=yrs + yrs[::-1],
                y=b["p75"].tolist() + b["p25"].tolist()[::-1],
                fill="toself", fillcolor=rgba(pale, BAND_OPACITY),
                line=dict(color="rgba(0,0,0,0)"),
                hoverinfo="skip", showlegend=False,
            ), row=1, col=col)

        # Group medians + 2023 circle (legend carries the group name).
        for name, code, pale, full in GROUPS:
            b = bands[code]
            fig.add_trace(go.Scatter(
                x=b["year"], y=b["p50"], mode="lines",
                line=dict(color=pale, width=1.6),
                name=name, showlegend=first_panel,
            ), row=1, col=col)
            bref = b[b["year"] == REF_YEAR]
            if not bref.empty:
                fig.add_trace(go.Scatter(
                    x=[REF_YEAR], y=[float(bref["p50"].iloc[0])],
                    mode="markers", marker=dict(color=full, size=8),
                    showlegend=False, hoverinfo="skip",
                ), row=1, col=col)

        # Jamaica line (on top) + 2023 circle with value label.
        fig.add_trace(go.Scatter(
            x=jam["year"], y=jam["eff_gap"], mode="lines",
            line=dict(color=jam_color, width=lw["thick"]),
            name="Jamaica", showlegend=first_panel,
        ), row=1, col=col)
        jref = jam[jam["year"] == REF_YEAR]
        if not jref.empty:
            v = float(jref["eff_gap"].iloc[0])
            fig.add_trace(go.Scatter(
                x=[REF_YEAR], y=[v], mode="markers+text",
                marker=dict(color=jam_color, size=8),
                text=[f"{v:.2f}"], textposition="top center",
                textfont=dict(size=12, color=jam_color),
                showlegend=False, hoverinfo="skip",
            ), row=1, col=col)

        # tidy CSV: one row per group/year + Jamaica
        for name, code, _, _ in GROUPS:
            for _, r in bands[code].iterrows():
                csv_rows.append({"sector": sector, "series": name, "year": int(r["year"]),
                                 "p25": round(r["p25"], 4), "p50": round(r["p50"], 4),
                                 "p75": round(r["p75"], 4)})
        for _, r in jam.iterrows():
            csv_rows.append({"sector": sector, "series": "Jamaica", "year": int(r["year"]),
                             "p25": np.nan, "p50": round(r["eff_gap"], 4), "p75": np.nan})

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
    fig.write_html(str(html_path), auto_open=AUTO_OPEN)
    print(f"  Saved {png_path.name} and {html_path.name}")

    csv_path = figures_dir / f"{OUTPUT_STEM}.csv"
    pd.DataFrame(csv_rows).to_csv(csv_path, index=False)
    print(f"  Exported data to {csv_path.name}")


if __name__ == "__main__":
    main()
