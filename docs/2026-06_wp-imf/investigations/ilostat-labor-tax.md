# ILOSTAT labor-income denominator

## Candidate construction

ILOSTAT's annual SDG indicator 10.4.1 provides labor income as a percentage of
GDP. It covers 2004--2026 in the vintage retrieved on August 12, 2026. Matching
ISO codes and calendar years to the WEO calibration database gives denominator
coverage for 40 AEs and 136 EMDEs in 2023.

The WEO labor-tax numerator can be constructed without its poorly covered wage-
bill series. Individual income tax is `GGRTII` when available and otherwise
`GGRTI - GGRTIC`; social contributions are `GGRS`. The candidate rate is

`tau_l = (individual income tax + social contributions) / ILO labor income`.

Because both inputs are expressed as percentages of GDP, GDP cancels from this
calculation. The WEO numerator limits the usable 2023 sample to 23 AEs and 59
EMDEs. The resulting equal-country medians are 35.6 percent for AEs and 8.6
percent for EMDEs. The calendar-GDP-weighted averages are 35.0 and 17.2 percent,
respectively.

## Validation against Bachas and others

The 2018 overlap provides a useful check against the current source. For 25 AEs,
the country-level correlation is 0.84 and the median absolute difference is 3.2
percentage points. The candidate and Bachas medians on this common sample are
35.9 and 37.1 percent. For 49 EMDEs, the correlation is 0.94 and the median
absolute difference is 1.6 percentage points; the corresponding medians are
10.5 and 10.7 percent.

## Qualifications

SDG indicator 10.4.1 includes employee compensation and the imputed labor income
of the self-employed. It is therefore broader than an employee wage bill. This
is defensible for the model's economy-wide labor-income base, but it should be
stated explicitly because the tax numerator is not measured on precisely the
same conceptual boundary in every country.

The current series combines reported information with ILO estimates. Within the
usable 2023 tax-rate sample, 18 AE observations are unflagged and 5 are imputed.
For EMDEs, 19 are unflagged, 29 are imputed, and 11 are model-based
extrapolations. All observations for 2025 and 2026 are imputed or extrapolated,
so 2023 is the preferable reference year for the paper.
