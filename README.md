# Spending Modelling

DSGE simulations for a replication panel of fiscal-spending policy responses
(infrastructure, human capital, R&D) across Advanced Economies and Emerging
Market and Developing Economies. Produces the charts for
`docs/2026-04_FM-panel-replication/panel.pdf`.

## Project Structure

```
├── drivers/                              # Main execution scripts
│   ├── runModel.m                        # Runs all 48 model variants via Dynare
│   ├── runSimulExport.m                  # Processes results and exports CSVs
│   └── runChartsFMpanelReplication.m     # Calls the Python chart scripts
├── models/                               # Dynare model files (.mod)
├── +environment/                         # Environment setup and configuration
│   ├── csvFiles/
│   │   ├── shockDict.csv                 # Shock definitions (model -> description)
│   │   └── varDict.csv                   # Variable definitions
│   └── setup.m                           # Environment initialization
├── +utils/                               # Utility functions
│   └── +call/
│       └── paths.m                       # Path configuration (machine-local, gitignored)
├── pyScripts/
│   └── 2026-04_spendingModelling/        # Python chart scripts (Plotly)
│       ├── chartConfig.json              # Shared styling (size, fonts, palette)
│       ├── fiscal_config.json            # Output path config
│       ├── fiscal_common.py              # Shared helpers
│       ├── plotReallocationAE.py         # Panel 1
│       ├── plotReallocationEM.py         # Panel 2
│       ├── plotEfficiencyAE.py           # Panel 3
│       ├── plotEfficiencyEM.py           # Panel 4 (1x2 subplots)
│       ├── plotHumanCapitalIRFs.py       # Panel 5
│       └── plotDiffusionAE.py            # Panel 6
└── docs/
    ├── csvFiles/
    │   ├── figureNumbers.csv             # Quarterly exports (2025Q1 - 2050Q1)
    │   └── figureNumbers_yearly.csv      # Annual (Q1-sampled, 2025 - 2050)
    └── 2026-04_FM-panel-replication/     # Output of the replication panel
        ├── panel.tex                     # LaTeX source for the 3x2 panel
        ├── panel.pdf                     # Compiled panel
        └── figures/                      # PNG/CSV outputs from the Python scripts
```

## Getting Started

### Prerequisites

- MATLAB (tested with R2024b)
- Dynare 5.5 or later
- IRIS Toolbox (for time series handling and CSV export)
- Python 3 with `pandas`, `plotly`, `kaleido` (for charts)
- A LaTeX distribution with `pdflatex` and the `opensans` package
  (for compiling `panel.tex`)

### Setup

1. **Configure paths.** `+utils/+call/paths.m` is machine-local and gitignored.
   Create/edit it to match your system:
   ```matlab
   project_path        = "/your/path/to/2025-05_spendingModelling";
   matlabUtils_path    = "/your/path/to/matlabUtils";
   iris_path           = "/your/path/to/iris";
   dynare_5_5_official = "/your/path/to/dynare/5.5/matlab";
   ```

2. **Install Python deps** (only needed for regenerating charts):
   ```
   pip install pandas plotly kaleido
   ```

### Running the pipeline

The three stages are independent — you only need to rerun a stage if its
inputs changed.

#### 1. Run all Dynare models

```matlab
iniProject           % sets up paths, iris.startup(), dynare_config()
run('drivers/runModel.m')
```

This runs 48 Dynare models (`Model_HumanCapital_*` and `EM_Model_HumanCapital_*`)
and writes `_results.mat` into each model's `Output/` directory.

#### 2. Export simulation results

```matlab
run('drivers/runSimulExport.m')
```

Reads the `_results.mat` files, builds impulse response databanks, redates
from synthetic dates so that period 25Q4 lands on 2050Q1, and writes:

- `docs/csvFiles/figureNumbers.csv` — quarterly, 2025Q1 - 2050Q1
- `docs/csvFiles/figureNumbers_yearly.csv` — annual (each year's value is
  its Q1 observation), 2025 - 2050

#### 3. Generate the charts and compile the panel

```matlab
run('drivers/runChartsFMpanelReplication.m')
```

Calls each Python script in `pyScripts/2026-04_spendingModelling/`, which
reads `figureNumbers_yearly.csv` and writes PNG/HTML/CSV triples into
`docs/2026-04_FM-panel-replication/figures/`. Then:

```
cd docs/2026-04_FM-panel-replication
pdflatex panel.tex
```

to produce `panel.pdf` (A4 portrait, 3x2 layout).

## Model Output

### Simulation results

- **Location:** `models/[ModelName]/Output/[ModelName]_results.mat`
- **Content:** Dynare output — impulse responses (`oo_.endo_simul`), steady
  state, parameters, variable names.

### Processed data

- **`docs/csvFiles/figureNumbers.csv`** — quarterly impulse responses for
  ~720 model/variable combinations, 2025Q1 - 2050Q1.
- **`docs/csvFiles/figureNumbers_yearly.csv`** — same data at annual
  frequency, sampled at Q1 of each year.

The quarterly CSV is validated to be byte-identical with the published
`data/Figure6_plotting_0819_muy05.xlsx` (sheet `Models_Results`) after the
date shift.

### Chart outputs

`docs/2026-04_FM-panel-replication/figures/` contains one PNG (for print),
one HTML (interactive) and one CSV (plotted data) per chart. HTML files
are gitignored.

### Shock dictionary

`+environment/csvFiles/shockDict.csv` maps each model name to a
human-readable shock description. Every model variant corresponds to a
specific policy experiment.

### Variable dictionary

`+environment/csvFiles/varDict.csv` maps each endogenous variable to a
human-readable description and the transformation used when plotting. The
columns are:

- `description` — long name (e.g. `yd` -> "Aggregate demand")
- `diffTransf` — transformation code (e.g. `pctDev` for percent deviation
  from steady state)
- `diffDesc` — LaTeX-ready label for chart axes (e.g. `\% deviation`)

The dictionary is loaded by `+environment/setup.m` into `envi.varDict` and
consumed by the MATLAB plotting routines.
