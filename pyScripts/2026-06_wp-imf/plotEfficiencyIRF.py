"""Shared IRF charts for spending-efficiency experiments."""

from math import log1p
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
INPUT_CSV = PROJECT_ROOT / "docs" / "csvFiles" / "figureNumbers.csv"
FIGURES_DIR = PROJECT_ROOT / "docs" / "2026-06_wp-imf" / "figures"

STYLE = {
    "template": "simple_white",
    "margins": {"t": 86, "b": 22, "l": 54, "r": 12},
    "legend": {"orientation": "h", "xanchor": "center", "x": 0.5},
    "axes": {
        "linecolor": "black",
        "linewidth": 1.5,
        "ticks": "inside",
        "showgrid": True,
        "gridcolor": "rgba(0,0,0,0.15)",
        "gridwidth": 0.5,
        "zeroline": True,
        "zerolinewidth": 1.5,
    },
    "line_width": 2.5,
}

PANELS = [
    ("yd", "Output (Y<sup>d</sup><sub>t</sub>)"),
    ("C", "Consumption (C<sub>t</sub>)"),
    ("Ip", "Private investment (I<sub>t</sub>)"),
    ("G", "Government spending (G<sub>t</sub>)"),
    ("A", "Adopted technology (A<sub>t</sub>)"),
    ("Kg", "Public infrastructure (K<sup>GI</sup><sub>t</sub>)"),
    ("Kge", "Educ./hlt capital (K<sup>GE</sup><sub>t</sub>)"),
    ("Kp", "Private capital (K<sub>t</sub>)"),
    ("L", "Labor supply (L<sub>t</sub>)"),
    ("H", "Human capital stock (H<sub>t</sub>)"),
    ("N", "Effective labor (N<sub>t</sub>)"),
    ("E", "Education time (E<sub>t</sub>)"),
    ("mc", "Real marginal cost (mc<sub>t</sub>)"),
    ("PI_ann", "Inflation (Π<sub>t</sub>)"),
    ("R_ann", "Nominal interest rate (R<sub>t</sub>)"),
    ("rreal_ann", "Real interest rate (R<sub>t</sub>/Π<sub>t</sub>)"),
    ("pdef_yss", "Primary deficit"),
    ("T_yss", "Transfers (T<sub>t</sub>)"),
    ("by_yss", "Debt-to-GDP ratio (b<sub>t</sub>)"),
    None,
]

COMPARISON_ROWS = [
    ("yd", "Output (Y<sup>d</sup><sub>t</sub>)"),
    ("C", "Consumption (C<sub>t</sub>)"),
    ("pdef_yss", "Prim. def. (PD<sub>t</sub>)"),
    ("by_yss", "Public debt (b<sub>t</sub>)"),
]

NCOLS = 4
NROWS = 5
BLOCKS = ["Demand", "Prod. stocks", "Labor", "Prices & rates", "Fiscal"]

PLOT_HORIZON_QUARTERS = 100
IMPACT_QUARTER = 1
X_TICK_HORIZONS = [1, 10, 25]
X_TICKS = [log1p(IMPACT_QUARTER)] + [log1p(4 * h) for h in X_TICK_HORIZONS]
X_TICK_LABELS = ["1q"] + [f"{h}y" for h in X_TICK_HORIZONS]
X_AXIS_MIN = log1p(IMPACT_QUARTER)
X_AXIS_MAX = log1p(PLOT_HORIZON_QUARTERS)
X_AXIS_PAD = 0.02 * (X_AXIS_MAX - X_AXIS_MIN)

FONT_FAMILY = "Palatino, 'Palatino Linotype', 'Book Antiqua', serif"


def load_data():
    df = pd.read_csv(INPUT_CSV)
    df = df.rename(columns={df.columns[0]: "date"})
    date_parts = (
        df["date"].astype(str)
        .str.extract(r"(?P<year>\d{4})Q(?P<quarter>[1-4])")
        .astype(int)
    )
    period = 4 * date_parts["year"] + date_parts["quarter"]
    df["horizon_quarter"] = period - period.iloc[0]
    df = df.sort_values("horizon_quarter")
    return df[df["horizon_quarter"].between(IMPACT_QUARTER, PLOT_HORIZON_QUARTERS)]


def plot_efficiency_irfs(scenarios, output_stem):
    """Render efficiency-gap closures and optional comparators on the IRF grid."""
    scenarios = [
        (*scenario, "solid") if len(scenario) == 3 else scenario
        for scenario in scenarios
    ]
    width_px, height_px = chart_render_px(output_stem, (15.0, 18.75))
    display_cm = chart_display_cm(output_stem, (15.0, 18.75))
    font_px = font_px_for_pt(7, width_px, display_cm[0])
    legend_font_px = font_px_for_pt(8, width_px, display_cm[0])
    title_font_px = font_px_for_pt(8, width_px, display_cm[0])
    block_font_px = font_px_for_pt(10, width_px, display_cm[0])

    df = load_data()
    quarters = df["horizon_quarter"].values
    horizon_positions = [log1p(quarter) for quarter in quarters]
    impact_values = df.set_index("horizon_quarter").loc[IMPACT_QUARTER]

    fig = make_subplots(
        rows=NROWS,
        cols=NCOLS,
        subplot_titles=[panel[1] if panel else "" for panel in PANELS],
        horizontal_spacing=0.06,
        vertical_spacing=0.075,
    )

    for idx, panel in enumerate(PANELS):
        row, col = idx // NCOLS + 1, idx % NCOLS + 1
        if panel is None:
            fig.update_xaxes(visible=False, row=row, col=col)
            fig.update_yaxes(visible=False, row=row, col=col)
            continue

        var = panel[0]
        panel_min = panel_max = None
        for model, label, color, dash in scenarios:
            colname = f"{model}___{var}"
            if colname not in df.columns:
                raise KeyError(f"Missing exported series: {colname}")
            values = df[colname].values
            series_min, series_max = values.min(), values.max()
            panel_min = series_min if panel_min is None else min(panel_min, series_min)
            panel_max = series_max if panel_max is None else max(panel_max, series_max)
            fig.add_trace(
                go.Scatter(
                    x=horizon_positions,
                    y=values,
                    name=label,
                    legendgroup=label,
                    line=dict(color=color, width=STYLE["line_width"], dash=dash),
                    showlegend=(idx == 0),
                    customdata=quarters,
                    hovertemplate=(
                        f"{label}<br>Quarter: %{{customdata}}"
                        "<br>Response: %{y:.3f}<extra></extra>"
                    ),
                ),
                row=row,
                col=col,
            )
        if (
            panel_min is not None
            and (panel_min != 0 or panel_max != 0)
            and (panel_min >= 0 or panel_max <= 0)
        ):
            fig.update_yaxes(rangemode="tozero", row=row, col=col)

        for model, label, color, dash in scenarios:
            colname = f"{model}___{var}"
            fig.add_trace(
                go.Scatter(
                    x=[log1p(IMPACT_QUARTER)],
                    y=[impact_values[colname]],
                    name=label,
                    legendgroup=label,
                    mode="markers",
                    marker=dict(
                        symbol="circle",
                        size=6,
                        color=color,
                        line=dict(color="white", width=0.75),
                    ),
                    showlegend=False,
                    hovertemplate=f"{label}<br>Q1: %{{y:.3f}}<extra></extra>",
                ),
                row=row,
                col=col,
            )

    for annotation in fig["layout"]["annotations"]:
        annotation["font"] = dict(family=FONT_FAMILY, size=title_font_px)

    for row, block in enumerate(BLOCKS, start=1):
        panel_idx = (row - 1) * NCOLS + 1
        axis_name = "yaxis" + ("" if panel_idx == 1 else str(panel_idx))
        y0, y1 = fig.layout[axis_name].domain
        fig.add_annotation(
            text=block.upper(),
            textangle=-90,
            xref="paper",
            yref="paper",
            x=0,
            y=(y0 + y1) / 2,
            xshift=-40,
            showarrow=False,
            xanchor="center",
            yanchor="middle",
            font=dict(family=FONT_FAMILY, size=block_font_px, color="#424242"),
            bgcolor="#E6E6E6",
            borderpad=2,
        )

    fig.update_layout(
        template=STYLE["template"],
        width=width_px,
        height=height_px,
        margin={
            **STYLE["margins"],
            "t": 112 if len(scenarios) > 3 else STYLE["margins"]["t"],
        },
        font=dict(family=FONT_FAMILY, size=font_px),
        legend=dict(
            orientation=STYLE["legend"]["orientation"],
            yref="container",
            yanchor="top",
            y=0.99,
            xanchor=STYLE["legend"]["xanchor"],
            x=STYLE["legend"]["x"],
            font=dict(size=legend_font_px),
            tracegroupgap=2,
            entrywidth=0.32 if len(scenarios) > 3 else 0,
            entrywidthmode="fraction" if len(scenarios) > 3 else "pixels",
        ),
    )

    axes = STYLE["axes"]
    fig.update_xaxes(
        tickvals=X_TICKS,
        ticktext=X_TICK_LABELS,
        range=[X_AXIS_MIN - X_AXIS_PAD, X_AXIS_MAX],
        showgrid=False,
        linecolor=axes["linecolor"],
        linewidth=axes["linewidth"],
        ticks=axes["ticks"],
        tickfont=dict(size=font_px),
    )
    fig.update_yaxes(
        showgrid=axes["showgrid"],
        gridcolor=axes["gridcolor"],
        gridwidth=axes["gridwidth"],
        zeroline=axes["zeroline"],
        zerolinewidth=axes["zerolinewidth"],
        zerolinecolor="black",
        linecolor=axes["linecolor"],
        linewidth=axes["linewidth"],
        ticks=axes["ticks"],
        tickfont=dict(size=font_px),
    )

    FIGURES_DIR.mkdir(parents=True, exist_ok=True)
    png_path = FIGURES_DIR / f"{output_stem}.png"
    pdf_path = FIGURES_DIR / f"{output_stem}.pdf"
    html_path = FIGURES_DIR / f"{output_stem}.html"
    smart_save_image(fig, png_path, display_cm)
    write_pdf(fig, pdf_path, width_px, display_cm[0])
    fig.write_html(html_path, auto_open=True)
    print(f"  Saved {png_path.name}, {pdf_path.name} and {html_path.name}")

    records = []
    for var, title in (panel for panel in PANELS if panel is not None):
        for model, label, _, _ in scenarios:
            colname = f"{model}___{var}"
            for quarter, value in zip(quarters, df[colname].values):
                records.append(
                    {
                        "horizon_quarter": quarter,
                        "scenario": label,
                        "variable": title,
                        "pct_dev": round(value, 3),
                    }
                )
    csv_path = FIGURES_DIR / f"{output_stem}.csv"
    pd.DataFrame(records).to_csv(csv_path, index=False)
    print(f"  Exported data to {csv_path.name}")


def plot_efficiency_comparison(instruments, output_stem):
    """Render matched efficiency and spending experiments by instrument."""
    width_px, height_px = chart_render_px(output_stem, (15.0, 13.0))
    display_cm = chart_display_cm(output_stem, (15.0, 13.0))
    font_px = font_px_for_pt(7.5, width_px, display_cm[0])
    legend_font_px = font_px_for_pt(8, width_px, display_cm[0])
    title_font_px = font_px_for_pt(9, width_px, display_cm[0])
    row_font_px = font_px_for_pt(9, width_px, display_cm[0])

    df = load_data()
    quarters = df["horizon_quarter"].values
    horizon_positions = [log1p(quarter) for quarter in quarters]
    impact_values = df.set_index("horizon_quarter").loc[IMPACT_QUARTER]

    nrows = len(COMPARISON_ROWS)
    ncols = len(instruments)
    subplot_titles = [instrument[0] for instrument in instruments]
    subplot_titles.extend([""] * (nrows * ncols - ncols))
    fig = make_subplots(
        rows=nrows,
        cols=ncols,
        subplot_titles=subplot_titles,
        shared_yaxes="rows",
        horizontal_spacing=0.10,
        vertical_spacing=0.10,
    )

    for col, (instrument, color, efficiency_model, spending_model) in enumerate(
        instruments, start=1
    ):
        treatments = [
            (efficiency_model, "Efficiency improvement", "solid"),
            (spending_model, "Spending increase", "dot"),
        ]
        for row, (variable, _row_label) in enumerate(COMPARISON_ROWS, start=1):
            for model, treatment, dash in treatments:
                colname = f"{model}___{variable}"
                if colname not in df.columns:
                    raise KeyError(f"Missing exported series: {colname}")
                values = df[colname].values
                fig.add_trace(
                    go.Scatter(
                        x=horizon_positions,
                        y=values,
                        name=treatment,
                        legendgroup=treatment,
                        line=dict(color=color, width=STYLE["line_width"], dash=dash),
                        showlegend=False,
                        customdata=quarters,
                        hovertemplate=(
                            f"{instrument}: {treatment}<br>Quarter: %{{customdata}}"
                            "<br>Response: %{y:.3f}<extra></extra>"
                        ),
                    ),
                    row=row,
                    col=col,
                )
                fig.add_trace(
                    go.Scatter(
                        x=[log1p(IMPACT_QUARTER)],
                        y=[impact_values[colname]],
                        name=treatment,
                        legendgroup=treatment,
                        mode="markers",
                        marker=dict(
                            symbol="circle",
                            size=6,
                            color=color,
                            line=dict(color="white", width=0.75),
                        ),
                        showlegend=False,
                        hovertemplate=(
                            f"{instrument}: {treatment}<br>Q1: %{{y:.3f}}<extra></extra>"
                        ),
                    ),
                    row=row,
                    col=col,
                )

    # Neutral legend keys make clear that line style, rather than column color,
    # identifies the two matched treatments.
    for treatment, dash in (("Efficiency improvement", "solid"),
                            ("Spending increase", "dot")):
        fig.add_trace(
            go.Scatter(
                x=[None],
                y=[None],
                name=treatment,
                legendgroup=treatment,
                mode="lines",
                line=dict(color="#424242", width=STYLE["line_width"], dash=dash),
                showlegend=True,
                hoverinfo="skip",
            ),
            row=1,
            col=1,
        )

    # Comparisons across instruments use the same vertical scale within each row.
    for row, (variable, _row_label) in enumerate(COMPARISON_ROWS, start=1):
        row_values = []
        for _instrument, _color, efficiency_model, spending_model in instruments:
            row_values.extend(df[f"{efficiency_model}___{variable}"].tolist())
            row_values.extend(df[f"{spending_model}___{variable}"].tolist())
        row_min = min(0, min(row_values))
        row_max = max(0, max(row_values))
        span = row_max - row_min
        pad = 0.06 * span if span else 0.1
        for col in range(1, ncols + 1):
            fig.update_yaxes(range=[row_min - pad, row_max + pad], row=row, col=col)

    for annotation in fig["layout"]["annotations"]:
        annotation["font"] = dict(family=FONT_FAMILY, size=title_font_px)

    for row, (_variable, row_label) in enumerate(COMPARISON_ROWS, start=1):
        panel_idx = (row - 1) * ncols + 1
        axis_name = "yaxis" + ("" if panel_idx == 1 else str(panel_idx))
        y0, y1 = fig.layout[axis_name].domain
        fig.add_annotation(
            text=row_label,
            textangle=-90,
            xref="paper",
            yref="paper",
            x=0,
            y=(y0 + y1) / 2,
            xshift=-42,
            showarrow=False,
            xanchor="center",
            yanchor="middle",
            font=dict(family=FONT_FAMILY, size=row_font_px, color="#424242"),
        )

    fig.update_layout(
        template=STYLE["template"],
        width=width_px,
        height=height_px,
        margin={"t": 80, "b": 22, "l": 58, "r": 12},
        font=dict(family=FONT_FAMILY, size=font_px),
        legend=dict(
            orientation="h",
            yref="container",
            yanchor="top",
            y=0.99,
            xanchor="center",
            x=0.5,
            font=dict(size=legend_font_px),
        ),
    )

    axes = STYLE["axes"]
    fig.update_xaxes(
        tickvals=X_TICKS,
        ticktext=X_TICK_LABELS,
        range=[X_AXIS_MIN - X_AXIS_PAD, X_AXIS_MAX],
        showgrid=False,
        linecolor=axes["linecolor"],
        linewidth=axes["linewidth"],
        ticks=axes["ticks"],
        tickfont=dict(size=font_px),
    )
    fig.update_yaxes(
        showgrid=axes["showgrid"],
        gridcolor=axes["gridcolor"],
        gridwidth=axes["gridwidth"],
        zeroline=axes["zeroline"],
        zerolinewidth=axes["zerolinewidth"],
        zerolinecolor="black",
        linecolor=axes["linecolor"],
        linewidth=axes["linewidth"],
        ticks=axes["ticks"],
        tickfont=dict(size=font_px),
    )

    FIGURES_DIR.mkdir(parents=True, exist_ok=True)
    png_path = FIGURES_DIR / f"{output_stem}.png"
    pdf_path = FIGURES_DIR / f"{output_stem}.pdf"
    html_path = FIGURES_DIR / f"{output_stem}.html"
    smart_save_image(fig, png_path, display_cm)
    write_pdf(fig, pdf_path, width_px, display_cm[0])
    fig.write_html(html_path, auto_open=True)
    print(f"  Saved {png_path.name}, {pdf_path.name} and {html_path.name}")

    records = []
    for variable, row_label in COMPARISON_ROWS:
        for instrument, _color, efficiency_model, spending_model in instruments:
            for treatment, model in (("Efficiency improvement", efficiency_model),
                                     ("Spending increase", spending_model)):
                colname = f"{model}___{variable}"
                for quarter, value in zip(quarters, df[colname].values):
                    records.append(
                        {
                            "horizon_quarter": quarter,
                            "instrument": instrument,
                            "treatment": treatment,
                            "variable": row_label,
                            "response": round(value, 3),
                        }
                    )
    csv_path = FIGURES_DIR / f"{output_stem}.csv"
    pd.DataFrame(records).to_csv(csv_path, index=False)
    print(f"  Exported data to {csv_path.name}")
