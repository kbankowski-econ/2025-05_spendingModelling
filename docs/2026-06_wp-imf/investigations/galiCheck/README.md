# Canonical NK ↔ Galí (2015, Ch. 3) cross-check

Standalone verification that the paper's from-scratch canonical New Keynesian
benchmark (`models/modelTemplateNK.mod`, i.e. `Model_NK_exp_gc`) is the standard
Galí (2015, *Monetary Policy, Inflation, and the Business Cycle*, Ch. 3) model
plus a wasteful, lump-sum-financed government-consumption block. Supports the
appendix deflation figures (`fig:simplifiedGc`, `fig:durationGc`,
`fig:persistenceGc`) and the deflation-puzzle discussion. See the session handoff
`docs/2026-06_wp-imf/.sped.md` (DONE → "Canonical NK = Galí (2015, Ch. 3)").

## Files

- `gali_g.mod` — Pfeifer's nonlinear Galí Ch. 3 FOCs, trimmed to the real/nominal
  core and **extended with government**: market clearing `Y = C + G`, wasteful
  lump-sum-financed `G`, AR(1) `Gc` shock, solved in perfect foresight. `alppha`
  is set by `-DALPHA` (default 0); `0` = constant returns (exact match to ours),
  `0.25` = Galí's baseline decreasing-returns case.
- `ours_g.mod` — our `modelTemplateNK` equations with **Galí's calibration**
  (β=0.99, φ=5, θ=0.75, ε=9, φπ=1.5, φy=0.125, no interest smoothing), driven by
  the same AR(1) `Gc` shock. `phi_sweep.m` overrides `phi` at run time.
- `compare.m` — runs `ours_g`, `gali_g -DALPHA=0`, `gali_g -DALPHA=0.25`; prints
  the max |percent-deviation difference| (ours vs Galí α=0) and saves the overlay
  `gali_compare.png`.
- `phi_sweep.m` — sweeps the Frisch elasticity (`phi` = inverse Frisch) in the
  verified-equivalent model **at Galí's calibration**, `ρ ∈ {0.9, 0.99}`. Isolates
  the Frisch dependence of the deflation's sign.
- `ours_paper.mod` — our canonical NK with the **paper's own calibration**
  (β=0.9985, φ=1.2, ε=10, θ=0.8, γπ=1.5, γy=0.25, ρ_R=0.7), i.e. the model behind
  `fig:persistenceGc`; AR(1) `Gc` shock via `g_ar`.
- `frisch_rho09.m` — runs `ours_paper` at `ρ ∈ {0.9, 0.99}`, sweeping φ from the
  paper's 1.2 up to Galí's 5; saves the IRF overlay `frisch_rho09.png`. Answers
  "does our deflation survive a Galí-like Frisch?".
- `gali_compare.png`, `frisch_rho09.png` — committed reference outputs.

## How to run

From the repo root, in MATLAB (the project's Dynare must be on the path via
`iniProject`):

```matlab
iniProject;
run('docs/2026-06_wp-imf/investigations/galiCheck/compare.m');     % equivalence + overlay
run('docs/2026-06_wp-imf/investigations/galiCheck/phi_sweep.m');   % Frisch sensitivity
```

Headless: `matlab -sd <repo> -batch "iniProject; run('docs/2026-06_wp-imf/investigations/galiCheck/compare.m')"`.
Dynare writes generated folders (`+gali_g/`, `gali_g/`, logs, …) next to the
mods; these are gitignored.

## Key results (2026-06-25)

- **Equivalence:** with α=0, `ours_g` and `gali_g` agree to **max |diff| = 1.3e-5**
  over 60 quarters — our NK *is* Galí Ch. 3 + government consumption. The DRS
  α=1/4 case differs only in the magnitude of the real-wage / marginal-cost /
  hours response (same signs).
- **Sign of the Gc deflation is calibration-dependent.** It is governed jointly by
  shock persistence and the Frisch elasticity: more persistent and more
  elastic-labor ⇒ more deflationary. At Galí's textbook Frisch (φ=5, Frisch 0.2) a
  persistent `ρ=0.9` shock is **inflationary** (+0.11 impact); deflation appears
  only near-permanent. The paper's deflation claim holds for the **permanent**
  shock but is not universal.

| φ (Frisch) | impact inflation, ρ=0.9 | ρ=0.99 |
|---|---|---|
| 5.0 (0.20) — Galí | +0.114 | −0.029 |
| 1.2 (0.83) — ours | −0.003 | −0.108 |
| 0.2 (5.0) | −0.110 | −0.195 |

- **In the PAPER's calibration (`frisch_rho09.m`), the ρ=0.9 deflation is driven by
  the high Frisch elasticity.** Swapping φ=1.2 (Frisch 0.83) → φ=5 (Galí's Frisch
  0.2) flips the impact inflation from **−0.29 to +0.35 annualized pp** (the real
  wage flips −0.14 → +0.79). The sign crosses zero around Frisch ≈ 0.4 (φ between 2
  and 3). The φ=1.2 run reproduces `fig:persistenceGc`'s ρ=0.9 inflation (−0.29)
  exactly, validating the standalone. **But a near-permanent ρ=0.99 shock stays
  deflationary even at Galí's Frisch** (−0.41 ann pp). So the deflation needs *both*
  elastic labor *and/or* high persistence; the permanent-shock result is robust, the
  ρ=0.9 result is not.

  | OUR calibration | impact inflation (ann pp), ρ=0.9 | ρ=0.99 |
  |---|---|---|
  | φ=1.2 (Frisch 0.83) — paper | −0.288 | −1.045 |
  | φ=2.0 (Frisch 0.50) | −0.083 | −0.805 |
  | φ=3.0 (Frisch 0.33) | +0.102 | −0.618 |
  | φ=5.0 (Frisch 0.20) — Galí | +0.352 | −0.405 |

## Possible follow-ups

- Decompose the remaining gap between our and Galí's ρ=0.9 results into the Taylor
  `γy` (0.25 vs 0.125) and `θ` (0.8 vs 0.75) contributions.
- Decide whether to fold a Frisch (and/or persistence) sensitivity panel into the
  paper alongside `fig:persistenceGc`.
