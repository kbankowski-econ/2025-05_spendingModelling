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

## Completeness

The glossary tables now list **every** declared model object and the row counts match
the model exactly: endogenous 74, parameters 56, exogenous 16. Objects with no paper
symbol (steady-state constants, log levels, reporting transforms, computational
auxiliaries) carry "--" in the Paper column.

False positives (the `t` is part of a word, leave as-is): `probadopt` (adopt), `Deltacost` (cost), `tauc`/`tauw` (tau).

Related but separate (doubled letters, not a `t` issue), for the later optimization pass: `ZZ` in `ZZ`/`ZZRD`.
