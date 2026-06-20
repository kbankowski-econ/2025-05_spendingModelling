"""
Shared helpers for the working-paper figure scripts in this folder.

Two small utilities used by every plot script:
  - chart_dims_px:    read a chart's Width/Height (cm) from chartTable.csv -> px
  - smart_save_image: write a PNG (tagged with its true DPI) only when it changes

chartTable.csv is expected alongside this module. Depends only on the standard
library and plotly (for smart_save_image).
"""
import struct
import zlib
from pathlib import Path

import plotly.io as pio

_THIS_DIR = Path(__file__).resolve().parent
CONFIG_CSV = _THIS_DIR / "chartTable.csv"
_CM_TO_PX = 37.795275591  # 1 cm at 96 DPI; rendered at scale=2 -> 192 DPI
_BASE_DPI = 96            # plotly's logical DPI; the rendered DPI is _BASE_DPI * scale


def _png_with_dpi(png_bytes, dpi):
    """Insert a pHYs chunk so the PNG reports `dpi`, making its natural size in
    LaTeX (pixels / DPI) equal the authored size. kaleido writes no pHYs, so we
    splice one in right after IHDR without re-encoding the image data."""
    ppm = int(round(dpi / 0.0254))  # pixels per metre (pHYs unit = 1 = metre)
    body = b"pHYs" + struct.pack(">IIB", ppm, ppm, 1)
    chunk = struct.pack(">I", 9) + body + struct.pack(">I", zlib.crc32(body) & 0xFFFFFFFF)
    ihdr_end = 8 + 4 + 4 + 13 + 4  # 8-byte signature + IHDR (len+type+13 data+crc)
    return png_bytes[:ihdr_end] + chunk + png_bytes[ihdr_end:]


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
    """Write the PNG only if its bytes changed (avoids needless churn). The PNG
    is tagged with its true DPI (_BASE_DPI * scale) so it renders at the authored
    size with a bare \\includegraphics (no width override needed)."""
    new_bytes = pio.to_image(fig, format="png", scale=scale)
    new_bytes = _png_with_dpi(new_bytes, _BASE_DPI * scale)
    if output_path.exists() and output_path.read_bytes() == new_bytes:
        print(f"  [SmartSave] Skipping {output_path.name} (no changes)")
        return False
    output_path.write_bytes(new_bytes)
    print(f"  [SmartSave] Updating {output_path.name}")
    return True
