"""
Shared helpers for the working-paper figure scripts in this folder.

  - chart_size_cm:    read a chart's *display* size (cm) from chartTable.csv
  - smart_save_image: write a PNG, tagged so its natural size in LaTeX equals the
                      requested display size, only when its bytes change

Each chart is rendered at a fixed internal canvas (set in the script — this is
what controls font sizes and quality), then tagged with a DPI chosen so a bare
\\includegraphics renders it at the display size from chartTable.csv. Shrinking a
chart in the paper is therefore a pure display change: edit Width/Height in
chartTable.csv and the canvas/fonts are untouched. chartTable.csv is expected
alongside this module. Depends only on the standard library and plotly.
"""
import struct
import zlib
from pathlib import Path

import plotly.io as pio

_THIS_DIR = Path(__file__).resolve().parent
CONFIG_CSV = _THIS_DIR / "chartTable.csv"
_CM_PER_INCH = 2.54


def chart_size_cm(stem, default_cm):
    """Display size (width_cm, height_cm) for a chart, read from chartTable.csv by
    matching pngFile. Falls back to default_cm if the file or row is missing."""
    import csv
    width_cm, height_cm = default_cm
    if CONFIG_CSV.exists():
        with CONFIG_CSV.open(newline="", encoding="utf-8") as handle:
            for row in csv.DictReader(handle):
                if Path(row.get("pngFile", "")).name == f"{stem}.png":
                    width_cm, height_cm = float(row["Width"]), float(row["Height"])
                    break
    return width_cm, height_cm


def _png_with_dpi(png_bytes, dpi):
    """Insert a pHYs chunk so the PNG reports `dpi`. kaleido writes no pHYs, so we
    splice one in right after IHDR without re-encoding the image data."""
    ppm = int(round(dpi / _CM_PER_INCH * 100))  # pixels per metre (pHYs unit 1 = metre)
    body = b"pHYs" + struct.pack(">IIB", ppm, ppm, 1)
    chunk = struct.pack(">I", 9) + body + struct.pack(">I", zlib.crc32(body) & 0xFFFFFFFF)
    ihdr_end = 8 + 4 + 4 + 13 + 4  # signature + IHDR (len + type + 13 data + crc)
    return png_bytes[:ihdr_end] + chunk + png_bytes[ihdr_end:]


def smart_save_image(fig, output_path, display_cm, scale=2):
    """Render `fig` and tag the PNG so a bare \\includegraphics shows it at
    display_cm = (width_cm, height_cm), aspect preserved (the image fits inside
    that box). Writes only when the bytes change (avoids needless churn)."""
    new_bytes = pio.to_image(fig, format="png", scale=scale)
    px_w = int.from_bytes(new_bytes[16:20], "big")   # IHDR width
    px_h = int.from_bytes(new_bytes[20:24], "big")   # IHDR height
    width_cm, height_cm = display_cm
    # DPI that fits the bitmap inside the display box without distortion.
    dpi = max(px_w / (width_cm / _CM_PER_INCH), px_h / (height_cm / _CM_PER_INCH))
    new_bytes = _png_with_dpi(new_bytes, dpi)
    if output_path.exists() and output_path.read_bytes() == new_bytes:
        print(f"  [SmartSave] Skipping {output_path.name} (no changes)")
        return False
    output_path.write_bytes(new_bytes)
    print(f"  [SmartSave] Updating {output_path.name}")
    return True
