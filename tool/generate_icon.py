"""Generate ZÜVO app icons for all Android densities."""
from PIL import Image, ImageDraw, ImageFont
import os

# Colors
NAVY = (10, 22, 40)       # 0x0A1628
TEAL = (46, 221, 200)     # 0x2EDDC8
LIME = (126, 217, 87)     # 0x7ED957

def generate_icon(size):
    """Generate a ZÜVO icon at given size with full name."""
    img = Image.new('RGBA', (size, size), NAVY + (255,))
    draw = ImageDraw.Draw(img)

    # Try to load a bold font, fall back to default
    font_size = int(size * 0.28)
    font = None
    for name in ['arialbd.ttf', 'Arial Bold.ttf', 'calibrib.ttf', 'segoeui.ttf', 'impact.ttf']:
        try:
            font = ImageFont.truetype(name, font_size)
            break
        except (OSError, IOError):
            continue
    if font is None:
        font = ImageFont.load_default()

    # Measure "ZÜV" and "O" separately for two-tone rendering
    text_zuv = "ZÜV"
    text_o = "O"

    bbox_full = draw.textbbox((0, 0), text_zuv + text_o, font=font)
    full_w = bbox_full[2] - bbox_full[0]
    full_h = bbox_full[3] - bbox_full[1]

    # Center position
    x_start = (size - full_w) / 2 - bbox_full[0]
    y_start = (size - full_h) / 2 - bbox_full[1]

    # Draw "ZÜV" in teal
    draw.text((x_start, y_start), text_zuv, fill=TEAL, font=font)

    # Measure width of "ZÜV" to offset "O"
    bbox_zuv = draw.textbbox((x_start, y_start), text_zuv, font=font)
    x_o = bbox_zuv[2]

    # Draw "O" in lime
    draw.text((x_o, y_start), text_o, fill=LIME, font=font)

    # Add subtle ECG line below the text
    line_y = y_start + full_h + size * 0.06
    line_left = size * 0.15
    line_right = size * 0.85
    mid = size * 0.5
    spike_h = size * 0.07
    lw = max(2, int(size * 0.02))

    draw.line(
        [(line_left, line_y),
         (mid - size * 0.08, line_y),
         (mid - size * 0.04, line_y - spike_h * 0.5),
         (mid - size * 0.02, line_y - spike_h * 1.8),
         (mid + size * 0.02, line_y + spike_h * 1.2),
         (mid + size * 0.04, line_y),
         (mid + size * 0.08, line_y - spike_h * 0.3),
         (mid + size * 0.12, line_y),
         (line_right, line_y)],
        fill=TEAL, width=lw, joint='curve'
    )

    return img


# Generate all sizes
densities = {
    'mipmap-mdpi': 48,
    'mipmap-hdpi': 72,
    'mipmap-xhdpi': 96,
    'mipmap-xxhdpi': 144,
    'mipmap-xxxhdpi': 192,
}

base = os.path.join(os.path.dirname(__file__), '..', 'android', 'app', 'src', 'main', 'res')

for folder, size in densities.items():
    icon = generate_icon(size)
    outdir = os.path.join(base, folder)
    os.makedirs(outdir, exist_ok=True)
    path = os.path.join(outdir, 'ic_launcher.png')
    icon.save(path, 'PNG')
    print(f'  {folder}/ic_launcher.png ({size}x{size})')

# Also save a high-res version for store listing
icon_1024 = generate_icon(1024)
assets_dir = os.path.join(os.path.dirname(__file__), '..', 'assets', 'icon')
os.makedirs(assets_dir, exist_ok=True)
icon_1024.save(os.path.join(assets_dir, 'zuvo_icon.png'), 'PNG')
print('  assets/icon/zuvo_icon.png (1024x1024)')
print('Done!')
