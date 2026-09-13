"""Retrieve government budget allocations for R&D (GBARD) from the OECD MSTI
database.

GBARD is the Frascati Manual funder-based measure of government support for
R&D: all R&D funding allocated in government budgets, regardless of the
performing sector. The extract keeps the MSTI total (measure C) in national
currency at current prices for the paper's 36-economy sample; it documents the
public R&D spending target in the calibration (Grdy).

The output is a compact, analysis-ready copy of the official SDMX response.
"""
from io import StringIO
from pathlib import Path
from subprocess import run

import pandas as pd


HERE = Path(__file__).resolve().parent
REPO = HERE.parents[2]
OUTPUT = REPO / "data" / "oecdGbard.csv"

URL = (
    "https://sdmx.oecd.org/public/rest/data/"
    "OECD.STI.STP,DSD_MSTI@DF_MSTI,/all?startPeriod=2013"
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
KEEP_COLUMNS = ["REF_AREA", "TIME_PERIOD", "OBS_VALUE", "OBS_STATUS", "UNIT_MULT"]
OUTPUT_COLUMNS = ["isocode", "group", "year", "value", "observation_status"]


def retrieve():
    result = run(
        [
            "curl", "-L", "--fail", "--silent", "--show-error",
            "--max-time", "300", "-H", "Accept: text/csv", URL,
        ],
        check=True,
        capture_output=True,
    )
    return pd.read_csv(StringIO(result.stdout.decode("utf-8-sig")), low_memory=False)


def clean(raw):
    data = raw.loc[
        raw["REF_AREA"].isin(COUNTRY_GROUP)
        & raw["MEASURE"].eq("C")            # GBARD total
        & raw["UNIT_MEASURE"].eq("XDC")     # national currency
        & raw["PRICE_BASE"].eq("V"),        # current prices
        KEEP_COLUMNS,
    ].copy()
    if not data["UNIT_MULT"].eq(6).all():
        raise ValueError("Expected all GBARD values in millions (UNIT_MULT=6)")
    data["group"] = data["REF_AREA"].map(COUNTRY_GROUP)
    data = data.rename(columns={
        "REF_AREA": "isocode",
        "TIME_PERIOD": "year",
        "OBS_VALUE": "value",
        "OBS_STATUS": "observation_status",
    })[OUTPUT_COLUMNS]
    data = data.sort_values(["isocode", "year"]).reset_index(drop=True)
    if data.duplicated(["isocode", "year"]).any():
        raise ValueError("OECD extract contains duplicate country-years")
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
