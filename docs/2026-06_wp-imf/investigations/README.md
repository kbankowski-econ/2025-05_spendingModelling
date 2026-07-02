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
- `modelDeriv/` — model derivations. `costMinimization.tex`: the intermediate
  firm's cost-minimization problem, the `mu^p` markup wedge in the factor demands,
  the profit flow funding the technology values, and the Θ=0 fixed-cost caveat.
