"""Compare OECD government-investment aggregates using WEO classifications and weights.

The supplied WEO file does not contain government investment. This script joins
its 2023 development classification and nominal US-dollar GDP (`ngdpd`) to the
OECD government-investment-to-GDP observations already retrieved for the paper.
"""
from argparse import ArgumentParser
from pathlib import Path

import pandas as pd

HERE = Path(__file__).resolve().parent
REPO = HERE.parents[2]
OECD_CSV = REPO / "data" / "oecdGovernmentInvestmentPctGDP_2023.csv"
OUTPUT_CSV = REPO / "data" / "oecdGovernmentInvestmentPctGDP_2023_weoComparison.csv"
DEFAULT_WEO = Path(
    "/Users/kk/Developer/2025-09_FM-conjunctural/data/fmData/WEO_enhanced.dta"
)

WEO_GROUP = {
    "Advanced": "AE",
    "Emerging": "EMDE",
    "Low-Income": "EMDE",
}


def aggregate(data, classification_column, classification_label, weighting, value):
    rows = []
    for group in ("AE", "EMDE"):
        sample = data[data[classification_column].eq(group)]
        if weighting == "Equal country weights":
            aggregate_value = sample[value].mean()
        else:
            aggregate_value = (sample[value] * sample["ngdpd"]).sum() / sample["ngdpd"].sum()
        rows.append({
            "classification": classification_label,
            "weighting": weighting,
            "group": group,
            "economies": len(sample),
            "government_investment_pct_gdp": f"{aggregate_value:.4f}",
        })
    return rows


def main():
    parser = ArgumentParser()
    parser.add_argument("--weo", type=Path, default=DEFAULT_WEO)
    args = parser.parse_args()

    oecd = pd.read_csv(OECD_CSV)
    oecd["government_investment_pct_gdp_unrounded"] = (
        100 * oecd["government_investment_millions"] / oecd["gdp_millions"]
    )
    weo = pd.read_stata(args.weo, convert_categoricals=False)
    weo = weo.loc[
        weo["year"].eq(2023),
        ["isocode", "devClass", "ngdpd"],
    ]

    data = oecd.merge(weo, left_on="iso3", right_on="isocode", validate="one_to_one")
    if len(data) != len(oecd):
        raise ValueError("Not every OECD observation matched a 2023 WEO observation")
    if data["ngdpd"].isna().any():
        raise ValueError("Missing 2023 WEO nominal-dollar GDP weights")
    data["weo_group"] = data["devClass"].map(WEO_GROUP)
    if data["weo_group"].isna().any():
        unexpected = sorted(data.loc[data["weo_group"].isna(), "devClass"].unique())
        raise ValueError(f"Unexpected WEO development classes: {unexpected}")

    value = "government_investment_pct_gdp_unrounded"
    rows = []
    for column, label in (
        ("group", "Paper (April 2025 WEO)"),
        ("weo_group", "Supplied WEO file"),
    ):
        rows.extend(aggregate(data, column, label, "Equal country weights", value))
        rows.extend(aggregate(data, column, label, "2023 WEO nominal-GDP weights", value))

    pd.DataFrame(rows).to_csv(OUTPUT_CSV, index=False, lineterminator="\n")
    print(f"Wrote {OUTPUT_CSV.relative_to(REPO)}")


if __name__ == "__main__":
    main()
