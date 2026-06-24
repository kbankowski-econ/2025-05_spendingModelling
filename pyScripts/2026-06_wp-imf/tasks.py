"""
IMF Working Paper - "Spending Smarter" - Figure & Data Task Runner
================================================================================
Generates the figures used in docs/2026-06_wp-imf/draftPaper.tex and the model
data they read.

The plotting scripts live in this folder (the self-contained 2026-06_wp-imf
scripts). They read their sizes from chartTable.csv (RenderWidth/RenderHeight =
canvas, DisplayWidth/DisplayHeight = size in the paper), write into
docs/2026-06_wp-imf/figures, and auto-open each chart's .html in the browser.

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
- plotStandardShocksAE: AE transmission of the four standard debt-financed shocks
- plotReallocationAE:   AE output response to three reallocation shocks
- plotReallocationEM:   EMDE output response (infra + human capital; no R&D)
- plotEfficiencyAE:     AE 2050 output gain from closing efficiency gaps
- plotEfficiencyEM:     EMDE output gain from closing efficiency gaps
- plotHumanCapital:     Human capital + R&D mix IRFs
- plotDiffusionAE:      Technology diffusion-speed sensitivity
- plotEfficiencyBands:  Spending-efficiency gaps by income group (appendix)

DIAGNOSTICS (read *_results.mat directly):
--------------------------------------------------------------------------------
- plotContributions:        yd contribution decomposition across models (drivers/plotContributions.m)
- investigateContributions: contribution decomposition across variables, one shock (drivers/investigateContributions.m)

- run-all:              exportData, then regenerate every figure and the
                        contribution panels.

Main entry point: invoke run-all
"""

from invoke import task
import os
import sys

# This folder holds the plotting scripts (and chartTable.csv they read).
SCRIPT_DIR = os.path.dirname(os.path.abspath(__file__))

# Repository root and MATLAB binary for the data-pipeline tasks
REPO_ROOT = os.path.dirname(os.path.dirname(SCRIPT_DIR))
MATLAB = "/Applications/MATLAB_R2024b.app/bin/matlab"


def _run_plot(c, script, label):
    """Run one of this folder's plotting scripts (it reads chartTable.csv and
    auto-opens the chart's .html)."""
    path = os.path.join(SCRIPT_DIR, script)
    print(f"--- {label} ---")
    c.run(f"{sys.executable} {path}")


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
def plotStandardShocksAE(c):
    """
    AE transmission overview: IRFs of main variables to the four standard
    debt-financed expansion shocks (3x4 grid).
    Out: figures/standardShocksAE.png/.pdf/.html/.csv
    """
    _run_plot(c, "plotStandardShocksAE.py", "Generating: AE Standard-Shock Transmission")


@task
def plotSimplifiedGcAE(c):
    """
    Appendix: the government-consumption shock under progressive model
    simplification (full vs Simple1/2/3), same 5x4 block layout.
    Out: figures/simplifiedGcAE.png/.pdf/.html/.csv
    """
    _run_plot(c, "plotSimplifiedGcAE.py", "Generating: AE Simplified-Model Gc Shock")


@task
def plotReallocationAE(c):
    """
    AE output response to three expenditure-reallocation shocks.
    Out: figures/reallocationAE_yd.png/.html/.csv
    """
    _run_plot(c, "plotReallocationAE.py", "Generating: AE Reallocation")


@task
def plotReallocationEM(c):
    """
    EMDE output response (infrastructure + human capital; no R&D).
    Out: figures/reallocationEM_yd.png/.html/.csv
    """
    _run_plot(c, "plotReallocationEM.py", "Generating: EMDE Reallocation")


@task
def plotEfficiencyAE(c):
    """
    AE 2050 output gain from gradually closing spending-efficiency gaps.
    Out: figures/efficiencyAE_yd.png/.html/.csv
    """
    _run_plot(c, "plotEfficiencyAE.py", "Generating: AE Spending Efficiency")


@task
def plotEfficiencyEM(c):
    """
    EMDE output gain from gradually closing spending-efficiency gaps.
    Out: figures/efficiencyEM_yd.png/.html/.csv
    """
    _run_plot(c, "plotEfficiencyEM.py", "Generating: EMDE Spending Efficiency")


@task
def plotHumanCapital(c):
    """
    Human capital + R&D mix IRFs.
    Out: figures/humanCapital_yd_IRF.png/.html/.csv
    """
    _run_plot(c, "plotHumanCapitalIRFs.py", "Generating: Human Capital + R&D")


@task
def plotDiffusionAE(c):
    """
    Technology diffusion-speed sensitivity.
    Out: figures/diffusionAE_yd.png/.html/.csv
    """
    _run_plot(c, "plotDiffusionAE.py", "Generating: Technology Diffusion")


@task
def plotEfficiencyBands(c):
    """
    Spending-efficiency gaps by income group (appendix figure).
    Out: figures/efficiencyBands.png/.html/.csv
    """
    _run_plot(c, "plotEfficiencyBands.py", "Generating: Efficiency Bands (appendix)")


@task
def plotContributions(c):
    """
    Diagnostic: output (yd) contribution decompositions (drivers/plotContributions.m).
    Reads the solved models and writes barcon panels into docs/contributions/.
    In: *_results.mat | Out: docs/contributions/*.png
    """
    print("--- Plotting contributions (plotContributions.m) ---")
    cmd = (
        f"{MATLAB} -batch "
        f"\"cd('{REPO_ROOT}'); iniProject; run('drivers/plotContributions.m')\""
    )
    c.run(cmd, warn=True)


@task
def investigateContributions(c):
    """
    Diagnostic: across-variables contribution decomposition for one shock
    (drivers/investigateContributions.m). One panel per target variable
    (currently yd and yt for the gov-consumption shock; extend aItemList once
    more equations are name-tagged in model_block.modpart).
    In: *_results.mat | Out: docs/contributions/contribByVariable_*.png
    """
    print("--- Investigating contributions (investigateContributions.m) ---")
    cmd = (
        f"{MATLAB} -batch "
        f"\"cd('{REPO_ROOT}'); iniProject; run('drivers/investigateContributions.m')\""
    )
    c.run(cmd, warn=True)


@task(pre=[
    exportData,
    plotStandardShocksAE,
    plotSimplifiedGcAE,
    plotReallocationAE,
    plotReallocationEM,
    plotEfficiencyAE,
    plotEfficiencyEM,
    plotHumanCapital,
    plotDiffusionAE,
    plotEfficiencyBands,
    plotContributions,
    investigateContributions,
])
def run_all(c):
    """
    Export model data, then regenerate every figure.
    (Does not re-solve the models; run `runModels` first if the model changed.)
    """
    print("Full figure workflow complete.")
