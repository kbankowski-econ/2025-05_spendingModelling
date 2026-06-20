"""
IMF Working Paper - "Spending Smarter" - Figure & Data Task Runner
================================================================================
Generates the six figures used in docs/2026-06_wp-imf/draftPaper.tex and the
model data they read.

The plotting scripts themselves live in the sibling project
pyScripts/2026-04_spendingModelling/ (referenced via APR26_SCRIPT_DIR). This
runner points their output at docs/2026-06_wp-imf/figures by setting
FISCAL_CONFIG_PATH to this folder's fiscal_config.json.

Every figure task (and `run-all`) accepts `--open-html`: pass it to auto-open each
chart's interactive .html in the browser after it is written, e.g.
    invoke run-all --open-html
    invoke plot-reallocation-ae --open-html

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

APPENDIX FIGURE:
--------------------------------------------------------------------------------
- plotEfficiencyBands:  Efficiency uncertainty bands (appendix figure, not one of
                        the six main-text figures). Out: figures/efficiencyBands.png

- run-all:              exportData, then regenerate all six main-text figures.

Main entry point: invoke run-all
"""

from invoke import task
import json
import os
import sys
import tempfile

# This project (holds fiscal_config.json pointing output at docs/2026-06_wp-imf)
SCRIPT_DIR = os.path.dirname(os.path.abspath(__file__))

# Sibling project that holds the actual plotting scripts + fiscal_common.py
APR26_SCRIPT_DIR = os.path.join(os.path.dirname(SCRIPT_DIR), "2026-04_spendingModelling")

# Repository root and MATLAB binary for the data-pipeline tasks
REPO_ROOT = os.path.dirname(os.path.dirname(SCRIPT_DIR))
MATLAB = "/Applications/MATLAB_R2024b.app/bin/matlab"

# Redirect the sibling scripts' output to this paper's figures/ folder
LOCAL_CONFIG = os.path.join(SCRIPT_DIR, "fiscal_config.json")


def _plot_env(open_html):
    """Environment for the plot scripts. By default they use this folder's
    fiscal_config.json. With open_html=True, point them at an override config
    (auto_open_html on) so each chart's .html opens in the browser; the scripts
    read auto_open_html from FISCAL_CONFIG_PATH."""
    if not open_html:
        return {"FISCAL_CONFIG_PATH": LOCAL_CONFIG}
    with open(LOCAL_CONFIG) as handle:
        cfg = json.load(handle)
    settings = cfg["output_settings"]
    # base_path is resolved relative to the config file; make it absolute so the
    # override can live in a temp dir and still write to the same figures folder.
    settings["base_path"] = os.path.normpath(
        os.path.join(os.path.dirname(LOCAL_CONFIG), settings["base_path"])
    )
    settings["auto_open_html"] = True
    override = os.path.join(tempfile.gettempdir(), "fiscal_config_autoopen.json")
    with open(override, "w") as handle:
        json.dump(cfg, handle)
    return {"FISCAL_CONFIG_PATH": override}


def _run_plot(c, script, label, open_html=False):
    """Run a plotting script from the sibling project, output to this paper."""
    path = os.path.join(APR26_SCRIPT_DIR, script)
    print(f"--- {label} ---")
    c.run(f"{sys.executable} {path}", env=_plot_env(open_html))


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

@task(help={"open_html": "Open each chart's .html in the browser after writing it."})
def plotStandardShocksAE(c, open_html=False):
    """
    Overview panel: AE responses to the four standard expansion shocks.
    Out: figures/standardShocksAE.png
    """
    _run_plot(c, "plotStandardShocksAE.py", "Generating Overview: Standard Expansion Shocks", open_html)


@task(help={"open_html": "Open each chart's .html in the browser after writing it."})
def plotReallocationAE(c, open_html=False):
    """
    Fig 1: AE output response to three expenditure-reallocation shocks.
    Out: figures/reallocationAE_yd.png/.html/.csv
    """
    _run_plot(c, "plotReallocationAE.py", "Generating Fig 1: AE Reallocation", open_html)


@task(help={"open_html": "Open each chart's .html in the browser after writing it."})
def plotReallocationEM(c, open_html=False):
    """
    Fig 2: EMDE output response (infrastructure + human capital; no R&D).
    Out: figures/reallocationEM_yd.png/.html/.csv
    """
    _run_plot(c, "plotReallocationEM.py", "Generating Fig 2: EMDE Reallocation", open_html)


@task(help={"open_html": "Open each chart's .html in the browser after writing it."})
def plotEfficiencyAE(c, open_html=False):
    """
    Fig 3: AE 2050 output gain from gradually closing spending-efficiency gaps.
    Out: figures/efficiencyAE_yd.png/.html/.csv
    """
    _run_plot(c, "plotEfficiencyAE.py", "Generating Fig 3: AE Spending Efficiency", open_html)


@task(help={"open_html": "Open each chart's .html in the browser after writing it."})
def plotEfficiencyEM(c, open_html=False):
    """
    Fig 4: EMDE output gain from gradually closing spending-efficiency gaps.
    Out: figures/efficiencyEM_yd.png/.html/.csv
    """
    _run_plot(c, "plotEfficiencyEM.py", "Generating Fig 4: EMDE Spending Efficiency", open_html)


@task(help={"open_html": "Open each chart's .html in the browser after writing it."})
def plotHumanCapital(c, open_html=False):
    """
    Fig 5: Human capital + R&D mix IRFs.
    Out: figures/humanCapital_yd_IRF.png/.html/.csv
    """
    _run_plot(c, "plotHumanCapitalIRFs.py", "Generating Fig 5: Human Capital + R&D", open_html)


@task(help={"open_html": "Open each chart's .html in the browser after writing it."})
def plotDiffusionAE(c, open_html=False):
    """
    Fig 6: Technology diffusion-speed sensitivity.
    Out: figures/diffusionAE_yd.png/.html/.csv
    """
    _run_plot(c, "plotDiffusionAE.py", "Generating Fig 6: Technology Diffusion", open_html)


# =============================================================================
# APPENDIX FIGURE (not one of the six main-text figures)
# =============================================================================

@task(help={"open_html": "Open each chart's .html in the browser after writing it."})
def plotEfficiencyBands(c, open_html=False):
    """
    Efficiency uncertainty bands (appendix figure).
    Out: figures/efficiencyBands.png
    """
    _run_plot(c, "plotEfficiencyBands.py", "Generating Efficiency Bands (appendix)", open_html)


@task(help={"open_html": "Open each chart's .html in the browser after writing it."})
def run_all(c, open_html=False):
    """
    Export model data, then regenerate all six paper figures.
    (Does not re-solve the models; run `runModels` first if the model changed.)
    Pass --open-html to open every chart's .html in the browser.
    """
    exportData(c)
    plotStandardShocksAE(c, open_html)
    plotReallocationAE(c, open_html)
    plotReallocationEM(c, open_html)
    plotEfficiencyAE(c, open_html)
    plotEfficiencyEM(c, open_html)
    plotHumanCapital(c, open_html)
    plotDiffusionAE(c, open_html)
    print("Full figure workflow complete.")
