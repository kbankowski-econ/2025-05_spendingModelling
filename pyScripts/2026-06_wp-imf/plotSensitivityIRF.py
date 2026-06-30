"""
Figure: output-IRF sensitivity to structural parameters (fig:sensitivity).

For the three productive advanced-economy expansions, the output response (yd,
percent deviation from steady state) is traced as one structural parameter is
swept over a plausible range, one panel each:

  - Infrastructure investment -> Model_HumanCapital_exp_igi, vary alpha_G
  - Human capital investment  -> Model_HumanCapital_exp_ige, vary mu  (alphaH)
  - R&D investment            -> Model_HumanCapital_exp_grd, vary alpha_RD

In each panel the lines fan from the low (light) to the high (dark) parameter
value; the dashed black line is the baseline calibration. A 1x3 grid of percent
deviations from steady state.

Data source: the one-at-a-time parameter sweep
docs/2026-06_wp-imf/investigations/sensitivity/results/sweep_AE_irf.csv
(produced by investigations/sensitivity/sweep.m). Unlike the other figures this
does not read figureNumbers_yearly.csv, because the sweep re-solves the model per
parameter draw. Writes PNG/PDF/HTML/CSV into docs/2026-06_wp-imf/figures/.
Requires pandas + plotly (with a Kaleido backend for PNG export).
"""
from pathlib import Path

import pandas as pd
import plotly.graph_objects as go
from plotly.subplots import make_subplots

from wp_charts import chart_render_px, chart_display_cm, font_px_for_pt, smart_save_image, write_pdf

# --- Paths (resolved from this file) -----------------------------------------
SCRIPT_DIR = Path(__file__).resolve().parent
PROJECT_ROOT = SCRIPT_DIR.parents[1]
INPUT_CSV = (PROJECT_ROOT / "docs" / "2026-06_wp-imf" / "investigations" /
             "sensitivity" / "results" / "sweep_AE_irf.csv")
FIGURES_DIR = PROJECT_ROOT / "docs" / "2026-06_wp-imf" / "figures"

# --- Styling (inlined; matches the other working-paper figures) ---------------
STYLE = {
    "template": "simple_white",
    "margins": {"t": 44, "b": 28, "l": 40, "r": 40},
    "axes": {"linecolor": "black", "linewidth": 1.5, "ticks": "inside",
             "showgrid": True, "gridcolor": "rgba(0,0,0,0.15)", "gridwidth": 0.5,
             "zeroline": True, "zerolinewidth": 1.5},
    "line_width_standard": 2.0,
}

# (model directory, swept parameter, panel title, parameter symbol, (light, dark)
# colour ramp). Colours match the reallocation/standard-shock figures: infra
# blue, human capital purple, R&D green; the ramp goes low -> high.
PANELS = [
    ("Model_HumanCapital_exp_igi", "alphaG",  "Infrastructure (α<sub>G</sub>)",
     "α<sub>G</sub>", ("#90CAF9", "#0D47A1")),
    ("Model_HumanCapital_exp_ige", "alphaH",  "Human Capital (μ)",
     "μ", ("#CE93D8", "#4A148C")),
    ("Model_HumanCapital_exp_grd", "alphaRD", "R&D (α<sub>RD</sub>)",
     "α<sub>RD</sub>", ("#A5D6A7", "#1B5E20")),
]

HORIZON_YEARS = 25                          # match the multiplier table's 25y window
X_TICK_HORIZONS = [1, 10, 25]
OUTPUT_STEM = "sensitivityIRF_AE"

# Both sizes come from chartTable.csv: render = original chart size (canvas,
# controls fonts/quality); display = size shown in the paper (aspect preserved).
WIDTH_PX, HEIGHT_PX = chart_render_px(OUTPUT_STEM, (22.5, 8.25))
DISPLAY_CM = chart_display_cm(OUTPUT_STEM, (15.0, 5.5))

# Font matching the paper: Palatino (the paper's mathpazo), sized so the chart
# text renders at a fixed point size on the page (recomputed from render/display).
FONT_FAMILY = "Palatino, 'Palatino Linotype', 'Book Antiqua', serif"
FONT_PX = font_px_for_pt(8, WIDTH_PX, DISPLAY_CM[0])         # axis ticks
TITLE_FONT_PX = font_px_for_pt(8.5, WIDTH_PX, DISPLAY_CM[0])  # subplot titles
LABEL_FONT_PX = font_px_for_pt(6.5, WIDTH_PX, DISPLAY_CM[0])  # endpoint range labels


def _lerp_hex(c0, c1, t):
    """Linear interpolation between two #rrggbb colours at fraction t in [0,1]."""
    a = [int(c0[i:i + 2], 16) for i in (1, 3, 5)]
    b = [int(c1[i:i + 2], 16) for i in (1, 3, 5)]
    return "#" + "".join(f"{round(a[k] + (b[k] - a[k]) * t):02x}" for k in range(3))


def main():
    irf = pd.read_csv(INPUT_CSV)
    ycols = [f"yd_y{y}" for y in range(HORIZON_YEARS + 1)]
    years = list(range(HORIZON_YEARS + 1))

    fig = make_subplots(
        rows=1, cols=len(PANELS),
        subplot_titles=[p[2] for p in PANELS],
        horizontal_spacing=0.10,
    )

    for j, (ex, param, _title, _psym, (c_lo, c_hi)) in enumerate(PANELS):
        col = j + 1
        sub = irf[(irf.experiment == ex) & (irf.param == param)].sort_values("param_value")
        vals = sub.param_value.to_numpy()
        lo, hi = vals.min(), vals.max()
        for _, row in sub.iterrows():
            frac = 0.0 if hi == lo else (row.param_value - lo) / (hi - lo)
            fig.add_trace(
                go.Scatter(
                    x=years, y=row[ycols].to_numpy(dtype=float), mode="lines",
                    line=dict(color=_lerp_hex(c_lo, c_hi, frac), width=STYLE["line_width_standard"]),
                    showlegend=False, hoverinfo="skip",
                ),
                row=1, col=col,
            )
        # baseline calibration: thick grey line (identified in the figure note)
        base = irf[(irf.experiment == ex) & (irf.is_baseline == 1)]
        if len(base):
            fig.add_trace(
                go.Scatter(
                    x=years, y=base.iloc[0][ycols].to_numpy(dtype=float), mode="lines",
                    line=dict(color="#757575", width=5.0),
                    showlegend=False, hoverinfo="skip",
                ),
                row=1, col=col,
            )
        # label every line with its parameter value, just past its right endpoint
        # (the panel title carries the parameter symbol). The wider inter-panel
        # spacing and right margin leave room for these labels. The baseline
        # value's label is greyed to match the thick grey baseline line.
        base_end = float(base.iloc[0][ycols[-1]]) if len(base) else None
        for _, r in sub.iterrows():
            frac = 0.0 if hi == lo else (r.param_value - lo) / (hi - lo)
            r_end = float(r[ycols[-1]])
            is_base = base_end is not None and abs(r_end - base_end) < 1e-9
            color = "#757575" if is_base else _lerp_hex(c_lo, c_hi, frac)
            fig.add_annotation(
                row=1, col=col, x=HORIZON_YEARS, y=r_end,
                text=f"{r.param_value:g}", showarrow=False,
                xanchor="left", yanchor="middle", xshift=3,
                font=dict(family=FONT_FAMILY, size=LABEL_FONT_PX, color=color),
            )

    # Subplot titles (the first len(PANELS) annotations, added by make_subplots
    # before the endpoint labels) at the title point size.
    for annotation in fig["layout"]["annotations"][:len(PANELS)]:
        annotation["font"] = dict(family=FONT_FAMILY, size=TITLE_FONT_PX)

    fig.update_layout(
        template=STYLE["template"],
        width=WIDTH_PX, height=HEIGHT_PX, margin=STYLE["margins"],
        font=dict(family=FONT_FAMILY, size=FONT_PX),
        showlegend=False,
    )

    axes = STYLE["axes"]
    fig.update_xaxes(
        tickvals=X_TICK_HORIZONS, ticktext=[f"{h}y" for h in X_TICK_HORIZONS],
        range=[0, HORIZON_YEARS], showgrid=False,
        linecolor=axes["linecolor"], linewidth=axes["linewidth"],
        ticks=axes["ticks"], tickfont=dict(size=FONT_PX),
    )
    fig.update_yaxes(
        showgrid=axes["showgrid"], gridcolor=axes["gridcolor"], gridwidth=axes["gridwidth"],
        zeroline=axes["zeroline"], zerolinewidth=axes["zerolinewidth"], zerolinecolor="black",
        linecolor=axes["linecolor"], linewidth=axes["linewidth"],
        ticks=axes["ticks"], tickfont=dict(size=FONT_PX),
    )

    FIGURES_DIR.mkdir(parents=True, exist_ok=True)
    png_path = FIGURES_DIR / f"{OUTPUT_STEM}.png"
    pdf_path = FIGURES_DIR / f"{OUTPUT_STEM}.pdf"
    html_path = FIGURES_DIR / f"{OUTPUT_STEM}.html"
    smart_save_image(fig, png_path, DISPLAY_CM)
    write_pdf(fig, pdf_path, WIDTH_PX, DISPLAY_CM[0])
    fig.write_html(html_path, auto_open=True)
    print(f"  Saved {png_path.name}, {pdf_path.name} and {html_path.name}")

    # Tidy long-format export: one row per (panel, parameter value, year).
    records = []
    for ex, param, title, _psym, _ramp in PANELS:
        sub = irf[(irf.experiment == ex) & (irf.param == param)].sort_values("param_value")
        for _, row in sub.iterrows():
            for y in years:
                records.append({"panel": title, "param": param,
                                "param_value": row.param_value, "year": y,
                                "pct_dev": round(float(row[f"yd_y{y}"]), 3)})
    csv_path = FIGURES_DIR / f"{OUTPUT_STEM}.csv"
    pd.DataFrame(records).to_csv(csv_path, index=False)
    print(f"  Exported data to {csv_path.name}")


if __name__ == "__main__":
    main()
