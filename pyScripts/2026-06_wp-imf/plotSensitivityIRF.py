"""
Figures: output-IRF sensitivity to structural parameters. The permanent mode
produces the Section 4 figure (fig:sensitivity); the default AR(1) mode produces
its persistent-temporary-shock appendix counterpart.

For the three productive advanced-economy expansions, the output response (yd,
percent deviation from steady state) is traced as one structural parameter is
swept over a plausible range, one panel each:

  - Infrastructure investment -> Model_HumanCapital_exp_igi, vary alpha_G
  - Human capital investment  -> Model_HumanCapital_exp_ige, vary mu
  - R&D investment            -> Model_HumanCapital_exp_grd, vary alpha_RD

In each panel the lines fan from the low (light) to the high (dark) parameter
value. The thick grey line is the AE baseline; where applicable, a thick colored
line marks the EMDE value of the varied elasticity. Circles identify the
first-quarter responses. A 1x3 grid of percent deviations from steady state.

Data source: the one-at-a-time parameter sweep produced by
investigations/sensitivity/sweep.m. By default this reads sweep_AE_irf.csv;
with --permanent it reads sweep_AE_irf_perm.csv and writes the headline figure.
Unlike the other figures this does not read figureNumbers_yearly.csv,
because the sweep re-solves the model per parameter draw. Writes PNG/PDF/HTML/CSV
into docs/2026-06_wp-imf/figures/. Requires pandas + plotly (with a Kaleido backend
for PNG export).
"""
import argparse
from pathlib import Path

import pandas as pd
import plotly.graph_objects as go
from plotly.subplots import make_subplots

from wp_charts import chart_render_px, chart_display_cm, font_px_for_pt, smart_save_image, write_pdf

# --- Paths (resolved from this file) -----------------------------------------
SCRIPT_DIR = Path(__file__).resolve().parent
PROJECT_ROOT = SCRIPT_DIR.parents[1]
RESULTS_DIR = (PROJECT_ROOT / "docs" / "2026-06_wp-imf" / "investigations" /
               "sensitivity" / "results")
FIGURES_DIR = PROJECT_ROOT / "docs" / "2026-06_wp-imf" / "figures"

# --- Styling (inlined; matches the other working-paper figures) ---------------
STYLE = {
    "template": "simple_white",
    "margins": {"t": 44, "b": 28, "l": 40, "r": 80},
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
    ("Model_HumanCapital_exp_ige", "mu",      "Human Capital (μ)",
     "μ", ("#CE93D8", "#4A148C")),
    ("Model_HumanCapital_exp_grd", "alphaRD", "R&D (α<sub>RD</sub>)",
     "α<sub>RD</sub>", ("#A5D6A7", "#1B5E20")),
]

AE_VALUES = {"alphaG": 0.054, "mu": 0.10, "alphaRD": 0.09}
EMDE_VALUES = {"alphaG": 0.17, "mu": 0.25}

HORIZON_QUARTERS = 100                      # 25 years of quarterly responses
IMPACT_QUARTER = 1
X_TICKS = [IMPACT_QUARTER, 20, 40, HORIZON_QUARTERS]
X_TICK_LABELS = ["1q", "5y", "10y", "25y"]
OUTPUT_STEM = "sensitivityIRF_AE"
FONT_FAMILY = "Palatino, 'Palatino Linotype', 'Book Antiqua', serif"


def _lerp_hex(c0, c1, t):
    """Linear interpolation between two #rrggbb colours at fraction t in [0,1]."""
    a = [int(c0[i:i + 2], 16) for i in (1, 3, 5)]
    b = [int(c1[i:i + 2], 16) for i in (1, 3, 5)]
    return "#" + "".join(f"{round(a[k] + (b[k] - a[k]) * t):02x}" for k in range(3))


def _format_param(value):
    """Keep endpoint labels precise enough to identify the calibration grid."""
    return f"{value:.3f}".rstrip("0").rstrip(".")


def main(permanent=False):
    suffix = "_perm" if permanent else ""
    input_csv = RESULTS_DIR / f"sweep_AE_irf{suffix}.csv"
    output_stem = f"{OUTPUT_STEM}{'Perm' if permanent else ''}"

    # Both sizes come from chartTable.csv: render = original chart size (canvas,
    # controls fonts/quality); display = size shown in the paper (aspect preserved).
    width_px, height_px = chart_render_px(output_stem, (22.5, 8.25))
    display_cm = chart_display_cm(output_stem, (15.0, 5.5))

    # Font matching the paper: Palatino (the paper's mathpazo), sized so the chart
    # text renders at a fixed point size on the page.
    font_px = font_px_for_pt(8, width_px, display_cm[0])
    title_font_px = font_px_for_pt(8.5, width_px, display_cm[0])
    label_font_px = font_px_for_pt(6.5, width_px, display_cm[0])

    irf = pd.read_csv(input_csv)
    ycols = [f"yd_q{q}" for q in range(IMPACT_QUARTER, HORIZON_QUARTERS + 1)]
    quarters = list(range(IMPACT_QUARTER, HORIZON_QUARTERS + 1))

    # Common y-range (all panels share one vertical scale) and the minimum data
    # gap two endpoint labels need to avoid overlapping, used to spread the
    # crowded labels (chiefly the infrastructure panel, which the shared scale
    # compresses) outward from the baseline.
    panel_exps = [f"{p[0]}{suffix}" for p in PANELS]
    pdata = irf[irf.experiment.isin(panel_exps)][ycols]   # only the plotted panels
    ylo, yhi = float(pdata.min().min()), float(pdata.max().max())   # NaN-safe (skipna)
    pad = 0.06 * (yhi - ylo)
    ylo, yhi = ylo - pad, yhi + pad
    panel_h_px = height_px - STYLE["margins"]["t"] - STYLE["margins"]["b"]
    label_min_gap = label_font_px * 1.25 * (yhi - ylo) / panel_h_px

    fig = make_subplots(
        rows=1, cols=len(PANELS),
        subplot_titles=[p[2] for p in PANELS],
        shared_yaxes=True,            # common y-scale across all three panels
        horizontal_spacing=0.15,
    )

    for j, (base_ex, param, _title, _psym, (c_lo, c_hi)) in enumerate(PANELS):
        col = j + 1
        ex = f"{base_ex}{suffix}"
        sub = irf[(irf.experiment == ex) & (irf.param == param)].sort_values("param_value")
        vals = sub.param_value.to_numpy()
        lo, hi = vals.min(), vals.max()
        for _, row in sub.iterrows():
            frac = 0.0 if hi == lo else (row.param_value - lo) / (hi - lo)
            is_emde = param in EMDE_VALUES and abs(row.param_value - EMDE_VALUES[param]) < 1e-9
            fig.add_trace(
                go.Scatter(
                    x=quarters, y=row[ycols].to_numpy(dtype=float), mode="lines",
                    line=dict(
                        color=_lerp_hex(c_lo, c_hi, frac),
                        width=4.0 if is_emde else STYLE["line_width_standard"],
                    ),
                    showlegend=False, hoverinfo="skip",
                ),
                row=1, col=col,
            )
            fig.add_trace(
                go.Scatter(
                    x=[IMPACT_QUARTER], y=[float(row[ycols[0]])], mode="markers",
                    marker=dict(
                        symbol="circle", size=7 if is_emde else 6,
                        color=_lerp_hex(c_lo, c_hi, frac),
                        line=dict(color="white", width=0.75),
                    ),
                    showlegend=False, hoverinfo="skip",
                ),
                row=1, col=col,
            )
        # baseline calibration: thick grey line (identified in the figure note)
        base = irf[(irf.experiment == ex) & (irf.is_baseline == 1)]
        if len(base):
            fig.add_trace(
                go.Scatter(
                    x=quarters, y=base.iloc[0][ycols].to_numpy(dtype=float), mode="lines",
                    line=dict(color="#757575", width=5.0),
                    showlegend=False, hoverinfo="skip",
                ),
                row=1, col=col,
            )
            fig.add_trace(
                go.Scatter(
                    x=[IMPACT_QUARTER], y=[float(base.iloc[0][ycols[0]])], mode="markers",
                    marker=dict(
                        symbol="circle", size=7, color="#757575",
                        line=dict(color="white", width=0.75),
                    ),
                    showlegend=False, hoverinfo="skip",
                ),
                row=1, col=col,
            )
        # label every line with its parameter value, just past its right endpoint
        # (the panel title carries the parameter symbol). The baseline value's
        # label is greyed to match the thick grey baseline line and stays at its
        # endpoint; the others are spread vertically outward from it (up for
        # higher values, down for lower) only where they would otherwise overlap.
        items = []
        for _, r in sub.iterrows():
            frac = 0.0 if hi == lo else (r.param_value - lo) / (hi - lo)
            r_end = float(r[ycols[-1]])
            is_base = abs(r.param_value - AE_VALUES[param]) < 1e-9
            is_emde = param in EMDE_VALUES and abs(r.param_value - EMDE_VALUES[param]) < 1e-9
            items.append({"y": r_end, "label_y": r_end, "val": r.param_value,
                          "is_base": is_base, "is_emde": is_emde,
                          "color": "#757575" if is_base else _lerp_hex(c_lo, c_hi, frac)})
        items.sort(key=lambda d: d["y"])
        anchor = next((k for k, d in enumerate(items) if d["is_base"]), len(items) // 2)
        for k in range(anchor + 1, len(items)):              # push higher labels up
            items[k]["label_y"] = max(items[k]["y"], items[k - 1]["label_y"] + label_min_gap)
        for k in range(anchor - 1, -1, -1):                  # push lower labels down
            items[k]["label_y"] = min(items[k]["y"], items[k + 1]["label_y"] - label_min_gap)
        for d in items:
            label = _format_param(d["val"])
            if d["is_base"]:
                label += " (AE)"
            elif d["is_emde"]:
                label += " (EMDE)"
            fig.add_annotation(
                row=1, col=col, x=HORIZON_QUARTERS, y=d["label_y"],
                text=label, showarrow=False,
                xanchor="left", yanchor="middle", xshift=3,
                font=dict(family=FONT_FAMILY, size=label_font_px, color=d["color"]),
            )

    # Subplot titles (the first len(PANELS) annotations, added by make_subplots
    # before the endpoint labels) at the title point size.
    for annotation in fig["layout"]["annotations"][:len(PANELS)]:
        annotation["font"] = dict(family=FONT_FAMILY, size=title_font_px)

    fig.update_layout(
        template=STYLE["template"],
        width=width_px, height=height_px, margin=STYLE["margins"],
        font=dict(family=FONT_FAMILY, size=font_px),
        showlegend=False,
    )

    axes = STYLE["axes"]
    fig.update_xaxes(
        tickvals=X_TICKS, ticktext=X_TICK_LABELS,
        tickangle=0, range=[0, HORIZON_QUARTERS], showgrid=False,
        linecolor=axes["linecolor"], linewidth=axes["linewidth"],
        ticks=axes["ticks"], tickfont=dict(size=font_px),
    )
    fig.update_yaxes(
        range=[ylo, yhi],
        showgrid=axes["showgrid"], gridcolor=axes["gridcolor"], gridwidth=axes["gridwidth"],
        zeroline=axes["zeroline"], zerolinewidth=axes["zerolinewidth"], zerolinecolor="black",
        linecolor=axes["linecolor"], linewidth=axes["linewidth"],
        ticks=axes["ticks"], tickfont=dict(size=font_px),
    )

    FIGURES_DIR.mkdir(parents=True, exist_ok=True)
    png_path = FIGURES_DIR / f"{output_stem}.png"
    pdf_path = FIGURES_DIR / f"{output_stem}.pdf"
    html_path = FIGURES_DIR / f"{output_stem}.html"
    smart_save_image(fig, png_path, display_cm)
    write_pdf(fig, pdf_path, width_px, display_cm[0])
    fig.write_html(html_path, auto_open=True)
    print(f"  Saved {png_path.name}, {pdf_path.name} and {html_path.name}")

    # Tidy long-format export: one row per (panel, parameter value, quarter).
    records = []
    for base_ex, param, title, _psym, _ramp in PANELS:
        ex = f"{base_ex}{suffix}"
        sub = irf[(irf.experiment == ex) & (irf.param == param)].sort_values("param_value")
        for _, row in sub.iterrows():
            for q in quarters:
                records.append({"panel": title, "param": param,
                                "param_value": row.param_value, "quarter": q,
                                "pct_dev": round(float(row[f"yd_q{q}"]), 3)})
    csv_path = FIGURES_DIR / f"{output_stem}.csv"
    pd.DataFrame(records).to_csv(csv_path, index=False)
    print(f"  Exported data to {csv_path.name}")


if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument(
        "--permanent", action="store_true",
        help="plot the permanent-shock sensitivity sweep",
    )
    main(permanent=parser.parse_args().permanent)
