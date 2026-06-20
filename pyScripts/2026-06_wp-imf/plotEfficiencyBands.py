"""
Figure: spending-efficiency gaps by income group (App. B, fig:efficiencyBands).

Spending-efficiency gaps over time — interquartile bands by income group
(advanced economies, emerging markets, low-income developing countries) for
infrastructure, health, education and R&D (2x2 panel; R&D for AEs only).

The shaded band is the 25th-75th percentile of eff_gap across each group's
economies in each year, the centre line is the group median, and the labelled
circle marks each group's 2023 value (the calibration reference).

Standalone: this script has no local-module dependencies. Its only input is the
IMF staff efficiency-estimate CSVs in DATA_DIR (the Developer copy; the
Documents copy is stale); it writes the PNG/HTML/CSV into
docs/2026-06_wp-imf/figures/. Requires pandas + numpy + plotly (with a Kaleido
backend for PNG export).
"""
from pathlib import Path

import numpy as np
import pandas as pd
import plotly.graph_objects as go
from plotly.subplots import make_subplots

from wp_charts import chart_dims_px

# --- Paths --------------------------------------------------------------------
SCRIPT_DIR = Path(__file__).resolve().parent
PROJECT_ROOT = SCRIPT_DIR.parents[1]
FIGURES_DIR = PROJECT_ROOT / "docs" / "2026-06_wp-imf" / "figures"

# IMF staff efficiency estimates (2025-04-14), [SECTOR]_inefficiency-scores.csv,
# eff_gap column. The Developer copy; the Documents copy is stale.
DATA_DIR = "/Users/kk/Developer/2025-05_fmEfficiencyScores/code-output/2025-04-14-efficiency-estimates"

# --- Styling (inlined from the former chartConfig.json) -----------------------
STYLE = {
    "template": "simple_white",
    "line_width_standard": 2.5,
    "legend_font_size": 14,
    "axes": {"linecolor": "black", "linewidth": 1.5, "ticks": "inside",
             "gridcolor": "rgba(0,0,0,0.15)", "gridwidth": 0.5,
             "zerolinewidth": 1.5},
}

SECTORS = ["INF", "HLT", "EDU", "RND"]
SECTOR_TITLES = {"INF": "Infrastructure", "HLT": "Health", "EDU": "Education", "RND": "R&D"}

# Sectors plotted for advanced economies only (the innovation channel is an
# AE-only channel in the model; R&D is shut down for EMDEs).
AE_ONLY_SECTORS = {"RND"}

# Income groups: (label, income code, colour). Colours follow the project's
# income-group palette (CLAUDE.md): AE blue, EM orange, LIDC brown. The band is
# the colour at low opacity; the median line and 2023 marker use the full tone.
GROUPS = [
    ("Advanced Economies", "AE", "#1E88E5"),               # blue
    ("Emerging Markets", "EM", "#FF9800"),                 # orange
    ("Low-Income Developing Countries", "LIC", "#795548"), # brown
]
BAND_OPACITY = 0.15

MIN_PEERS = 10              # minimum countries in a group-year to draw the band
FIRST_YEAR, LAST_YEAR = 2000, 2024

# Convention: first tick as full yyyy, the rest as two-digit yy.
TICK_YEARS = [2000, 2005, 2010, 2015, 2020]
TICK_LABELS = [str(TICK_YEARS[0])] + [f"{y % 100:02d}" for y in TICK_YEARS[1:]]

Y_RANGE = [0.0, 0.7]
Y_TICKS = [0.0, 0.2, 0.4, 0.6]

OUTPUT_STEM = "efficiencyBands"

# Chart size comes from chartTable.csv (cm); fall back to this if it is absent.
DEFAULT_CM = (23.81, 16.40)
WIDTH_PX, HEIGHT_PX = chart_dims_px(OUTPUT_STEM, DEFAULT_CM)

# Reference year highlighted as the calibration period.
REF_YEAR = 2023

# Minimum vertical gap between the 2023 value labels within a panel, so that
# near-equal group values do not overprint.
LABEL_MIN_GAP = 0.045


def rgba(hexcol, alpha):
    h = hexcol.lstrip("#")
    return f"rgba({int(h[0:2],16)},{int(h[2:4],16)},{int(h[4:6],16)},{alpha})"


def load_sector(sector):
    """Return the cleaned sector data clipped to the year window."""
    df = pd.read_csv(
        f"{DATA_DIR}/{sector}_inefficiency-scores.csv",
        usecols=["iso3c", "country", "year", "income", "eff_gap"],
    )
    df = df.dropna(subset=["eff_gap"])
    df = df[(df["year"] >= FIRST_YEAR) & (df["year"] <= LAST_YEAR)]
    return df


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


def declutter(values):
    """Given a list of (value, colour, label) tuples, return label y-positions
    pushed apart by at least LABEL_MIN_GAP so labels do not overprint."""
    order = sorted(range(len(values)), key=lambda i: values[i][0])
    ys = [None] * len(values)
    prev = -np.inf
    for i in order:
        y = max(values[i][0], prev + LABEL_MIN_GAP)
        ys[i] = y
        prev = y
    return ys


def main():
    axes = STYLE["axes"]

    fig = make_subplots(
        rows=2, cols=2,
        subplot_titles=tuple(SECTOR_TITLES[s] for s in SECTORS),
        shared_yaxes=True,
        horizontal_spacing=0.06, vertical_spacing=0.13,
    )

    csv_rows = []
    for idx, sector in enumerate(SECTORS):
        row, col = idx // 2 + 1, idx % 2 + 1
        df = load_sector(sector)
        first_panel = (idx == 0)
        # R&D is plotted for advanced economies only.
        groups = [g for g in GROUPS if sector not in AE_ONLY_SECTORS or g[1] == "AE"]
        bands = {code: group_band(df, code) for _, code, _ in groups}

        # Shaded IQR bands (background, no legend entry).
        for _, code, colr in groups:
            b = bands[code]
            yrs = b["year"].tolist()
            fig.add_trace(go.Scatter(
                x=yrs + yrs[::-1],
                y=b["p75"].tolist() + b["p25"].tolist()[::-1],
                fill="toself", fillcolor=rgba(colr, BAND_OPACITY),
                line=dict(color="rgba(0,0,0,0)"),
                hoverinfo="skip", showlegend=False,
            ), row=row, col=col)

        # Group medians (legend carries the group name).
        for name, code, colr in groups:
            b = bands[code]
            fig.add_trace(go.Scatter(
                x=b["year"], y=b["p50"], mode="lines",
                line=dict(color=colr, width=STYLE["line_width_standard"]),
                name=name, showlegend=first_panel,
            ), row=row, col=col)

        # 2023 circle + decluttered value label for each group.
        ref_vals = []
        for name, code, colr in groups:
            bref = bands[code][bands[code]["year"] == REF_YEAR]
            v = float(bref["p50"].iloc[0]) if not bref.empty else None
            ref_vals.append((v, colr, name))
        present = [(i, t) for i, t in enumerate(ref_vals) if t[0] is not None]
        label_ys = declutter([t for _, t in present])
        for (idx2, (v, colr, _)), ly in zip(present, label_ys):
            fig.add_trace(go.Scatter(
                x=[REF_YEAR], y=[v], mode="markers",
                marker=dict(color=colr, size=8),
                showlegend=False, hoverinfo="skip", cliponaxis=False,
            ), row=row, col=col)
            fig.add_trace(go.Scatter(
                x=[REF_YEAR + 0.8], y=[ly], mode="text",
                text=[f"{v:.2f}"], textposition="middle right",
                textfont=dict(size=STYLE["legend_font_size"], color=colr),
                showlegend=False, hoverinfo="skip", cliponaxis=False,
            ), row=row, col=col)

        # tidy CSV: one row per group/year
        for name, code, _ in groups:
            for _, r in bands[code].iterrows():
                csv_rows.append({"sector": sector, "series": name, "year": int(r["year"]),
                                 "p25": round(r["p25"], 4), "p50": round(r["p50"], 4),
                                 "p75": round(r["p75"], 4)})

    fig.update_xaxes(
        range=[FIRST_YEAR, LAST_YEAR + 3], tickvals=TICK_YEARS, ticktext=TICK_LABELS,
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
        template=STYLE["template"], width=WIDTH_PX, height=HEIGHT_PX,
        margin=dict(l=30, r=12, t=64, b=24), font=dict(size=14),
        legend=dict(orientation="h", yanchor="bottom", y=1.06,
                    xanchor="center", x=0.5, font=dict(size=13)),
    )
    for annot in fig.layout.annotations:
        if annot.text in SECTOR_TITLES.values():
            annot.font.size = 15

    FIGURES_DIR.mkdir(parents=True, exist_ok=True)
    png_path = FIGURES_DIR / f"{OUTPUT_STEM}.png"
    html_path = FIGURES_DIR / f"{OUTPUT_STEM}.html"
    fig.write_image(str(png_path), width=WIDTH_PX, height=HEIGHT_PX, scale=2)
    fig.write_html(str(html_path), auto_open=False)
    print(f"  Saved {png_path.name} and {html_path.name}")

    csv_path = FIGURES_DIR / f"{OUTPUT_STEM}.csv"
    pd.DataFrame(csv_rows).to_csv(csv_path, index=False)
    print(f"  Exported data to {csv_path.name}")


if __name__ == "__main__":
    main()
