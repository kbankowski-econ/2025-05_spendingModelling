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
  verified-equivalent model at `ρ ∈ {0.9, 0.99}`, printing impact inflation / real
  wage / output. This isolates the Frisch dependence of the deflation's sign.
- `gali_compare.png` — committed reference output of `compare.m`.

## How to run

From the repo root, in MATLAB (the project's Dynare must be on the path via
`iniProject`):

```matlab
iniProject;
run('docs/2026-06_wp-imf/galiCheck/compare.m');     % equivalence + overlay
run('docs/2026-06_wp-imf/galiCheck/phi_sweep.m');   % Frisch sensitivity
```

Headless: `matlab -sd <repo> -batch "iniProject; run('docs/2026-06_wp-imf/galiCheck/compare.m')"`.
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

## Next step (TODO)

Run `ρ=0.9` under a Galí-like Frisch (φ≈5) to map where the inflation sign flips
and to decompose the paper-calibration deflation into Frisch vs persistence vs the
Taylor `γy` / `θ` contributions. `phi_sweep.m` is the quick path.
