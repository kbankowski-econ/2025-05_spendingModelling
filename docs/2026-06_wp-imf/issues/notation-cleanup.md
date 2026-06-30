# Notation cleanup (in progress)

We are cleaning notation **in the LaTeX glossary tables first** (app:glossary,
`makeGlossary.py`). Once the target notation is agreed, propagate to the draft
(`draftPaper.tex`) and the model (`models/`). The glossary's "model code" column
already shows the **target** names, which may run ahead of the actual model until
we propagate.

## DONE — Tier 1 (misleading names) + `alppha` typo: applied to the MODEL and glossary

Renamed in the model source (declare/param macros, `model_block(_simple).modpart`,
`modelTemplate{,NK,Simple}.mod`, `Steady_states_solution.m`) and in the glossary +
`makeParametersTable.py`. Re-ran all 44 models: rank condition verified, values
**identical** (a pure rename), `parametersTable.tex` byte-unchanged.

| paper | concept | old model code | new model code |
|---|---|---|---|
| $\mu$ | HC elasticity w.r.t. public HC stock | `alphaH` | `mu` |
| $\gamma$ | HC elasticity w.r.t. time input | `muy` | `gamma` |
| $\varsigma$ | adoption-probability elasticity | `rhoSADOPT` | `varsigma` |
| $\varphi$ | inverse Frisch elasticity | `phi` | `varphi` |
| $\phi$ | survival rate of adopted tech | `phiob` | `phi` |
| $\alpha$ | private capital share | `alppha` | `alpha` |

Note: `phi`/`phiob` were swapped carefully (`phi`→`varphi` first, then `phiob`→`phi`).
The paper prose uses the Greek symbols (unchanged), so no draft-text edit was needed.
`alpha`/`gamma` shadow MATLAB builtins but the rename solves cleanly (standard DSGE usage).

## DONE — Redundant trailing `t`: applied to the MODEL, glossary, varDict, and scripts

Renamed in the model source (declares, `model_block(_simple).modpart`, the three
templates, `Steady_states_solution.m`), in `+environment/csvFiles/varDict.csv`, and
in the export/plot scripts (`runSimulExport.m`, `runPlots.m`,
`investigateContributions.m`, `plotStandardShocksAE{,Perm}.py`, `plotSimplifiedGcAE.py`)
and the glossary. Re-ran all 44 models (rank condition verified) and re-exported;
values **identical** (pure rename). `figureNumbers` columns renamed (`…___AAt` → `…___A`).

| paper | concept | old model code | new model code |
|---|---|---|---|
| $Y_t$ | gross output ($Y_t = v_t^p Y_t^d$) | `yt` | `y` |
| $D_t$ | public debt | `Dt` | `D` |
| $A_t$ | adopted technology | `AAt` | `A` |
| $S_t$ | adoption expenditure | `St` | `S` |
| $\mathcal{J}_t$ | value of unadopted tech | `JZt` | `J` |
| — | effective labor for R&D | `SSt` | `Srd` (not `SS` — clashes with `*ss`) |
| $\chi_t$ | R&D-process disturbance | `shockchit` | `shockchi` (also `shockchitss`→`shockchiss`) |
| $\vartheta$ | love-of-variety exponent | `varthetaat` | `vartheta` |
| $\varepsilon_t^{\chi}$ | R&D-process shock | `epsi_shockchit` | `epsi_shockchi` |
| $\rho_\chi$ | R&D-process shock persistence | `rhoshockchit` | `rhoshockchi` |

Deleted: `rho_AAt` — dead parameter (`=0`, unused), removed from `declare_all.macro`,
`declare_all_ext.macro`, `parameters_common.macro`, and the glossary. Parameter count
56 → 55.

After this pass the model and the glossary match exactly with **no rename map**:
endogenous 74, parameters 55, exogenous 16.

## DONE — Tier 2 (opaque encoded names): applied to the MODEL, glossary, varDict, scripts

Renamed across the model source, `varDict.csv`, the export scripts (`runSimulExport.m`,
`runPlots.m`), the glossary, and `makeParametersTable.py`. Re-ran all 44 models (rank
condition verified) and re-exported; values **identical** (`parametersTable.tex`
byte-unchanged, since `rho_A`=`rho_ZZRD`=0.79). `figureNumbers` columns `…___ZZRD` → `…___Z`.

| paper | concept | old model code | new model code |
|---|---|---|---|
| $Z_t$ | created technology | `ZZRD` | `Z` |
| $\rho_A$ | persistence of created technology | `rho_ZZRD` | `rho_A` |
| $g_t$ | gross growth rate (variable) | `ZZ` | `g` |
| $g$ | steady-state gross growth | `ZZss` | `gss` |
| $\rho_g$ | trend-growth shock persistence | `rho_ZZ` | `rho_g` |
| $\varepsilon_t^{g}$ | trend-growth shock | `epsi_ZZ` | `epsi_g` |

No paper-symbol changes (code renamed to the existing symbols). No plot scripts reference
`ZZ`/`ZZRD`, so no figures needed regenerating. Model and glossary still match exactly:
74 / 55 / 16.

## DONE — Follow-up cleanups (2026-07)

Model + glossary + varDict + scripts (re-ran 44 models, re-exported; values identical):
- **χ symbol fix.** The paper uses `\chi_p` for price indexation (model `chi`) and bare
  `\chi` for the human-capital-accumulation scale (model `muyH`, paper line 224). Glossary
  corrected: `chi`→$\chi_p$, `muyH`→$\chi$ (was "--"). The model-only R&D disturbance
  (`shockchi`/`epsi_shockchi`/`rhoshockchi`) is now "--" in the Paper column — the paper's
  tech-creation equation is deterministic, so it carries no paper symbol (the earlier
  $\chi_t$/$\varepsilon_t^\chi$/$\rho_\chi$ were dropped; no `\zeta` introduced).
- **`alphaZZ1` deleted** — dead parameter (assigned 0.2, never used). Params 55 → 54.
- **`W_real`→`w`** ($w_t$, real wage). varDict + export updated.
- **`Trans`→`T`** ($T_t$) and **`Trans_yss`→`T_yss`** (reporting). varDict, export derivedMap,
  and the three plot scripts' `Trans_yss` panel updated; figures regenerated.
- **`probadopt`→`q`** ($q_t$), **`probadoptss`→`qss`** ($\bar q$).

Model and glossary still match exactly: endogenous 74, parameters 54, exogenous 16.

Not done (declined): `Kg`→`Kgi` (3), `Kp`/`Ip`→`K`/`I` (9), `betta`→`beta`
(10, MATLAB `beta` clash), `Bigtheta`→`Theta` (8).

## DONE — Debt level `D`→`b`

Renamed the public-debt level `D`→`b` (paper symbol $D_t$ unchanged) so debt and the
debt-to-GDP ratio form the mnemonic pair `b` / `by` (= b/y). Used an `&`-safe regex so
the `D` in "R\&D" comments was untouched. Model source + varDict + glossary; re-ran 44
models (values identical), re-exported. Debt level is not an exported column, so no
figure change. Model and glossary still match: 74 / 54 / 16.

## DONE — Parameter-symbol verification against the paper (glossary-only)

Cross-checked every glossary parameter symbol against the paper's actual equations.
Corrections (the paper uses a different form):
- `deltaH`: $\delta^H$ → **$\delta^h$** (paper line 224, lowercase).
- Steady-state values now use the paper's no-subscript convention: `Piss` $\Pi_{ss}$→**$\Pi$**;
  `taucss`/`tauwss` $\tau^c_{ss}$/$\tau^w_{ss}$→**$\tau^c$/$\tau^w$**; efficiency-gap SS
  `eGI_ss`/`eGE_ss`/`eGRD_ss` →**$e^{GI}$/$e^{GE}$/$e^{GRD}$**.
- `byss` $d_{ss}$ → **$d^*$** (the paper's debt target).
- `rho_tauc`/`rho_tauw` → **$\rho_{\tau c}$/$\rho_{\tau w}$** (paper form).
- `Deltacost` $\Delta^c$ → **$\Delta$** (paper $\Delta_t$, the debt-spread sensitivity).
- `omega` (endogenous): "--" → **$\omega$** (paper line 206, disutility scale).

Marked **"--"** (the paper assigns no formal symbol — calibration values described in
prose): the spending shares `Igiy`/`Gcy`/`Igey`/`Grdy`, the spending-process persistences
`rho_Gc`/`rho_Igi`/`rho_Ige`, the trend-growth-shock persistence `rho_g`, the tax-rule
output-gap responses `gamma_y_tauc`/`gamma_y_tauw` (the paper's tax rules respond to debt
only), and the derived `gammaa`/`markupss`/`Bigtheta_y`/`qss`. (15 "--" params total.)

Verified correct against the paper (incl. brace/order forms that render identically):
$\beta$, $\varphi$, $\chi_p$, $\delta$, $\theta_p$, $\epsilon$, $\alpha$, $\Theta$,
$\alpha_G$, $\rho_R$, $\gamma_\pi$, $\gamma_y$, $\rho_{RG}$, $\gamma_d^{\tau c}$,
$\gamma_d^{\tau w}$, $\gamma_d^{T}$, $\rho_T$, $\eta_1$, $\eta_2$, $g$, $\mu$, $\gamma$,
$\vartheta$, $\phi$, $\varsigma$, $\alpha_{HA}$, $\alpha_{RD}$, $\rho_A$.

Every glossary parameter symbol now matches the paper or is a documented "--".

## Completeness

The glossary tables now list **every** declared model object and the row counts match
the model exactly: endogenous 74, parameters 56, exogenous 16. Objects with no paper
symbol (steady-state constants, log levels, reporting transforms, computational
auxiliaries) carry "--" in the Paper column.

False positives (the `t` is part of a word, leave as-is): `probadopt` (adopt), `Deltacost` (cost), `tauc`/`tauw` (tau).

Related but separate (doubled letters, not a `t` issue), for the later optimization pass: `ZZ` in `ZZ`/`ZZRD`.
