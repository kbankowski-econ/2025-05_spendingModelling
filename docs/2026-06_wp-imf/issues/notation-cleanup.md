# Notation cleanup (in progress)

We are cleaning notation **in the LaTeX glossary tables first** (app:glossary,
`makeGlossary.py`). Once the target notation is agreed, propagate to the draft
(`draftPaper.tex`) and the model (`models/`). The glossary's "model code" column
already shows the **target** names, which may run ahead of the actual model until
we propagate.

## Decided — applied in the glossary; model + draft propagation PENDING

Redundant trailing `t` (mirrored the paper time subscript; no other model variable carries one):

| paper | concept | old model code | new model code |
|---|---|---|---|
| $Y_t$ | gross output ($Y_t = v_t^p Y_t^d$) | `yt` | `y` |
| $D_t$ | public debt | `Dt` | `D` |
| $A_t$ | adopted technology | `AAt` | `A` (also drops doubled `AA`) |
| $S_t$ | adoption expenditure | `St` | `S` |
| $\mathcal{J}_t$ | value of unadopted tech | `JZt` | `J` |
| $\vartheta$ | love-of-variety exponent (constant) | `varthetaat` | `vartheta` |
| $\varepsilon_t^{\chi}$ | R&D-process shock | `epsi_shockchit` | `epsi_shockchi` |
| $\rho_\chi$ | R&D-process shock persistence | `rhoshockchit` | `rhoshockchi` |

Not in the glossary but to rename in the model during propagation:
- `SSt` → `Srd` (effective labor for R&D). NOT `SS` — that clashes with the steady-state `*ss`/`STEADY_STATE` convention.
- `shockchit` → `shockchi` (the R&D-process disturbance variable; drives the two renamed items above).

Dropped:
- `rho_AAt` — removed from the glossary. It is **declared but dead** (`rho_AAt=0.0` in
  parameters_common.macro, never referenced in any equation). Delete it from
  `declare_all.macro`/`declare_all_ext.macro`/`parameters_common.macro` in the model pass.
  (Renaming it to `rho_A` would also have collided with `rho_ZZRD` = paper $\rho_A$.)

False positives (the `t` is part of a word, leave as-is): `probadopt` (adopt), `Deltacost` (cost), `tauc`/`tauw` (tau).

Related but separate (doubled letters, not a `t` issue), for the later optimization pass: `ZZ` in `ZZ`/`ZZRD`.
