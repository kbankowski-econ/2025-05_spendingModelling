# Section 3 — Revision Rationale Log

**Document:** `latexReplication/section3.tex` — "Measuring Spending Efficiency:
Methodology and SACU Results"
**Source of truth:** `docs/2026-06_WP-Alexis/Spending-Smarter-in-SACU.docx` (Section 3)
**Purpose:** Record *why* each substantive revision was made, so co-authors and
reviewers can see the reasoning behind changes rather than just the diff. This
is the justification trail for a significant rewrite of Section 3.

---

## How to use this log

- Each revision gets one entry under **Revision Log**, newest at the top.
- An entry records: an ID, the date, the location in the text, *what* changed,
  and — most importantly — *why* (the justification).
- Candidate changes we have identified but not yet made live under **Backlog**.
  When a backlog item is implemented, move it into the Revision Log with an ID.
- Status tags: `proposed` → `applied` → `confirmed by author` (or `reverted`).

### Entry template

```
### R<id> — <short title>   [<status>]
- **Date:** YYYY-MM-DD
- **Location:** §3.x, paragraph / Table 1 / Figure 3 caption, etc.
- **Change:** <one-line description of the edit>
- **Rationale:** <why this is correct / better; cite the source or reasoning>
- **Knock-on:** <anything downstream this affects — calibration, §5/§6, etc.>
```

---

## Revision Log

_(No revisions applied yet. The rewrite starts here — entries will be added as
we make edits.)_

---

## Backlog — candidate revisions identified in review

These came out of the initial read of Section 3 (2026-06-02). They are *not yet
applied*; they are the raw material for the rewrite. Priority is a rough
ordering, not a commitment.

### High priority — likely referee-visible

- **B1 — SFA vs. DEA wording (§3.1, step 1).** The prose says the frontier
  "represents the maximum outcome observed across countries with a given level
  of spending." That describes a deterministic DEA/FDH frontier, not stochastic
  frontier analysis. SFA uses a composed error term to separate inefficiency
  from random noise; the frontier is an *estimated stochastic function*, not the
  observed maximum. The description currently contradicts the method's name.
  *Fix direction:* restate so the frontier is the SFA-estimated best-practice
  function, with inefficiency as the one-sided deviation.

- **B2 — Specification uncertainty vs. two-decimal precision (§3.3 caveat 2 vs.
  Table 1).** §3.3 concedes alternative weightings can move gap *levels* by "up
  to 26 percentage points in the extreme case," yet Table 1 reports gaps to 0.01
  and the §6 country rankings hinge on differences of 0.01–0.08. Need to
  reconcile: either argue the *ranking* is more robust than the *level* (e.g.
  specification shifts are roughly parallel across countries), or add explicit
  uncertainty bands. This is the single most important coherence issue.

- **B3 — "Leakage" framing stronger than the caveat (§3.1 step 3 vs. §3.3
  caveat 1).** Step 3 says a 0.35 gap means "35 percent of each unit spent…
  leaks… and does not contribute to the productive public capital stock," mapped
  1:1 into the (1 − eGI) accumulation term. Caveat 1 says the gap "conflates
  several underlying factors… and does not, on their own, identify the
  mechanism." Decide which framing to commit to and soften the leakage language
  to match, or explicitly flag it as a modelling convention.

### Medium priority — conceptual choices to defend

- **B4 — R&D dropped without explanation (§3.1 step 1).** Methodology lists
  four sectors incl. research and development, but R&D never reappears (not in
  Table 1, the blend, or the model). Add one line explaining why (data
  availability? not material for SACU?).

- **B5 — Health gap likely absorbs disease burden as "inefficiency" (§3.2).**
  The frontier controls only for population, income, geography. §3.2 then
  attributes health gaps partly to HIV/AIDS legacy. If disease burden depresses
  life expectancy independent of spending efficiency and isn't controlled out,
  it loads onto *measured inefficiency*, overstating SACU health gaps. Strongest
  concrete instance of caveat 1; matters because health feeds the blended HC gap.

- **B6 — Simple-average blend (§3.2 / Table 1).** eGH_blend weights education
  and health equally, but the human-capital capital stock / spending is not split
  50/50. Either justify equal weighting or move to a spending-weighted blend.
  *Knock-on:* changes eGH_blend inputs → §5 calibration (Annex Table 1) → §6
  results.

### Low priority — numeric / wording nits

- **B7 — Prose ranges run wider than the table.** §3.2 says education gaps
  "0.30 to 0.45" (table: 0.35–0.42) and health "0.35 to 0.50" (table: 0.37–0.47);
  the exec summary's "30 to 45 percent" understates Lesotho's 0.47 health gap.
  Tighten to match Table 1.

- **B8 — Mixed vintages in the blend.** Education is 2024, health 2023; the
  blend averages across years. Harmless but worth a footnote.

- **B9 — Spending normalization differs across stages.** The frontier input is
  real spending *per capita*; the DSGE calibration uses spending */GDP*
  (gI_Y, gH_Y). Not wrong, but be explicit so a reader doesn't conflate them.

---

## Verified-consistent (do NOT "fix" — these are correct)

Checked 2026-06-02; flagging so we don't accidentally break them in the rewrite:

- Table 1 **blended HC = simple average** of education + health holds for all
  five countries (Lesotho 0.445 → 0.45 rounds correctly).
- Table 1 (§3) and **Annex Table 1** (§5) report identical eGI and eGH_blend
  values — the inputs are internally consistent across the paper.
