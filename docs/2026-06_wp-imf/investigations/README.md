# Investigations

Self-contained model cross-checks and robustness investigations supporting the
working paper (`../draftPaper.tex`). Each lives in its own subfolder with a
README, the standalone `.mod`/driver code, and committed reference output;
Dynare-generated artifacts are gitignored. These are diagnostics, not part of the
paper's model pipeline (`drivers/runModel.m`).

- `galiCheck/` — verifies the canonical NK benchmark equals Galí (2015, Ch. 3)
  plus a government block, and maps how the Gc-shock deflation depends on the
  Frisch elasticity and shock persistence.
- `detrending/` — worked level→stationarized transformation (capital-LoM example);
  why `g` appears where it does and Λ never does (self-compiling note).
- `tech-growth-rate/` — why the technology stocks detrend by their own rate
  `1+gammaa = g^((1-alpha)/(vartheta-1))`, not `g` (self-compiling note).
- `sensitivity/` — parameter-sweep driver + plots behind §4.3.
- `modelDeriv/` — model derivations, styled after the Sims NK lecture notes kept in
  the folder (`notes_new_keynesian_2024-1.pdf`; see `.sped.md` for the convention).
  `costMinimization.tex`: the intermediate firm's cost-minimization problem, the
  `mu^p` markup wedge in the factor demands, and the profit flow funding the
  technology values. `pricingEquations.tex`: the retailer's Calvo reset-price
  problem with indexation → the x1/x2 recursions, the reset condition, and the
  price-index law of motion; asides on price dispersion (an aggregation object)
  and on why the recursions carry no growth factor. `creationAdoption.tex`: the
  technology block — creation process, adoption LoM (level → stationarized), the
  V/J value functions (per-variety → A-scaled → detrended, showing where the
  A(-1)/A and 1/(1+gammaa) factors come from), and the S-FOC.
  `householdProblem.tex`: the household Lagrangian and six FOCs, the
  work-vs-schooling arbitrage, the exact tax-adjusted SDF, and an aside on which
  conditions pick up g when stationarized (and why lambda_H carries none).
