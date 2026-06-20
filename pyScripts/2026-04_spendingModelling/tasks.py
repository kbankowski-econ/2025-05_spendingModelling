"""Invoke task runner for the spending-model figures.

Usage:
  invoke --list                 list available figure tasks
  invoke standard-shocks-ae     build a single figure
  invoke all                    build every figure

Each task regenerates one figure from the exported model output in
docs/csvFiles/figureNumbers*.csv (run the Dynare drivers first to refresh it).
"""
from pathlib import Path
from invoke import task

HERE = Path(__file__).resolve().parent


def _run(c, script):
    with c.cd(str(HERE)):
        c.run(f"python {script}")


@task
def standard_shocks_ae(c):
    """Overview panel: AE responses to the four standard expansion shocks."""
    _run(c, "plotStandardShocksAE.py")


@task
def reallocation_ae(c):
    """AE expenditure-reallocation output response."""
    _run(c, "plotReallocationAE.py")


@task
def reallocation_em(c):
    """EMDE expenditure-reallocation output response."""
    _run(c, "plotReallocationEM.py")


@task
def efficiency_ae(c):
    """AE spending-efficiency output gains."""
    _run(c, "plotEfficiencyAE.py")


@task
def efficiency_em(c):
    """EMDE spending-efficiency output gains."""
    _run(c, "plotEfficiencyEM.py")


@task
def efficiency_bands(c):
    """Estimated spending-efficiency gaps by income group."""
    _run(c, "plotEfficiencyBands.py")


@task
def diffusion_ae(c):
    """AE high- vs low-diffusion output gains."""
    _run(c, "plotDiffusionAE.py")


@task
def human_capital_irfs(c):
    """AE human-capital and R&D mix IRFs."""
    _run(c, "plotHumanCapitalIRFs.py")


@task(
    standard_shocks_ae,
    reallocation_ae,
    reallocation_em,
    efficiency_ae,
    efficiency_em,
    efficiency_bands,
    diffusion_ae,
    human_capital_irfs,
)
def all(c):
    """Build every figure."""
    pass
