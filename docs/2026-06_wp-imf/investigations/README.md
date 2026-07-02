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
  One consolidated note, `modelDerivations.tex` (with TOC), covering every
  optimizing block in the order of §2: the household problem (Lagrangian, six
  FOCs, work-vs-schooling arbitrage, exact tax-adjusted SDF, which conditions
  pick up g); intermediate-goods cost minimization (the mu^p markup wedge, where
  the pricing equation hides, two markups/two layers); Calvo price setting (the
  x1/x2 recursions, reset condition, price-index LoM, price dispersion as an
  aggregation object); and technology creation/adoption (creation process,
  adoption LoM, V/J values built per-variety → A-scaled → detrended, the S-FOC,
  and the origin of each growth factor).
