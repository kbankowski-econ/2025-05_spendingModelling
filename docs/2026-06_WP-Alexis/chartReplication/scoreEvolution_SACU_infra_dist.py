import os
import pandas as pd
import plotly.graph_objects as go
from PIL import Image, ImageOps

DATA_DIR = '/Users/kk/Documents/0000-00_work/2025-05_fmEfficiencyScores/code-output/2025-04-14-efficiency-estimates'
OUT_DIR = os.path.dirname(os.path.abspath(__file__))

# 5 SACU countries
SACU = {'BWA': 'Botswana', 'SWZ': 'Eswatini', 'LSO': 'Lesotho', 'NAM': 'Namibia', 'ZAF': 'South Africa'}
SACU_HIGHLIGHT_COLOR = '#1E88E5' # Blue
OTHER_COLOR = '#BDBDBD'         # Light grey

WIDTH, HEIGHT = 600, 230
SCALE = 2
BORDER_PX = 1
BORDER_COLOR = (100, 181, 246)  # #64B5F6

def main():
    # Load Infrastructure efficiency score data
    df = pd.read_csv(f'{DATA_DIR}/INF_inefficiency-scores.csv',
                     usecols=['iso3c', 'country', 'year', 'eff_gap'])
    
    # Filter for 2023 and drop NaNs
    df_2023 = df[df.year == 2023].dropna(subset=['eff_gap'])
    
    # Sort descending by eff_gap
    df_2023 = df_2023.sort_values('eff_gap', ascending=False).reset_index(drop=True)
    
    # Build colors list
    colors = []
    for iso in df_2023['iso3c']:
        if iso in SACU:
            colors.append(SACU_HIGHLIGHT_COLOR)
        else:
            colors.append(OTHER_COLOR)
            
    fig = go.Figure()
    
    # Main bar trace
    fig.add_trace(go.Bar(
        x=df_2023['country'],
        y=df_2023['eff_gap'],
        marker_color=colors,
        marker_line_width=0,
        showlegend=False
    ))
    
    # Dummy traces for the legend
    fig.add_trace(go.Bar(x=[None], y=[None], name='SACU', marker_color=SACU_HIGHLIGHT_COLOR))
    fig.add_trace(go.Bar(x=[None], y=[None], name='Other', marker_color=OTHER_COLOR))
    
    fig.update_layout(
        template='simple_white',
        height=HEIGHT,
        width=WIDTH,
        font={'size': 10.5},
        margin=dict(l=28, r=8, t=15, b=45),
        legend=dict(
            orientation='h',
            yanchor='bottom',
            y=1.02,
            xanchor='right',
            x=1.0,
            font=dict(size=10.5)
        )
    )
    
    # Set y-axis properties
    fig.update_yaxes(
        range=[0.15, 0.70],
        showgrid=True,
        gridcolor='rgba(0,0,0,0.1)',
        gridwidth=0.5,
        zeroline=True,
        zerolinecolor='black',
        zerolinewidth=1.5,
        linecolor='black',
        linewidth=1.5,
        ticks='inside',
        tickfont=dict(size=10.5),
        tickvals=[0.2, 0.3, 0.4, 0.5, 0.6, 0.7]
    )
    
    # Set x-axis properties (only show SACU labels)
    sacu_countries = [SACU[iso] for iso in ['NAM', 'LSO', 'SWZ', 'BWA', 'ZAF']]
    fig.update_xaxes(
        showgrid=False,
        linecolor='black',
        linewidth=1.5,
        ticks='inside',
        tickfont=dict(size=10.5),
        tickvals=sacu_countries,
        ticktext=sacu_countries,
        tickangle=45
    )
    
    # Save the output files
    base = os.path.join(OUT_DIR, 'scoreEvolution_SACU_infra_dist')
    png = base + '.png'
    
    fig.write_image(png, width=WIDTH, height=HEIGHT, scale=SCALE)
    
    # Add border frame
    bordered = ImageOps.expand(Image.open(png).convert('RGB'), border=BORDER_PX, fill=BORDER_COLOR)
    bordered.save(png)
    
    df_2023.to_csv(base + '.csv', index=False)
    fig.write_html(base + '.html')
    print(f'wrote {png}')
    print(f'wrote {base}.csv')
    print(f'wrote {base}.html')

if __name__ == '__main__':
    main()
