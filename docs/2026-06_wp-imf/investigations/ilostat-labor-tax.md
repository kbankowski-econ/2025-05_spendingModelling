# ILOSTAT labor-income denominator

## Selected construction

ILOSTAT's annual SDG indicator 10.4.1 provides labor income as a percentage of
GDP. It covers 2004--2026 in the vintage retrieved on August 12, 2026. Matching
ISO codes and calendar years to the WEO calibration database gives denominator
coverage for 40 AEs and 136 EMDEs in 2023.

The ILOSTAT series begins in 2004. To present the same 2000--23 horizon as the
other calibration series, each economy's 2004 labor-income share is held
constant over 2000--03. The WoRLD numerator remains year-specific during the
backcast period.

The labor-tax numerator comes from the IMF's World Revenue Longitudinal
Database (WoRLD). Individual income taxes are `TaxIncI`, and social
contributions are `SocialCon`. The rate is

`tau_l = (individual income tax + social contributions) / ILO labor income`.

Because both inputs are expressed as percentages of GDP, GDP cancels from this
calculation. The WoRLD numerator limits the usable 2023 sample to 37 AEs and 62
EMDEs. The resulting equal-country medians are 34.1 percent for AEs and 11.1
percent for EMDEs. Aggregating the GDP-weighted tax and labor-income components
before calculating the rates gives 32.4 and 16.5 percent, respectively.

## Validation against Bachas and others

The 2018 overlap provides a useful check against the previous source. For 35
AEs, the country-level correlation is 0.78 and the median absolute difference is
2.6 percentage points. The WoRLD--ILOSTAT and Bachas medians on this common
sample are 33.7 and 33.9 percent. For 56 EMDEs, the correlation is 0.91 and the
median absolute difference is 1.9 percentage points; the corresponding medians
are 11.5 and 12.2 percent.

## Qualifications

SDG indicator 10.4.1 includes employee compensation and the imputed labor income
of the self-employed. It is therefore broader than an employee wage bill. This
is defensible for the model's economy-wide labor-income base, but it should be
stated explicitly because the tax numerator is not measured on precisely the
same conceptual boundary in every country.

The current series combines reported information with ILO estimates. Within the
usable 2023 tax-rate sample, 27 AE observations are unflagged and 10 are
imputed. For EMDEs, 26 are unflagged, 24 are imputed, and 12 are model-based
extrapolations. All observations for 2025 and 2026 are imputed or extrapolated,
so 2023 is the preferable reference year for the paper.
