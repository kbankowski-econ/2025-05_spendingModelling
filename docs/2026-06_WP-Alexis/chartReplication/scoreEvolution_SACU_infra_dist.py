import os
import pandas as pd
import plotly.graph_objects as go
from plotly.subplots import make_subplots
from PIL import Image, ImageOps

DATA_DIR = '/Users/kk/Documents/0000-00_work/2025-05_fmEfficiencyScores/code-output/2025-04-14-efficiency-estimates'
OUT_DIR = os.path.dirname(os.path.abspath(__file__))

# 3 sectors for the 3x1 panel
SECTORS = ['INF', 'HLT', 'EDU']
SECTOR_TITLES = {'INF': 'Infrastructure', 'HLT': 'Health', 'EDU': 'Education'}

# 5 SACU countries
SACU = {'BWA': 'Botswana', 'SWZ': 'Eswatini', 'LSO': 'Lesotho', 'NAM': 'Namibia', 'ZAF': 'South Africa'}
SACU_HIGHLIGHT_COLOR = '#1E88E5' # Blue
OTHER_COLOR = '#BDBDBD'         # Light grey

WIDTH, HEIGHT = 600, 360
SCALE = 2
BORDER_PX = 1
BORDER_COLOR = (100, 181, 246)  # #64B5F6

# Predefined offsets (ax, ay) to stagger and spread out country labels horizontally and vertically
# This prevents overlaps when labels are drawn horizontally
ANNOTATION_OFFSETS = {
    'INF': {
        'Namibia':      {'ax': -40, 'ay': -18},
        'Lesotho':      {'ax': 0,   'ay': -18},
        'Eswatini':     {'ax': 40,  'ay': -18},
        'Botswana':     {'ax': 0,   'ay': -18},
        'South Africa': {'ax': 0,   'ay': -18}
    },
    'HLT': {
        'Lesotho':      {'ax': 15,  'ay': -18},
        'South Africa': {'ax': 65,  'ay': -18},
        'Botswana':     {'ax': 115, 'ay': -18},
        'Eswatini':     {'ax': 160, 'ay': -18},
        'Namibia':      {'ax': 205, 'ay': -18}
    },
    'EDU': {
        'South Africa': {'ax': -15, 'ay': -18},
        'Namibia':      {'ax': 15,  'ay': -18},
        'Botswana':     {'ax': 0,   'ay': -18},
        'Lesotho':      {'ax': -15, 'ay': -18},
        'Eswatini':     {'ax': 15,  'ay': -18}
    }
}

def main():
    # Build 3x1 subplots
    fig = make_subplots(rows=3, cols=1,
                        subplot_titles=tuple(SECTOR_TITLES[s] for s in SECTORS),
                        vertical_spacing=0.08)
    
    all_data = []
    
    # Define ranges and ticks for each sector
    sector_axes = {
        'INF': {'range': [0.15, 0.70], 'tickvals': [0.2, 0.3, 0.4, 0.5, 0.6, 0.7]},
        'HLT': {'range': [0.10, 0.60], 'tickvals': [0.1, 0.2, 0.3, 0.4, 0.5, 0.6]},
        'EDU': {'range': [0.20, 0.75], 'tickvals': [0.2, 0.3, 0.4, 0.5, 0.6, 0.7]}
    }
    
    for r_idx, s in enumerate(SECTORS, 1):
        df = pd.read_csv(f'{DATA_DIR}/{s}_inefficiency-scores.csv',
                         usecols=['iso3c', 'country', 'year', 'eff_gap'])
        df_2023 = df[df.year == 2023].dropna(subset=['eff_gap'])
        df_2023 = df_2023.sort_values('eff_gap', ascending=False).reset_index(drop=True)
        
        # Collect data for CSV output
        df_2023['sector'] = s
        all_data.append(df_2023)
        
        # Build colors list
        colors = []
        for iso in df_2023['iso3c']:
            if iso in SACU:
                colors.append(SACU_HIGHLIGHT_COLOR)
            else:
                colors.append(OTHER_COLOR)
                
        # Add bar chart trace
        fig.add_trace(go.Bar(
            x=df_2023['country'],
            y=df_2023['eff_gap'],
            marker_color=colors,
            marker_line_width=0,
            showlegend=False
        ), row=r_idx, col=1)
        
        # Update y-axis for this row
        axis_config = sector_axes[s]
        fig.update_yaxes(
            range=axis_config['range'],
            tickvals=axis_config['tickvals'],
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
            row=r_idx, col=1
        )
        
        # Update x-axis for this row (hide tick labels/tick marks)
        fig.update_xaxes(
            showticklabels=False,
            showgrid=False,
            linecolor='black',
            linewidth=1.5,
            ticks='',
            row=r_idx, col=1
        )
        
        # Add custom annotations for SACU countries (horizontal text with pointer lines)
        for iso, name in SACU.items():
            if name in df_2023['country'].values:
                row_data = df_2023[df_2023['country'] == name].iloc[0]
                val = row_data['eff_gap']
                
                # Get custom offsets
                offsets = ANNOTATION_OFFSETS[s][name]
                
                fig.add_annotation(
                    x=name,
                    y=val,
                    ax=offsets['ax'],
                    ay=offsets['ay'],
                    text=name,
                    showarrow=True,
                    arrowhead=0,
                    arrowwidth=1.2,
                    arrowcolor='#424242',
                    font=dict(size=9.5, color='#212121'),
                    row=r_idx, col=1
                )
        
    # Add dummy traces for the legend (showlegend=True, aligned centrally)
    fig.add_trace(go.Bar(x=[None], y=[None], name='SACU', marker_color=SACU_HIGHLIGHT_COLOR))
    fig.add_trace(go.Bar(x=[None], y=[None], name='Other', marker_color=OTHER_COLOR))
    
    fig.update_layout(
        template='simple_white',
        height=HEIGHT,
        width=WIDTH,
        font={'size': 10.5},
        margin=dict(l=28, r=8, t=45, b=20), # reduced margins for shorter height
        legend=dict(
            orientation='h',
            yanchor='bottom',
            y=1.06,
            xanchor='center',
            x=0.5,
            font=dict(size=10.5)
        )
    )
    
    fig.update_annotations(font_size=10.5)
    
    # Save the output files
    base = os.path.join(OUT_DIR, 'scoreEvolution_SACU_infra_dist')
    png = base + '.png'
    
    fig.write_image(png, width=WIDTH, height=HEIGHT, scale=SCALE)
    
    # Add border frame
    bordered = ImageOps.expand(Image.open(png).convert('RGB'), border=BORDER_PX, fill=BORDER_COLOR)
    bordered.save(png)
    
    pd.concat(all_data).to_csv(base + '.csv', index=False)
    fig.write_html(base + '.html')
    print(f'wrote {png}')
    print(f'wrote {base}.csv')
    print(f'wrote {base}.html')

if __name__ == '__main__':
    main()
