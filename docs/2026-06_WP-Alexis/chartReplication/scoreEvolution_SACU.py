"""
Independent replication of the `scoreEvolution` task, adapted for SACU.

Source data (same as the original task):
  /Users/.../2025-05_fmEfficiencyScores/code-output/2025-04-14-efficiency-estimates/
  {INF,HLT,EDU,RND}_inefficiency-scores.csv  (cols: iso3c, year, eff_gap, ...)

Output (this folder):
  scoreEvolution_SACU_eff_gap.png  - 1x4 sector panels, eff_gap over time
  scoreEvolution_SACU_eff_gap.csv  - the underlying series (independent extract)

Ported from:
  /Users/kk/Developer/2025-09_FM-conjunctural/pyScripts/2026-05_MRP-Latam-Caribbean/scoreEvolution.py
Self-contained: hardcodes the 5 SACU countries; no countryTable/chartTable deps.
"""
import os
import sys
import webbrowser
import pandas as pd
import plotly.graph_objects as go
from plotly.subplots import make_subplots
from PIL import Image, ImageOps

DATA_DIR = '/Users/kk/Documents/0000-00_work/2025-05_fmEfficiencyScores/code-output/2025-04-14-efficiency-estimates'
OUT_DIR = os.path.dirname(os.path.abspath(__file__))

SECTORS = ['INF', 'HLT', 'EDU', 'RND']
SECTOR_TITLES = {'INF': 'Infrastructure', 'HLT': 'Health', 'EDU': 'Education', 'RND': 'R&D'}

# 5 SACU countries, in the paper's order.
SACU = {'BWA': 'Botswana', 'SWZ': 'Eswatini', 'LSO': 'Lesotho', 'NAM': 'Namibia', 'ZAF': 'South Africa'}
SACU_COLORS = {
    'Botswana': '#00838F',      # teal
    'Eswatini': '#1E88E5',      # blue
    'Lesotho': '#6A1B9A',       # purple
    'Namibia': '#E65100',       # deep orange
    'South Africa': '#C2185B',  # crimson
}
SACU_AGG_COLOR = '#424242'  # SACU aggregate: thick solid dark-grey headline line
# Peer-group reference lines (dashed/dotted), mirroring Figure 3's AE/EM/SSA averages.
# SSA uses the IMF African Department (includes the SACU members themselves).
REFERENCES = {
    'AEs': {'color': '#1A237E', 'dash': 'dot'},  # navy
    'EMs': {'color': '#2E7D32', 'dash': 'dot'},  # green
    'SSA': {'color': '#5D4037', 'dash': 'dot'},  # brown
}

YEAR_MIN, YEAR_MAX = 1980, 2024  # source extends to 2029 (likely projections); cap as in original
XAXIS_MAX = 2025                 # axis extends a year past the data so 2023 circles aren't clipped
MARKER_YEARS = [2000, 2023]      # circle markers at Figure 3's two snapshot years

# Authored 1:1 for a 16 cm-wide figure: layout ~600 px = 16 cm at 96 dpi, so at
# scale=2 the PNG is ~190 dpi and the fonts render at their intended size in the
# document (no 2x downscale). Fonts are absolute px, so the smaller canvas makes
# them proportionally larger than the old 1280 px authoring.
WIDTH, HEIGHT = 600, 230
SCALE = 2
BORDER_PX = 1                 # light-blue frame thickness (px) on the final PNG
BORDER_COLOR = (100, 181, 246)  # #64B5F6


def load(measure):
    out = {}
    for s in SECTORS:
        df = pd.read_csv(f'{DATA_DIR}/{s}_inefficiency-scores.csv',
                         usecols=['iso3c', 'year', measure, 'income', 'department'])
        df = df[(df.year >= YEAR_MIN) & (df.year <= YEAR_MAX)]
        out[s] = df
    return out


def build_series(data, measure):
    """Return {sector: {'Global': series, country: series}} of year->value."""
    series = {}
    for s in SECTORS:
        df = data[s]
        d = {
            'AEs': df[df.income == 'AE'].groupby('year')[measure].mean(),
            'EMs': df[df.income == 'EM'].groupby('year')[measure].mean(),
            'SSA': df[df.department == 'AFR'].groupby('year')[measure].mean(),
        }
        for iso, name in SACU.items():
            sub = df[df.iso3c == iso].set_index('year')[measure]
            if len(sub):
                d[name] = sub
        d['SACU'] = df[df.iso3c.isin(SACU)].groupby('year')[measure].mean()  # 5-country mean
        series[s] = d
    return series


def make_figure(series, measure):
    fig = make_subplots(rows=1, cols=4,
                        subplot_titles=tuple(SECTOR_TITLES[s] for s in SECTORS),
                        shared_yaxes=True, horizontal_spacing=0.03)
    def add_markers(ser, color, col):
        yrs = [y for y in MARKER_YEARS if y in ser.index]
        if yrs:
            fig.add_trace(go.Scatter(x=yrs, y=[ser.loc[y] for y in yrs], mode='markers',
                                     marker=dict(color=color, size=7, symbol='circle-open',
                                                 line=dict(color=color, width=1.6)),
                                     showlegend=False), row=1, col=col)

    for i, s in enumerate(SECTORS, 1):
        # Peer-group reference lines (dashed/dotted) first, so country lines sit on top.
        for ref, st in REFERENCES.items():
            r = series[s][ref].sort_index()
            fig.add_trace(go.Scatter(x=r.index, y=r.values, mode='lines', name=ref,
                                     line=dict(color=st['color'], width=2, dash=st['dash']),
                                     showlegend=(i == 1)), row=1, col=i)
            add_markers(r, st['color'], i)
        for name, color in SACU_COLORS.items():
            if name in series[s]:
                ser = series[s][name].sort_index()
                fig.add_trace(go.Scatter(x=ser.index, y=ser.values, mode='lines', name=name,
                                         line=dict(color=color, width=2),
                                         showlegend=(i == 1)), row=1, col=i)
                add_markers(ser, color, i)
        # SACU aggregate: thick solid line on top, first in the legend (headline series).
        agg = series[s]['SACU'].sort_index()
        fig.add_trace(go.Scatter(x=agg.index, y=agg.values, mode='lines', name='SACU',
                                 line=dict(color=SACU_AGG_COLOR, width=3.6),
                                 legendrank=1, showlegend=(i == 1)), row=1, col=i)
        add_markers(agg, SACU_AGG_COLOR, i)

    fig.update_layout(template='simple_white', height=HEIGHT, width=WIDTH, font={'size': 10.5},
                      margin=dict(l=38, r=10, t=78, b=34),
                      legend=dict(orientation='h', yanchor='bottom', y=1.18,
                                  xanchor='center', x=0.5, font=dict(size=10.5)))
    fig.update_annotations(font_size=10.5)  # subplot titles, matched to the ~8 pt ticks
    for i in range(1, 5):
        fig.update_yaxes(range=[0, 1], showgrid=True, gridcolor='rgba(0,0,0,0.1)', gridwidth=0.5,
                         zeroline=True, zerolinecolor='black', zerolinewidth=1.5,
                         linecolor='black', linewidth=1.5, ticks='inside', tickfont=dict(size=10.5),
                         row=1, col=i)
        fig.update_xaxes(showgrid=False, linecolor='black', linewidth=1.5, ticks='inside',
                         tickfont=dict(size=10.5), tickvals=[1980, 2000, 2020], ticktext=['1980', '00', '20'],
                         range=[YEAR_MIN, XAXIS_MAX], row=1, col=i)
    return fig


def save(fig, series, measure):
    base = os.path.join(OUT_DIR, f'scoreEvolution_SACU_{measure}')
    png = base + '.png'
    # Use fig.write_image (not the legacy PlotlyScope API, which drops traces under plotly 6.x).
    fig.write_image(png, width=WIDTH, height=HEIGHT, scale=SCALE)
    # Bake a light-blue frame around the whole PNG.
    bordered = ImageOps.expand(Image.open(png).convert('RGB'), border=BORDER_PX, fill=BORDER_COLOR)
    bordered.save(png)
    rows = []
    for s in SECTORS:
        for name, ser in series[s].items():
            for yr, val in ser.items():
                rows.append({'sector': s, 'entity': name, 'year': int(yr), measure: round(float(val), 4)})
    pd.DataFrame(rows).to_csv(base + '.csv', index=False)
    html = base + '.html'
    fig.write_html(html)
    print(f'wrote {png}')
    print(f'wrote {base}.csv ({len(rows)} rows)')
    print(f'wrote {html}')
    webbrowser.open(f'file://{os.path.abspath(html)}')  # auto-open the interactive chart


def main():
    measure = sys.argv[1] if len(sys.argv) > 1 else 'eff_gap'
    data = load(measure)
    series = build_series(data, measure)
    fig = make_figure(series, measure)
    save(fig, series, measure)


if __name__ == '__main__':
    main()
