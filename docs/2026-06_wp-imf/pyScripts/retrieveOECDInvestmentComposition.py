"""Retrieve government investment by function from the OECD COFOG database.

The extract contains the ten COFOG divisions for general government (S13) and
two capital transactions:

* P5L: gross capital formation and acquisitions less disposals of non-produced
  assets, the concept underlying Government at a Glance Table J.10.4;
* P51G: gross fixed capital formation, retained as a robustness alternative.

The output is a compact, analysis-ready copy of the official SDMX response.
"""
from io import StringIO
from pathlib import Path
from subprocess import run

import pandas as pd


HERE = Path(__file__).resolve().parent
REPO = HERE.parents[2]
OUTPUT = REPO / "data" / "oecdGovernmentInvestmentByFunction.csv"

URL = (
    "https://sdmx.oecd.org/public/rest/v1/data/"
    "OECD.SDD.NAD,DSD_NASEC10@DF_TABLE11,1.1/"
    "A..S13._Z.D.P51G+P5L._Z."
    "GF01+GF02+GF03+GF04+GF05+GF06+GF07+GF08+GF09+GF10."
    "XDC.S.V.N.T1100?startPeriod=2000"
)

COUNTRY_GROUP = {
    "AUT": "AE", "BEL": "AE", "BGR": "EMDE", "CHL": "EMDE",
    "COL": "EMDE", "CRI": "EMDE", "CZE": "AE", "DNK": "AE",
    "EST": "AE", "FIN": "AE", "FRA": "AE", "DEU": "AE",
    "GRC": "AE", "HRV": "AE", "HUN": "EMDE", "ISL": "AE",
    "IRL": "AE", "ISR": "AE", "ITA": "AE", "JPN": "AE",
    "KOR": "AE", "LVA": "AE", "LTU": "AE", "LUX": "AE",
    "NLD": "AE", "NOR": "AE", "POL": "EMDE", "PRT": "AE",
    "ROU": "EMDE", "SVK": "AE", "SVN": "AE", "ESP": "AE",
    "SWE": "AE", "CHE": "AE", "GBR": "AE", "USA": "AE",
}
FUNCTIONS = [f"GF{number:02d}" for number in range(1, 11)]
KEEP_COLUMNS = [
    "REF_AREA", "TRANSACTION", "EXPENDITURE", "TIME_PERIOD", "OBS_VALUE",
    "OBS_STATUS",
]
OUTPUT_COLUMNS = [
    "isocode", "group", "transaction", "function", "year", "value",
    "observation_status",
]


def retrieve():
    result = run(
        [
            "curl", "-L", "--fail", "--silent", "--show-error",
            "--max-time", "180", "-H", "Accept: text/csv", URL,
        ],
        check=True,
        capture_output=True,
    )
    return pd.read_csv(StringIO(result.stdout.decode("utf-8-sig")))


def clean(raw):
    missing = set(KEEP_COLUMNS) - set(raw.columns)
    if missing:
        raise ValueError(f"OECD response is missing columns: {sorted(missing)}")

    data = raw.loc[
        raw["REF_AREA"].isin(COUNTRY_GROUP)
        & raw["TRANSACTION"].isin(["P51G", "P5L"])
        & raw["EXPENDITURE"].isin(FUNCTIONS),
        KEEP_COLUMNS,
    ].copy()
    data["group"] = data["REF_AREA"].map(COUNTRY_GROUP)
    data = data.rename(columns={
        "REF_AREA": "isocode",
        "TRANSACTION": "transaction",
        "EXPENDITURE": "function",
        "TIME_PERIOD": "year",
        "OBS_VALUE": "value",
        "OBS_STATUS": "observation_status",
    })[OUTPUT_COLUMNS]
    data = data.sort_values(
        ["transaction", "isocode", "year", "function"]
    ).reset_index(drop=True)

    duplicates = data.duplicated(
        ["transaction", "isocode", "year", "function"]
    )
    if duplicates.any():
        raise ValueError("OECD extract contains duplicate country-year functions")

    common = data.loc[
        data["transaction"].eq("P5L") & data["year"].between(2013, 2022)
    ]
    counts = common.groupby(["isocode", "year"])["function"].nunique()
    expected_cells = len(COUNTRY_GROUP) * 10
    if len(counts) != expected_cells or not counts.eq(10).all():
        raise ValueError("P5L does not provide a balanced 2013-22 sample")
    return data


def main():
    data = clean(retrieve())
    OUTPUT.parent.mkdir(parents=True, exist_ok=True)
    data.to_csv(OUTPUT, index=False, lineterminator="\n")
    print(
        f"  Wrote {OUTPUT.relative_to(REPO)}: {len(data):,} observations, "
        f"{data['isocode'].nunique()} economies, "
        f"{data['year'].min()}-{data['year'].max()}"
    )


if __name__ == "__main__":
    main()
