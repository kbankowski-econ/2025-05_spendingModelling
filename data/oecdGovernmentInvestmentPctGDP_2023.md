# OECD government investment as a percentage of GDP

The accompanying CSV files retrieve 2023 data for the 36 economies used in the
paper's AE and OECD-covered EMDE samples.
They were retrieved from the OECD SDMX API on 2026-08-07.

Government investment is OECD transaction `P5L` for the general-government
sector (`S13`): gross capital formation plus acquisitions less disposals of
non-produced assets. GDP is transaction `B1GQ` for the total economy (`S1`).
Both values are current-price national-currency amounts in millions. The ratio
is calculated as 100 times government investment divided by GDP.

Sources:

- [OECD Annual government non-financial accounts and key indicators](https://sdmx.oecd.org/public/rest/v1/data/OECD.SDD.NAD,DSD_NASEC10@DF_TABLE12,1.1/A..S13._Z.D.P5L._Z._Z.XDC.S.V.N.T0200?startPeriod=2023&endPeriod=2023),
  `OECD.SDD.NAD,DSD_NASEC10@DF_TABLE12,1.1`.
- [OECD Annual GDP and components](https://sdmx.oecd.org/public/rest/v1/data/OECD.SDD.NAD,DSD_NAMAIN10@DF_TABLE1,2.0/A..S1.S1.B1GQ._Z._Z._Z.XDC.V.N.T0101?startPeriod=2023&endPeriod=2023),
  `OECD.SDD.NAD,DSD_NAMAIN10@DF_TABLE1,2.0`.

Regenerate the files with:

```sh
python3 docs/2026-06_wp-imf/pyScripts/retrieveOECDGovernmentInvestment.py
```
