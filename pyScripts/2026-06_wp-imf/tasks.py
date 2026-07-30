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
- runModels:        Solve all configured models (drivers/runModel.m)
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
- plotEfficiencyAE:     AE efficiency-gap closures with fiscal-shock comparators
- plotEfficiencyEM:     EMDE transmission of permanent efficiency-gap closures
- plotHumanCapital:     Human capital + R&D mix IRFs
- plotDiffusionAE:      Technology diffusion-speed sensitivity
- plotEfficiencyBands:  Spending-efficiency gaps by income group (appendix)

PAPER TABLES (\\input by draftPaper.tex):
--------------------------------------------------------------------------------
- makeMultipliers:  Multipliers by horizon (docs/.../makeMultipliers.py)
                    In: *_results.mat | Out: docs/2026-06_wp-imf/multipliersTable.tex
- makeCommonParametersTable:    Common macro and policy parameters
- makeCalibrationTargetsTable:  AE and EMDE steady-state targets
- makeParametersTable:          Structural productive-spending parameters
- makeEfficiencyGapsTable:      Efficiency-gap derivation
                    Calibration values, not model output.
                    Out: docs/2026-06_wp-imf/*Table.tex

DIAGNOSTICS (read *_results.mat directly):
--------------------------------------------------------------------------------
- plotContributions:        yd contribution decomposition across models (drivers/plotContributions.m)
- investigateContributions: contribution decomposition across variables, one shock (drivers/investigateContributions.m)

- run-all:              exportData, then regenerate every figure, every \\input
                        table, and the contribution panels.

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


def _run_plot(c, script, label, args=""):
    """Run one of this folder's plotting scripts (it reads chartTable.csv and
    auto-opens the chart's .html)."""
    path = os.path.join(SCRIPT_DIR, script)
    print(f"--- {label} ---")
    c.run(f"{sys.executable} {path} {args}".rstrip())


# =============================================================================
# DATA PIPELINE (MATLAB / Dynare)
# =============================================================================

@task
def runModels(c):
    """
    Solve all configured models (drivers/runModel.m). Run only when the model or
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
    Appendix: AE transmission under the four persistent temporary
    debt-financed expansion shocks (5x4 grid).
    Out: figures/standardShocksAE.png/.pdf/.html/.csv
    """
    _run_plot(c, "plotStandardShocksAE.py", "Generating: AE Standard-Shock Transmission")


@task
def plotStandardShocksAEPerm(c):
    """
    Section 4: AE transmission of the four standard debt-financed shocks when
    each is a permanent step increase.
    Out: figures/standardShocksAEPerm.png/.pdf/.html/.csv
    """
    _run_plot(c, "plotStandardShocksAEPerm.py", "Generating: AE Standard-Shock Transmission (permanent)")


@task
def plotSimplifiedGcAE(c):
    """
    Appendix: persistent temporary government-consumption shock under
    progressive model simplification, same 5x4 block layout.
    Out: figures/simplifiedGcAE.png/.pdf/.html/.csv
    """
    _run_plot(c, "plotSimplifiedGcAE.py", "Generating: AE Simplified-Model Gc Shock")


@task
def plotSimplifiedGcAEPerm(c):
    """
    Primary model-structure robustness exercise under a permanent shock.
    Out: figures/simplifiedGcAEPerm.png/.pdf/.html/.csv
    """
    _run_plot(
        c, "plotSimplifiedGcAE.py", "Generating: AE Simplified-Model Gc Shock (permanent)",
        args="--permanent",
    )


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
    AE permanent efficiency-gap closures with corresponding permanent
    spending-shock IRFs (5x4 grid).
    Out: figures/efficiencyAE_yd.png/.pdf/.html/.csv
    """
    _run_plot(c, "plotEfficiencyAE.py", "Generating: AE Spending Efficiency")


@task
def plotEfficiencyEM(c):
    """
    EMDE transmission of permanent spending-efficiency-gap closures (5x4 grid).
    Out: figures/efficiencyEM_yd.png/.pdf/.html/.csv
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
def plotSensitivityIRF(c):
    """
    Appendix: AE output-IRF sensitivity under persistent temporary shocks to
    the structural parameters alpha_G, mu, alpha_RD (1x3 fan). Reads
    docs/2026-06_wp-imf/investigations/sensitivity/results/sweep_AE_irf.csv
    (produced by investigations/sensitivity/sweep.m, MATLAB), not figureNumbers.
    Out: figures/sensitivityIRF_AE.png/.pdf/.html/.csv
    """
    _run_plot(c, "plotSensitivityIRF.py", "Generating: AE Parameter Sensitivity (IRF)")


@task
def plotSensitivityIRFPerm(c):
    """
    Section 4 sensitivity exercise under permanent shocks. Reads
    docs/2026-06_wp-imf/investigations/sensitivity/results/sweep_AE_irf_perm.csv.
    Out: figures/sensitivityIRF_AEPerm.png/.pdf/.html/.csv
    """
    _run_plot(
        c, "plotSensitivityIRF.py", "Generating: AE Parameter Sensitivity (permanent)",
        args="--permanent",
    )


@task
def plotEfficiencyBands(c):
    """
    Spending-efficiency gaps by income group (appendix figure).
    Out: figures/efficiencyBands.png/.html/.csv
    """
    _run_plot(c, "plotEfficiencyBands.py", "Generating: Efficiency Bands (appendix)")


@task
def makeMultipliers(c):
    """
    Regenerate the multiplier table from the solved models.
    Runs docs/2026-06_wp-imf/pyScripts/makeMultipliers.py.
    In: *_results.mat | Out: docs/2026-06_wp-imf/multipliersTable.tex (\\input by the paper)
    """
    path = os.path.join(REPO_ROOT, "docs", "2026-06_wp-imf", "pyScripts", "makeMultipliers.py")
    print("--- Generating: Multiplier table (makeMultipliers.py) ---")
    c.run(f"{sys.executable} {path}")


def _run_table(c, script, label):
    """Run one of the docs/2026-06_wp-imf/pyScripts table generators."""
    path = os.path.join(REPO_ROOT, "docs", "2026-06_wp-imf", "pyScripts", script)
    print(f"--- Generating: {label} ---")
    c.run(f"{sys.executable} {path}")


@task
def makeCommonParametersTable(c):
    """
    Regenerate the common macro and policy parameter table.
    Out: docs/2026-06_wp-imf/commonParametersTable.tex
    """
    _run_table(c, "makeCommonParametersTable.py", "Common parameters table")


@task
def makeCalibrationTargetsTable(c):
    """
    Regenerate the AE and EMDE steady-state target table.
    Out: docs/2026-06_wp-imf/calibrationTargetsTable.tex
    """
    _run_table(c, "makeCalibrationTargetsTable.py", "Calibration targets table")


@task
def makeParametersTable(c):
    """
    Regenerate the structural productive-spending parameter table.
    Out: docs/2026-06_wp-imf/parametersTable.tex (\\input by the paper)
    """
    _run_table(c, "makeParametersTable.py", "Structural parameters table")


@task
def makeEfficiencyGapsTable(c):
    """
    Regenerate the spending-efficiency gap derivation table.
    Out: docs/2026-06_wp-imf/efficiencyGapsTable.tex (\\input by the paper)
    """
    _run_table(c, "makeEfficiencyGapsTable.py", "Efficiency-gap table")


@task
def makeGlossary(c):
    """
    Regenerate the appendix symbol glossary (paper <-> model-code mapping):
    endogenous variables, parameters, exogenous shocks (makeGlossary.py).
    Out: docs/2026-06_wp-imf/glossary{Endogenous,Parameters,Exogenous}.tex
    """
    _run_table(c, "makeGlossary.py", "Symbol glossary (appendix)")


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
    plotStandardShocksAEPerm,
    plotSimplifiedGcAE,
    plotSimplifiedGcAEPerm,
    plotReallocationAE,
    plotReallocationEM,
    plotEfficiencyAE,
    plotEfficiencyEM,
    plotHumanCapital,
    plotDiffusionAE,
    plotSensitivityIRF,
    plotSensitivityIRFPerm,
    plotEfficiencyBands,
    makeMultipliers,
    makeCommonParametersTable,
    makeCalibrationTargetsTable,
    makeParametersTable,
    makeEfficiencyGapsTable,
    makeGlossary,
    plotContributions,
    investigateContributions,
])
def run_all(c):
    """
    Export model data, then regenerate every figure and every \\input table
    (multipliers, parameters, efficiency gaps, and the glossary).
    (Does not re-solve the models; run `runModels` first if the model changed.)
    """
    print("Full figure and table workflow complete.")
