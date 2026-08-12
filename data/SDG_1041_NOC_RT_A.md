# ILOSTAT labour income share

`SDG_1041_NOC_RT_A.rds` was retrieved on 2026-08-12 from the official ILOSTAT
bulk-download facility:

https://rplumber.ilo.org/files/indicator/SDG_1041_NOC_RT_A.rds

`SDG_1041_NOC_RT_A.csv` is a direct CSV conversion of the RDS file. The series
is SDG indicator 10.4.1, labour income as a percentage of GDP, at annual
frequency. It covers 2004--2026 in the retrieved vintage. The value-status code
`I` denotes an imputation, `M` denotes a model-based extrapolation, and an empty
status is unflagged in the source.

The implicit labor-income tax rate in the paper combines this denominator with
the IMF WoRLD tax numerator:

`tau_l = (personal income tax + social contributions) / labor income`.

Because the ILO indicator includes both employee compensation and the imputed
labor income of the self-employed, it is broader than an employee wage bill.
This conceptual difference should be stated if the series replaces the current
Bachas and others measure in the paper.

SHA-256 checksums are recorded below:

- `SDG_1041_NOC_RT_A.rds`:
  `d442d2dd8400409d1baa3909f526365ea93a7bb8f7ba85140ce407766d2e7c3e`
- `SDG_1041_NOC_RT_A.csv`:
  `ed9186d68a65a722d3c5d5df3ca58b2573c2ab47984db3ce4acdf757946f5ce3`
