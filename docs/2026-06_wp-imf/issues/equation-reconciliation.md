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

## ⚠ Timing-convention mismatch (paper writes stocks contemporaneously; model uses predetermined/lagged stocks)
A pervasive difference — not an error in the model (it is internally consistent with
predetermined stocks), but the paper's dating does not match the code. A replicator
comparing them would be misled. Needs an author decision on which dating is intended
(then fix the other side):

1. **Production** (eq. 242): paper $A_t$, model `A(-1)`. (Capital $K_{t-1}$, $K^{GI}_{t-1}$ already match — both lagged.)
2. **Effective labor** (212/244): paper $N_t = H_t L_t$, model `N = Lab*H(-1)`.
3. **Labor FOC** (230): paper $H_t$, model `H(-1)` (follows from 2).
4. **HC accumulation** (224) and the **schooling FOC** (231): paper $K_t^{GE}$, model `Kge(-1)`; the relative timing of $E$ and $K^{GE}$ also differs (paper same period; model `E` with `Kge(-1)`).
5. **Adoption** (eq. 555): paper $q_t\phi(Z_t-A_t)+\phi A_t$, model `q*phi*(Z(-1)-A(-1))+phi*A(-1)` (model pairs current `q` with lagged `Z`,`A`).
6. **Adoption value functions** $\mathcal V$, $\mathcal J$, and the $S$-FOC (556–558): paper detrends with $A_t/A_{t+1}$, model with `A(-1)/A` (= $A_{t-1}/A_t$).

## ⚠ Substantive discrepancies (beyond dating)
7. **R&D instrument persistence.** Appendix A (eq. 567) gives public R&D an AR(1) term,
   $G_t^{RD}-G^{RD}=\rho_{RD}(G_{t-1}^{RD}-G^{RD})+Y^d\varepsilon_t^{grd}$, but (a) the
   model's instrument is `Grd = Grdss + ydss*epsi_grd` with **no** AR term (persistence
   lives in the shock path), (b) $\rho_{RD}$ is **not a model parameter**, and (c) the
   paper applies it **only** to R&D — the other three instruments (565–568) have no
   persistence term. → Recommend writing all four instruments uniformly as
   $X_t = X^{SS} + Y^d\varepsilon_t$ (drop $\rho_{RD}$ from 567), and state the AR(1)
   persistence as a property of the experiment's shock path.
8. **Market-clearing technology resources** (eq. 592). Model: `... + Srd + (Z(-1)/A(-1)-1)*S`;
   paper: `... + S_t + (Z_{t-1}/A_{t-1}-1)S_t`. The first term differs — the model adds
   `Srd` (steady-state R&D-development labor, a constant) whereas the paper adds the
   adoption expenditure $S_t$ again. Confirm the intended resource cost of the
   technology sector and align the two.

## 🧹 Dead parameters (declared, never used in any equation) — candidates for deletion
`rho_Gc`, `rho_Igi`, `rho_Ige` (=0.9 in the macros, but the instrument equations are
`X = Xss + ydss*epsi_X`, with no persistence term). Same situation as the already-deleted
`alphaZZ1`/`rho_AAt`. (These are already shown "--" in the glossary.)

## Direction
The timing items (1–6) need the author's call on the intended dating; the cleanest
outcome is to make the paper adopt the model's predetermined-stock dating (lag the
stocks), since the model is the solved/implemented version. Items 7–8 are clear
paper-side simplifications to match the model. None of this changes model results.
