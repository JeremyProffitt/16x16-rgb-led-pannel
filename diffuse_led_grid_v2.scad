/**
 * diffuse_led_grid_v2.scad
 *
 * Light-isolating diffuser grid for a 16×16 WS2812B LED panel.
 * Extended 8 mm on each side for a mounting border with 12 countersunk
 * M3 screw holes (3 per side). Screws enter from the bottom (Z=0).
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
 * ┌──────────────────────┬──────────────────────────┬────────────────┬─────────────────────────────────┐
 * │ Component            │ Origin (relative)         │ Size           │ Notes                           │
 * ├──────────────────────┼──────────────────────────┼────────────────┼─────────────────────────────────┤
 * │ outer_plate          │ (0, 0, 0)                 │ 176×176×4 mm   │ Rounded corners r=1 mm          │
 * │ cell[col][row]       │ (9+col×10, 9+row×10, 0.2)│ 8×8×3.8 mm     │ 256 total; open at top          │
 * │ screw_hole (×12)     │ 4 mm from each outer edge │ ⌀3 shaft       │ Countersunk ⌀5 at Z=0 (bottom) │
 * └──────────────────────┴──────────────────────────┴────────────────┴─────────────────────────────────┘
 */

include <common.scad>

// ============================================================
// Diffuser-specific dimensions
// ============================================================
total_thickness_mm  = 4.0;   // overall Z height
base_thickness_mm   = 0.2;   // solid diffusing base (Z=0 to Z=0.2)
cavity_depth_mm     = total_thickness_mm - base_thickness_mm;  // 3.8 mm

// ============================================================
// Build-volume assertions (Bambu H2D: 325×320×325 mm)
// ============================================================
assert(outer_width_mm  <= 325, "Width exceeds H2D X build volume");
assert(outer_height_mm <= 320, "Height exceeds H2D Y build volume");
assert(total_thickness_mm <= 325, "Thickness exceeds H2D Z build volume");

// ============================================================
// Components
// ============================================================

// Solid outer plate (before subtraction)
// Bounding box: (0,0,0) to (176, 176, 4)
module outer_plate() {
    linear_extrude(total_thickness_mm)
        rounded_rect_2d(outer_width_mm, outer_height_mm, outer_corner_r_mm);
}

// Single cell cavity for col, row (0-based)
// Open at Z=total_thickness_mm, floored at Z=base_thickness_mm
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

// Countersunk screw hole centred at origin, running +Z through full plate.
// Screw enters from the BOTTOM face (Z=0); countersink cone opens downward.
module countersunk_hole() {
    union() {
        // through-shaft
        translate([0, 0, -0.01])
            cylinder(h = total_thickness_mm + 0.02, r = screw_dia_mm / 2);
        // countersink cone at bottom face: wide at Z=0, narrows to shaft diameter
        translate([0, 0, -0.01])
            cylinder(
                h  = countersink_depth_mm + 0.01,
                r1 = head_dia_mm  / 2,
                r2 = screw_dia_mm / 2
            );
    }
}

// All 12 screw holes (3 per side × 4 sides)
// Centers: hole_inset_mm from each outer edge; at 20 mm, centre, and 156 mm along each side
module all_screw_holes() {
    for (x = [hole_pos_a, hole_pos_b, hole_pos_c]) {
        translate([x, hole_inset_mm,                   0]) countersunk_hole();
        translate([x, outer_height_mm - hole_inset_mm, 0]) countersunk_hole();
    }
    for (y = [hole_pos_a, hole_pos_b, hole_pos_c]) {
        translate([hole_inset_mm,                  y, 0]) countersunk_hole();
        translate([outer_width_mm - hole_inset_mm, y, 0]) countersunk_hole();
    }
}

// Complete diffuser assembly
// Bounding box: (0,0,0) to (176, 176, 4)
module diffuser() {
    difference() {
        outer_plate();
        cell_grid();
        all_screw_holes();
    }
}

// ============================================================
// Debug / Visualization
// ============================================================

module debug_axes(len = 25) {
    color("red")   cylinder(r = 0.4, h = len);
    color("green") rotate([-90, 0, 0]) cylinder(r = 0.4, h = len);
    color("blue")  rotate([0, 90, 0])  cylinder(r = 0.4, h = len);
}

module assembly_colored() {
    color("white") diffuser();
}

module assembly_xray() {
    color("cyan", 0.25) diffuser();
}

// ============================================================
// Render
// ============================================================
diffuser();
// debug_axes();
// assembly_xray();
