# Pre-Submission Review

**Reviewed:** 2026-08-16  
**Draft:** `draftPaper.tex` and the current compiled 54-page PDF  
**Overall assessment:** The paper has a coherent structure, a well-developed model
description, and a polished quantitative narrative, but it is not yet ready for
submission. The main risks are conceptual positioning, the definition of the
headline experiments, and the empirical basis for several influential calibration
choices. These should be resolved before further line editing.

## Submission Blockers

- [ ] **Decide whether the paper is about endogenous growth or endogenous level effects.** The balanced-growth rate `g` is calibrated, and technology-trend growth is derived from it. The policy shocks change stationary human-capital and technology stocks but do not appear to change the asymptotic growth rate. Either demonstrate formally and numerically that policy changes long-run growth, or consistently reframe the title, abstract, introduction, model description, and conclusion around endogenous technology accumulation and long-run output levels.

- [ ] **Correct the definition of a “permanent” experiment and the “Long-term” multiplier.** In `drivers/runModel.m`, the permanent spending shock lasts through quarter 1,000 and fiscal closure is restored in quarter 1,001. This is effectively permanent for the reported 25-year responses, but the 250-year column is measured exactly when the shock ends and is not an asymptotic permanent-shock multiplier. Choose one of two defensible treatments: solve a genuine transition to a new terminal steady state, or describe the experiment as a 250-year step and rename or remove the “Long-term” column. In either case, rerun with a longer terminal horizon and verify that the first 25 years are invariant.

- [ ] **Make the fiscal-financing assumption fully transparent and test an alternative.** The model-properties expansions suspend the transfer response to debt for the entire shock path. Report the switch timing explicitly and explain what households expect about eventual repayment. Add at least one robustness exercise with earlier transfer adjustment, another fiscal instrument, or a fixed debt path. This is necessary because the debt-financed results and their wealth effects depend directly on this closure.

- [ ] **Resolve the treatment of government consumption and the absence of welfare analysis.** The calibration describes government consumption as including teachers, doctors, nurses, social transfers in kind, and intermediate consumption, but the experiments subsequently treat its marginal unit as wasteful and nonproductive. Define the source category as a nonproductive residual or administrative component, or give public services a productive or utility role. Until then, present reallocations strictly as output experiments, not welfare-improving policy recommendations.

- [ ] **Resolve the high education-and-health time allocation together with human-capital depreciation.** The visible TODO correctly flags `E=0.157`. The calibration also sets human-capital depreciation to 2.5 percent per quarter, the same as physical capital, which may be driving the large required time allocation and the human-capital dynamics. Benchmark both objects jointly against the literature, recalibrate if necessary, and rerun every affected result. Remove the TODO box only after this is settled.

- [ ] **Recalibrate or defend the technology-adoption elasticity.** The AE value `varsigma=0.80` is highly influential and differs from the roughly 0.925--0.95 values in the two cited technology-adoption papers; the EMDE value 0.10 has little direct empirical support. The existing sensitivity work shows strong nonlinear effects near the AE calibration. Choose literature-consistent values or provide an independent rationale, and show how the diffusion and human-capital/R&D results change.

- [ ] **Document the public-R&D spending target.** The AE and EMDE targets of 0.6 and 0.1 percent of GDP are the only country-group targets not derived in Figure 1 or supported by a stated data source. Add a reproducible source, sample, aggregation method, and time period. If comparable general-government data are unavailable, label the values as judgmental and include sensitivity.

- [ ] **Remove all internal-only material from the circulation manuscript.** Delete the title-page TODO box and the full appendix titled “Summary of Policy Experiments (NOT FOR PUBLICATION),” including the October 2025 Fiscal Monitor watermark and figures read from another project. Confirm that the submission PDF contains no internal labels, dated presentation panels, external-project paths, or unpublished production notes.

## Major Substantive Revisions

- [ ] **Strengthen the empirical defense of the AE/EMDE targets.** Report coverage by variable and show inclusive alternatives for the weighted aggregates that exclude the United States, Japan, or China in the baseline. In particular, verify that the 5.1 percent EMDE trend-growth target is not dominated by a few large economies and explain why this weighted average represents a typical EMDE.

- [ ] **Test the functional split of government investment.** The EMDE split is based on only seven OECD economies, most of them European, and the mapping assigns housing, recreation, and social protection to human-capital investment. Provide an economic justification, show results under narrower and alternative mappings, and avoid presenting the 69/31 EMDE split as broadly representative without qualification.

- [ ] **Provide uncertainty around spending-efficiency gaps.** The paper uses 2023 point estimates from `Bankowskietal2026`, but the appendix reports distributions rather than estimation uncertainty. Ensure that the underlying paper or dataset is publicly citable, document the construction sufficiently for replication, and show policy results for plausible confidence bands or alternative gap values.

- [ ] **Qualify or cost the efficiency reforms.** The model treats closing efficiency gaps as costless. Either introduce a resource or fiscal cost, provide a break-even cost calculation, or state prominently that the reported gains are gross benefits before administrative, institutional, and transition costs. Remove language implying that such reforms are unambiguously attractive.

- [ ] **Broaden sensitivity beyond the three headline elasticities.** At minimum, test trend growth, human-capital depreciation, the adoption elasticity, public-capital depreciation, the debt-feedback coefficient and switch duration, and monetary-policy accommodation. These are quantitatively important for the cross-group comparison or the financing mechanism but are not covered by the current Figure 3.

- [ ] **Clarify the EMDE technology assumption.** EMDE public R&D remains in the resource constraint but has no effect on technology creation, while adoption continues from an exogenous frontier. Explain the economic interpretation, show that the result is not being read as “R&D has no return in EMDEs,” and consider a small positive creation elasticity as a robustness case.

- [ ] **Demonstrate complementarity in the 50/50 human-capital/R&D experiment.** Report an interaction measure relative to the sum of matched half-sized standalone shocks. This will distinguish genuine complementarity from scaling or nonlinear shock-size effects and substantiate one of the paper's main policy claims.

- [ ] **Benchmark multiplier definitions and magnitudes transparently.** Add a compact comparison of the model's present-value cumulative multipliers with literature estimates that use comparable horizons and definitions. Decide whether impact, peak, fixed-real-rate, or alternative-financing multipliers belong in a robustness appendix. Keep the 25-year numbers as the headline unless a genuine asymptotic object is established.

- [ ] **Add a limitations paragraph or subsection.** It should cover the representative-agent structure, stylized country groups, output rather than welfare, the assumed nonproductive margin of government consumption, costless efficiency reform, no endogenous technology creation in EMDEs, perfect foresight, and uncertainty around the calibration. The conclusion currently states the policy payoff without these boundaries.

- [ ] **Tighten the contribution claim against the model literature.** Support the statement that human capital and endogenous technology are rarely combined with a disaggregated fiscal block by discussing the closest integrated DSGE models. State precisely which combination is novel rather than relying on “to our knowledge.”

## Reproducibility and Data

- [ ] **Create a standalone replication package and one-command workflow.** Several scripts use absolute paths to other local projects, including the WEO, efficiency, and investment-composition inputs; `drivers/runPlots.m` also contains an absolute output path. Move or document immutable inputs, replace machine-specific paths with project-relative configuration, record MATLAB/Dynare/Python versions, and verify the build in a clean clone.

- [ ] **Freeze and document every data vintage.** Record retrieval dates, series codes, transformations, WEO classifications, country lists, exclusions, and missing-data rules for WEO, WoRLD, ILOSTAT, OECD COFOG, and the efficiency estimates. Preserve a machine-readable country-year audit table behind each calibration target.

- [ ] **Add automated paper consistency checks.** The final pipeline should verify that calibration tables equal model parameters, reported text numbers equal generated CSVs, all model paths are finite over the reported horizon, and every figure and table is regenerated from the committed results. Run the full pipeline once after the final calibration lock.

- [ ] **Prepare the archive according to data licenses.** Confirm which IMF, OECD, ILOSTAT, and WoRLD inputs may be redistributed. Where redistribution is prohibited, provide retrieval scripts, checksums, and exact instructions rather than local copies.

## Manuscript and Production Cleanup

- [ ] **Choose the submission format.** Update the June 2026 date, acknowledgments, author affiliations and contact details, disclaimer, keywords, JEL codes, and source-note convention for the intended outlet. Prepare an anonymized manuscript if required.

- [ ] **Replace calendar framing where it is unnecessary.** Section 5 and the summary figures repeatedly use 2026 and 2050 even though the experiments are model horizons. Prefer “after 25 years” unless the submission is explicitly tied to that policy vintage. Rename the diffusion figure consistently.

- [ ] **Complete a final numerical audit.** Check every number in the abstract, introduction, model-properties discussion, policy section, conclusion, tables, captions, notes, and appendix against the final generated data after all recalibrations and robustness decisions.

- [ ] **Clean the bibliography and source attribution.** Replace the `OECD2025Glance` book citation with the actual OECD COFOG database citation used in Appendix C, give `Bankowskietal2026` a stable working-paper number or public link when available, add missing DOI or report metadata where useful, and remove the duplicate `pages` field in `Bergetal2019`.

- [ ] **Perform a final prose pass.** Correct “Table of content,” reconsider the singular heading “Country-Group Calibration Target,” standardize “government consumption” versus “wasteful government consumption,” remove dated or promotional wording, shorten remaining long notes, and ensure each paragraph leads with the economic point rather than a figure or table reference.

- [ ] **Perform final PDF quality assurance.** Eliminate the remaining overfull box and PDF-string warnings, confirm no undefined references or citations, inspect every page at print size, and test figures and colored table rows in grayscale and for color accessibility. Check that fonts are embedded and that the PDF meets the outlet's file-size and metadata requirements.

## Recommended Order of Work

1. Lock the conceptual claim: growth rate versus output level, and output versus welfare.
2. Redefine the permanent experiment, fiscal closure, and multiplier horizon.
3. Resolve the human-capital, adoption, R&D, country-target, and investment-split calibrations.
4. Rerun models, robustness exercises, figures, tables, and the numerical audit once.
5. Add limitations and revise the abstract, introduction, policy discussion, and conclusion.
6. Remove internal material, build the standalone replication package, and complete production checks.
