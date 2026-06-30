# §4.3 Sensitivity analysis — multipliers vs. structural parameters

Quantitative back-up for **§4.3 (Sensitivity)**, which currently has qualitative
text only. A **one-at-a-time (OAT)** sweep of the structural parameters the
section flags — α_G, μ, and the three spending-efficiency wedges — showing how
each moves the fiscal multiplier of the standard expansions.

## Why a bespoke sweep (and not Dynare's GSA)

Dynare's native global sensitivity toolbox (`sensitivity` / `dynare_sensitivity`)
is built on the **perturbation/`stoch_simul`** reduced form: it Monte-Carlo
samples parameters and maps them to stability regions and to stochastic
moments/IRFs. This model is solved entirely by **`perfect_foresight_setup` /
`perfect_foresight_solver`** (deterministic, 2000-period), so the native toolbox
does not apply without a separate, stationarized `stoch_simul` version of the
model — which would change the object being analyzed. The native toolbox also
answers a different question (determinacy + moment Sobol indices), not "how does
the 25-year multiplier move with α_G."

What §4.3 needs is comparative statics of the **multiplier / IRF** with respect to
a handful of named parameters. That is the same pattern as the Frisch check in
`../galiCheck/phi_sweep.m`: override the parameter with `set_param_value`,
re-solve the deterministic model, recompute the statistic.

## Parameters swept (AE calibration)

| Paper | `.mod` | AE baseline | grid |
|---|---|---|---|
| α_G (infra output elasticity) | `alphaG`    | 0.054  | 0.02–0.20 (to the EM value) |
| μ (HC-formation elasticity)   | `alphaH`    | 0.10   | 0.05–0.30 |
| α_RD (R&D-on-TFP elasticity)  | `alphaRD`   | 0.0189 | 0.005–0.10 |
| ς (adoption elasticity)       | `rhoSADOPT` | 0.80   | 0.10–0.95 |

`alphaRD` = 0.09·(1−ρ_A) is derived, so the sweep reads each parameter's AE
baseline from `M_.params` at build time (no hardcoding). One parameter moves at a
time; the others stay at baseline.

**The efficiency-gap parameters (e^GI/e^GE/e^GRD) were dropped from the sweep.**
A first pass showed the per-dollar multiplier is *exactly* invariant to them (the
(1−e) wedge scales effective spending and the steady-state stock by the same
factor, cancelling in the ratio). The gap level sets the *stock*; the gains from
*closing* a gap are the separate §5.2 experiment. This cleanly separates §4.3
from §5.2 and is worth a sentence in the paper, but it is not a sweep dimension.

## Experiments (AE only, first pass)

The four standard debt-financed expansions (`Model_HumanCapital_exp_{gc,igi,ige,grd}`),
AR(1) ρ=0.9, +1%-of-GDP, the same specs as `runModel.m` and Table 3.

## Multiplier definition

Identical to Table 3 (`pyScripts/makeMultipliers.py`): the **present-value
cumulative own-spending multiplier**

    M_Ny = Σ β^(t-1) (yd_t − yd_ss)  /  Σ β^(t-1) (inst_t − inst_ss),   t = 2..4N+1

with β = `betta` and `inst` the experiment's own instrument (Gc/Igi/Ige/Grd).
Horizons: 1, 5, 10, 20, 25 years and a "long-term" 250-year column.

## Files

- `sweep.m` — the driver. Builds each AE expansion in a gitignored `work/` dir
  (so the committed `models/**/_results.mat` are never touched — the shared
  macros and steady-state helper are pulled from `models/` via the preprocessor
  `-I` include path and the MATLAB path), then OAT-sweeps the five parameters and
  writes one row per (experiment, parameter, grid value).
- `results/sweep_AE.csv` — tidy multiplier output: `experiment, instrument,
  param, param_value, is_baseline, mult_1y, mult_5y, mult_10y, mult_20y,
  mult_25y, mult_long`. (`*_smoke.csv` are gitignored smoke artifacts.)
- `results/sweep_AE_irf.csv` — companion IRF output: the **annual `yd` impulse
  response** (percent deviation from steady state) for every draw, wide —
  `…, is_baseline, yd_y0 … yd_y50` (year 0 = SS = 0; year k = mean of that
  year's four quarters). Same rows as the multiplier file.
- `plot_sweep.py` — (i) `sweep_grid.png`: multiplier vs. parameter, experiment ×
  parameter small multiples at the long-term horizon; (ii) `sweep_tornado.png`:
  per-experiment tornado; (iii) `sweep_irf_fan.png`: output-IRF fans (yd vs.
  year) for selected (experiment, parameter) pairs, one line per grid value.
- `work/` — gitignored Dynare build artifacts.

## How to run

From the repo root, in MATLAB (project Dynare on the path via `iniProject`):

```matlab
cd('/Users/kk/Developer/sm-worktrees/wp-equations'); iniProject;
run('docs/2026-06_wp-imf/investigations/sensitivity/sweep.m')
```

Or headless (benign exit-time segfault after the `Wrote …` line, as with
`runModel.m`):

```bash
matlab -batch "cd('<repo>'); iniProject; run('docs/2026-06_wp-imf/investigations/sensitivity/sweep.m')"
```

A quick smoke test (one experiment, one parameter, short horizon):

```bash
SWEEP_SMOKE=1 matlab -batch "...same..."
```

Then plot (Python 3.11 framework env):

```bash
python docs/2026-06_wp-imf/investigations/sensitivity/plot_sweep.py
```

## Findings (AE, full sweep — `results/sweep_AE{,_grid,_tornado}.png`)

Each multiplier has a **two-factor** structure: its own channel's elasticity as
the primary driver, plus the adoption elasticity ς as a universal secondary one.

1. **Each productive multiplier is governed by its own output elasticity**
   (long-term, near-linear): infrastructure in α_G (0.13 → 11.6 as α_G = 0.02 →
   0.20; baseline 0.054 → 2.38), human capital in μ (3.5 → 25.8 as μ = 0.05 →
   0.30; baseline 8.19), R&D in α_RD (0.95 → 34.2 as α_RD = 0.005 → 0.10; baseline
   0.0189 → 6.66). Each is essentially flat to the *other* channels' elasticities.
2. **ς (adoption elasticity) is the one systemic parameter** — every experiment
   is sensitive to it at long horizons, because it governs economy-wide technology
   diffusion. The response is strongly **convex**, kicking in above ς ≈ 0.8
   (long-term: R&D 5.1 → 12.3, HC 6.5 → 24.1, infra 1.9 → 5.9 as ς = 0.10 → 0.95;
   wasteful consumption becomes *more* negative, −0.5 → −2.9). Since the paper
   uses ς = 0.80 and the literature suggests 0.90–0.95, the calibration sits right
   at the knee of the curve — a calibration note worth making.
3. **ς also shifts the R&D multiplier's *timing*.** Higher ς back-loads the payoff
   (R&D 10-year multiplier 3.3 at ς = 0.1 → 0.16 at ς = 0.95) while raising the
   long-run level — faster eventual diffusion, slower to arrive.
4. **Government consumption (≈ −1.2 long run) responds only to ς** — no productive
   channel, so the own-elasticities do nothing; ς amplifies the long-run wealth
   loss.

The efficiency gaps were checked and found *exactly* invariant (see above), so
they are excluded. Baselines reproduce Table 3 (`makeMultipliers.py`) exactly,
validating the loop. One non-key cell failed to solve (government consumption at
ς = 0.95, recorded NaN).

## Status / next steps

- [x] Driver runs end-to-end; AE full sweep complete; baselines match Table 3.
- [x] R&D sweep extended with α_RD and ς; both drive the R&D multiplier.
- [ ] EMDE counterpart (re-run with EM params/efficiency; note α_RD = α_HA = 0,
      so no R&D channel, ς is small at 0.1, and μ is larger at 0.25).
- [ ] Promote the chosen view to a paper figure/table via the chartTable
      pipeline once the headline cut is agreed (tornado vs. spider; which
      horizon; which parameter→experiment pairings to feature).
