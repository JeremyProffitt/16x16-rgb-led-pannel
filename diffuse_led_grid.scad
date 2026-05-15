/**
 * diffuse_led_grid.scad
 *
 * Light-isolating diffuser grid for a 16×16 WS2812B LED panel.
 * One cell per LED; walls prevent bleed between pixels.
 * Print face-down (Z=0 on build plate). No supports required.
 *
 * Coordinate System (print orientation):
 *   X = Width  (positive = right when facing front)
 *   Y = Height (positive = back / up-in-use)
 *   Z = Depth  (positive = upward in print; Z=0 on build plate)
 *
 * Origin: front-bottom-left corner of outer plate
 * Z=0 is the LED-facing base, placed on the build plate.
 *
 * Component Index:
 * ┌──────────────────┬──────────────────────────┬───────────────────┬─────────────────────────┐
 * │ Component        │ Origin (relative)         │ Size              │ Notes                   │
 * ├──────────────────┼──────────────────────────┼───────────────────┼─────────────────────────┤
 * │ outer_plate      │ (0, 0, 0)                 │ 160×160×4 mm      │ Rounded corners r=1 mm  │
 * │ cell[col][row]   │ (1+col×10, 1+row×10, 0.2)│ 8×8×3.8 mm        │ 256 total; open at top  │
 * └──────────────────┴──────────────────────────┴───────────────────┴─────────────────────────┘
 */

// ============================================================
// LED Panel Specs  (WS2812B 16×16)
// ============================================================
panel_width_mm   = 160.0;   // panel width
panel_height_mm  = 160.0;   // panel height
led_count_x      = 16;      // LEDs across
led_count_y      = 16;      // LEDs tall
led_pitch_mm     = 10.0;    // center-to-center spacing

// ============================================================
// Diffuser Dimensions
// ============================================================
total_thickness_mm  = 4.0;   // overall Z height
base_thickness_mm   = 0.2;   // solid diffusing base (Z=0 to Z=0.2)
outer_border_mm     = 1.0;   // outer wall thickness on each side
wall_thickness_mm   = 2.0;   // inter-cell wall thickness
outer_corner_r_mm   = 1.0;   // outer plate XY corner radius

// ============================================================
// Derived (do not edit)
// ============================================================
cell_size_mm    = led_pitch_mm - wall_thickness_mm;      // 8.0 mm
cavity_depth_mm = total_thickness_mm - base_thickness_mm; // 3.8 mm
outer_width_mm  = panel_width_mm;   // 160 mm  (1 + 16×8 + 15×2 + 1 = 160)
outer_height_mm = panel_height_mm;  // 160 mm

$fn = 64;

// ============================================================
// Build-volume assertions (Bambu H2D: 325×320×325 mm)
// ============================================================
assert(outer_width_mm  <= 325, "Width exceeds H2D X build volume");
assert(outer_height_mm <= 320, "Height exceeds H2D Y build volume");
assert(total_thickness_mm <= 325, "Thickness exceeds H2D Z build volume");

// ============================================================
// Primitive helpers
// ============================================================

// 2-D rounded rectangle, used for outer plate footprint
// w, h: overall extents; r: corner radius
// Bounding box: (0,0) to (w, h)
module rounded_rect_2d(w, h, r) {
    hull() {
        translate([r,   r  ]) circle(r);
        translate([w-r, r  ]) circle(r);
        translate([r,   h-r]) circle(r);
        translate([w-r, h-r]) circle(r);
    }
}

// ============================================================
// Components
// ============================================================

// Solid outer plate (before cells are subtracted)
// Bounding box: (0,0,0) to (outer_width_mm, outer_height_mm, total_thickness_mm)
module outer_plate() {
    linear_extrude(total_thickness_mm)
        rounded_rect_2d(outer_width_mm, outer_height_mm, outer_corner_r_mm);
}

// Single cell cavity for column col (0-based), row row (0-based)
// The cavity is open at Z=total_thickness_mm and floored at Z=base_thickness_mm
// Bounding box within plate:
//   X: (outer_border_mm + col×led_pitch_mm) to (+cell_size_mm)
//   Y: (outer_border_mm + row×led_pitch_mm) to (+cell_size_mm)
//   Z: base_thickness_mm to total_thickness_mm
module cell_cavity(col, row) {
    translate([
        outer_border_mm + col * led_pitch_mm,
        outer_border_mm + row * led_pitch_mm,
        base_thickness_mm
    ])
    cube([cell_size_mm, cell_size_mm, cavity_depth_mm + 0.01]);
}

// Full 16×16 grid of cell cavities
module cell_grid() {
    for (col = [0 : led_count_x - 1])
        for (row = [0 : led_count_y - 1])
            cell_cavity(col, row);
}

// Complete diffuser assembly
// Bounding box: (0,0,0) to (160, 160, 4)
module diffuser() {
    difference() {
        outer_plate();
        cell_grid();
    }
}

// ============================================================
// Debug / Visualization
// ============================================================

// Coordinate-axis indicators at origin
module debug_axes(len = 25) {
    color("red")   cylinder(r = 0.4, h = len);
    color("green") rotate([-90, 0, 0]) cylinder(r = 0.4, h = len);
    color("blue")  rotate([0, 90, 0])  cylinder(r = 0.4, h = len);
}

// Opaque, color-coded assembly view
module assembly_colored() {
    color("white") diffuser();
}

// Transparent X-ray view to inspect base and wall geometry
module assembly_xray() {
    color("cyan", 0.25) diffuser();
}

// ============================================================
// Render
// ============================================================
diffuser();
// debug_axes();
// assembly_xray();
