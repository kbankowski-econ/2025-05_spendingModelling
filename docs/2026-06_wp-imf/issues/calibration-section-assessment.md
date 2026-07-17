# Calibration section assessment

**Date:** 2026-07-17

**Scope:** Section 3, `Calibration`, in `draftPaper.tex`, including Tables 1 and 2,
the complete parameter glossary in Appendix B, and the active AE and EMDE model
calibrations.

**Status:** Assessment only. No changes to the paper are proposed as final here.

## Overall assessment

The section has a sound core but is not yet complete enough for a reader to
reconstruct the quantitative setup or understand all economically important
differences between the AE and EMDE calibrations. It does a good job on the
parameters specific to productive public spending, technology creation, adoption,
and spending efficiency. Table 2 is particularly transparent about how the
efficiency gaps are constructed.

The main weakness is not that all 40 model parameters are absent from the main
text. A working-paper calibration section does not need to discuss every
conventional parameter individually. The weakness is that the selection principle
is inconsistent: some secondary parameters are reported, while several choices
that materially determine steady states, cross-group comparisons, debt dynamics,
and long-run growth are omitted. The section also does not explicitly direct the
reader to Appendix B for the complete calibration.

The current organization follows economic blocks at first, then moves to
efficiency gaps, and finally to fiscal steady-state ratios. Within those blocks it
mixes four different kinds of objects:

1. parameters taken from the literature;
2. empirical steady-state targets;
3. parameters chosen to distinguish AEs from EMDEs; and
4. scale parameters solved internally to hit targets.

That mixture makes the calibration logic harder to see than necessary. A structure
organized first by calibration role and then by economic channel would be clearer.

## What already works

The opening paragraph establishes the two country groups, quarterly frequency, and
the distinction between conventional parameters and parameters central to the
paper's mechanisms. That is the right starting point.

The discussion focuses attention on the mechanisms that matter for the paper:
public infrastructure, human-capital formation, technology creation and adoption,
and spending efficiency. It generally explains why AE and EMDE values differ,
rather than merely listing numbers.

Table 1 is compact and organized by model block. Its note correctly explains that
the technology-creation coefficients are long-run elasticities and translates
them into per-period loadings.

The efficiency-gap discussion has a clear empirical basis. Table 2 reports the
underlying health and education components, explains how the EMDE averages are
formed, and links the calibration to the appendix time series.

The appendix glossary already provides a strong foundation for full transparency:
it lists the complete active parameter set, AE and EMDE values, and the targets of
the internally solved scale parameters. The main text should use that asset more
explicitly.

## Completeness assessment

The following table evaluates the active calibration by category. “Main” means the
object is presented in Section 3; “Appendix” means it appears only in the complete
parameter glossary.

| Calibration block | Current coverage | Assessment |
|---|---|---|
| Frequency and solution concept | Quarterly frequency is stated; perfect foresight and the 2025--50 horizon are stated immediately before Section 3 | Adequate, although the calibration opening should cross-reference those conventions |
| Preferences | Only the inverse Frisch elasticity is discussed; `beta` is appendix-only; `omega` is internally solved but not mentioned | Incomplete: the discount factor and labor-supply target should be visible or explicitly delegated |
| Private and public capital | `alpha_G` and public-capital depreciation are discussed; private capital share and private depreciation are not | Mostly adequate for the paper's focus, but the text should clarify that the same physical-capital depreciation rate applies to private and public capital |
| Human capital | `mu` and `gamma` are discussed; human-capital depreciation and the internally solved scale `chiH` are not | Incomplete: the education-time target and scale calibration are part of the quantitative mechanism |
| Price setting and production | Calvo pricing, indexation, substitution elasticity, private capital share, love-of-variety exponent, and intermediate-producer markup are appendix-only | Too compressed into “standard values”; `vartheta` and the separate 1.18 markup are not purely conventional details |
| Monetary policy | The Taylor rule is in the model section, but all policy coefficients and steady-state inflation are appendix-only | Acceptable only with an explicit appendix reference; a compact common-parameter table would be better |
| Fiscal closure | Tax rates are discussed, but the debt target, transfer-feedback coefficient, and transfer persistence are omitted | Incomplete: these choices govern debt dynamics and the financing exercises |
| Spending shares | Government consumption, infrastructure, and human-capital investment are discussed | Incomplete: baseline public R&D spending is omitted |
| Trend growth | The constant `g` is explained in Section 2 but its AE and EMDE calibrations are omitted from Section 3 | Material omission: trend growth is now a calibrated country-group difference |
| Technology creation | `rho_A`, `alpha_HA`, and `alpha_RD` are discussed and tabulated | Good, subject to the attribution issue already recorded in `literature-consistency.md` |
| Technology adoption | `varsigma` and the adoption-lag target are discussed; `phi` is only tabulated; `q_0` is described as internally pinned | Conceptually appropriate, but the stated adoption lag conflicts with the active target |
| Spending efficiency | All active gaps are discussed and their data construction is shown | Strongest part of the section |
| Internally calibrated scales | Only `q_0` is mentioned; `omega` and `chiH` are not | Incomplete: all three should be presented together as a distinct calibration method |
| Derived parameters | Technology growth `gamma^a` and the nominal steady-state rate are derived elsewhere | They need not be independently tabulated, but the calibration section should identify them as derived rather than calibrated |
| Experiment design | Shock sizes, persistence, financing, and reform duration are presented in Sections 4 and 5 | Correct location; Section 3 should cross-reference rather than duplicate them |

## Specific issues to resolve

### 1. Adoption lag does not match the active calibration

The text says that the steady-state adoption probability is targeted to deliver an
average adoption lag of approximately 10 years. The active calibration is
`qss=0.2/4=0.05` per quarter. Under the model's constant-hazard interpretation, the
expected waiting time is `1/0.05=20` quarters, or 5 years, not 10 years.

This is a substantive choice, not just wording. A 10-year mean lag would require a
quarterly probability near 0.025. The existing literature review also notes that
Comin and Gertler motivate roughly 10 years, whereas Anzoategui et al. use 5 years.
The paper should first decide which target is intended and then align the model,
prose, citation, and sensitivity discussion.

### 2. The human-capital spending share is rounded inconsistently

The prose reports public human-capital investment of 1.5 percent of GDP for AEs.
The active model uses `Igey=0.0145`, or 1.45 percent. Table 1 does not report this
target, while the appendix glossary rounds it to 0.015. Either 1.45 percent is the
intended calibration and should be reported exactly, or the model should be changed
to 1.5 percent. This should be decided before restructuring the section.

### 3. The infrastructure elasticity is described at a different precision

The prose says `alpha_G=0.05` for AEs, while the model and Table 1 use 0.054.
This may be harmless rounding, but using 0.054 consistently would remove ambiguity,
especially because the table otherwise reports three decimal places.

### 4. Country-group trend growth is missing

The model uses quarterly gross trend growth of 1.004 for AEs and 1.0075 for EMDEs,
approximately 1.6 and 3.0 percent at annual rates. This difference affects the
stationary steady state, discounting across dates, capital accumulation, and the
derived technology-growth rate. It belongs in the country-group calibration table.

### 5. Debt targets and fiscal closure are missing

The active debt targets correspond to 100 percent of annual GDP for AEs and
60 percent for EMDEs. In the quarterly model they are stored as 4 and 2.4 because
debt is divided by quarterly GDP. Reporting only the raw model values in the
appendix can mislead readers; Section 3 should report the intuitive annual-GDP
ratios and explain the quarterly normalization in a note.

The transfer rule also uses `gamma_d^T=0.01` and `rho_T=0`. The weak debt response
is quantitatively important for debt-financed exercises, while the auxiliary dummy
temporarily switches it off. These parameters should be disclosed in either the
common calibration table or a short fiscal-closure paragraph.

### 6. Baseline public R&D spending is omitted

The model calibrates public R&D spending to 0.6 percent of GDP in AEs and
0.1 percent in EMDEs. These shares affect the resource constraint and steady state
even though the endogenous-innovation response is disabled for EMDE experiments.
They should appear beside the other spending shares.

### 7. “Standard parameters” is doing too much work

The phrase currently covers `beta`, `alpha`, Calvo stickiness, indexation, the two
markup-related parameters, `vartheta`, steady-state inflation, the Taylor-rule
coefficients, human-capital depreciation, and fiscal-feedback parameters. Some can
reasonably be called standard, but `vartheta=1.35`, the separate intermediate
markup of 1.18, and the very weak transfer response deserve explicit rationale or
at least visibility in a table.

### 8. Internally solved parameters should be presented together

The model solves three scales in the steady state:

| Scale | Target |
|---|---|
| `omega` | steady-state labor supply `L=1/3` |
| `chiH` | steady-state education and health time `E=0.157` |
| `q_0` / `kappaprob` | steady-state adoption probability `q=0.05` |

The section discusses only the third. Presenting all three together would make the
distinction between externally calibrated elasticities and internally calibrated
scales explicit. The sources or rationale for the labor and time targets should
also be stated.

### 9. The EMDE innovation assumption needs sharper language

Table 1 uses “--” for `alpha_HA`, `alpha_RD`, `varsigma`, and the R&D efficiency
gap, while the underlying model still carries some dormant adoption parameters and
a positive baseline R&D spending share. The intended economic restriction is clear,
but the presentation should distinguish:

- a channel set to zero structurally;
- a parameter retained in code but inactive in the reported experiments; and
- a baseline fiscal outlay that remains in the resource constraint.

Saying simply that the entire endogenous-innovation channel is “switched off” can
hide those distinctions.

### 10. Literature attributions remain open

The separate review in `literature-consistency.md` flags the adoption elasticity
of 0.8, the adoption-lag attribution, and the interpretation of the
Chang--Gomes--Schorfheide learning-by-doing mechanism. These issues should be
resolved as part of the calibration rewrite rather than carried into a new
structure unchanged.

## Structural diagnosis

The present sequence is:

1. general calibration statement;
2. five bullets on selected structural parameters;
3. Table 1 repeating those parameter values;
4. three bullets on efficiency gaps;
5. Table 2 repeating those gap values and showing their construction; and
6. three bullets on selected fiscal steady-state ratios.

This creates two problems. First, the prose and tables repeat values while still
leaving important targets unreported. Second, the fiscal steady state appears last,
even though it defines the baseline economy against which all spending experiments
are measured.

The section would be easier to follow if it answered four questions in order:

1. What is common across the two calibrations?
2. What empirical targets distinguish AEs from EMDEs?
3. Which structural elasticities govern the paper's transmission channels?
4. Which coefficients are derived or solved internally rather than selected
   directly?

## Recommended structure

### 3.1 Calibration strategy and common parameters

Open with the quarterly frequency, the two representative economies, and a clear
classification of parameters: common literature values, country-group targets,
channel-specific elasticities, and internally calibrated scales. State that the
main text reports parameters material to the results and that Appendix B provides
the complete parameter vector.

Add a compact table of common macro and policy parameters. At minimum it should
include `beta`, `varphi`, `alpha`, `delta`, `delta^h`, `theta_p`, `chi_p`,
`epsilon`, `vartheta`, the 1.18 intermediate markup, the Taylor-rule coefficients,
steady-state inflation, and the transfer-rule coefficients. Short prose should
explain only the nonstandard or quantitatively important choices.

### 3.2 Country-group steady-state targets

Move the fiscal ratios forward and put all AE/EMDE targets in one table:

- annualized trend growth;
- government debt as a share of annual GDP;
- government consumption;
- infrastructure investment;
- public human-capital investment;
- public R&D spending;
- consumption and labor-income tax rates; and
- any common targets used to pin labor supply and education time.

This table would show immediately what differs across the two representative
economies. Its note should distinguish annual reporting units from the quarterly
objects used in Dynare and cite the data sources for each block.

### 3.3 Productive-spending and endogenous-growth parameters

Retain the useful core of current Table 1, but remove the efficiency-gap rows,
which belong in the next subsection. Organize the remaining parameters by
infrastructure, human capital, technology creation, and adoption. Discuss the
economic rationale and AE/EMDE differences in short paragraphs rather than a
bullet-by-bullet repetition of the table.

Include the steady-state adoption probability in this block because it is the
target that gives meaning to `q_0`. Resolve the 5-year versus 10-year target before
rewriting the prose.

### 3.4 Spending-efficiency gaps

Keep Table 2 and its construction note. The three bullets that merely restate its
headline numbers can be replaced with one paragraph emphasizing the empirical
method, the use of 2023 medians, and the aggregation of health and education into
the human-capital gap.

Table 1 should no longer repeat the same efficiency values. This would give each
table one job: structural transmission parameters in Table 1, empirical efficiency
targets in Table 2.

### 3.5 Internally calibrated and derived coefficients

Close with a short paragraph or small mapping table for `omega`, `chiH`, and
`q_0`, identifying the target that pins each scale. Then state that `gamma^a` and
the steady-state nominal rate are implied by the balanced-growth restrictions
rather than selected independently.

End by separating calibration from experiment design: point readers to Sections 4
and 5 for shock persistence, size, duration, financing, and reform paths.

## Table architecture

A complete but economical presentation would use three main calibration tables:

1. **Baseline macro and policy parameters:** common values, with AE/EMDE columns
   only where they differ.
2. **Country-group steady-state targets and structural channel parameters:** this
   could be one table with two panels, or two smaller tables if space permits.
3. **Derivation of spending-efficiency gaps:** the current Table 2.

Appendix B would remain the exhaustive 40-parameter reference. The main text should
explicitly say so. This is preferable to expanding Table 1 into a long,
undifferentiated list or leaving the conventional calibration implicit.

## Suggested implementation sequence

1. Decide whether the intended adoption lag is 5 or 10 years and whether the model
   or prose should change.
2. Reconcile the AE human-capital spending share at 1.45 versus 1.5 percent and use
   0.054 consistently for `alpha_G`.
3. Decide the desired main-text table architecture: three compact tables or one
   larger parameter table plus the existing efficiency table.
4. Draft the country-group target table directly from the solved model results,
   with transformations to annual reporting units coded in the generator.
5. Expand the parameter-table generator so all displayed values remain tied to the
   active result files.
6. Rewrite the prose around calibration logic and provenance, avoiding repetition
   of table entries.
7. Add the explicit Appendix B cross-reference and verify every active parameter is
   either discussed in the main text or clearly delegated there.
8. Rebuild the paper and recheck the model only if a substantive calibration choice
   changes; a presentation-only restructure should not alter results.

## Decisions for discussion

The rewrite depends on five substantive editorial choices:

1. Should the adoption target remain at the model's 5-year mean lag, or should the
   model be recalibrated to the 10-year lag stated in the paper?
2. Should the main calibration section show all common NK and policy parameters, or
   list only the less standard ones and delegate the rest explicitly to Appendix B?
3. Should fiscal closure parameters appear in the main calibration table because
   they shape the debt-financed exercises?
4. Should the AE human-capital spending target be reported as the model's exact
   1.45 percent or rounded/recalibrated to 1.5 percent?
5. Should the current AE/EMDE distinction be described as “endogenous innovation
   disabled for EMDEs” rather than treating technology creation, adoption, and
   baseline R&D spending as a single channel?
