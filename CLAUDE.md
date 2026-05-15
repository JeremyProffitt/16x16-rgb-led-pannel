# Claude Code Guidelines for 10-Inch Unibody Rack Project

## Project Overview

This repository contains OpenSCAD designs for a unibody 10-inch server rack that prints in a single piece on the Bambu Labs H2D printer. The rack prints front-face-down with no supports required, features rounded exterior edges, and includes handle cutouts for portability.

### Key Design Constraints

- **Printer**: Bambu Labs H2D (single nozzle: 325 x 320 x 325 mm)
- **Print orientation**: Front face down on build plate
- **No supports**: All geometry must be self-supporting (max 45 deg overhang)
- **Wall thickness**: 5mm on all sides
- **Standard**: 10-inch rack (254mm panel width, EIA-310 derived hole pattern)

---

## 1. README.md Maintenance

The `README.md` must always be kept up-to-date and include rendered images of each SCAD design.

### Required Images

For **each** `.scad` file in the project, the README must display two images:

1. **Front-angle view**: Camera positioned at 45 deg azimuth and 45 deg elevation from the front face
2. **Rear-angle view**: Camera positioned at the opposite angle (225 deg azimuth, 45 deg elevation)

### Image Specifications

- Format: PNG
- Resolution: 1024x1024 pixels
- Background: Tomorrow color scheme
- Naming convention: `<scad_filename>_front.png` and `<scad_filename>_rear.png`

### Camera Settings

OpenSCAD camera parameter format: `--camera=translateX,translateY,translateZ,rotX,rotY,rotZ,distance`

Camera angles:
- **Front view**: `rotX=55, rotY=0, rotZ=45` with `--autocenter --viewall`
- **Rear view**: `rotX=55, rotY=0, rotZ=225` with `--autocenter --viewall`

### README Structure

```markdown
## Designs

### [Design Name]

| Front View | Rear View |
|------------|-----------|
| ![Front](https://github.com/<owner>/<repo>/releases/latest/download/<design>_front.png) | ![Rear](https://github.com/<owner>/<repo>/releases/latest/download/<design>_rear.png) |

[Description of the design and its purpose]

**Documentation**: [design.md](<design>.md)

**Download STL**: [design.stl](https://github.com/<owner>/<repo>/releases/latest/download/<design>.stl)
```

### GitHub Releases

Each release must include:
- All generated STL files
- All rendered PNG images (both views)
- The release pipeline automatically generates these artifacts

---

## 2. OpenSCAD Coding Conventions

### Coordinate System Convention

All designs use the following coordinate system (print orientation):

```openscad
/**
 * Coordinate System (print orientation):
 *   X = Rack width  (positive = right when facing rack front)
 *   Y = Rack height (positive = up in use orientation; along bed Y in print)
 *   Z = Rack depth  (positive = toward back; upward in print orientation)
 *
 * Origin: Front-bottom-left corner of rack outer shell
 * Z=0 is the front face, placed on the build plate
 */
```

### Dimension Variables

All measurements must be defined as named constants at the top of the file. **Never use hardcoded numbers in geometry.**

#### Naming Convention

Variables follow this pattern: `<scope>_<description>_mm`

- **Standard dimensions**: Prefix with `rack_`
  - `rack_panel_width_mm` - 10" panel width
  - `rack_unit_height_mm` - 1U height

- **Design dimensions**: Descriptive prefix
  - `wall_thickness_mm` - common wall thickness
  - `rail_depth_mm` - mounting rail depth
  - `handle_length_mm` - handle cutout length

- **Computed dimensions**: Derived from other variables
  - `outer_width_mm` - total outer width
  - `rack_height_mm` - total rack height

- **Always use `_mm` suffix** to indicate units

### Modular Function Design

Every distinct component must be defined in its own module:

```openscad
module rounded_box(w, h, d, r) { ... }
module inner_cavity() { ... }
module mounting_rail(x_start) { ... }
module mounting_holes(x_pos) { ... }
module handle_cutout(x_start) { ... }
module rack() { ... }
```

### Position and Alignment Documentation

Each module must include a comment block with:
- Purpose description
- Parameter descriptions
- Bounding box coordinates
- Connection/alignment notes

### Component Index Table

Include a master index of all components at the top of the file showing origin, size, and relationships.

### Debug and Visualization Modules

Every SCAD file must include:
- `debug_axes()` - coordinate axes visualization
- `assembly_colored()` - color-coded view
- `assembly_xray()` - transparent view for internal inspection

---

## 3. Design Rules for Support-Free Printing

### Critical Rules

1. **Front face down**: Z=0 is always the build plate contact surface
2. **Vertical walls only**: All walls extend along Z (print height) - no overhangs
3. **Handle bridges**: Side wall cutouts bridge only the wall thickness (5mm) - always printable
4. **No internal ceilings**: Open-back design eliminates bridging concerns
5. **Rounded edges along Z only**: Fillets on Z-parallel edges are vertical in print

### Overhang Checklist

Before adding any feature, verify:
- [ ] No horizontal surfaces above Z=0 that span more than wall_thickness
- [ ] No overhangs exceeding 45 degrees from vertical
- [ ] All holes are oriented along Z (vertical in print)
- [ ] Bridges span no more than wall_thickness_mm

---

## 4. 10-Inch Rack Standard Reference

### Key Dimensions

| Parameter | Imperial | Metric |
|-----------|----------|--------|
| Panel width | 10" | 254.0 mm |
| Rail-to-rail center | 9.312" | 236.525 mm |
| Rail width | 0.625" | 15.875 mm |
| Clear opening | 8.75" | 222.25 mm |
| 1U height | 1.75" | 44.45 mm |

### Hole Pattern (per 1U, from bottom)

| Hole | Imperial | Metric |
|------|----------|--------|
| 1st | 0.25" | 6.35 mm |
| 2nd | 0.875" | 22.225 mm |
| 3rd | 1.50" | 38.10 mm |

Hole spacings: 15.875mm, 15.875mm, 12.70mm (repeating across U boundaries)

---

## 5. Documentation Files

### Per-Design Documentation

For each `.scad` file, maintain a corresponding `.md` file in the same directory.

| SCAD File | Documentation File |
|-----------|-------------------|
| `rack.scad` | `rack.md` |

### Documentation File Structure

Each documentation file must contain:
- Overview and purpose
- Dimensions table with all parameters
- ASCII cross-section diagrams (top view, side view, front view)
- Component descriptions with positions and bounding boxes
- Print settings and assembly notes
- Changelog

### Hardware Component References

Standalone reference docs for external hardware integrated into designs (dimensions, mounting hole patterns, cable clearances, authoritative vendor sources) live alongside the SCAD files:

| Component | Reference File |
|-----------|----------------|
| Waveshare 7inch HDMI LCD (B) | `waveshare-7inch-lcd-display-b.md` |

Consult these before designing any mount, case, or bezel that integrates the listed hardware — all dimensions are verified against the vendor's mechanical drawings.

---

## 6. Build Scripts and Generated Files

### Scripts

- `build.sh` - Bash script for Linux/macOS
- `generate.bat` - Batch script for Windows

Both scripts:
1. Find all `.scad` files
2. Generate STL files (binstl format)
3. Generate PNG images (front and rear views, 1024x1024, Tomorrow scheme)
4. Output to `output/` directory

### .gitignore

Generated files are never committed. The CI pipeline generates them for releases.

---

## 7. Workflow Summary

1. **Development**: Create/modify `.scad` files following modular conventions
2. **Verify print fit**: Ensure model fits within H2D build volume (325x320x325mm)
3. **Check supports**: Verify no overhangs require support material
4. **Documentation**: Update corresponding `.md` file with ASCII diagrams
5. **Local Testing**: Run `build.sh` or `generate.bat` for local STL/image generation
6. **README Update**: Ensure `README.md` references designs and release downloads
7. **Release**: GitHub Actions pipeline generates artifacts and attaches to release

---

## 8. Quick Reference: Required Updates Checklist

When creating or modifying a `.scad` file:

- [ ] Coordinate system documented at top of file
- [ ] All dimensions as named variables with `_mm` suffix
- [ ] Print fit assertions included
- [ ] Support-free design verified
- [ ] Component index table updated
- [ ] Each module has position/bounding box comments
- [ ] Debug modules included (axes, colored, xray)
- [ ] Corresponding `.md` created/updated with ASCII diagrams
- [ ] `README.md` updated with design entry
