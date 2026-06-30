# Equation-by-equation reconciliation: paper vs model (2026-07)

Systematic comparison of `draftPaper.tex` (§2 main text + Appendix A equilibrium
conditions) against `models/model_block.modpart`. Conventions that are **not**
discrepancies: the paper presents several equations in level form while the model
is stationarized (the `g`/`(1+gammaa)` factors in the Euler, capital-return, debt,
and capital laws-of-motion are the balanced-growth detrending — the paper's
Appendix A states this explicitly); and the model uses one `delta` (=0.025) where
the paper writes $\delta$, $\delta^{GI}$, $\delta^{GE}$ (all the same value) plus
$\delta^h$.

## ✅ Match (after the eq-Z fix)
Marginal utility, both Euler equations, private-capital LoM, Calvo `x1`/`x2` + price
LoM, marginal-cost/factor FOCs, shadow value of HC, SDF, Taylor rule, sovereign
spread + default probability, public-capital LoMs (`Kg`,`Kge`), government budget,
tax rules, transfer rule, debt-to-GDP, gross-output wedge, price dispersion, and the
technology-creation eq (Z) (reconciled earlier: loadings, lagged R&D).

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
   adoption expenditure $S_t$ again. → **FIXED:** the paper's first technology term is now
   $S^{R}$ (the steady-state R&D-development resource, = model `Srd`), with $\left(Z_{t-1}/A_{t-1}-1\right)S_t$
   the adoption cost; glossary maps `Srd` → $S^{R}$ (was "--").

## 🧹 Dead parameters — DELETED 2026-07
Removed 5 declared-but-never-used parameters (a full scan of all equation/SS files
confirmed none are referenced): `rho_Gc`, `rho_Igi`, `rho_Ige` (the instrument
equations are `X = Xss + ydss*epsi_X`, no persistence term) and `gamma_y_tauc`,
`gamma_y_tauw` (the tax rules respond to debt only, not the output gap). Deleted from
`declare_all.macro`, `declare_all_ext.macro`, `parameters_common.macro`, and the glossary;
re-ran 44 models (values identical). Parameter count 54 → 49. (Same situation as the
earlier `alphaZZ1`/`rho_AAt` deletions.)

## Direction
The timing items (1–6) need the author's call on the intended dating; the cleanest
outcome is to make the paper adopt the model's predetermined-stock dating (lag the
stocks), since the model is the solved/implemented version. Items 7–8 are clear
paper-side simplifications to match the model. None of this changes model results.
