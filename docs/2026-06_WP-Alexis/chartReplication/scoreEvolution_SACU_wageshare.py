"""
Wage bill as a share of total expenditure in SACU, styled like Figure 1
(scoreEvolution_SACU_WEO.py).

Source data:
  /Users/kk/Developer/2025-09_FM-conjunctural/data/fmData/IMF-FAD-Gov-Comp-and-Empl-Dataset.xlsx
  (sheet 'raw', variable WB_harmonized_x = wage bill as % of total expenditure)

Outputs:
  docs/2026-06_WP-Alexis/chartReplication/scoreEvolution_SACU_wageshare.png
  docs/2026-06_WP-Alexis/chartReplication/scoreEvolution_SACU_wageshare.csv
  docs/2026-06_WP-Alexis/chartReplication/scoreEvolution_SACU_wageshare.html
  docs/2026-06_WP-Alexis/latexReplication/figures/figure_wage_share.png
"""
import os
import webbrowser
import pandas as pd
import plotly.graph_objects as go
from PIL import Image, ImageOps

DB_PATH = '/Users/kk/Developer/2025-09_FM-conjunctural/data/fmData/IMF-FAD-Gov-Comp-and-Empl-Dataset.xlsx'
VAR = 'WB_harmonized_x'  # wage bill as % of total expenditure
OUT_DIR = os.path.dirname(os.path.abspath(__file__))
FIGURES_DIR = os.path.abspath(os.path.join(OUT_DIR, '../latexReplication/figures'))

YEAR_MIN, YEAR_MAX = 2000, 2022
MARKER_YEARS = [2000, 2022]

# 5 SACU countries
SACU_NAMES = {
    'BWA': 'Botswana',
    'SWZ': 'Eswatini',
    'LSO': 'Lesotho',
    'NAM': 'Namibia',
    'ZAF': 'South Africa',
}
SACU_COLORS = {
    'Botswana': '#00838F',      # teal
    'Eswatini': '#1E88E5',      # blue
    'Lesotho': '#6A1B9A',       # purple
    'Namibia': '#E65100',       # deep orange
    'South Africa': '#C2185B',  # crimson
}
SACU_AGG_COLOR = '#424242'  # SACU aggregate: thick solid dark-grey headline line

# Peer-group reference lines (dashed/dotted), mirroring Figure 1.
REFERENCES = {
    'AEs': {'color': '#1A237E', 'dash': 'dot'},  # navy
    'EMs': {'color': '#2E7D32', 'dash': 'dot'},  # green
    'SSA': {'color': '#5D4037', 'dash': 'dash'},  # brown
}

WIDTH, HEIGHT = 600, 250
SCALE = 2
BORDER_PX = 1                 # light-blue frame thickness (px) on the final PNG
BORDER_COLOR = (100, 181, 246)  # #64B5F6


def load_data():
    df = pd.read_excel(DB_PATH, sheet_name='raw')
    df['year'] = df['year'].astype(int)
    df = df[(df['year'] >= YEAR_MIN) & (df['year'] <= YEAR_MAX)]
    return df


def build_series(df):
    d = {}

    # 1. AEs (median of Advanced Economies)
    d['AEs'] = df[df['income'] == 'Advanced Economies'].groupby('year')[VAR].median()

    # 2. EMs (median of Emerging Market Economies)
    d['EMs'] = df[df['income'] == 'Emerging Market Economies'].groupby('year')[VAR].median()

    # 3. SSA (median of Sub-Saharan African countries)
    d['SSA'] = df[df['region'] == 'Sub-Sahara Africa'].groupby('year')[VAR].median()

    # 4. SACU countries
    for iso, name in SACU_NAMES.items():
        d[name] = df[df['isocode'] == iso].set_index('year')[VAR]

    # 5. SACU aggregate (unweighted simple average of the 5 SACU countries)
    d['SACU'] = df[df['isocode'].isin(SACU_NAMES.keys())].groupby('year')[VAR].mean()

    return d


def make_figure(series):
    fig = go.Figure()

    def add_markers(ser, color):
        yrs = [y for y in MARKER_YEARS if y in ser.index]
        if yrs:
            fig.add_trace(go.Scatter(x=yrs, y=[ser.loc[y] for y in yrs], mode='markers',
                                     marker=dict(color=color, size=7, symbol='circle-open',
                                                 line=dict(color=color, width=1.6)),
                                     showlegend=False))

    # Layer 1: AE and EM (lines first, then markers)
    for ref in ['AEs', 'EMs']:
        st = REFERENCES[ref]
        r = series[ref].sort_index()
        rank = 2 if ref == 'AEs' else 3
        fig.add_trace(go.Scatter(x=r.index, y=r.values, mode='lines', name=ref,
                                 line=dict(color=st['color'], width=2, dash=st['dash']),
                                 legendrank=rank))
        add_markers(r, st['color'])

    # Layer 2: SSA (line, then markers)
    st = REFERENCES['SSA']
    r = series['SSA'].sort_index()
    fig.add_trace(go.Scatter(x=r.index, y=r.values, mode='lines', name='SSA',
                             line=dict(color=st['color'], width=2, dash=st['dash']),
                             legendrank=4))
    add_markers(r, st['color'])

    # Layer 3: Single countries (each country's line, then markers)
    for rank_offset, (name, color) in enumerate(SACU_COLORS.items()):
        ser = series[name].sort_index()
        fig.add_trace(go.Scatter(x=ser.index, y=ser.values, mode='lines', name=name,
                                 line=dict(color=color, width=2),
                                 legendrank=5 + rank_offset))
        add_markers(ser, color)

    # Layer 4: SACU aggregate (line, then markers) at the very top
    agg = series['SACU'].sort_index()
    fig.add_trace(go.Scatter(x=agg.index, y=agg.values, mode='lines', name='SACU',
                             line=dict(color=SACU_AGG_COLOR, width=3.6),
                             legendrank=1))
    add_markers(agg, SACU_AGG_COLOR)

    # General Layout
    fig.update_layout(template='simple_white', height=HEIGHT, width=WIDTH, font={'size': 10.5},
                      margin=dict(l=30, r=8, t=58, b=28),
                      legend=dict(orientation='h', yanchor='bottom', y=1.16,
                                  xanchor='center', x=0.5, font=dict(size=10.5)))
    # Subplot-style title sitting just above the plot area, below the legend
    fig.add_annotation(text='Wage Bill (% of Total Expenditure)', xref='paper', yref='paper',
                       x=0.5, y=1.0, xanchor='center', yanchor='bottom', showarrow=False,
                       font=dict(size=10.5))

    fig.update_yaxes(range=[20, 55], showgrid=True, gridcolor='rgba(0,0,0,0.1)', gridwidth=0.5,
                     linecolor='black', linewidth=1.5, ticks='inside', tickfont=dict(size=10.5),
                     tickvals=[20, 25, 30, 35, 40, 45, 50, 55])

    fig.update_xaxes(showgrid=False, linecolor='black', linewidth=1.5, ticks='inside',
                     tickfont=dict(size=10.5), tickvals=[2000, 2005, 2010, 2015, 2020],
                     ticktext=['2000', '05', '10', '15', '20'],
                     range=[1999, 2023])

    return fig


def save_chart(fig, series):
    csv_path = os.path.join(OUT_DIR, 'scoreEvolution_SACU_wageshare.csv')
    html_path = os.path.join(OUT_DIR, 'scoreEvolution_SACU_wageshare.html')

    os.makedirs(FIGURES_DIR, exist_ok=True)
    dest_png_path = os.path.join(FIGURES_DIR, 'figure_wage_share.png')

    # Write the raw image
    fig.write_image(dest_png_path, width=WIDTH, height=HEIGHT, scale=SCALE)

    # Bake a light-blue frame around the PNG and overwrite
    bordered = ImageOps.expand(Image.open(dest_png_path).convert('RGB'), border=BORDER_PX, fill=BORDER_COLOR)
    bordered.save(dest_png_path)
    print(f'wrote bordered PNG to {dest_png_path}')

    # Save CSV
    rows = []
    for name, ser in series.items():
        for yr, val in ser.items():
            if pd.notna(val):
                rows.append({'entity': name, 'year': int(yr), 'value': round(float(val), 4)})
    pd.DataFrame(rows).to_csv(csv_path, index=False)
    print(f'wrote {csv_path}')

    # Save HTML
    fig.write_html(html_path)
    print(f'wrote {html_path}')

    try:
        webbrowser.open(f'file://{os.path.abspath(html_path)}')
    except Exception:
        pass


def main():
    df = load_data()
    series = build_series(df)
    fig = make_figure(series)
    save_chart(fig, series)


if __name__ == '__main__':
    main()
