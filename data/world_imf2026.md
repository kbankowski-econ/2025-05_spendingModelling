# IMF World Revenue Longitudinal Database

`world_imf2026.dta` is the 2026 vintage of the IMF's World Revenue Longitudinal
Database (WoRLD), downloaded on 2026-08-12. The database is available from:

https://data.imf.org/Datasets/WORLD

The paper's calibration-data figure uses `TaxIncI`, taxes on the income and
profits of individuals, and `SocialCon`, social contributions. Both are reported
as percentages of GDP. Corporate income taxes (`TaxIncC`) are excluded. Missing
social contributions remain missing; only explicitly reported zeros are treated
as zero.

SHA-256:
`359487f34b057839c5d2ebea2416e09b6d33725bcc57b7b8f8bac3108f49677a`
