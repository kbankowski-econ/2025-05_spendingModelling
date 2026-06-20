"""
Convenience runner: regenerate every working-paper figure.

Each plot script can be run on its own (`python plotReallocationAE.py`); it
imports the shared helpers from wp_charts.py in this folder. This runner just
invokes the scripts in turn via subprocess.
"""
import subprocess
import sys
from pathlib import Path

SCRIPT_DIR = Path(__file__).resolve().parent

SCRIPTS = [
    "plotDiffusionAE.py",       # Fig: technology diffusion
    "plotReallocationAE.py",    # Fig: reallocation (a) AE
    "plotReallocationEM.py",    # Fig: reallocation (b) EMDE
    "plotEfficiencyAE.py",      # Fig: spending efficiency (a) AE
    "plotEfficiencyEM.py",      # Fig: spending efficiency (b) EMDE
    "plotHumanCapitalIRFs.py",  # Fig: human capital + R&D mix
    "plotEfficiencyBands.py",   # Fig: efficiency bands by income group (App. B)
]


def main():
    failures = []
    for script in SCRIPTS:
        print(f"=== {script} ===")
        result = subprocess.run([sys.executable, str(SCRIPT_DIR / script)])
        if result.returncode != 0:
            failures.append(script)
    if failures:
        print(f"\nFAILED: {', '.join(failures)}")
        sys.exit(1)
    print("\nAll figures regenerated.")


if __name__ == "__main__":
    main()
