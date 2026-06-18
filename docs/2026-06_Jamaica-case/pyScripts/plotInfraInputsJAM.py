"""
Jamaica case deck: infrastructure input and output variables over time —
interquartile bands by income group (advanced economies, emerging markets,
low-income) with Jamaica overlaid, one small panel per variable (3x5 grid).

This is the data behind the infrastructure efficiency gap: the single input
(public investment per capita) and the output/outcome indicators the frontier
maps it onto. For each variable and income group the shaded band is the
25th-75th percentile across that group's economies in each year, with the group
median as the centre line; the thick blue line is Jamaica. Companion to
plotEfficiencyBandsJAM.py, mirroring the infrastructure block of the efficiency
project's inputCtryPanel dashboard.

Coverage of the raw series is uneven (e.g. Jamaica's public-investment input is
only 1990-96, rail has no Jamaica data), so the window runs from 1990 and no
single reference-year marker is drawn; the lines simply show what exists.

Data: IMF staff SFA input file (2025-04-14), data/sfa_input_data.csv.
"""
import pandas as pd
import numpy as np
import plotly.graph_objects as go
from plotly.subplots import make_subplots
from fiscal_common import load_config, load_chart_config, ensure_output_dir

# Estimation-ready input/output series feeding the SFA. Jamaica's public-
# investment input is the desk reconstruction (2003-2024) spliced into
# FM2025_data_transformed.csv by the efficiency project (commit 47ddb3f4) and
# re-exported here via saveSfaInputData.py.
DATA_FILE = "/Users/kk/Developer/2025-05_fmEfficiencyScores/data/sfa_input_data.csv"

# Infrastructure variables in dashboard order: the input first, then outputs.
# (column, short panel title with units)
VARS = [
    ("pubinv_ppp_pc_ma5",      "Public investment (input)"),
    ("elec_consumption_wdi",   "Electricity use (kWh pc)"),
    ("elec_access_wdi",        "Electricity access (%)"),
    ("tran_rail_wdi_pc",       "Rail lines (pc)"),
    ("road_density",           "Road density (km/km²)"),
    ("paved_ratio_int",        "Paved road ratio (%)"),
    ("tran_air_passengers_pc", "Air passengers (pc)"),
    ("tran_port_traffic_pc",   "Port traffic (TEU pc)"),
    ("comm_phone_wdi_int",     "Fixed telephone (/100)"),
    ("comm_cell_wdi_int",      "Mobile cellular (/100)"),
    ("sanitation_wdi",         "Basic sanitation (%)"),
    ("water_drinking_wdi",     "Basic drinking water (%)"),
    ("infra_quality",          "Infra quality (1–7)"),
]
NROWS, NCOLS = 3, 5

# Income groups: (label, income code, pale colour for band + median line,
# full colour reserved for emphasis). Lines/bands stay pale so Jamaica's bold
# blue stands out, matching plotEfficiencyBandsJAM.py.
GROUPS = [
    ("Advanced economies", "AE", "#80CBC4", "#00897B"),   # teal
    ("Emerging markets", "EM", "#FFCC80", "#FB8C00"),      # orange (Jamaica's group)
    ("Low-income", "LIC", "#EF9A9A", "#E53935"),           # red
]
BAND_OPACITY = 0.18

JAM_ISO = "JAM"
MIN_PEERS = 8              # minimum countries in a group-year to draw the band
FIRST_YEAR, LAST_YEAR = 1990, 2024

# Convention: first tick as full yyyy, the rest as two-digit yy.
TICK_YEARS = [1990, 2000, 2010, 2020]
TICK_LABELS = [str(TICK_YEARS[0])] + [f"{y % 100:02d}" for y in TICK_YEARS[1:]]

OUTPUT_STEM = "infraInputsJAM"

# Open the interactive HTML in the browser after generating.
AUTO_OPEN = True


def rgba(hexcol, alpha):
    h = hexcol.lstrip("#")
    return f"rgba({int(h[0:2],16)},{int(h[2:4],16)},{int(h[4:6],16)},{alpha})"


def group_band(df, var, code):
    """Per-year 25/50/75 percentiles of `var` for one income group, where the
    group has at least MIN_PEERS countries reporting that year."""
    grp = df[df["income"] == code].dropna(subset=[var]).groupby("year")[var]
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

    cols = ["iso3c", "year", "income"] + [v for v, _ in VARS]
    df = pd.read_csv(DATA_FILE, usecols=cols)
    df = df[(df["year"] >= FIRST_YEAR) & (df["year"] <= LAST_YEAR)]
    jam_all = df[df["iso3c"] == JAM_ISO]

    titles = [t for _, t in VARS] + [""] * (NROWS * NCOLS - len(VARS))
    fig = make_subplots(
        rows=NROWS, cols=NCOLS, subplot_titles=titles,
        horizontal_spacing=0.045, vertical_spacing=0.10,
    )

    csv_rows = []
    for idx, (var, title) in enumerate(VARS):
        row, col = idx // NCOLS + 1, idx % NCOLS + 1
        first_panel = (idx == 0)
        bands = {code: group_band(df, var, code) for _, code, _, _ in GROUPS}

        # Shaded IQR bands (background, no legend entry).
        for _, code, pale, _ in GROUPS:
            b = bands[code]
            if b.empty:
                continue
            yrs = b["year"].tolist()
            fig.add_trace(go.Scatter(
                x=yrs + yrs[::-1],
                y=b["p75"].tolist() + b["p25"].tolist()[::-1],
                fill="toself", fillcolor=rgba(pale, BAND_OPACITY),
                line=dict(color="rgba(0,0,0,0)"),
                hoverinfo="skip", showlegend=False,
            ), row=row, col=col)

        # Group medians (legend carries the group name, drawn once).
        for name, code, pale, _ in GROUPS:
            b = bands[code]
            if b.empty:
                continue
            fig.add_trace(go.Scatter(
                x=b["year"], y=b["p50"], mode="lines",
                line=dict(color=pale, width=1.6),
                name=name, showlegend=first_panel,
            ), row=row, col=col)

        # Jamaica line on top (may be a short stub or absent for some series).
        jam = jam_all[["year", var]].dropna().sort_values("year")
        fig.add_trace(go.Scatter(
            x=jam["year"], y=jam[var], mode="lines",
            line=dict(color=jam_color, width=lw["thick"]),
            name="Jamaica", showlegend=first_panel,
        ), row=row, col=col)

        # tidy CSV: one row per group/year + Jamaica
        for name, code, _, _ in GROUPS:
            for _, r in bands[code].iterrows():
                csv_rows.append({"variable": var, "series": name, "year": int(r["year"]),
                                 "p25": round(r["p25"], 4), "p50": round(r["p50"], 4),
                                 "p75": round(r["p75"], 4)})
        for _, r in jam.iterrows():
            csv_rows.append({"variable": var, "series": "Jamaica", "year": int(r["year"]),
                             "p25": np.nan, "p50": round(float(r[var]), 4), "p75": np.nan})

    axes = cfg["axes"]
    fig.update_xaxes(
        range=[FIRST_YEAR, LAST_YEAR + 1], tickvals=TICK_YEARS, ticktext=TICK_LABELS,
        showgrid=False, linecolor=axes["linecolor"], linewidth=1,
        ticks=axes["ticks"], tickfont=dict(size=12),
    )
    fig.update_yaxes(
        nticks=4, showgrid=True, gridcolor=axes["gridcolor"], gridwidth=axes["gridwidth"],
        linecolor=axes["linecolor"], linewidth=1,
        ticks=axes["ticks"], tickfont=dict(size=12),
    )

    fig.update_layout(
        template=cfg["template"], width=1340, height=470,
        margin=dict(l=30, r=12, t=84, b=22), font=dict(size=13),
        legend=dict(orientation="h", yanchor="bottom", y=1.11,
                    xanchor="center", x=0.5, font=dict(size=14)),
    )
    # Per-panel (subplot) titles.
    for annot in fig.layout.annotations:
        if annot.text in titles:
            annot.font.size = 14

    figures_dir = output_dir / "figures"
    figures_dir.mkdir(parents=True, exist_ok=True)
    png_path = figures_dir / f"{OUTPUT_STEM}.png"
    html_path = figures_dir / f"{OUTPUT_STEM}.html"
    fig.write_image(str(png_path), width=1340, height=470, scale=2)
    fig.write_html(str(html_path), auto_open=AUTO_OPEN)
    print(f"  Saved {png_path.name} and {html_path.name}")

    csv_path = figures_dir / f"{OUTPUT_STEM}.csv"
    pd.DataFrame(csv_rows).to_csv(csv_path, index=False)
    print(f"  Exported data to {csv_path.name}")


if __name__ == "__main__":
    main()
