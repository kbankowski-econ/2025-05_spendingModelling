# Literature-consistency review — `draftPaper.tex`

**Date:** 2026-06-19 · **Branch:** `wp-literature` · **Status:** findings only, no paper edits made.

Scope: checked the paper against the three heavily-cited sources whose PDFs are in
`literature/`:

- Comin & Gertler (2006), *Medium-Term Business Cycles* — `CominGertler2006.pdf`
- Anzoategui, Comin, Gertler & Martinez (2019), *Endogenous Technology Adoption and R&D…* — `Anzoateguietal2019.pdf`
- Chang, Gomes & Schorfheide (2002), *Learning-by-Doing as a Propagation Mechanism* — `ChangGomesSchorfheide2002.pdf`

The model **structure** (Z/A creation–adoption, adopter value functions, production
externality) is faithful to the sources. All open issues are in **calibration values
and attributions**.

---

## ✅ Consistent — no action

| Item | Paper | Source | Check |
|---|---|---|---|
| Z (created) vs A (adopted) distinction, gap = unadopted | lines 154–157, 255 | CG2006; Anz2019 | matches |
| Adoption law of motion `A_{t+1}=λₜφ[Zₜ−Aₜ]+φAₜ` | eq. (A), line 266 | Anz2019 eq. (21) | **verbatim** |
| Adoption-probability power form `λₜ=λ₀(Sₜ/Λₜ)^ς` | line 268 | Anz `λ=κ_λ(·)^{ρ_λ}`, CG | form matches; `1/Λₜ` vs `×Zₜ` both stationarize λ on BGP |
| Adopter value fns 𝒱, 𝒥 and FOC for Sₜ | app. eqs. VA/JZ/SAfoc | Anz2019 eqs. (18)–(20) | matches |
| Survival rate φ = 0.97 | Table, line 338 | CG2006 (φ=0.97, 3% annual obsolescence) | exact |
| ρ_A = 0.79 (quarterly) | lines 323/337 | CGS quarterly skill-persistence φ̂ = 0.798 | matches |
| Footnote: Anz single elasticity sets markup **and** returns-to-variety | line 241 | Anz2019 eqs. (7) & (10): single ϑ does both | **correct** — paper's split of ε (markup) from ϑ (love-of-variety `A^{ϑ−1}`) is a legitimate, accurately described departure |
| Love-of-variety term `A^{ϑ−1}` in production | eq. (production), line 238 | Anz2019 eq. (10) | matches |

---

## ⚠️ Flags

### 1. ς = 0.8 (adoption elasticity) — inconsistent with BOTH cited sources. **[most significant]**
- **Paper:** line 324 and Table line 342 set ς = 0.80, described as "elasticity of the
  probability of adoption with respect to adoption spending," *"Following Comin-Gertler
  2006 and Anzoategui et al. 2019."*
- **Comin-Gertler 2006:** the **adoption** elasticity is **0.95** (p.1505).
- **Anzoategui 2019:** adoption elasticity **ρ_λ = 0.925** (their Table 3).
- **0.8 is Comin-Gertler's *R&D-creation* elasticity ρ** ("ρ equal to 0.8, the midpoint of
  these estimates"), a different parameter.
- **Read:** looks like CG's creation elasticity was borrowed and labelled as the adoption
  elasticity. Literature-consistent value would be ~0.92–0.95. Matters for the diffusion
  experiment (Fig. 6).

### 2. "average lag ≈ ten years" — joint attribution only half-correct. **[moderate]**
- **Paper:** line 324 attributes ~10-yr adoption lag to "Comin-Gertler 2006 and
  Anzoategui 2019."
- **CG2006:** ~10 years ✓ (median diffusion 9.8 / 12.5 yrs).
- **Anzoategui 2019:** explicitly calibrate a **five-year** lag (§IIIC: "an average
  adoption lag of five years"). ✗
- **Fix idea:** cite CG for the 10-yr lag; don't imply Anz's value.

### 3. α_HA = 0.45 "as in CGS" — 0.45 is not a CGS number. **[moderate]**
- **Paper:** line 323 / Table line 335 set α_HA = 0.45 "as in Chang-Gomes-Schorfheide 2002."
- **CGS:** learning-by-doing elasticity is **μ = 0.111 quarterly (μ̂ = 0.326 annual)** —
  never 0.45.
- The model's *effective* coefficient in eq. (Z) is `(1−ρ_A)·α_HA = 0.21·0.45 ≈ 0.094`,
  which lands near CGS's quarterly 0.111 — but it's the headline **0.45**, not the effective
  0.094, that's attributed to CGS.
- Note: this is the literature-side counterpart to the known internal `alphaHA`-normalization
  item (project memory; `.sped.md` TODO). Here the issue is that "0.45 as in CGS" reads as a
  direct CGS value when it isn't.

### 4. "human capital fosters innovation … learning-by-doing as in CGS" — conceptual mismatch. **[moderate]**
- **Paper:** line 258 invokes CGS for human capital driving technology *creation* (Zₜ).
- **CGS:** the learning-by-doing channel runs **past labor (hours) → skill/human capital**,
  and **technology Aₜ is exogenous** (random walk, their eq. 10). CGS has **no**
  innovation/technology-creation channel.
- The paper legitimately borrows CGS's AR(1) accumulation *form* + persistence (0.79), but
  the *economic mechanism* it attributes to CGS (human capital → innovation) is not in CGS.
- **Fix idea:** soften to "the learning-by-doing *functional form* of CGS," rather than
  implying CGS models human-capital-driven innovation.

---

## Notes / method
- PDFs extracted with `pdftotext -layout`; parameter values read from the source tables
  (CG2006 calibration pp.1505–06; Anz2019 Tables 3 & §IIIC; CGS Table 1).
- α_RD = 0.10 is attributed to Fieldhouse-Mertens 2023 (not in this review's scope).
- No edits made to `draftPaper.tex`. Flags 1–4 are candidate edits to Section 4
  (Calibration) and the related footnotes when picked up.
