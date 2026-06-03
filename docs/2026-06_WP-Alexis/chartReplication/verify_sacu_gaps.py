import pandas as pd

DATA_DIR = '/Users/kk/Documents/0000-00_work/2025-05_fmEfficiencyScores/code-output/2025-04-14-efficiency-estimates'
SECTORS = ['INF', 'HLT', 'EDU', 'RND']
SACU = {'BWA': 'Botswana', 'SWZ': 'Eswatini', 'LSO': 'Lesotho', 'NAM': 'Namibia', 'ZAF': 'South Africa'}

# Paper Table 1 values for comparison
PAPER = {
    'BWA': {'INF': 0.34, 'EDU': 0.38, 'HLT': 0.40},
    'SWZ': {'INF': 0.39, 'EDU': 0.35, 'HLT': 0.41},
    'LSO': {'INF': 0.40, 'EDU': 0.42, 'HLT': 0.47},
    'NAM': {'INF': 0.41, 'EDU': 0.35, 'HLT': 0.37},
    'ZAF': {'INF': 0.33, 'EDU': 0.37, 'HLT': 0.37},
}

data = {}
for s in SECTORS:
    df = pd.read_csv(f'{DATA_DIR}/{s}_inefficiency-scores.csv', usecols=['iso3c', 'year', 'eff_gap'])
    data[s] = df

# year coverage
for s in SECTORS:
    print(f"{s}: years {int(data[s].year.min())}-{int(data[s].year.max())}, "
          f"{data[s].iso3c.nunique()} countries, {len(data[s])} rows")

def gap(s, iso, yr):
    df = data[s]
    r = df[(df.iso3c == iso) & (df.year == yr)]
    return float(r.eff_gap.iloc[0]) if len(r) else None

print("\n=== SACU eff_gap: source vs paper Table 1 ===")
for sect, label, paper_year in [('INF', 'Infrastructure', 2023), ('EDU', 'Education', 2024), ('HLT', 'Health', 2023)]:
    print(f"\n{label} ({sect}), source year {paper_year}:")
    print(f"  {'country':14} {'source':>8} {'paper':>7} {'diff':>7}")
    for iso, name in SACU.items():
        src = gap(sect, iso, paper_year)
        pap = PAPER[iso].get('EDU' if sect == 'EDU' else ('HLT' if sect == 'HLT' else 'INF'))
        if src is None:
            print(f"  {name:14} {'n/a':>8} {pap:>7.2f}")
        else:
            print(f"  {name:14} {src:>8.3f} {pap:>7.2f} {src-pap:>+7.3f}")

print("\n=== also 2000 (for the 2000-vs-2023 Figure 3 comparison) ===")
for sect, label in [('INF', 'Infrastructure'), ('EDU', 'Education'), ('HLT', 'Health')]:
    print(f"\n{label} ({sect}) in 2000:")
    for iso, name in SACU.items():
        print(f"  {name:14} {gap(sect, iso, 2000)}")
