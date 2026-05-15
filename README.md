# 16×16 RGB LED Panel — OpenSCAD Designs

OpenSCAD designs for a 16×16 WS2812B LED panel system. All parts print face-down on the Bambu Labs H2D with no supports required.

## Designs

---

### Diffuse LED Grid (v1)

| Front View | Rear View |
|------------|-----------|
| ![Front](https://github.com/JeremyProffitt/16x16-rgb-led-pannel/releases/latest/download/diffuse_led_grid_front.png) | ![Rear](https://github.com/JeremyProffitt/16x16-rgb-led-pannel/releases/latest/download/diffuse_led_grid_rear.png) |

Light-isolating diffuser grid for a 16×16 WS2812B LED panel. One 8×8 mm cell per LED; 2 mm walls prevent light bleed between pixels. 160×160×4 mm overall with a 0.2 mm translucent base layer.

**Download STL**: [diffuse_led_grid.stl](https://github.com/JeremyProffitt/16x16-rgb-led-pannel/releases/latest/download/diffuse_led_grid.stl)

---

### Diffuse LED Grid v2 (with Mounting Border)

| Front View | Rear View |
|------------|-----------|
| ![Front](https://github.com/JeremyProffitt/16x16-rgb-led-pannel/releases/latest/download/diffuse_led_grid_v2_front.png) | ![Rear](https://github.com/JeremyProffitt/16x16-rgb-led-pannel/releases/latest/download/diffuse_led_grid_v2_rear.png) |

Extended diffuser with an 8 mm mounting border on each side — 176×176×4 mm overall. Includes 12 countersunk M3 screw holes (3 per side, ⌀5 mm countersink at the bottom face). Designed to sandwich against the lid using M3 screws and hex nuts.

**Download STL**: [diffuse_led_grid_v2.stl](https://github.com/JeremyProffitt/16x16-rgb-led-pannel/releases/latest/download/diffuse_led_grid_v2.stl)

---

### LED Grid Lid

| Front View | Rear View |
|------------|-----------|
| ![Front](https://github.com/JeremyProffitt/16x16-rgb-led-pannel/releases/latest/download/led_grid_lid_front.png) | ![Rear](https://github.com/JeremyProffitt/16x16-rgb-led-pannel/releases/latest/download/led_grid_lid_rear.png) |

Back cover for the LED grid assembly. Matches the 176×176 mm footprint of diffuse_led_grid_v2 and is 12 mm tall. Features:

- **M3 hex nut pockets** (12×) recessed into the bottom face — screws enter from the diffuser side
- **Centre recess** — 164×164 mm, 1 mm deep, keeps the PCB from resting on the lid surface
- **6× wire cutouts** — 40×40 mm pockets, 4 mm deep from the top, in two rows (front and rear)
- **Wire-run channel** — 136×46×10 mm trough connecting both wire-cutout rows, centred at Y=88
- **40 mm fan mount** — ⌀37 mm airflow opening with 4× M3 holes on a 32 mm pattern, through the wire-run floor
- **2× X-through-holes** — ⌀5 mm running the full width at Y=73 and Y=103, for cable routing or rods
- **4× zip-tie arch slots** — one per corner, ramp-arch profile cut from the bottom face with a retaining bar

**Download STL**: [led_grid_lid.stl](https://github.com/JeremyProffitt/16x16-rgb-led-pannel/releases/latest/download/led_grid_lid.stl)

---

## Build

### Local (Windows)

```bat
generate.bat
```

### Local (Linux / macOS)

```sh
./build.sh
```

Generated STLs and PNGs are written to `output/` (git-ignored).

### CI — GitHub Actions

Push a version tag to trigger a release:

```sh
git tag v1.0.0
git push origin v1.0.0
```

The workflow installs OpenSCAD, renders all designs, and attaches STLs and PNGs to the GitHub release automatically.

## Hardware

| Part | Spec |
|------|------|
| LED matrix | WS2812B 16×16, 160×160 mm, 10 mm pitch |
| Fasteners | M3×? screws + M3 standard hex nuts (DIN 934) |
| Fan (optional) | 40×40 mm, 32 mm hole pattern |

## Printer

Bambu Labs H2D — build volume 325×320×325 mm. All parts print face-down with no supports.
