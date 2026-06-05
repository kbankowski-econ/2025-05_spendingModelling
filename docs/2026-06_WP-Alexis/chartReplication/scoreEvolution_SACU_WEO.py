"""
Replication of Figure 1 (Public-Sector Debt and Expenditure Dynamics in SACU),
adapted to match the formatting of scoreEvolution_SACU_eff_gap_snapshot.png.

Source data:
  /Users/kk/Developer/2025-09_FM-conjunctural/data/fmData/WEO_enhanced.dta

Outputs:
  docs/2026-06_WP-Alexis/chartReplication/scoreEvolution_SACU_WEO.png
  docs/2026-06_WP-Alexis/chartReplication/scoreEvolution_SACU_WEO.csv
  docs/2026-06_WP-Alexis/chartReplication/scoreEvolution_SACU_WEO.html
  docs/2026-06_WP-Alexis/latexReplication/figures/figure_debt_dynamics.png
"""
import os
import sys
import webbrowser
import pandas as pd
import plotly.graph_objects as go
from plotly.subplots import make_subplots
from PIL import Image, ImageOps

DB_PATH = '/Users/kk/Developer/2025-09_FM-conjunctural/data/fmData/WEO_enhanced.dta'
OUT_DIR = os.path.dirname(os.path.abspath(__file__))
FIGURES_DIR = os.path.abspath(os.path.join(OUT_DIR, '../latexReplication/figures'))

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

# Peer-group reference lines (dashed/dotted), mirroring Figure 3's AE/EM/SSA averages.
REFERENCES = {
    'AEs': {'color': '#1A237E', 'dash': 'dot'},  # navy
    'EMs': {'color': '#2E7D32', 'dash': 'dot'},  # green
    'SSA': {'color': '#5D4037', 'dash': 'dash'},  # brown
}

WIDTH, HEIGHT = 600, 230
SCALE = 2
BORDER_PX = 1                 # light-blue frame thickness (px) on the final PNG
BORDER_COLOR = (100, 181, 246)  # #64B5F6


def load_data():
    df = pd.read_stata(DB_PATH)
    df['year'] = df['year'].astype(int)
    # Filter for years 2000 to 2025 (inclusive)
    df = df[(df['year'] >= 2000) & (df['year'] <= 2025)]
    return df


def build_series(df):
    series = {}
    variables = ['ggxwdg_gdp', 'ggx_gdp']
    
    for var in variables:
        d = {}
        
        # 1. AEs (median of Advanced Countries)
        ae = df[df['devClass'] == 'Advanced'].groupby('year')[var].median()
        d['AEs'] = ae
        
        # 2. EMs (median of Emerging Countries)
        em = df[df['devClass'] == 'Emerging'].groupby('year')[var].median()
        d['EMs'] = em
        
        # 3. SSA (median of Sub-Saharan African countries)
        ssa = df[df['regionShort'] == 'SSA'].groupby('year')[var].median()
        d['SSA'] = ssa
        
        # 4. SACU Countries
        for iso, name in SACU_NAMES.items():
            sub = df[df['isocode'] == iso].set_index('year')[var]
            d[name] = sub
            
        # 5. SACU Aggregate (unweighted simple average of the 5 SACU countries)
        sacu_countries = list(SACU_NAMES.keys())
        sacu_mean = df[df['isocode'].isin(sacu_countries)].groupby('year')[var].mean()
        d['SACU'] = sacu_mean
        
        series[var] = d
        
    return series


def make_figure(series):
    fig = make_subplots(rows=1, cols=2,
                        subplot_titles=('Gross Public Debt', 'Total Expenditure'),
                        shared_yaxes=False, horizontal_spacing=0.08)
    
    def add_markers(ser, color, col):
        yrs = [y for y in [2000, 2023] if y in ser.index]
        if yrs:
            fig.add_trace(go.Scatter(x=yrs, y=[ser.loc[y] for y in yrs], mode='markers',
                                     marker=dict(color=color, size=7, symbol='circle-open',
                                                 line=dict(color=color, width=1.6)),
                                     showlegend=False), row=1, col=col)

    vars_list = ['ggxwdg_gdp', 'ggx_gdp']
    for i, var in enumerate(vars_list, 1):
        # Layer 1: AE and EM (lines first, then markers)
        for ref in ['AEs', 'EMs']:
            st = REFERENCES[ref]
            r = series[var][ref].sort_index()
            rank = 2 if ref == 'AEs' else 3
            fig.add_trace(go.Scatter(x=r.index, y=r.values, mode='lines', name=ref,
                                     line=dict(color=st['color'], width=2, dash=st['dash']),
                                     legendrank=rank, showlegend=(i == 1)), row=1, col=i)
            add_markers(r, st['color'], i)

        # Layer 2: SSA (line, then markers)
        st = REFERENCES['SSA']
        r = series[var]['SSA'].sort_index()
        fig.add_trace(go.Scatter(x=r.index, y=r.values, mode='lines', name='SSA',
                                 line=dict(color=st['color'], width=2, dash=st['dash']),
                                 legendrank=4, showlegend=(i == 1)), row=1, col=i)
        add_markers(r, st['color'], i)

        # Layer 3: Single countries (each country's line, then markers)
        for rank_offset, (name, color) in enumerate(SACU_COLORS.items()):
            if name in series[var]:
                ser = series[var][name].sort_index()
                fig.add_trace(go.Scatter(x=ser.index, y=ser.values, mode='lines', name=name,
                                         line=dict(color=color, width=2),
                                         legendrank=5 + rank_offset, showlegend=(i == 1)), row=1, col=i)
                add_markers(ser, color, i)

        # Layer 4: SACU aggregate (line, then markers) at the very top
        agg = series[var]['SACU'].sort_index()
        fig.add_trace(go.Scatter(x=agg.index, y=agg.values, mode='lines', name='SACU',
                                 line=dict(color=SACU_AGG_COLOR, width=3.6),
                                 legendrank=1, showlegend=(i == 1)), row=1, col=i)
        add_markers(agg, SACU_AGG_COLOR, i)

    # General Layout
    fig.update_layout(template='simple_white', height=HEIGHT, width=WIDTH, font={'size': 10.5},
                      margin=dict(l=28, r=8, t=55, b=28),
                      legend=dict(orientation='h', yanchor='bottom', y=1.15,
                                  xanchor='center', x=0.5, font=dict(size=10.5)))
    fig.update_annotations(font_size=10.5)

    # Y-axes configurations
    # Left subplot: Gross Public Debt (% of GDP)
    fig.update_yaxes(range=[0, 120], showgrid=True, gridcolor='rgba(0,0,0,0.1)', gridwidth=0.5,
                     zeroline=True, zerolinecolor='black', zerolinewidth=1.5,
                     linecolor='black', linewidth=1.5, ticks='inside', tickfont=dict(size=10.5),
                     tickvals=[0, 20, 40, 60, 80, 100, 120], row=1, col=1)

    # Right subplot: Total Expenditure (% of GDP)
    fig.update_yaxes(range=[0, 70], showgrid=True, gridcolor='rgba(0,0,0,0.1)', gridwidth=0.5,
                     zeroline=True, zerolinecolor='black', zerolinewidth=1.5,
                     linecolor='black', linewidth=1.5, ticks='inside', tickfont=dict(size=10.5),
                     tickvals=[0, 10, 20, 30, 40, 50, 60, 70], row=1, col=2)

    # X-axes configurations
    for col in [1, 2]:
        fig.update_xaxes(showgrid=False, linecolor='black', linewidth=1.5, ticks='inside',
                         tickfont=dict(size=10.5), tickvals=[2000, 2005, 2010, 2015, 2020, 2025],
                         ticktext=['2000', '05', '10', '15', '20', '25'],
                         range=[1999, 2026], row=1, col=col)

    return fig


def save_chart(fig, series):
    # 1. Paths
    csv_path = os.path.join(OUT_DIR, 'scoreEvolution_SACU_WEO.csv')
    html_path = os.path.join(OUT_DIR, 'scoreEvolution_SACU_WEO.html')
    
    os.makedirs(FIGURES_DIR, exist_ok=True)
    dest_png_path = os.path.join(FIGURES_DIR, 'figure_debt_dynamics.png')
    
    # Write the raw image
    fig.write_image(dest_png_path, width=WIDTH, height=HEIGHT, scale=SCALE)
    
    # Bake a light-blue frame around the PNG and overwrite
    bordered = ImageOps.expand(Image.open(dest_png_path).convert('RGB'), border=BORDER_PX, fill=BORDER_COLOR)
    bordered.save(dest_png_path)
    print(f'wrote bordered PNG to {dest_png_path}')
    
    # Save CSV
    rows = []
    variables = {'ggxwdg_gdp': 'debt', 'ggx_gdp': 'spending'}
    for var, label in variables.items():
        for name, ser in series[var].items():
            for yr, val in ser.items():
                rows.append({'variable': label, 'entity': name, 'year': int(yr), 'value': round(float(val), 4)})
    pd.DataFrame(rows).to_csv(csv_path, index=False)
    print(f'wrote {csv_path}')
    
    # Save HTML
    fig.write_html(html_path)
    print(f'wrote {html_path}')
    
    # Auto-open
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
