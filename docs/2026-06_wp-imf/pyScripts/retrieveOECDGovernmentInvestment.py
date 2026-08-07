"""Retrieve 2023 general-government investment as a percentage of GDP.

The numerator is OECD transaction P5L for sector S13: gross capital formation
plus acquisitions less disposals of non-produced assets. The denominator is
current-price GDP (B1GQ) for the total economy. Both series are downloaded in
national currency, millions, from the OECD SDMX API.

Writes:
  ../../../data/oecdGovernmentInvestmentPctGDP_2023.csv
  ../../../data/oecdGovernmentInvestmentPctGDP_2023_summary.csv
"""
from csv import DictReader, DictWriter
from io import StringIO
from pathlib import Path
from statistics import mean, median
from subprocess import run

HERE = Path(__file__).resolve().parent
REPO = HERE.parents[2]
COUNTRY_CSV = REPO / "data" / "oecdGovernmentInvestmentPctGDP_2023.csv"
SUMMARY_CSV = REPO / "data" / "oecdGovernmentInvestmentPctGDP_2023_summary.csv"

YEAR = "2023"
GOVERNMENT_INVESTMENT_URL = (
    "https://sdmx.oecd.org/public/rest/v1/data/"
    "OECD.SDD.NAD,DSD_NASEC10@DF_TABLE12,1.1/"
    "A..S13._Z.D.P5L._Z._Z.XDC.S.V.N.T0200"
    f"?startPeriod={YEAR}&endPeriod={YEAR}"
)
GDP_URL = (
    "https://sdmx.oecd.org/public/rest/v1/data/"
    "OECD.SDD.NAD,DSD_NAMAIN10@DF_TABLE1,2.0/"
    "A..S1.S1.B1GQ._Z._Z._Z.XDC.V.N.T0101"
    f"?startPeriod={YEAR}&endPeriod={YEAR}"
)

COUNTRIES = {
    "AE": [
        ("AUT", "Austria"), ("BEL", "Belgium"), ("HRV", "Croatia"),
        ("CZE", "Czechia"), ("DNK", "Denmark"), ("EST", "Estonia"),
        ("FIN", "Finland"), ("FRA", "France"), ("DEU", "Germany"),
        ("GRC", "Greece"), ("ISL", "Iceland"), ("IRL", "Ireland"),
        ("ISR", "Israel"), ("ITA", "Italy"), ("JPN", "Japan"),
        ("KOR", "Korea"), ("LVA", "Latvia"), ("LTU", "Lithuania"),
        ("LUX", "Luxembourg"), ("NLD", "Netherlands"), ("NOR", "Norway"),
        ("PRT", "Portugal"), ("SVK", "Slovak Republic"),
        ("SVN", "Slovenia"), ("ESP", "Spain"), ("SWE", "Sweden"),
        ("CHE", "Switzerland"), ("GBR", "United Kingdom"),
        ("USA", "United States"),
    ],
    "EMDE": [
        ("BGR", "Bulgaria"), ("CHL", "Chile"), ("COL", "Colombia"),
        ("CRI", "Costa Rica"), ("HUN", "Hungary"), ("POL", "Poland"),
        ("ROU", "Romania"),
    ],
}


def download(url):
    result = run(
        [
            "curl", "-L", "--fail", "--silent", "--show-error",
            "--max-time", "120", "-H", "Accept: text/csv", url,
        ],
        check=True,
        capture_output=True,
    )
    return list(DictReader(StringIO(result.stdout.decode("utf-8-sig"))))


def index_unique(rows, label):
    indexed = {}
    for row in rows:
        code = row["REF_AREA"]
        if code in indexed:
            raise ValueError(f"Duplicate {label} observation for {code}")
        indexed[code] = row
    return indexed


def build_country_records(investment_rows, gdp_rows):
    investment = index_unique(investment_rows, "government-investment")
    gdp = index_unique(gdp_rows, "GDP")
    records = []
    for group, countries in COUNTRIES.items():
        for code, country in countries:
            if code not in investment or code not in gdp:
                raise ValueError(f"Missing OECD observation for {country} ({code})")
            numerator = investment[code]
            denominator = gdp[code]
            if numerator["CURRENCY"] != denominator["CURRENCY"]:
                raise ValueError(f"Currency mismatch for {country}")
            if numerator["UNIT_MULT"] != "6" or denominator["UNIT_MULT"] != "6":
                raise ValueError(f"Expected values in millions for {country}")

            investment_value = float(numerator["OBS_VALUE"])
            gdp_value = float(denominator["OBS_VALUE"])
            records.append({
                "country": country,
                "iso3": code,
                "group": group,
                "year": YEAR,
                "currency": numerator["CURRENCY"],
                "government_investment_millions": f"{investment_value:.3f}",
                "gdp_millions": f"{gdp_value:.3f}",
                "government_investment_pct_gdp": f"{100 * investment_value / gdp_value:.4f}",
                "government_investment_transaction": "P5L",
                "gdp_transaction": "B1GQ",
            })
    return records


def build_summary(records):
    output = []
    for group in COUNTRIES:
        values = [
            float(row["government_investment_pct_gdp"])
            for row in records if row["group"] == group
        ]
        for statistic, function in (("Unweighted mean", mean), ("Median", median)):
            output.append({
                "group": group,
                "year": YEAR,
                "statistic": statistic,
                "economies": len(values),
                "government_investment_pct_gdp": f"{function(values):.4f}",
            })
    return output


def write_csv(path, records):
    path.parent.mkdir(parents=True, exist_ok=True)
    with path.open("w", encoding="utf-8", newline="") as file:
        writer = DictWriter(file, fieldnames=records[0], lineterminator="\n")
        writer.writeheader()
        writer.writerows(records)


def main():
    records = build_country_records(
        download(GOVERNMENT_INVESTMENT_URL),
        download(GDP_URL),
    )
    write_csv(COUNTRY_CSV, records)
    write_csv(SUMMARY_CSV, build_summary(records))
    print(f"Wrote {COUNTRY_CSV.relative_to(REPO)}")
    print(f"Wrote {SUMMARY_CSV.relative_to(REPO)}")


if __name__ == "__main__":
    main()
