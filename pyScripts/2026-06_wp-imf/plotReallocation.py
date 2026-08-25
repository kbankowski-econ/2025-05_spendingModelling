"""Figure 5: expenditure reallocation, output and public-debt effects."""
from pathlib import Path

import pandas as pd
import plotly.graph_objects as go
from plotly.subplots import make_subplots

from wp_charts import chart_render_px, chart_display_cm, debt_to_ratio_change, font_px_for_pt, smart_save_image, write_pdf

SCRIPT_DIR = Path(__file__).resolve().parent
PROJECT_ROOT = SCRIPT_DIR.parents[1]
INPUT_CSV = PROJECT_ROOT / "docs" / "csvFiles" / "figureNumbers_yearly.csv"
FIGURES_DIR = PROJECT_ROOT / "docs" / "2026-06_wp-imf" / "figures"

OUTPUT_STEM = "reallocation_yd"
YEARS = [2026, 2030, 2040, 2050]
YEAR_LABELS = ["2026", "30", "40", "50"]

SERIES = [
    ("Infrastructure investment", "#1565C0", "Model_HumanCapital_epsi_ig", "EM_Model_HumanCapital_epsiig"),
    ("Human capital investment", "#6A1B9A", "Model_HumanCapital_epsi_cge", "EM_Model_HumanCapital_epsicge"),
    ("R&D spending", "#2E7D32", "Model_HumanCapital_epsi_cgrd", None),
]

WIDTH_PX, HEIGHT_PX = chart_render_px(OUTPUT_STEM, (15, 8.5))
DISPLAY_CM = chart_display_cm(OUTPUT_STEM, (15, 8.5))
FONT_FAMILY = "Palatino, 'Palatino Linotype', 'Book Antiqua', serif"
FONT_PX = font_px_for_pt(8, WIDTH_PX, DISPLAY_CM[0])
LEGEND_FONT_PX = font_px_for_pt(7, WIDTH_PX, DISPLAY_CM[0])


def main():
    df = pd.read_csv(INPUT_CSV)
    df = df.rename(columns={df.columns[0]: "date"})
    df["year"] = df["date"].str.extract(r"(\d{4})").astype(int)
    df = debt_to_ratio_change(df)
    indexed = df[df["year"].isin(YEARS)].set_index("year")

    fig = make_subplots(
        rows=2,
        cols=2,
        shared_xaxes=True,
        shared_yaxes="rows",
        row_heights=[2 / 3, 1 / 3],
        horizontal_spacing=0.10,
        vertical_spacing=0.18,
        subplot_titles=("Advanced Economies", "Emerging Market and Developing Economies"),
    )

    for label, color, ae_model, em_model in SERIES:
        for col, model in ((1, ae_model), (2, em_model)):
            if model is None:
                continue
            for row, variable in ((1, "yd"), (2, "by_yss")):
                fig.add_trace(
                    go.Bar(
                        x=YEAR_LABELS,
                        y=indexed.loc[YEARS, f"{model}___{variable}"].values,
                        name=label,
                        legendgroup=label,
                        showlegend=(row == 1 and col == 1),
                        marker_color=color,
                    ),
                    row=row,
                    col=col,
                )

    fig.update_layout(
        template="simple_white",
        width=WIDTH_PX,
        height=HEIGHT_PX,
        margin=dict(t=58, b=25, l=58, r=20),
        font=dict(family=FONT_FAMILY, size=FONT_PX),
        barmode="group",
        bargap=0.20,
        bargroupgap=0.05,
        legend=dict(
            orientation="h",
            yref="container",
            yanchor="top",
            y=0.995,
            xanchor="center",
            x=0.5,
            font=dict(size=LEGEND_FONT_PX),
        ),
        annotations=[
            dict(a.to_plotly_json(), font=dict(family=FONT_FAMILY, size=FONT_PX))
            for a in fig.layout.annotations
        ],
    )

    fig.update_xaxes(
        showgrid=False,
        linecolor="black",
        linewidth=1.5,
        ticks="inside",
        tickfont=dict(size=FONT_PX),
        title=None,
    )
    fig.update_yaxes(
        showgrid=True,
        gridcolor="rgba(0,0,0,0.15)",
        gridwidth=0.5,
        zeroline=True,
        zerolinewidth=1.5,
        zerolinecolor="black",
        linecolor="black",
        linewidth=1.5,
        ticks="inside",
        tickfont=dict(size=FONT_PX),
        title=None,
    )
    # Row labels anchored at the plot-area edge and offset by a fixed pixel
    # xshift (as in plotEfficiencyIRF.py), so they sit at the same distance from
    # the axis in both rows even though the lower row's negative tick labels are
    # wider than the upper row's positive labels.
    row_labels = (
        ("Output", sum(fig.layout.yaxis.domain) / 2),
        ("Debt-to-GDP Ratio", sum(fig.layout.yaxis3.domain) / 2),
    )
    for text, y in row_labels:
        fig.add_annotation(
            text=text,
            textangle=-90,
            xref="paper",
            yref="paper",
            x=0,
            y=y,
            xshift=-42,
            showarrow=False,
            xanchor="center",
            yanchor="middle",
            font=dict(family=FONT_FAMILY, size=FONT_PX),
        )

    FIGURES_DIR.mkdir(parents=True, exist_ok=True)
    smart_save_image(fig, FIGURES_DIR / f"{OUTPUT_STEM}.png", DISPLAY_CM)
    write_pdf(fig, FIGURES_DIR / f"{OUTPUT_STEM}.pdf", WIDTH_PX, DISPLAY_CM[0])
    fig.write_html(FIGURES_DIR / f"{OUTPUT_STEM}.html", auto_open=True)

    export = pd.DataFrame({"year": YEARS})
    for label, _, ae_model, em_model in SERIES:
        for economy, model in (("AE", ae_model), ("EMDE", em_model)):
            if model is None:
                continue
            for variable, outcome in (("yd", "Output"), ("by_yss", "Public debt")):
                export[f"{economy} — {label} — {outcome}"] = indexed.loc[
                    YEARS, f"{model}___{variable}"
                ].values
    export.round(3).to_csv(FIGURES_DIR / f"{OUTPUT_STEM}.csv", index=False)
    print(f"  Saved {OUTPUT_STEM}.png/.pdf/.html/.csv")


if __name__ == "__main__":
    main()
