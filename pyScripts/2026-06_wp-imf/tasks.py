"""Invoke task runner for the working-paper (2026-06_wp-imf) figures.

Usage:
  invoke --list                 list available figure tasks
  invoke standard-shocks-ae     build a single figure
  invoke all                    build every figure

Each task regenerates one figure from the exported model output in
docs/csvFiles/figureNumbers*.csv (run the Dynare drivers first to refresh it),
writing into docs/2026-06_wp-imf/figures/.
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


@task(standard_shocks_ae)
def all(c):
    """Build every working-paper figure."""
    pass
