# Notation cleanup (in progress)

We are cleaning notation **in the LaTeX glossary tables first** (app:glossary,
`makeGlossary.py`). Once the target notation is agreed, propagate to the draft
(`draftPaper.tex`) and the model (`models/`). The glossary's "model code" column
already shows the **target** names, which may run ahead of the actual model until
we propagate.

## Decided

| paper | concept | old model code | new model code | status |
|---|---|---|---|---|
| $Y_t$ | gross output (production; $Y_t = v_t^p Y_t^d$) | `yt` | **`y`** | glossary updated; model/draft pending |

## Candidates — redundant trailing `t` (mirrors the paper's time subscript; no other model variable carries one)

Endogenous:
- `Dt` → `D` ($D_t$, public debt) — clean, no clash.
- `AAt` → `A` ($A_t$, adopted technology) — clean; also drops the doubled `AA`.
- `St` → `S` ($S_t$, adoption expenditure) — clean.
- `JZt` → `J` or `JZ` ($\mathcal{J}_t$, value of unadopted tech) — decide letter.
- `SSt` → NOT `SS` (clashes with the steady-state `*ss`/`STEADY_STATE` convention); use e.g. `Srd`/`Slab` (effective labor for R&D).
- `shockchit` → `shockchi` (or `chi`; R&D-process productivity shock) — cascades below.

Parameters / exogenous that inherit the `t`:
- `varthetaat` → `vartheta` ($\vartheta$) — it is a constant, so the trailing `at`/`t` is spurious.
- `rho_AAt` → renaming via `AAt`→`A` would give `rho_A`, which **clashes** with `rho_ZZRD` (= paper $\rho_A$). Needs a distinct name; clarify what `rho_AAt` (persistence of the adopted/stationary tech process) maps to in the paper first.
- `epsi_shockchit` → `epsi_shockchi` (follows `shockchit`).
- `rhoshockchit` → `rhoshockchi` (follows `shockchit`).

False positives (the `t` is part of a word, leave as-is): `probadopt` (adopt), `Deltacost` (cost), `tauc`/`tauw` (tau).

Related but separate (doubled letters, not a `t` issue): `AA` in `AAt`, `ZZ` in `ZZ`/`ZZRD`, `SS` in `SSt`.
