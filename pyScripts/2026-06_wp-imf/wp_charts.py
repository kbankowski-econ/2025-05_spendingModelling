"""
Shared helpers for the working-paper figure scripts in this folder.

Two small utilities used by every plot script:
  - chart_dims_px:    read a chart's Width/Height (cm) from chartTable.csv -> px
  - smart_save_image: write a PNG only when its bytes change

chartTable.csv is expected alongside this module. Depends only on the standard
library and plotly (for smart_save_image).
"""
from pathlib import Path

import plotly.io as pio

_THIS_DIR = Path(__file__).resolve().parent
CONFIG_CSV = _THIS_DIR / "chartTable.csv"
_CM_TO_PX = 37.795275591  # 1 cm at 96 DPI; rendered at scale=2 -> 192 DPI


def chart_dims_px(stem, default_cm):
    """Return (width_px, height_px) for a chart, reading Width/Height (in cm)
    from chartTable.csv by matching pngFile. Falls back to default_cm if the
    config file or row is missing, so a script still runs without the config."""
    import csv
    width_cm, height_cm = default_cm
    if CONFIG_CSV.exists():
        with CONFIG_CSV.open(newline="", encoding="utf-8") as handle:
            for row in csv.DictReader(handle):
                if Path(row.get("pngFile", "")).name == f"{stem}.png":
                    width_cm, height_cm = float(row["Width"]), float(row["Height"])
                    break
    return round(width_cm * _CM_TO_PX), round(height_cm * _CM_TO_PX)


def smart_save_image(fig, output_path, scale=2):
    """Write the PNG only if its bytes changed (avoids needless churn)."""
    new_bytes = pio.to_image(fig, format="png", scale=scale)
    if output_path.exists() and output_path.read_bytes() == new_bytes:
        print(f"  [SmartSave] Skipping {output_path.name} (no changes)")
        return False
    output_path.write_bytes(new_bytes)
    print(f"  [SmartSave] Updating {output_path.name}")
    return True
