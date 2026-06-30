"""
Plot the §4.3 OAT sensitivity sweep (AE).

Reads results/sweep_AE.csv (written by sweep.m) and produces, in results/:
  - sweep_grid.png   : small multiples, experiment (row) x parameter (col),
                       multiplier vs. parameter value at the long-term horizon,
                       with the AE baseline marked.
  - sweep_tornado.png: per-experiment tornado at a chosen horizon — how each
                       parameter's grid moves that experiment's multiplier.

Run with the Python 3.11 framework env:
  python docs/2026-06_wp-imf/investigations/sensitivity/plot_sweep.py
"""
from pathlib import Path
import numpy as np
import pandas as pd
import matplotlib
matplotlib.use("Agg")
import matplotlib.pyplot as plt

HERE = Path(__file__).resolve().parent
CSV = HERE / "results" / "sweep_AE.csv"
IRF_CSV = HERE / "results" / "sweep_AE_irf.csv"

# experiment -> (display label, instrument)
EXPS = {
    "Model_HumanCapital_exp_gc":  ("Government consumption", "Gc"),
    "Model_HumanCapital_exp_igi": ("Infrastructure", "Igi"),
    "Model_HumanCapital_exp_ige": ("Human capital", "Ige"),
    "Model_HumanCapital_exp_grd": ("R&D", "Grd"),
}
# parameter -> (display label, AE baseline)
PARAMS = {
    "alphaG":    (r"$\alpha_G$ (infra elasticity)", 0.054),
    "alphaH":    (r"$\mu$ (HC elasticity)", 0.10),
    "alphaRD":   (r"$\alpha_{RD}$ (R&D elasticity)", 0.0189),
    "rhoSADOPT": (r"$\varsigma$ (adoption elasticity)", 0.80),
}
PALETTE = ["#00838F", "#5E35B1", "#6A1B9A", "#AD1457", "#E65100"]
HORIZON = "mult_long"        # headline horizon for the figures
HORIZON_LABEL = "Long-term multiplier"


def load():
    df = pd.read_csv(CSV)
    return df[df.is_baseline == 0].copy()


def plot_grid(df):
    exps, params = list(EXPS), list(PARAMS)
    fig, axes = plt.subplots(len(exps), len(params), figsize=(14, 12),
                             sharex=False, squeeze=False)
    for r, ex in enumerate(exps):
        for c, p in enumerate(params):
            ax = axes[r][c]
            sub = df[(df.experiment == ex) & (df.param == p)].sort_values("param_value")
            ax.plot(sub.param_value, sub[HORIZON], "-o", color=PALETTE[c], ms=4)
            base = PARAMS[p][1]
            ax.axvline(base, color="#757575", ls="--", lw=0.8)
            ax.axhline(0, color="#bbbbbb", lw=0.6)
            if r == 0:
                ax.set_title(PARAMS[p][0], fontsize=11)
            if c == 0:
                ax.set_ylabel(EXPS[ex][0], fontsize=11)
            ax.tick_params(labelsize=8)
    fig.suptitle(f"AE spending multipliers — OAT sensitivity ({HORIZON_LABEL})",
                 fontsize=14)
    fig.tight_layout(rect=[0, 0, 1, 0.98])
    out = HERE / "results" / "sweep_grid.png"
    fig.savefig(out, dpi=150)
    print(f"Wrote {out}")


def plot_tornado(df, horizon=HORIZON):
    exps = list(EXPS)
    fig, axes = plt.subplots(2, 2, figsize=(14, 10), squeeze=False)
    for k, ex in enumerate(exps):
        ax = axes[k // 2][k % 2]
        rows = []
        for p in PARAMS:
            sub = df[(df.experiment == ex) & (df.param == p)]
            vals = sub[horizon].to_numpy()
            vals = vals[np.isfinite(vals)]
            if vals.size:
                rows.append((PARAMS[p][0], vals.min(), vals.max()))
        # order by span (widest swing at top)
        rows.sort(key=lambda t: t[2] - t[1])
        y = np.arange(len(rows))
        for i, (lbl, lo, hi) in enumerate(rows):
            ax.barh(i, hi - lo, left=lo, color="#6A1B9A", alpha=0.75, height=0.6)
        ax.set_yticks(y)
        ax.set_yticklabels([r[0] for r in rows], fontsize=10)
        ax.axvline(0, color="#bbbbbb", lw=0.6)
        ax.set_title(EXPS[ex][0], fontsize=12)
        ax.tick_params(labelsize=9)
    fig.suptitle(f"Sensitivity of AE multipliers ({HORIZON_LABEL}) — range over each parameter's grid",
                 fontsize=14)
    fig.tight_layout(rect=[0, 0, 1, 0.97])
    out = HERE / "results" / "sweep_tornado.png"
    fig.savefig(out, dpi=150)
    print(f"Wrote {out}")


def plot_irf_fan(pairs=None):
    """yd IRF fans: percent deviation from SS vs. year, one line per grid value of
    a parameter, for selected (experiment, parameter) pairs. Baseline highlighted."""
    if pairs is None:
        pairs = [
            ("Model_HumanCapital_exp_igi", "alphaG"),
            ("Model_HumanCapital_exp_ige", "alphaH"),
            ("Model_HumanCapital_exp_grd", "alphaRD"),
            ("Model_HumanCapital_exp_grd", "rhoSADOPT"),
        ]
    irf = pd.read_csv(IRF_CSV)
    ycols = [c for c in irf.columns if c.startswith("yd_y")]
    years = [int(c[4:]) for c in ycols]
    base = irf[irf.is_baseline == 1]

    fig, axes = plt.subplots(2, 2, figsize=(14, 10), squeeze=False)
    for k, (ex, p) in enumerate(pairs):
        ax = axes[k // 2][k % 2]
        sub = irf[(irf.experiment == ex) & (irf.param == p)].sort_values("param_value")
        cmap = plt.get_cmap("viridis")
        vals = sub.param_value.to_numpy()
        lo, hi = vals.min(), vals.max()
        for _, row in sub.iterrows():
            frac = 0.0 if hi == lo else (row.param_value - lo) / (hi - lo)
            ax.plot(years, row[ycols].to_numpy(dtype=float), color=cmap(frac), lw=1.6,
                    label=f"{p}={row.param_value:g}")
        b = base[base.experiment == ex]
        if len(b):
            ax.plot(years, b.iloc[0][ycols].to_numpy(dtype=float), "--", color="black",
                    lw=1.8, label="baseline")
        ax.axhline(0, color="#bbbbbb", lw=0.6)
        ax.set_title(f"{EXPS[ex][0]} — output IRF vs. {PARAMS[p][0]}", fontsize=11)
        ax.set_xlabel("Years after shock", fontsize=9)
        ax.set_ylabel("Output, % dev. from SS", fontsize=9)
        ax.legend(fontsize=7, ncol=2)
        ax.tick_params(labelsize=8)
    fig.suptitle("AE output (yd) IRF sensitivity — annual, percent deviation from steady state",
                 fontsize=14)
    fig.tight_layout(rect=[0, 0, 1, 0.97])
    out = HERE / "results" / "sweep_irf_fan.png"
    fig.savefig(out, dpi=150)
    print(f"Wrote {out}")


def main():
    df = load()
    plot_grid(df)
    plot_tornado(df)
    plot_irf_fan()


if __name__ == "__main__":
    main()
