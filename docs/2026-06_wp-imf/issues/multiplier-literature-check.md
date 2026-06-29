# Multiplier consistency with the literature (2026-06-29)

Checks the paper's implied fiscal multipliers (`tab:multipliers` AR(1), `tab:multipliersPerm`
permanent) against the empirical literature, including the three cited sources. Numbers are
present-value cumulative output multipliers; the model uses an AR(1) ρ=0.9 shock for the
headline table and a permanent shock for the appendix table.

## Our numbers (25-year / Long-term)

| Category | AE AR(1) | AE permanent | EMDE AR(1) | EMDE permanent |
|---|---|---|---|---|
| Government consumption | −0.85 / −1.22 | **0.42 / 0.62** | −0.36 / −0.40 | 0.31 / 0.32 |
| Infrastructure | 1.77 / 2.38 | 1.54 / 2.70 | 4.54 / 4.98 | 2.99 / 4.34 |
| Human capital | 3.31 / 8.19 | 1.69 / 5.85 | 6.50 / 9.88 | 2.94 / 7.35 |
| R&D | 4.89 / 6.66 | 2.35 / 4.57 | — | — |

## Literature benchmarks

- **Government spending (general).** Ramey's survey evidence puts cumulative government-spending
  multipliers mostly around 0.6–1.0, and positive; consumption-type spending sits at the low end.
- **Public investment, advanced economies.** Afonso & Rodrigues (2024, PVAR, 40 countries):
  public-investment multiplier **0.87 (AE)**, 2.29 (EM), 1.67 (full). IMF (WEO Oct 2014):
  output rises ≈0.4% on impact and **≈1.5% after 4 years** in AEs. Ramey (2020): infrastructure
  long-run multiplier **1 to >2** (above 2 when public capital is highly productive or the
  economy is below the optimal capital stock), but short-run multipliers below the consumption
  multiplier because of implementation lags.
- **Public investment, EMDEs.** Afonso & Rodrigues: **2.29**. IMF (2014): developing-country
  response ≈0.25% on impact, ≈0.5% after 4 years (smaller than AEs). More recent EM evidence:
  ≈1.1 two years out, not statistically different from 1.
- **R&D.** Fieldhouse & Mertens (2023): implied **social returns of 140–210%** to nondefense
  public R&D; government R&D accounts for ~1/5 of postwar business-sector TFP growth — i.e.
  large long-run output effects. Afonso & Rodrigues also find positive R&D growth effects,
  larger for EMs.

## Verdict by category

- **Government consumption.** The **permanent** multiplier (+0.42 AE, +0.31 EMDE) is positive and
  below one — consistent with the literature for unproductive spending. The **AR(1)** multiplier
  is **negative** (−0.85 AE), which is at odds with the empirical consensus of positive
  government-spending multipliers. ⚠ AR(1) out of line; permanent in line.
- **Infrastructure, AE.** 1.5–2.7 (both shock types). Above Afonso–Rodrigues's 0.87 but within
  Ramey's "1 to >2" long-run range and close to the IMF's ≈1.5 medium-term figure. Reasonable,
  on the higher side. ✓ (borderline-high).
- **Infrastructure, EMDE.** 3.0–5.0. The EM>AE ordering matches Afonso–Rodrigues (2.29 EM vs 0.87
  AE), but our magnitudes are **above** their 2.29 and well above the IMF/recent-EM figures
  (≈0.5–1.1). The permanent 25-year value (3.0) is the closest to the literature; the AR(1)
  long-term (5.0) is high. ⚠ high.
- **Human capital.** Not a standard "multiplier" object in the literature (education/health are
  usually studied as long-run growth). The 25-year permanent value (1.7 AE, 2.9 EMDE) is
  plausible; the AR(1) and long-term values (8–10) are very large and have no clean empirical
  counterpart. ⚠ large, weakly benchmarked.
- **R&D.** 2.4–6.7 (AE). Large, but **qualitatively consistent** with the high social returns to
  public R&D (Fieldhouse–Mertens 140–210%) and its outsized TFP role. ✓ (high but supported).

## Bottom line and recommendation

1. The **permanent-shock multipliers (Appendix D) are the more literature-consistent set**:
   government consumption is positive and <1, AE infrastructure ≈1.5 matches the IMF medium-term
   figure, and the EM>AE ordering matches Afonso–Rodrigues. The AR(1) headline table has two
   problems against the literature — a **negative government-consumption multiplier** and
   **inflated long-horizon investment multipliers** (the transitory-shock accumulation effect).
   → **Consider making the permanent table the headline (Table 3) and moving the AR(1) version to
   the appendix**, or at least leading the discussion with the permanent numbers. This also fits
   the convention that "the fiscal multiplier" refers to a sustained spending change.
2. Regardless of which is the headline, the **25-year values are more defensible than the
   Long-term (250-year) values**; the durable HC/R&D channels push the long-run numbers (8–10)
   well beyond anything in the empirical literature. Lead with the 25-year figures in the text;
   keep Long-term as the converged reference.
3. The **§4.2 wording is already appropriately hedged** ("broadly in line at medium horizons,
   larger in the long run"). The EMDE infrastructure/human-capital magnitudes are the weakest
   point versus the literature and may warrant a sentence acknowledging they sit at the high end.

## Sources

- Ramey (2020), *The Macroeconomic Consequences of Infrastructure Investment*, NBER WP 27625.
- Fieldhouse & Mertens (2023), *The Impact of Public R&D Spending on Innovation*, NBER WP 30894;
  and *The Returns to Government R&D* (Dallas Fed WP).
- Afonso & Rodrigues (2024), *Is Public Investment in Construction and in R&D Growth Enhancing?
  A PVAR Approach*, Applied Economics 56(24): 2875–2899.
- IMF, *World Economic Outlook* (Oct 2014), Ch. 3, public-investment multipliers.
