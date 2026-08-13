"""Country-group evidence underlying the steady-state calibration targets.

The figure is structured as a 3x2 panel for the six target categories in Table 2.
Each panel pairs a time series with a smaller box-and-whisker summary.
Real GDP growth, government consumption, government investment, and public debt
are populated from the WEO calibration database. The consumption-tax panel
uses general sales taxes and excises from the IMF's WoRLD database. Its base is
private consumption plus government consumption excluding government employee
compensation, net of those taxes. The labor-income-tax panel divides individual
income taxes and social contributions from WoRLD by labor income from ILOSTAT.
For 2000--03, each economy's labor-income share is held at its 2004 value. China
is excluded only from the government-investment aggregates because its WEO
series covers the broader public sector.

Solid lines are equal-country group medians, dotted lines are calendar-GDP-
weighted group averages, and shaded areas are cross-country 25th--75th
percentile ranges. Open diamonds show the corresponding model targets in the
distribution panels.
The United States is excluded only from the AE consumption-tax weighted average
because its government employee compensation is unavailable after 2021.
Japan is excluded only from the AE public-debt weighted average because its
exceptionally high debt ratio has disproportionate influence under GDP weights.
Each boxplot pools the available country-year observations for 2000--23.

In:  WEO_calib_enhanced.dta, data/world_imf2026.dta,
     data/SDG_1041_NOC_RT_A.csv
Out: docs/2026-06_wp-imf/figures/calibrationDataBands.{png,pdf,html,csv}
"""
from argparse import ArgumentParser
from pathlib import Path

import pandas as pd
import plotly.graph_objects as go
from plotly.subplots import make_subplots

from wp_charts import (
    chart_display_cm,
    chart_render_px,
    font_px_for_pt,
    smart_save_image,
    write_pdf,
)

SCRIPT_DIR = Path(__file__).resolve().parent
PROJECT_ROOT = SCRIPT_DIR.parents[1]
FIGURES_DIR = PROJECT_ROOT / "docs" / "2026-06_wp-imf" / "figures"
DEFAULT_WEO = Path(
    "/Users/kk/Developer/2025-09_FM-conjunctural/data/fmData/"
    "WEO_calib_enhanced.dta"
)
DEFAULT_WORLD = PROJECT_ROOT / "data" / "world_imf2026.dta"
DEFAULT_ILO_LABOR = PROJECT_ROOT / "data" / "SDG_1041_NOC_RT_A.csv"

OUTPUT_STEM = "calibrationDataBands"
FIRST_YEAR, LAST_YEAR = 2000, 2023
REF_YEAR = 2023
LABOR_SHARE_FIRST_YEAR = 2004
MIN_PEERS = 10
MIN_AGGREGATE_IFSCODE = 1000

GROUPS = [
    ("Advanced Economies", "AE", "#1E88E5"),
    ("Emerging Market and Developing Economies", "EMDE", "#E67E22"),
]
GROUP_MAP = {
    "Advanced": "AE",
    "Emerging": "EMDE",
    "Low-Income": "EMDE",
}

PANELS = [
    ("Real GDP growth", "g_real"),
    ("Government consumption", "ncg_gdp"),
    ("Government investment", "nfig_gdp"),
    ("Consumption tax", "tau_c"),
    ("Labor income tax", "tau_l"),
    ("Public debt", "ggxwdg_gdp"),
]
TARGETS = {
    "g_real": {"AE": 1.6, "EMDE": 3.0},
    "ncg_gdp": {"AE": 18.0, "EMDE": 14.0},
    # Infrastructure plus human-capital investment; public R&D is not fixed investment.
    "nfig_gdp": {"AE": 3.0 + 1.45, "EMDE": 5.0 + 2.0},
    "tau_c": {"AE": 18.0, "EMDE": 15.0},
    "tau_l": {"AE": 25.0, "EMDE": 10.0},
    "ggxwdg_gdp": {"AE": 100.0, "EMDE": 60.0},
}

BAND_OPACITY = 0.15
LINE_WIDTH = 2.5
WEIGHTED_LINE_WIDTH = 2.0
TICK_YEARS = [2000, 2005, 2010, 2015, 2020, 2023]
TICK_LABELS = ["2000", "05", "10", "15", "20", "23"]

WIDTH_PX, HEIGHT_PX = chart_render_px(OUTPUT_STEM, (15, 15))
DISPLAY_CM = chart_display_cm(OUTPUT_STEM, (15, 15))
FONT_FAMILY = "Palatino, 'Palatino Linotype', 'Book Antiqua', serif"
FONT_PX = font_px_for_pt(8, WIDTH_PX, DISPLAY_CM[0])
LEGEND_FONT_PX = font_px_for_pt(7, WIDTH_PX, DISPLAY_CM[0])
TITLE_FONT_PX = font_px_for_pt(9, WIDTH_PX, DISPLAY_CM[0])
BOX_TICK_FONT_PX = font_px_for_pt(7, WIDTH_PX, DISPLAY_CM[0])


def rgba(hex_color, alpha):
    value = hex_color.lstrip("#")
    return (
        f"rgba({int(value[0:2], 16)},{int(value[2:4], 16)},"
        f"{int(value[4:6], 16)},{alpha})"
    )


def load_data(weo_path, world_path, ilo_labor_path):
    columns = [
        "ifscode", "isocode", "year", "devClass", "ngdpd", "g_real",
        "ncg_gdp", "nfig_gdp", "ncp_gdp", "ggece_gdp", "ggxwdg_gdp",
    ]
    data = pd.read_stata(weo_path, columns=columns, convert_categoricals=False)
    data = data.loc[data["ifscode"].lt(MIN_AGGREGATE_IFSCODE)].copy()

    world = pd.read_stata(
        world_path,
        columns=[
            "ISO3", "year", "TaxIncI", "SocialCon", "TaxSalG", "TaxSalExc",
        ],
        convert_categoricals=False,
    )
    data = data.merge(
        world[["ISO3", "year", "TaxSalG", "TaxSalExc"]],
        left_on=["isocode", "year"],
        right_on=["ISO3", "year"],
        how="left",
        validate="one_to_one",
    )
    consumption_tax_components = ["TaxSalG", "TaxSalExc"]
    complete_tax = data[consumption_tax_components].notna().all(axis=1)
    data["tau_c_tax"] = data[consumption_tax_components].sum(axis=1).where(
        complete_tax
    )
    data["tau_c_base"] = (
        data["ncp_gdp"] + data["ncg_gdp"] - data["ggece_gdp"]
    )
    data = data.drop(columns=["ISO3", *consumption_tax_components])

    pretax_consumption = data["tau_c_base"] - data["tau_c_tax"]
    data["tau_c"] = (
        data["tau_c_tax"] / pretax_consumption * 100
    ).where(pretax_consumption.gt(0))
    data["group"] = data["devClass"].map(GROUP_MAP)
    data = data.dropna(subset=["group"])
    data = data[data["year"].between(FIRST_YEAR, LAST_YEAR)].copy()

    country_year = data[["isocode", "year", "group", "ngdpd"]].dropna(
        subset=["isocode", "group"]
    )

    world["labor_tax_gdp"] = world["TaxIncI"] + world["SocialCon"]

    ilo = pd.read_csv(
        ilo_labor_path,
        usecols=["ref_area", "time", "obs_value"],
    ).rename(columns={"obs_value": "labor_income_gdp"})
    ilo_first = ilo.loc[ilo["time"].eq(LABOR_SHARE_FIRST_YEAR)].copy()
    ilo_backcast = pd.concat(
        [
            ilo_first.assign(time=year)
            for year in range(FIRST_YEAR, LABOR_SHARE_FIRST_YEAR)
        ],
        ignore_index=True,
    )
    ilo = pd.concat([ilo_backcast, ilo], ignore_index=True)

    labor = world.merge(
        ilo,
        left_on=["ISO3", "year"],
        right_on=["ref_area", "time"],
        how="inner",
        validate="one_to_one",
    )
    labor["tau_l"] = (
        labor["labor_tax_gdp"] / labor["labor_income_gdp"] * 100
    ).where(labor["labor_income_gdp"].gt(0))
    labor = labor.loc[labor["year"].between(FIRST_YEAR, LAST_YEAR)].merge(
        country_year,
        left_on=["ISO3", "year"],
        right_on=["isocode", "year"],
        how="inner",
        validate="one_to_one",
    )[
        [
            "year", "group", "ngdpd", "tau_l", "labor_tax_gdp",
            "labor_income_gdp",
        ]
    ]

    return pd.concat([data, labor], ignore_index=True, sort=False)


def group_sample(data, variable, group):
    subset = data.loc[data["group"].eq(group)]
    if variable == "nfig_gdp":
        subset = subset.loc[subset["isocode"].ne("CHN")]
    return subset


def group_band(data, variable, group):
    subset = group_sample(data, variable, group)
    grouped = subset.groupby("year")[variable]
    band = pd.DataFrame({
        "p25": grouped.quantile(0.25),
        "p50": grouped.quantile(0.50),
        "p75": grouped.quantile(0.75),
        "n": grouped.count(),
    })

    band["group_value"] = band["p50"]
    band["central_statistic"] = "country_median"

    weighted_subset = subset
    if variable == "tau_c" and group == "AE":
        weighted_subset = subset.loc[subset["isocode"].ne("USA")]
    if variable == "ggxwdg_gdp" and group == "AE":
        weighted_subset = subset.loc[subset["isocode"].ne("JPN")]

    if variable in {"tau_c", "tau_l"}:
        if variable == "tau_c":
            tax_column = "tau_c_tax"
            base_column = "tau_c_base"
            base = weighted_subset[base_column] - weighted_subset[tax_column]
        else:
            tax_column = "labor_tax_gdp"
            base_column = "labor_income_gdp"
            base = weighted_subset[base_column]

        weighted = weighted_subset.loc[
            weighted_subset[[tax_column, base_column]].notna().all(axis=1)
            & base.gt(0)
            & weighted_subset["ngdpd"].gt(0),
            ["year", tax_column, base_column, "ngdpd"],
        ].copy()
        weighted["weighted_tax"] = weighted[tax_column] * weighted["ngdpd"]
        weighted["weighted_base"] = weighted[base_column] * weighted["ngdpd"]
        weighted = weighted.groupby("year").agg(
            weighted_tax=("weighted_tax", "sum"),
            weighted_base=("weighted_base", "sum"),
            weighted_n=(tax_column, "count"),
        )
        if variable == "tau_c":
            denominator = weighted["weighted_base"] - weighted["weighted_tax"]
        else:
            denominator = weighted["weighted_base"]
        weighted["gdp_weighted_average"] = (
            weighted["weighted_tax"] / denominator * 100
        )
    else:
        weighted = weighted_subset.loc[
            weighted_subset[variable].notna() & weighted_subset["ngdpd"].gt(0),
            ["year", variable, "ngdpd"],
        ].copy()
        weighted["weighted_value"] = weighted[variable] * weighted["ngdpd"]
        weighted = weighted.groupby("year").agg(
            weighted_value=("weighted_value", "sum"),
            weight=("ngdpd", "sum"),
            weighted_n=(variable, "count"),
        )
        weighted["gdp_weighted_average"] = (
            weighted["weighted_value"] / weighted["weight"]
        )
    band = band.join(weighted[["gdp_weighted_average", "weighted_n"]])

    return band.loc[band["n"].ge(MIN_PEERS)].reset_index()


def add_populated_panel(
    fig, data, variable, row, time_col, box_col, show_group_legend, csv_rows,
):
    bands = {code: group_band(data, variable, code) for _, code, _ in GROUPS}

    for _, code, color in GROUPS:
        band = bands[code]
        years = band["year"].tolist()
        fig.add_trace(go.Scatter(
            x=years + years[::-1],
            y=band["p75"].tolist() + band["p25"].tolist()[::-1],
            fill="toself",
            fillcolor=rgba(color, BAND_OPACITY),
            line=dict(color="rgba(0,0,0,0)"),
            hoverinfo="skip",
            showlegend=False,
        ), row=row, col=time_col)

    for _, code, color in GROUPS:
        band = bands[code]
        reference_year = REF_YEAR
        if band.empty or not band["year"].eq(reference_year).any():
            raise ValueError(
                f"Missing {reference_year} {code} observations for {variable}"
            )

        fig.add_trace(go.Scatter(
            x=band["year"],
            y=band["group_value"],
            mode="lines",
            line=dict(color=color, width=LINE_WIDTH),
            name=f"{code}: median",
            legend="legend",
            legendgroup=f"{code}_median",
            legendrank=1 if code == "AE" else 3,
            showlegend=show_group_legend,
        ), row=row, col=time_col)
        fig.add_trace(go.Scatter(
            x=band["year"],
            y=band["gdp_weighted_average"],
            mode="lines",
            line=dict(color=color, width=WEIGHTED_LINE_WIDTH, dash="dot"),
            name=f"{code}: GDP-weighted average",
            legend="legend" if code == "AE" else "legend2",
            legendgroup=f"{code}_weighted",
            legendrank=2 if code == "AE" else 4,
            showlegend=show_group_legend,
        ), row=row, col=time_col)

        pooled = group_sample(data, variable, code)[variable].dropna()
        box_position = 0 if code == "AE" else 1
        q1, pooled_median, q3 = pooled.quantile([0.25, 0.50, 0.75])
        fig.add_trace(go.Box(
            x=[box_position],
            q1=[q1],
            median=[pooled_median],
            q3=[q3],
            lowerfence=[q1],
            upperfence=[q3],
            width=0.52,
            boxpoints=False,
            fillcolor=rgba(color, BAND_OPACITY),
            line=dict(color=color, width=1.5),
            marker=dict(color=color),
            name=code,
            showlegend=False,
            hovertemplate=f"{code}<br>%{{y:.2f}}<extra></extra>",
        ), row=row, col=box_col)

        period_median = float(band["group_value"].median())
        period_weighted = float(band["gdp_weighted_average"].mean())
        summary_lines = [
            (
                period_median,
                "solid",
                LINE_WIDTH,
                "Period median",
                "period_median",
                6,
            ),
            (
                period_weighted,
                "dot",
                WEIGHTED_LINE_WIDTH,
                "Period GDP-weighted average",
                "period_weighted",
                7,
            ),
        ]
        for y_value, dash, width, name, legendgroup, rank in summary_lines:
            fig.add_trace(go.Scatter(
                x=[box_position - 0.38, box_position + 0.38],
                y=[y_value, y_value],
                mode="lines",
                line=dict(color=color, width=width, dash=dash),
                name=name,
                legendgroup=legendgroup,
                legendrank=rank,
                showlegend=False,
                hovertemplate=f"{name}: %{{y:.2f}}<extra></extra>",
                cliponaxis=False,
            ), row=row, col=box_col)

        fig.add_trace(go.Scatter(
            x=[box_position],
            y=[TARGETS[variable][code]],
            mode="markers",
            marker=dict(
                color=color,
                size=9,
                symbol="diamond-open",
                line=dict(width=2),
            ),
            name="Table 2 target",
            legend="legend2",
            legendgroup="target",
            legendrank=5,
            showlegend=show_group_legend and code == "AE",
            hovertemplate="Table 2 target: %{y:.2f}<extra></extra>",
            cliponaxis=False,
        ), row=row, col=box_col)

        for _, obs in band.iterrows():
            csv_rows.append({
                "variable": variable,
                "group": code,
                "year": int(obs["year"]),
                "p25": round(float(obs["p25"]), 4),
                "p50": round(float(obs["p50"]), 4),
                "p75": round(float(obs["p75"]), 4),
                "group_value": round(float(obs["group_value"]), 4),
                "central_statistic": obs["central_statistic"],
                "economies": int(obs["n"]),
                "gdp_weighted_average": round(
                    float(obs["gdp_weighted_average"]), 4
                ),
                "weighted_economies": int(obs["weighted_n"]),
                "table2_target": TARGETS[variable][code],
            })


def main():
    parser = ArgumentParser()
    parser.add_argument("--weo", type=Path, default=DEFAULT_WEO)
    parser.add_argument("--world", type=Path, default=DEFAULT_WORLD)
    parser.add_argument("--ilo-labor", type=Path, default=DEFAULT_ILO_LABOR)
    args = parser.parse_args()
    data = load_data(args.weo, args.world, args.ilo_labor)

    fig = make_subplots(
        rows=3,
        cols=5,
        specs=[[{}, {}, None, {}, {}] for _ in range(3)],
        column_widths=[0.36, 0.12, 0.04, 0.36, 0.12],
        subplot_titles=tuple(
            item
            for pair_index in range(3)
            for item in (
                PANELS[pair_index * 2][0], "",
                PANELS[pair_index * 2 + 1][0], "",
            )
        ),
        horizontal_spacing=0.018,
        vertical_spacing=0.13,
    )

    csv_rows = []
    for index, (_, variable) in enumerate(PANELS):
        row = index // 2 + 1
        time_col = 1 if index % 2 == 0 else 4
        box_col = 2 if index % 2 == 0 else 5
        time_yaxis = "y" if index == 0 else f"y{index * 2 + 1}"
        if variable is not None:
            add_populated_panel(
                fig, data, variable, row, time_col, box_col,
                show_group_legend=(index == 0),
                csv_rows=csv_rows,
            )
            fig.update_xaxes(
                range=[FIRST_YEAR, LAST_YEAR + 1],
                tickvals=TICK_YEARS,
                ticktext=TICK_LABELS,
                showgrid=False,
                linecolor="black",
                linewidth=1.5,
                ticks="inside",
                row=row,
                col=time_col,
            )
            fig.update_yaxes(
                showgrid=True,
                gridcolor="rgba(0,0,0,0.15)",
                gridwidth=0.5,
                zeroline=True,
                zerolinecolor="black",
                zerolinewidth=1.2,
                linecolor="black",
                linewidth=1.5,
                ticks="inside",
                row=row,
                col=time_col,
            )
            fig.update_xaxes(
                range=[-0.5, 1.5],
                tickvals=[0, 1],
                ticktext=["AE", "EMDE"],
                tickfont=dict(size=BOX_TICK_FONT_PX),
                showgrid=False,
                linecolor="black",
                linewidth=1.5,
                ticks="",
                row=row,
                col=box_col,
            )
            fig.update_yaxes(
                matches=time_yaxis,
                showticklabels=True,
                tickfont=dict(size=BOX_TICK_FONT_PX),
                tickformat=".0f",
                showgrid=True,
                gridcolor="rgba(0,0,0,0.15)",
                gridwidth=0.5,
                zeroline=True,
                zerolinecolor="black",
                zerolinewidth=1.2,
                linecolor="black",
                linewidth=1.5,
                ticks="inside",
                side="right",
                row=row,
                col=box_col,
            )

    fig.update_xaxes(tickfont=dict(size=FONT_PX))
    fig.update_yaxes(tickfont=dict(size=FONT_PX))
    fig.update_layout(
        template="simple_white",
        width=WIDTH_PX,
        height=HEIGHT_PX,
        margin=dict(l=30, r=14, t=100, b=24),
        font=dict(family=FONT_FAMILY, size=FONT_PX),
        legend=dict(
            orientation="h",
            bgcolor="rgba(0,0,0,0)",
            yanchor="bottom",
            y=1.075,
            xanchor="center",
            x=0.5,
            font=dict(size=LEGEND_FONT_PX),
        ),
        legend2=dict(
            orientation="h",
            bgcolor="rgba(0,0,0,0)",
            yanchor="bottom",
            y=1.04,
            xanchor="center",
            x=0.5,
            font=dict(size=LEGEND_FONT_PX),
        ),
    )
    for annotation in fig.layout.annotations:
        if annotation.text in {title for title, _ in PANELS}:
            annotation.font.size = TITLE_FONT_PX
    left_title_x = (fig.layout.xaxis.domain[0] + fig.layout.xaxis2.domain[1]) / 2
    right_title_x = (fig.layout.xaxis3.domain[0] + fig.layout.xaxis4.domain[1]) / 2
    title_annotations = [
        annotation
        for annotation in fig.layout.annotations
        if annotation.text in {title for title, _ in PANELS}
    ]
    for index, annotation in enumerate(title_annotations):
        annotation.x = left_title_x if index % 2 == 0 else right_title_x

    FIGURES_DIR.mkdir(parents=True, exist_ok=True)
    png_path = FIGURES_DIR / f"{OUTPUT_STEM}.png"
    pdf_path = FIGURES_DIR / f"{OUTPUT_STEM}.pdf"
    html_path = FIGURES_DIR / f"{OUTPUT_STEM}.html"
    csv_path = FIGURES_DIR / f"{OUTPUT_STEM}.csv"
    smart_save_image(fig, png_path, DISPLAY_CM)
    write_pdf(fig, pdf_path, WIDTH_PX, DISPLAY_CM[0])
    fig.write_html(str(html_path), auto_open=True)
    pd.DataFrame(csv_rows).to_csv(csv_path, index=False, lineterminator="\n")
    print(f"  Saved {png_path.name}, {pdf_path.name}, {html_path.name}, and {csv_path.name}")


if __name__ == "__main__":
    main()
