"""
Shared helpers for the working-paper figure scripts in this folder.

  - chart_render_px:  read a chart's *render* (original) size (cm) -> pixels
  - chart_display_cm: read a chart's *display* size (cm) shown in the paper
  - smart_save_image: write a PNG, tagged so its natural size in LaTeX equals the
                      requested display size, only when its bytes change

Both sizes live in chartTable.csv. RenderWidth/RenderHeight set the plotly canvas
(hence font sizes and resolution); DisplayWidth/DisplayHeight set the size the
figure appears at in the paper, applied via a DPI tag so a bare \\includegraphics
renders it there. The two are independent: shrink DisplayWidth to make a figure
smaller in the paper without touching its fonts. chartTable.csv is expected
alongside this module. Depends only on the standard library and plotly.
"""
import struct
import zlib
from pathlib import Path

import plotly.io as pio

_THIS_DIR = Path(__file__).resolve().parent
CONFIG_CSV = _THIS_DIR / "chartTable.csv"
_CM_PER_INCH = 2.54
_CM_TO_PX = 37.795275591  # 1 cm at 96 DPI (the render canvas's logical DPI)
_PT_PER_INCH = 72.27       # TeX points per inch (LaTeX's "pt")

# Steady-state public debt in percent of annual GDP (Table 2 calibration targets).
DEBT_SS_PCT = {"AE": 78.8, "EM": 46.4}


def debt_to_ratio_change(df):
    """Convert every `<model>___by_yss` column in `df` from the numerator-only
    measure exported by the model (change in debt over steady-state annual GDP,
    in percentage points) to the change in the measured debt-to-GDP ratio, with
    debt divided by current final demand:

        (bbar + delta) / (1 + yd/100) - bbar

    where bbar is the country group's steady-state debt ratio (EM_-prefixed
    models use the EMDE target) and yd the output percent deviation. Columns
    without a matching `<model>___yd` series are left unchanged."""
    for col in [c for c in df.columns if c.endswith("___by_yss")]:
        model = col[: -len("___by_yss")]
        yd_col = f"{model}___yd"
        if yd_col not in df.columns:
            continue
        bbar = DEBT_SS_PCT["EM" if model.startswith("EM_") else "AE"]
        df[col] = (bbar + df[col]) / (1.0 + df[yd_col] / 100.0) - bbar
    return df


def font_px_for_pt(target_pt, render_width_px, display_width_cm):
    """Canvas font size (px) so chart text renders at `target_pt` points on the
    page, given the render width (px) and the on-page display width (cm). Keeps
    figure text at a fixed point size however the chart is scaled into the paper:
    a chart shown at half its render width needs double the canvas font px."""
    render_width_cm = render_width_px / _CM_TO_PX
    return round(target_pt * (96.0 / _PT_PER_INCH) * render_width_cm / display_width_cm, 1)


def _read_cm(stem, width_col, height_col, default_cm):
    """Read a (width_cm, height_cm) pair from chartTable.csv by matching pngFile.
    Falls back to default_cm if the file, row, or columns are missing/blank."""
    import csv
    width_cm, height_cm = default_cm
    if CONFIG_CSV.exists():
        with CONFIG_CSV.open(newline="", encoding="utf-8") as handle:
            for row in csv.DictReader(handle):
                if Path(row.get("pngFile", "")).name == f"{stem}.png":
                    if row.get(width_col) and row.get(height_col):
                        width_cm, height_cm = float(row[width_col]), float(row[height_col])
                    break
    return width_cm, height_cm


def chart_render_px(stem, default_cm):
    """Original chart (render canvas) size in pixels, from RenderWidth/RenderHeight
    (cm) in chartTable.csv. This is the plotly canvas, so it sets font sizes and
    resolution. Falls back to default_cm if the row/columns are missing."""
    width_cm, height_cm = _read_cm(stem, "RenderWidth", "RenderHeight", default_cm)
    return round(width_cm * _CM_TO_PX), round(height_cm * _CM_TO_PX)


def chart_display_cm(stem, default_cm):
    """Display size (width_cm, height_cm) shown in the paper, from DisplayWidth/
    DisplayHeight (cm) in chartTable.csv. Applied via the DPI tag, not the canvas.
    Falls back to default_cm if the row/columns are missing."""
    return _read_cm(stem, "DisplayWidth", "DisplayHeight", default_cm)


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


def write_pdf(fig, output_path, render_width_px, display_width_cm):
    """Write a vector PDF sized to the display width (cm), matching the PNG. The
    figure is laid out on the (high-resolution) render canvas; the page is then
    rescaled so its natural size equals the display size, so a bare
    \\includegraphics{...pdf} renders it at the paper size. Assumes the display
    and render aspect ratios match (height follows from the scale).

    kaleido v1 (HeadlessChrome backend) mishandles fractional `scale` on vector
    export -- it shrinks the page but clips the content at the bottom -- so the
    figure is exported at scale 1 and the page is rescaled with Ghostscript."""
    import subprocess
    import tempfile

    aspect = fig.layout.height / fig.layout.width
    width_pt = display_width_cm / _CM_PER_INCH * 72.0
    height_pt = width_pt * aspect
    with tempfile.TemporaryDirectory() as tmp:
        full_pdf = Path(tmp) / "full.pdf"
        fig.write_image(str(full_pdf), format="pdf", scale=1)
        subprocess.run(
            ["gs", "-q", "-dBATCH", "-dNOPAUSE", "-sDEVICE=pdfwrite",
             f"-dDEVICEWIDTHPOINTS={width_pt:.2f}",
             f"-dDEVICEHEIGHTPOINTS={height_pt:.2f}",
             "-dFIXEDMEDIA", "-dPDFFitPage",
             "-o", str(output_path), str(full_pdf)],
            check=True,
        )
    align_legend_rows(output_path)


# Match the roughly 15.75-point row pitch of the paper's other wrapped legends.
# Explicit row labels keep this export adjustment separate from subplot titles.
_LEGEND_ROWS = {
    "efficiencyAE_yd": (
        "Spending increase (AE, benchmark)", "Efficiency improvement (EMDE)"),
    "policyEfficiencyEM_yd": (
        "Closing the gap in the baseline",
        "Efficiency improvement from a higher initial gap"),
    "humanCapital_yd_IRF": ("Joint human capital + R&D", "R&D spending"),
}


def align_legend_rows(output_path, spacing_pt=15.75):
    """Align selected exported legend rows without changing plot geometry.

    Work in PDF points so figures with different canvas scales have the same
    printed row spacing. Copy vector strips, preserving fonts and legend keys.
    Refresh the companion PNG from the corrected PDF at its existing width.
    """
    import unicodedata
    import fitz

    output_path = Path(output_path)
    labels = _LEGEND_ROWS.get(output_path.stem)
    if labels is None:
        return
    source = fitz.open(output_path)
    page = source[0]
    lines = [line for block in page.get_text("dict")["blocks"]
             for line in block.get("lines", [])]
    rows = []
    for label in labels:
        matches = [line for line in lines if unicodedata.normalize(
            "NFKC", "".join(span["text"] for span in line["spans"])) == label]
        if len(matches) != 1:
            raise ValueError(f"Expected one legend label {label!r} in {output_path}")
        line = matches[0]
        rows.append((line["spans"][0]["origin"][1], fitz.Rect(line["bbox"])))
    shifts = [rows[0][0] + i * spacing_pt - row[0]
              for i, row in enumerate(rows)]
    if max(abs(shift) for shift in shifts) < 0.01:
        source.close()
        return
    clips = [fitz.Rect(0, box.y0 - 2, page.rect.width, box.y1 + 2)
             for _, box in rows]
    result = fitz.open()
    target = result.new_page(width=page.rect.width, height=page.rect.height)
    target.show_pdf_page(target.rect, source, 0)
    # Erase just the legend band, then place each original row at its new height.
    band = fitz.Rect(0, min(c.y0 for c in clips), page.rect.width,
                     max(c.y1 + max(0, d) for c, d in zip(clips, shifts)))
    target.add_redact_annot(band, fill=(1, 1, 1))
    target.apply_redactions(images=0, graphics=0)
    for clip, shift in zip(clips, shifts):
        dest = fitz.Rect(clip.x0, clip.y0 + shift, clip.x1, clip.y1 + shift)
        target.show_pdf_page(dest, source, 0, clip=clip, overlay=True)
    if len(source) > 1:
        result.insert_pdf(source, from_page=1)
    target = result[0]
    data = result.tobytes(garbage=4, deflate=True)
    source.close()
    output_path.write_bytes(data)
    png_path = output_path.with_suffix(".png")
    if png_path.exists():
        width = int.from_bytes(png_path.read_bytes()[16:20], "big")
        zoom = width / target.rect.width
        bitmap = target.get_pixmap(matrix=fitz.Matrix(zoom, zoom), alpha=False)
        png_path.write_bytes(_png_with_dpi(bitmap.tobytes("png"), zoom * 72))
    result.close()
