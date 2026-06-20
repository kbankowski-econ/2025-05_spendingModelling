"""
IMF Working Paper - "Spending Smarter" - Figure & Data Task Runner
================================================================================
Generates the six figures used in docs/2026-06_wp-imf/draftPaper.tex and the
model data they read.

The plotting scripts themselves live in the sibling project
pyScripts/2026-04_spendingModelling/ (referenced via APR26_SCRIPT_DIR). This
runner points their output at docs/2026-06_wp-imf/figures by setting
FISCAL_CONFIG_PATH to this folder's fiscal_config.json.

DATA PIPELINE (MATLAB / Dynare):
--------------------------------------------------------------------------------
- runModels:        Solve all 25 models (drivers/runModel.m)
                    In: models/*.mod | Out: models/<name>/Output/<name>_results.mat
                    Run only when the model or calibration changes. (Benign
                    exit-time segfault after "canonicalizeResults: normalized".)
- exportData:       Export simulated paths to the figure CSVs (drivers/runSimulExport.m)
                    In: *_results.mat | Out: docs/csvFiles/figureNumbers.csv,
                        docs/csvFiles/figureNumbers_yearly.csv

PAPER FIGURES (read docs/csvFiles/figureNumbers_yearly.csv):
--------------------------------------------------------------------------------
- plotReallocationAE:   Fig 1 - AE output response to three reallocation shocks
                        Out: figures/reallocationAE_yd.png/.html/.csv
- plotReallocationEM:   Fig 2 - EMDE output response (infra + human capital; no R&D)
                        Out: figures/reallocationEM_yd.png/.html/.csv
- plotEfficiencyAE:     Fig 3 - AE 2050 output gain from closing efficiency gaps
                        Out: figures/efficiencyAE_yd.png/.html/.csv
- plotEfficiencyEM:     Fig 4 - EMDE output gain from closing efficiency gaps
                        Out: figures/efficiencyEM_yd.png/.html/.csv
- plotHumanCapital:     Fig 5 - Human capital + R&D mix IRFs
                        Out: figures/humanCapital_yd_IRF.png/.html/.csv
- plotDiffusionAE:      Fig 6 - Technology diffusion-speed sensitivity
                        Out: figures/diffusionAE_yd.png/.html/.csv

EXTRA (not in the paper):
--------------------------------------------------------------------------------
- plotEfficiencyBands:  Efficiency uncertainty bands (sibling script; not one of
                        the six paper figures). Out: figures/efficiencyBands.png

- run-all:              exportData, then regenerate all six paper figures.

Main entry point: invoke run-all
"""

from invoke import task
import os
import sys

# This project (holds fiscal_config.json pointing output at docs/2026-06_wp-imf)
SCRIPT_DIR = os.path.dirname(os.path.abspath(__file__))

# Sibling project that holds the actual plotting scripts + fiscal_common.py
APR26_SCRIPT_DIR = os.path.join(os.path.dirname(SCRIPT_DIR), "2026-04_spendingModelling")

# Repository root and MATLAB binary for the data-pipeline tasks
REPO_ROOT = os.path.dirname(os.path.dirname(SCRIPT_DIR))
MATLAB = "/Applications/MATLAB_R2024b.app/bin/matlab"

# Redirect the sibling scripts' output to this paper's figures/ folder
LOCAL_CONFIG = os.path.join(SCRIPT_DIR, "fiscal_config.json")
PLOT_ENV = {"FISCAL_CONFIG_PATH": LOCAL_CONFIG}


def _run_plot(c, script, label):
    """Run a plotting script from the sibling project, output to this paper."""
    path = os.path.join(APR26_SCRIPT_DIR, script)
    print(f"--- {label} ---")
    c.run(f"{sys.executable} {path}", env=PLOT_ENV)


# =============================================================================
# DATA PIPELINE (MATLAB / Dynare)
# =============================================================================

@task
def runModels(c):
    """
    Solve all 25 models (drivers/runModel.m). Run only when the model or
    calibration changes. Benign exit-time segfault after completion.
    In: models/*.mod | Out: models/<name>/Output/<name>_results.mat
    """
    print("--- Solving models (runModel.m) ---")
    cmd = (
        f"{MATLAB} -batch "
        f"\"cd('{REPO_ROOT}'); iniProject; setenv('MODEL_FILTER',''); "
        f"run('drivers/runModel.m')\""
    )
    # runModel.m segfaults on exit *after* all models solve; tolerate non-zero exit.
    c.run(cmd, warn=True)


@task
def exportData(c):
    """
    Export simulated paths to the figure CSVs (drivers/runSimulExport.m).
    In: *_results.mat | Out: docs/csvFiles/figureNumbers.csv, figureNumbers_yearly.csv
    """
    print("--- Exporting model data (runSimulExport.m) ---")
    cmd = (
        f"{MATLAB} -batch "
        f"\"cd('{REPO_ROOT}'); iniProject; run('drivers/runSimulExport.m')\""
    )
    c.run(cmd)


# =============================================================================
# PAPER FIGURES
# =============================================================================

@task
def plotReallocationAE(c):
    """
    Fig 1: AE output response to three expenditure-reallocation shocks.
    Out: figures/reallocationAE_yd.png/.html/.csv
    """
    _run_plot(c, "plotReallocationAE.py", "Generating Fig 1: AE Reallocation")


@task
def plotReallocationEM(c):
    """
    Fig 2: EMDE output response (infrastructure + human capital; no R&D).
    Out: figures/reallocationEM_yd.png/.html/.csv
    """
    _run_plot(c, "plotReallocationEM.py", "Generating Fig 2: EMDE Reallocation")


@task
def plotEfficiencyAE(c):
    """
    Fig 3: AE 2050 output gain from gradually closing spending-efficiency gaps.
    Out: figures/efficiencyAE_yd.png/.html/.csv
    """
    _run_plot(c, "plotEfficiencyAE.py", "Generating Fig 3: AE Spending Efficiency")


@task
def plotEfficiencyEM(c):
    """
    Fig 4: EMDE output gain from gradually closing spending-efficiency gaps.
    Out: figures/efficiencyEM_yd.png/.html/.csv
    """
    _run_plot(c, "plotEfficiencyEM.py", "Generating Fig 4: EMDE Spending Efficiency")


@task
def plotHumanCapital(c):
    """
    Fig 5: Human capital + R&D mix IRFs.
    Out: figures/humanCapital_yd_IRF.png/.html/.csv
    """
    _run_plot(c, "plotHumanCapitalIRFs.py", "Generating Fig 5: Human Capital + R&D")


@task
def plotDiffusionAE(c):
    """
    Fig 6: Technology diffusion-speed sensitivity.
    Out: figures/diffusionAE_yd.png/.html/.csv
    """
    _run_plot(c, "plotDiffusionAE.py", "Generating Fig 6: Technology Diffusion")


# =============================================================================
# EXTRA (not one of the six paper figures)
# =============================================================================

@task
def plotEfficiencyBands(c):
    """
    Efficiency uncertainty bands (sibling script; not a paper figure).
    Out: figures/efficiencyBands.png
    """
    _run_plot(c, "plotEfficiencyBands.py", "Generating Efficiency Bands (extra)")


@task(pre=[
    exportData,
    plotReallocationAE,
    plotReallocationEM,
    plotEfficiencyAE,
    plotEfficiencyEM,
    plotHumanCapital,
    plotDiffusionAE,
])
def run_all(c):
    """
    Export model data, then regenerate all six paper figures.
    (Does not re-solve the models; run `runModels` first if the model changed.)
    """
    print("Full figure workflow complete.")
