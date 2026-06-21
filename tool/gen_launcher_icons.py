#!/usr/bin/env python3
"""Generate Benny launcher-icon source PNGs for each build flavor.

Reproduces assets/images/logo_tile.svg (navy squircle + amber house-mark) and
adds a diagonal corner-ribbon watermark for the non-prod flavors so staging /
uat builds are distinguishable on the home screen.

Outputs (assets/launcher/):
  ic_launcher_<flavor>.png        full squircle tile  -> iOS + legacy Android
  adaptive_bg.png                 full-bleed navy gradient -> Android adaptive bg
  adaptive_fg_<flavor>.png        house + ribbon in safe zone -> adaptive fg

Only the *launcher* icon (shown outside the app) is affected — in-app logos are
left untouched. Run:  python3 tool/gen_launcher_icons.py
"""
import os
from PIL import Image, ImageDraw, ImageFont

OUT_DIR = os.path.join(os.path.dirname(__file__), "..", "assets", "launcher")
SS = 4                      # supersample factor for anti-aliasing
RES = 1024                  # final icon size
SIZE = RES * SS             # supersampled working size
R = SIZE / 240.0            # SVG(240) -> supersampled pixel scale

NAVY_TOP = (26, 60, 94)     # #1A3C5E
NAVY_BOT = (20, 47, 73)     # #142F49
AMBER = (232, 160, 32)      # #E8A020
WHITE = (255, 255, 255)
DOOR_NAVY = (26, 60, 94)    # #1A3C5E
UAT_RED = (214, 83, 79)     # #D6534F

FONT_PATH = "/System/Library/Fonts/Supplemental/Arial Bold.ttf"

# flavor -> (ribbon text | None, ribbon bg, ribbon text color)
FLAVORS = {
    "prod": (None, None, None),
    "staging": ("STG", AMBER, NAVY_BOT),
    "uat": ("UAT", UAT_RED, WHITE),
}


def px(v):
    return v * R


def house_xy(x, y):
    """Apply the SVG group transform translate(36 36) scale(0.7)."""
    return 36 + 0.7 * x, 36 + 0.7 * y


def diagonal_gradient(c0, c1):
    """Top-left -> bottom-right linear gradient, matching the SVG navyTile."""
    grad = Image.new("RGB", (SIZE, SIZE))
    pixels = grad.load()
    for j in range(SIZE):
        for i in range(SIZE):
            t = (i + j) / (2.0 * (SIZE - 1))
            pixels[i, j] = tuple(int(c0[k] + (c1[k] - c0[k]) * t) for k in range(3))
    return grad


def rounded_mask(box, radius):
    m = Image.new("L", (SIZE, SIZE), 0)
    ImageDraw.Draw(m).rounded_rectangle(box, radius=radius, fill=255)
    return m


def draw_house(draw):
    # Roof — filled triangle + rounded stroke (stroke-width 12 * 0.7 = 8.4 SVG units).
    roof = [house_xy(120, 36), house_xy(202, 110), house_xy(38, 110)]
    roof_px = [(px(x), px(y)) for x, y in roof]
    draw.polygon(roof_px, fill=AMBER)
    draw.line(roof_px + [roof_px[0]], fill=AMBER, width=int(px(8.4)), joint="curve")

    wl, wr = house_xy(60, 104), house_xy(180, 208)
    draw.rounded_rectangle([px(wl[0]), px(wl[1]), px(wr[0]), px(wr[1])],
                           radius=px(9.8), fill=WHITE)

    for wx in (74, 142):
        a, b = house_xy(wx, 128), house_xy(wx + 24, 152)
        draw.rounded_rectangle([px(a[0]), px(a[1]), px(b[0]), px(b[1])],
                               radius=px(4.2), fill=AMBER)

    dl, dtop, dr = house_xy(104, 208), house_xy(104, 166), house_xy(136, 208)
    cx, cy = house_xy(120, 166)
    rad = 0.7 * 16
    draw.rectangle([px(dl[0]), px(dtop[1]), px(dr[0]), px(dl[1])], fill=DOOR_NAVY)
    draw.pieslice([px(cx - rad), px(cy - rad), px(cx + rad), px(cy + rad)],
                  180, 360, fill=DOOR_NAVY)
    hx, hy = house_xy(129, 189)
    hr = 0.7 * 3
    draw.ellipse([px(hx - hr), px(hy - hr), px(hx + hr), px(hy + hr)], fill=AMBER)


def house_layer():
    img = Image.new("RGBA", (SIZE, SIZE), (0, 0, 0, 0))
    draw_house(ImageDraw.Draw(img))
    return img


def ribbon_layer(center, text, bg, fg, clip_mask):
    """A 45° ribbon centered at `center`, clipped to `clip_mask`."""
    band_w, band_h = int(SIZE * 1.7), int(SIZE * 0.155)
    band = Image.new("RGBA", (band_w, band_h), bg + (255,))
    bd = ImageDraw.Draw(band)
    font = ImageFont.truetype(FONT_PATH, int(band_h * 0.62))
    tb = bd.textbbox((0, 0), text, font=font)
    bd.text(((band_w - (tb[2] - tb[0])) / 2 - tb[0],
             (band_h - (tb[3] - tb[1])) / 2 - tb[1]),
            text, font=font, fill=fg + (255,))
    rot = band.rotate(45, expand=True, resample=Image.BICUBIC)
    layer = Image.new("RGBA", (SIZE, SIZE), (0, 0, 0, 0))
    layer.alpha_composite(rot, (int(center - rot.width / 2), int(center - rot.height / 2)))
    clipped = Image.new("RGBA", (SIZE, SIZE), (0, 0, 0, 0))
    clipped.paste(layer, (0, 0), clip_mask)
    return clipped


def save(img, name):
    os.makedirs(OUT_DIR, exist_ok=True)
    img.resize((RES, RES), Image.LANCZOS).save(os.path.join(OUT_DIR, name))
    print("wrote", name)


def main():
    grad = diagonal_gradient(NAVY_TOP, NAVY_BOT)
    house = house_layer()
    full_mask = Image.new("L", (SIZE, SIZE), 255)  # full-bleed: OS rounds corners

    # Shared Android adaptive background — full-bleed gradient (system masks it).
    bg = Image.new("RGBA", (SIZE, SIZE))
    bg.paste(grad, (0, 0))
    save(bg, "adaptive_bg.png")

    # Adaptive foreground: house scaled up to better fill the central safe zone.
    fg_scale = 1.28
    fg_house = house.resize((int(SIZE * fg_scale), int(SIZE * fg_scale)), Image.LANCZOS)
    off = int((SIZE - fg_house.width) / 2)
    # Safe-zone square (central ~62%) used to clip the foreground ribbon ends.
    sz0, sz1 = int(SIZE * 0.19), int(SIZE * 0.81)
    safe_mask = Image.new("L", (SIZE, SIZE), 0)
    ImageDraw.Draw(safe_mask).rectangle([sz0, sz0, sz1, sz1], fill=255)

    for flavor, (text, rbg, rfg) in FLAVORS.items():
        # Full-bleed tile for iOS + legacy Android (the OS applies its own
        # corner rounding, so no alpha corners — avoids white corners on iOS).
        tile = Image.new("RGBA", (SIZE, SIZE))
        tile.paste(grad, (0, 0))
        tile.alpha_composite(house)
        if text:
            tile = Image.alpha_composite(tile, ribbon_layer(int(SIZE * 0.80), text, rbg, rfg, full_mask))
        save(tile, f"ic_launcher_{flavor}.png")

        # Adaptive foreground (transparent, house + safe-zone ribbon).
        fg = Image.new("RGBA", (SIZE, SIZE), (0, 0, 0, 0))
        fg.alpha_composite(fg_house, (off, off))
        if text:
            fg = Image.alpha_composite(fg, ribbon_layer(int(SIZE * 0.70), text, rbg, rfg, safe_mask))
        save(fg, f"adaptive_fg_{flavor}.png")


if __name__ == "__main__":
    main()
