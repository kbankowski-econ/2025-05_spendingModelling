# Section 4.4 sensitivity analysis

Quantitative support for the paper's sensitivity figure. The driver varies the
structural elasticity governing each productive-spending channel:

| Experiment | Parameter | AE baseline | Grid |
|---|---|---:|---|
| Infrastructure investment | `alphaG` | 0.054 | 0.03, 0.054, 0.075, 0.10, 0.122, 0.15 |
| Human-capital investment | `mu` | 0.10 | 0.05, 0.10, 0.15, 0.20 |
| R&D spending | `alphaRD` | 0.09 | 0.05, 0.07, 0.09, 0.11, 0.13 |

For each pair, `sweep.m` overrides the parameter with `set_param_value`, solves
the deterministic perfect-foresight model, and records output responses and
present-value cumulative own-spending multipliers. Other parameters remain at
their AE calibration. A separate baseline row retains the full calibrated model
for each experiment.

The sweep is deliberately paper-specific. It excludes government consumption,
cross-channel elasticities, the adoption elasticity, and spending-efficiency
gaps because none enters the current sensitivity figure. Efficiency reforms are
analyzed as separate experiments in the paper.

## Files

- `sweep.m`: isolated Dynare driver. It builds models under the gitignored
  `work/` directory, leaving committed model results unchanged.
- `results/sweep_AE.csv` and `results/sweep_AE_perm.csv`: multiplier results for
  persistent temporary and permanent spending increases.
- `results/sweep_AE_irf.csv` and `results/sweep_AE_irf_perm.csv`: corresponding
  annual and quarterly output paths used by the paper figure.

## Multiplier definition

The calculation matches the paper's multiplier table: discounted cumulative
output deviations divided by discounted cumulative deviations of the spending
instrument. It is reported at 1, 5, 10, 20, 25, and 250 years.

## Run

From the repository root:

```bash
matlab -batch "cd('<repo>'); iniProject; run('docs/2026-06_wp-imf/investigations/sensitivity/sweep.m')"
SWEEP_PERMANENT=1 matlab -batch "cd('<repo>'); iniProject; run('docs/2026-06_wp-imf/investigations/sensitivity/sweep.m')"
python pyScripts/2026-06_wp-imf/plotSensitivityIRF.py
python pyScripts/2026-06_wp-imf/plotSensitivityIRF.py --permanent
```

Set `SWEEP_SMOKE=1` to run three R&D/`alphaRD` draws as a short pipeline check.
