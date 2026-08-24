"""
Working paper: cumulative fiscal-multiplier table for the four standard
debt-financed expansion simulations (Model_HumanCapital_exp_{gc,igi,ige,grd}).

The model's post-simulation block (models/postSimul.mod) computes cumulative
output multipliers at 1/5/10/20/25-year horizons but only *prints* them and uses
the combined investment change (Igi+Ige+Grd) as the denominator, which is zero
for a pure consumption shock. This script reproduces the calculation from the
committed simulation paths but divides each scenario's output gain by *its own*
spending change, so every instrument (consumption included) gets a finite
multiplier.

For each scenario it loads <model>/Output/<model>_results.mat, takes the
endogenous simulation oo_.endo_simul (column 1 = pre-shock steady state), and
computes the PRESENT-VALUE cumulative multiplier

    M_Ny = sum_{t=1}^{4N} beta^(t-1) (yd_t - yd_ss)
           ------------------------------------------------
           sum_{t=1}^{4N} beta^(t-1) (instrument_t - instrument_ss)

i.e. output and own-spending are each discounted before summing, so flows
arriving at different dates are compared on equal footing. beta is the model's
own discount factor (read from M_.params), equivalently discounting at the
steady-state real rate R_ss = 1/beta. (Because numerator and denominator share
the same weights, the choice of starting exponent is immaterial to the ratio.)
Without discounting the AR(1) spending injection saturates while productive
output keeps accumulating, so the undiscounted cumulative multiplier rises
mechanically with the horizon; discounting curbs that long-horizon drift.

Period 1 (endo_simul column 1) is the pre-shock steady state and is excluded;
the shock is active from period 2, so an N-year horizon spans the 4N quarters in
indices 2:(N*4+1). Each is a +1%-of-GDP debt-financed AR(1) shock with
persistence 0.9 and no offsetting cut (advanced-economy and emerging-market
calibrations alike).

Writes:
  ../csvFiles/multipliers.csv      (one row per scenario, all horizons)
  ../multipliersTable.tex          (\\input by draftPaper.tex)

The permanent-shock table also reports three partial model variants beneath
every estimable baseline row: no endogenous technology, no human capital, and
both removals together.
"""
from pathlib import Path
import numpy as np
from scipy.io import loadmat

HERE = Path(__file__).resolve().parent
REPO = HERE.parents[2]                        # repo root (.../wp-equations)
MODELS = REPO / "models"
CSV_OUT = HERE.parent / "csvFiles" / "multipliers.csv"
TEX_OUT = HERE.parent / "multipliersTable.tex"
CSV_OUT_PERM = HERE.parent / "csvFiles" / "multipliersPermanent.csv"
TEX_OUT_PERM = HERE.parent / "multipliersTablePermanent.tex"

# Table columns: (header label, horizon in years). The outer horizons are
# consolidated into a single "Long-term" column, reported at the 250-year horizon
# by which the present-value cumulative multiplier has largely stopped changing.
COLS = [("1y", 1), ("5y", 5), ("10y", 10), ("20y", 20), ("25y", 25), ("Long-term", 250)]
HORIZONS = [yr for _, yr in COLS]      # years; quarter window is N*4
CHANNEL_HORIZON = 25

# Both tables stop at 25 years: the cumulative multiplier converges only
# gradually, so the 250-year column invited more weight than it can carry. The
# CSVs still record every horizon in COLS.
TEX_COLS = [col for col in COLS if col[0] != "Long-term"]

# Spending type -> list of (region label, model directory or None, instrument).
# A None model emits dashes (R&D is shut down for EMDEs: alphaRD = alphaHA = 0).
GROUPS = [
    ("Government consumption", [
        ("AE", "Model_HumanCapital_exp_gc",    "Gc"),
        ("EMDE", "EM_Model_HumanCapital_exp_gc", "Gc"),
    ]),
    ("Infrastructure investment", [
        ("AE", "Model_HumanCapital_exp_igi",    "Igi"),
        ("EMDE", "EM_Model_HumanCapital_exp_igi", "Igi"),
    ]),
    ("Human capital investment", [
        ("AE", "Model_HumanCapital_exp_ige",    "Ige"),
        ("EMDE", "EM_Model_HumanCapital_exp_ige", "Ige"),
    ]),
    ("Research and development", [
        ("AE", "Model_HumanCapital_exp_grd", "Grd"),
        ("EMDE", None,                        None),
    ]),
]

# Permanent-shock counterparts: same instruments, model dirs suffixed "_perm".
PERM_GROUPS = [(stype, [(r, (m + "_perm") if m else None, i) for r, m, i in regs])
               for stype, regs in GROUPS]

# Supplementary estimates shown below every estimable permanent baseline row.
# Their names mirror the baseline model names so the table stays synchronized
# with the experiment list in drivers/runModel.m.
PERM_SUPPLEMENTS = {
    model: [
        ("No human capital",
         model.replace("Model_HumanCapital", "Model_NoHumanCapital"), inst, "stepgreen"),
        ("No endog. tech.",
         model.replace("Model_HumanCapital", "Model_Simple1"), inst, "targetblue"),
        ("No endog. tech. + no human capital",
         model.replace("Model_HumanCapital", "Model_Simple2"), inst, "stepred"),
    ]
    for _stype, regions in PERM_GROUPS
    for _region, model, inst in regions
    if model is not None
}


def multipliers(model, inst):
    """Present-value cumulative output multipliers at each horizon (output and
    own-spending discounted at the model's beta), own-spending denominator."""
    m = loadmat(MODELS / model / "Output" / f"{model}_results.mat")
    oo, M = m["oo_"], m["M_"]
    sim = oo["endo_simul"][0, 0]                       # n_endo x T
    names = [str(x[0]) for x in M["endo_names"][0, 0][:, 0]]
    idx = {n: i for i, n in enumerate(names)}
    ss = oo["steady_state"][0, 0].ravel()
    pnames = [str(x[0]) for x in M["param_names"][0, 0][:, 0]]
    beta = float(M["params"][0, 0].ravel()[pnames.index("betta")])

    yd = sim[idx["yd"]]
    fc = sim[idx[inst]] - ss[idx[inst]]               # own spending change
    out = {}
    for h in HORIZONS:
        ped = h * 4 + 1                                # MATLAB yd(2:ped); period 1 = SS, excluded
        disc = beta ** np.arange(ped - 1)             # beta^0 ... beta^(4N-1)
        out[h] = float(np.sum(disc * (yd[1:ped] - yd[0])) / np.sum(disc * fc[1:ped]))
    return out


def emit(groups, csv_out, tex_out, label, supplements=None, channel_effect=False,
         tex_cols=None):
    """Compute every (type, region) cell for one shock set and write its CSV + TeX.

    tex_cols selects which horizons the TeX table shows; the CSV always keeps all
    of COLS so no computed horizon is lost.
    """
    supplements = supplements or {}
    tex_cols = tex_cols or TEX_COLS
    tex_horizons = [yr for _, yr in tex_cols]
    print(f"--- {label} ---")
    data = []   # (stype, region, model, mult-or-None, 25-year channel effect)
    for stype, regions in groups:
        for region, model, inst in regions:
            mult = multipliers(model, inst) if model else None
            data.append((stype, region, model, mult, None))
            shown = ("  ".join(f"{lbl}={mult[yr]:.2f}" for lbl, yr in COLS)
                     if mult else "  (n/a)")
            print(f"  {stype:26s} {region:20s} {shown}")
            for step, step_model, step_inst, _step_color in supplements.get(model, []):
                step_mult = multipliers(step_model, step_inst)
                effect = (mult[CHANNEL_HORIZON] - step_mult[CHANNEL_HORIZON]
                          if channel_effect else None)
                data.append((stype, f"{region} - {step}", step_model, step_mult, effect))
                shown = "  ".join(f"{lbl}={step_mult[yr]:.2f}" for lbl, yr in COLS)
                print(f"  {'':26s} {step:20s} {shown}")

    csv_cols = ["mult_" + lbl.replace("-", "").replace(" ", "").lower() for lbl, _ in COLS]
    if channel_effect:
        csv_cols.append(f"channel_effect_{CHANNEL_HORIZON}y")
    csv_out.parent.mkdir(parents=True, exist_ok=True)
    with csv_out.open("w", encoding="utf-8") as f:
        f.write("category,region,model," + ",".join(csv_cols) + "\n")
        for stype, region, model, mult, effect in data:
            cells = (",".join(f"{mult[h]:.4f}" for h in HORIZONS)
                     if mult else ",".join([""] * len(HORIZONS)))
            if channel_effect:
                cells += f",{effect:.4f}" if effect is not None else ","
            f.write(f"{stype},{region},{model or ''},{cells}\n")
    print(f"  Wrote {csv_out.name}")

    ncol = len(tex_cols) + int(channel_effect)
    header_labels = [lbl for lbl, _ in tex_cols]
    if channel_effect:
        header_labels.append(rf"\makecell{{Channel effect\\({CHANNEL_HORIZON}y)}}")
    header = "    Present-value multiplier & " + " & ".join(header_labels) + " \\\\"
    lines = [
        "% Generated by pyScripts/makeMultipliers.py from the committed",
        "% _results.mat simulation paths. Do not edit by hand.",
        "\\begin{tabular}{l " + "c " * ncol + "}",
        "    \\toprule",
        header,
        "    \\midrule",
    ]
    for gi, (stype, regions) in enumerate(groups):
        if gi > 0:
            lines.append("    \\addlinespace[0.3em]")
        lines.append(f"    \\multicolumn{{{ncol + 1}}}{{l}}{{\\textit{{{stype}}}}} \\\\")
        for region, model, inst in regions:
            mult = multipliers(model, inst) if model else None
            cells = (" & ".join(f"{mult[h] + 0.0:.2f}".replace("-0.00", "0.00")
                                 for h in tex_horizons)
                     if mult else " & ".join(["--"] * ncol))
            if mult and channel_effect:
                cells += " & --"
            lines.append(f"    \\quad {region} & {cells} \\\\")
            for step, step_model, step_inst, step_color in supplements.get(model, []):
                step_mult = multipliers(step_model, step_inst)
                step_cells = " & ".join(
                    f"{{\\scriptsize\\color{{{step_color}}} {step_mult[h] + 0.0:.2f}}}".replace(
                        "-0.00", "0.00"
                    )
                    for h in tex_horizons
                )
                if channel_effect:
                    effect = mult[CHANNEL_HORIZON] - step_mult[CHANNEL_HORIZON]
                    effect_cell = f"{{\\scriptsize\\color{{{step_color}}} {effect + 0.0:.2f}}}".replace(
                        "-0.00", "0.00"
                    )
                    step_cells += f" & {effect_cell}"
                step_label = f"{{\\scriptsize\\color{{{step_color}}}\\itshape {step}}}"
                lines.append(f"    \\quad\\quad {step_label} & {step_cells} \\\\")
    lines += ["    \\bottomrule", "\\end{tabular}"]
    tex_out.write_text("\n".join(lines) + "\n", encoding="utf-8")
    print(f"  Wrote {tex_out.name}")


def main():
    emit(GROUPS,      CSV_OUT,      TEX_OUT,      "AR(1), persistence 0.9")
    emit(PERM_GROUPS, CSV_OUT_PERM, TEX_OUT_PERM, "Permanent shocks", PERM_SUPPLEMENTS,
         channel_effect=True)


if __name__ == "__main__":
    main()
