# Equation-by-equation reconciliation: paper vs model (2026-07)

Systematic comparison of `draftPaper.tex` (§2 main text + Appendix A equilibrium
conditions) against `models/model_block.modpart`. Conventions that are **not**
discrepancies: the paper presents several equations in level form while the model
is stationarized (the `g`/`(1+gammaa)` factors in the Euler, capital-return, debt,
and capital laws-of-motion are the balanced-growth detrending — the paper's
Appendix A states this explicitly); and the model uses one `delta` (=0.025) where
the paper writes $\delta$, $\delta^{GI}$, $\delta^{GE}$ (all the same value) plus
$\delta^h$.

## ✅ Match (current, verified 2026-07 after the simplification pass)
Marginal utility, both Euler equations, private-capital LoM, Calvo `x1`/`x2` + price
LoM, marginal-cost/factor FOCs, shadow value of HC, SDF, Taylor rule, government
borrowing rate (simplified — see the simplification pass below), public-capital LoMs
(`Kg`,`Kge`), government budget, tax rules, transfer rule, debt-to-GDP, gross-output
wedge, price dispersion, market clearing, production, HC accumulation, and the
technology-creation eq (Z) (now deterministic, wedge inlined). All verified
line-for-line against `model_block.modpart`.
**Correction (2026-07-02):** the "marginal-cost/factor FOCs" entry above was wrong —
the paper's factor demands omitted the `markupss` wedge. See "Factor-price markup
wedge" below; fixed paper-side.

## ⚠ Timing-convention mismatch — FIXED 2026-07 (paper aligned to the model)
The model uses predetermined (lagged) stocks; the paper wrote some contemporaneously.
**Fixed in the paper** (paper-only, no model change) so all stocks entering production
and the FOCs are predetermined, matching the code:

1. **Production** (eq. 2.10): $A_t \to A_{t-1}$. (Capital $K_{t-1}$, $K^{GI}_{t-1}$ already lagged.)
2. **Effective labor** (prose 212/244): $N_t = H_t L_t \to N_t = H_{t-1}L_t$.
3. **Labor FOC** (eq. 2.6): $w_t H_t \to w_t H_{t-1}$.
4. **HC accumulation** (eq. 2.4) → $H_t = (1-\delta^h)H_{t-1} + \chi E_t^\gamma (K_{t-1}^{GE}/\Lambda_{t-1})^\mu$; **schooling FOC** (eq. 2.7) $K_t^{GE} \to K_{t-1}^{GE}$.
5. **Adoption** (eq. A and the stationarized eq. Astat): $\to A_t = q_t\phi(Z_{t-1}-A_{t-1})+\phi A_{t-1}$.
6. **Adoption value functions** $\mathcal V$, $\mathcal J$, $S$-FOC: detrending ratio $A_t/A_{t+1} \to A_{t-1}/A_t$.

Verified each against `model_block.modpart`; the paper's equation block now matches
the code line-for-line. The only intentional presentation difference that remains is
the `g`-detrending (paper main text in levels, model/appendix stationarized), which
the appendix states.

## ⚠ Substantive discrepancies (beyond dating) — FIXED 2026-07
**Items 7 and 8 fixed in the paper** (commit below) to match the model; no model change.

7. **R&D instrument persistence.** Appendix A (eq. 567) gives public R&D an AR(1) term,
   $G_t^{RD}-G^{RD}=\rho_{RD}(G_{t-1}^{RD}-G^{RD})+Y^d\varepsilon_t^{grd}$, but (a) the
   model's instrument is `Grd = Grdss + ydss*epsi_grd` with **no** AR term (persistence
   lives in the shock path), (b) $\rho_{RD}$ is **not a model parameter**, and (c) the
   paper applies it **only** to R&D — the other three instruments (565–568) have no
   persistence term. → **FIXED:** all four instruments now written uniformly as
   $X_t = X^{SS} + Y^d\varepsilon_t$ ($\rho_{RD}$ dropped); a clause notes the innovations
   follow a persistent AR(1) path in the experiments.
8. **Market-clearing technology resources** (eq. 592). Model: `... + Srd + (Z(-1)/A(-1)-1)*S`;
   paper: `... + S_t + (Z_{t-1}/A_{t-1}-1)S_t`. The first term differs — the model adds
   `Srd` (steady-state R&D-development labor, a constant) whereas the paper adds the
   adoption expenditure $S_t$ again. → **SUPERSEDED 2026-07:** `Srd` is pinned to zero,
   so the term was vacuous; it was dropped from both the model and the paper entirely,
   and `Srd` was later removed as a variable. See the simplification pass below.

## 🧹 Dead parameters — DELETED 2026-07
Removed 5 declared-but-never-used parameters (a full scan of all equation/SS files
confirmed none are referenced): `rho_Gc`, `rho_Igi`, `rho_Ige` (the instrument
equations are `X = Xss + ydss*epsi_X`, no persistence term) and `gamma_y_tauc`,
`gamma_y_tauw` (the tax rules respond to debt only, not the output gap). Deleted from
`declare_all.macro`, `declare_all_ext.macro`, `parameters_common.macro`, and the glossary;
re-ran 44 models (values identical). Parameter count 54 → 49. (Same situation as the
earlier `alphaZZ1`/`rho_AAt` deletions.)

## Tax-rate rules simplified — 2026-07-16
The consumption- and labor-income-tax rules are now direct tax-rate shocks,
`tauc=taucss+epsi_tauc` and `tauw=tauwss+epsi_tauw`. A shock of `0.01` changes the
corresponding rate by one percentage point; persistence, if used in a future tax
experiment, is encoded in the shock path. The four superseded parameters `rho_tauc`,
`rho_tauw`, `gamma_d_tauc`, and `gamma_d_tauw` were removed from the declarations,
common calibration, paper, and glossary. Across all 44 models, steady states are
exactly unchanged and the maximum absolute difference in simulated endogenous paths
is `1.39e-13`; both exported CSV datasets are byte-identical. Result MAT containers
changed because they include model metadata and eigenvalue information.

## Auxiliary transfer-rule dummy — 2026-07-16
The debt-feedback term in the transfer rule now carries the deterministic binary
switch `eTaux`, denoted $e_{T,t}^{\mathrm{aux}}$ in the paper. It is zero over
quarters `1:1000` in all 18 non-budget-neutral `*_exp_*` models, which switches
off the transfer response throughout the spending path and makes the experiments
entirely debt-financed. It returns to one afterward, restoring the debt-feedback
rule; all budget-neutral experiments keep it at one. All 44
models solve with unchanged steady states. Budget-neutral paths are exactly
unchanged, and the maximum absolute change among non-fiscal endogenous paths is
`1.03e-13`; only the intended transfer, deficit, and debt paths change materially.
Re-expressing the switch as a direct multiplier of the debt-feedback term leaves
all 44 steady states and endogenous simulation paths exactly unchanged relative
to the preceding implementation.

## 🧹 Model simplification pass — 2026-07 (supersedes item 8 and parts of the Match list)
After the reconciliation above, the model was pruned so only live, paper-described objects
remain. Every change was a numerical no-op (`figureNumbers` byte-identical each time) unless
noted, each followed by a 44-model re-run.

- **Dropped the `S^{R}` market-clearing term (supersedes item 8).** `Srd` is pinned to zero,
  so the term was vacuous. Removed from model and paper; market clearing is now
  `Y^d = C + I + I^{GI} + G^C + I^{GE} + G^{RD} + (Z_{t-1}/A_{t-1}-1)S_t`. Later removed the
  `Srd` and `Ns` variables entirely (both identically zero).
- **eq (Z) is now deterministic.** The inert R&D-process disturbance (`shockchi`≡1, never
  shocked) and its `+log(shockchi)` term were removed, and the R&D efficiency wedge was
  inlined (the `Grdeff` variable is gone). Model and paper eq (Z) match exactly:
  `log(Z/Zss) = ρ_A·log(Z(-1)/Zss) + (1-ρ_A)α_HA·log(H(-1)/Hss) + (1-ρ_A)α_RD·log((1-e^{GRD}_{t-1})G^{RD}_{t-1}/((1-e^{GRD})G^{RD,SS}))`.
  The long-run elasticities were recalibrated to `alphaHA=0.1/(1-rho_A)` and
  `alphaRD=0.09`, preserving the former effective coefficients exactly.
- **Removed the dormant sovereign-risk block (supersedes "sovereign spread + default
  probability" in the Match list).** `Deltacost=0`, so the debt-dependent spread was
  identically zero. Dropped `Delta_G`, `prob_def`, `eta1`, `eta2`, `Deltacost`; the borrowing
  rate simplified to `log(R) = ρ_RG·R(-1) + (1-ρ_RG)·log(R^{mp}) + ε^{spr}` (paper eq:spread
  updated, appendix subsection retitled "Monetary Policy and Government Borrowing Rate").
- **Removed inert allocative shocks** `epsiallo_ig`/`epsiallo_ige` (never set): production and
  HC simplify to `Kg(-1)^{α_G}` and `Kge(-1)^μ`, matching the paper. (The paper's allocative-
  efficiency scenario is the reallocation dimension, not these shocks.)
- **Removed unused reporting variables** `lnyd`, `lnPI`, `ln_Grd`, `ygrowth`, `by_ann`,
  `Igi_ys`, `Grd_ydss_ratio`, `pdef`, plus `TFP`/`dserv_yss` (exported but plotted nowhere).

Notation aligned with the paper: debt `D`/`d` → `b`/`by` (paper `B_t`/`b_t`/`b^*`); shock
`epsirhoadopt` → `epsi_q` (paper `ε^q`); transfer parameter `gamma_d_trans` →
`gamma_d_T` (paper `γ_d^T`), while the zero-calibrated `rho_trans` was subsequently
removed; plus the earlier Tier-1/2 renames.

Counts after the pass: **57 endogenous, 45 parameters, 13 exogenous** — model and the
appendix glossary match exactly.

## 🔧 Technology-block detrending — FIXED 2026-07
The appendix technology block (adoption LoM `eq:Astat`, value functions `eq:VA`/`eq:JZ`,
and the `S`-FOC `eq:SAfoc`) wrote the growth factor as `g`, but the model detrends the
technology stocks by their own rate `(1+gammaa)`, which is derived from output growth by
`1+gammaa = g^((1-alpha)/(vartheta-1))` (= `g^2` at the calibration, since the exponent
is 2). Technology grows faster than output because it enters production only via the
love-of-variety term `A^(vartheta-1)`; a single trend at `g` would leave the production
function unbalanced. **FIXED:** the four appendix equations, the glossary equations for
A/V/J/S, and the §2.5 discussion now use `1+gamma^a` (the paper's new symbol for `gammaa`),
with the relation `1+gamma^a = g^{(1-alpha)/(vartheta-1)}` stated. Paper-side only; the
model was already correct. See `investigations/tech-growth-rate/`.

## 🔧 Factor-price markup wedge — FIXED 2026-07-02 (paper-side)
The paper's factor demands (main-text `eq:factordemand`, the Appendix A derivation,
and the glossary equations for `rk`/`mc`) read `r^k = α·mc·Y/K`, `w = (1−α)·mc·Y/N`,
but the model prices factors off `mc/markupss`:
- `model_block.modpart:46`: `(1-alpha)*mc*y/N = markupss*w`
- `Steady_states_solution.m:34`: `w=(1-alpha)*mc*y/N/markupss` (and `:27` for `Kp_y`/rk)

The wedge is load-bearing: factor payments absorb only `mc/μ^p` of revenue, and the
residual `(μ^p−1)/μ^p·mc·Y` is exactly the per-period profit that gives adopted
technologies their value in `eq:VA` (`model_block.modpart:68`). Structure = Anzoategui
two-layer production: intermediate variety producers charge the fixed gross markup
`markupss`=1.18 over unit factor cost; Calvo retailers (elasticity ε=10, so the retail
markup ε/(ε−1)=1.11 is a *different* object) buy intermediate output at relative price
`mc` (their marginal cost; SS 0.9 = (ε−1)/ε).
**FIXED paper-side:** `eq:factordemand` + App. A now carry `mc_t/μ^p`; §2.2 and App. A
introduce the retail layer in one sentence each (final good aggregates *retail*
varieties; retailers buy intermediate output at `mc_t` and set Calvo prices); the
ε-vs-ϑ footnote now names both markups; the profit-flow sentence links the wedge to
the technology values. Glossary: `rk`/`mc` equations fixed, `markupss` got its paper
symbol `μ^p` (was `--`).

## 🔧 Minor exactness fixes — 2026-07-02 (paper-side)
- **SDF stated exactly.** `eq:sdf` now reads
  `SDF_{t+1} = β·λ_{t+1}(1+τc_{t+1})/(λ_t(1+τc_t)) = β·C_t/C_{t+1}` — identical to
  `model_block.modpart:29`, no "constant consumption-tax" caveat needed (the second
  equality is exact by eq:mu). Main-text §2.2 mention switched to `β·C_t/C_{t+1}`.
- **Adoption-probability shock shown.** App. A `eq:probadopt` now reads
  `q_t = (q_0+ε^q_t)(S_t)^ς`, matching `q = (kappaprob+epsi_q)*S^varsigma`
  (`model_block.modpart:62`); noted as zero in all experiments. Glossary `q` equation
  updated to match.
- **Glossary `byss` symbol fixed:** `$d^*$` → `$b^*$` (paper uses `b^*` throughout).

## Status
All items above are resolved. Timing items 1–6 and item 7 were fixed in the paper
(predetermined-stock dating; uniform instruments). Item 8 was superseded — the term was
dropped entirely. As of 2026-07 the model and paper are fully reconciled on equations and
notation; the only intentional presentation difference is the `g`-detrending (paper main
text in levels, model/appendix stationarized), which the appendix states.

The previously dormant borrowing-rate oddity is fixed: the persistence term is now
`rho_RG*log(R(-1))`, so the equation is consistently expressed in logs. The correction
is numerically inert at the current calibration (`rho_RG=0`) but makes the equation
well-defined if borrowing-rate persistence is used in future work. The paper's
equation~`eq:spread` and generated glossary were updated at the same time.

**Superseded on 2026-07-17:** the separate borrowing-rate equation has now been
removed. Because `rho_RG=0` and the spread shock was never activated, it imposed
`R=Rmp` in every simulation. The Taylor rule therefore determines `R` directly,
and `Rmp`, `rho_RG`, and `epsi_spread` have been eliminated.
