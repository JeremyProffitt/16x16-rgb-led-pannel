/**
 * led_grid_lid.scad
 *
 * Lid for the 16×16 LED grid diffuser. Matches the 176×176 mm footprint,
 * 12 mm tall. Nut pockets are on the bottom face (Z=0); screws enter from
 * below through the diffuser and engage nuts recessed in the lid bottom.
 *
 * Top face features (all measured from Z=12 downward):
 *   - Centre recess   : 164×164 mm, 1 mm deep, 6 mm margin all round
 *   - wire-cutout-left   (front) : X 20–60,   Y 30–70,  4 mm deep
 *   - wire-cutout-center (front) : X 68–108,  Y 30–70,  4 mm deep
 *   - wire-cutout-right  (front) : X 116–156, Y 30–70,  4 mm deep
 *   - wire-cutout-left   (rear)  : X 20–60,   Y 106–146, 4 mm deep
 *   - wire-cutout-center (rear)  : X 68–108,  Y 106–146, 4 mm deep
 *   - wire-cutout-right  (rear)  : X 116–156, Y 106–146, 4 mm deep
 *   - wire-run           : X 20–156, Y 65–111, 10 mm deep (46 mm, centred on Y=88)
 *   - fan-mount          : ⌀37 mm opening + 4× ⌀3.2 mm M3 holes, centred (88,88), through wire-run floor
 *   - x-through-hole (×2): ⌀5 mm, full X length, Z-centred (Z=6), Y = 73 mm and Y = max(Y)-73 = 103 mm
 *   - zip-tie-hole (×1)  : arch 10×8×24 mm + 12×4 mm bar, cut from bottom, at (10,10)
 *
 * Coordinate System (print orientation):
 *   X = Width  (positive = right when facing front)
 *   Y = Height (positive = back / up-in-use)
 *   Z = Depth  (positive = upward in print; Z=0 on build plate)
 *
 * Origin: front-bottom-left corner of lid plate
 * Z=0 is the bottom face (nut-pocket side, faces down in use).
 * Z=12 is the top face (recess and cutouts face up in use).
 *
 * Component Index:
 * ┌───────────────────────────┬───────────────────────────┬──────────────────┬─────────────────────────────────────┐
 * │ Component                 │ Origin (relative)          │ Size             │ Notes                               │
 * ├───────────────────────────┼───────────────────────────┼──────────────────┼─────────────────────────────────────┤
 * │ lid_plate                 │ (0, 0, 0)                  │ 176×176×12 mm    │ Rounded corners r=1 mm              │
 * │ screw_hole (×12)          │ 4 mm from each outer edge  │ ⌀3 shaft         │ Through-hole; hex nut pocket Z=0    │
 * │ centre_recess             │ (6, 6, 11)                 │ 164×164×1 mm     │ 1 mm deep from top                  │
 * │ wire-cutout-left (front)  │ (20, 30, 8)                │ 40×40×4 mm       │ 4 mm deep from top                  │
 * │ wire-cutout-center(front) │ (68, 30, 8)                │ 40×40×4 mm       │                                     │
 * │ wire-cutout-right (front) │ (116, 30, 8)               │ 40×40×4 mm       │                                     │
 * │ wire-cutout-left (rear)   │ (20, 106, 8)               │ 40×40×4 mm       │ 4 mm deep from top                  │
 * │ wire-cutout-center(rear)  │ (68, 106, 8)               │ 40×40×4 mm       │                                     │
 * │ wire-cutout-right (rear)  │ (116, 106, 8)              │ 40×40×4 mm       │                                     │
 * │ wire-run                  │ (20, 65, 2)                │ 136×46×10 mm     │ 10 mm deep from top; joins rows     │
 * │ fan-mount                 │ centred (88,88), Z=0–2     │ ⌀37 + 4× ⌀3.2   │ Through wire-run floor (2 mm)       │
 * │ x-through-hole (×2)       │ Y=73 & Y=103, Z=6 (centred)│ ⌀5 mm × 176 mm  │ Full X length, along X axis         │
 * │ zip-tie-hole (×1)         │ X=10–34, Y=10–20, Z=0–8   │ arch + 12×4 bar  │ From bottom; bar retains zip tie    │
 * └───────────────────────────┴───────────────────────────┴──────────────────┴─────────────────────────────────────┘
 */

include <common.scad>

// ============================================================
// Lid-specific dimensions
// ============================================================
lid_thickness_mm   = 12.0;

// Centre recess (top face, 1 mm deep)
recess_margin_mm   = 6.0;    // (176 - 164) / 2
recess_depth_mm    = 1.0;

// Wire cutouts — front row (Y 30–70) and rear row (Y 106–146), 4 mm deep each
cutout_size_mm     = 40.0;   // 70 - 30 = 40 mm
cutout_depth_mm    = 4.0;
cutout_x_left_mm   = 20.0;
cutout_x_center_mm = outer_width_mm / 2 - cutout_size_mm / 2;   // 68 mm
cutout_x_right_mm  = outer_width_mm - 20.0 - cutout_size_mm;    // 116 mm
cutout_y_front_mm  = 30.0;                          // front row start Y
cutout_y_rear_mm   = outer_height_mm - 70.0;        // rear row start Y = 106 mm

// Wire-run channel (top face, 10 mm deep) — connects front and rear wire cutouts
wire_run_x_start_mm = 20.0;
wire_run_x_end_mm   = 156.0;
wire_run_y_start_mm = 65.0;
wire_run_y_end_mm   = outer_height_mm - 65.0;       // 111 mm
wire_run_depth_mm   = 10.0;

// 40×40 mm fan mount — centred in the lid, through the wire-run floor
fan_center_x_mm      = outer_width_mm  / 2;         // 88 mm
fan_center_y_mm      = outer_height_mm / 2;         // 88 mm
fan_blade_dia_mm     = 37.0;                        // airflow opening diameter
fan_mount_pattern_mm = 32.0;                        // screw hole centre-to-centre
fan_screw_dia_mm     = 3.2;                         // M3 clearance
// floor thickness = lid_thickness - wire_run_depth = 12 - 10 = 2 mm
fan_floor_z_mm       = lid_thickness_mm - wire_run_depth_mm;

// Zip-tie hole — arch cut from bottom, retaining bar at arch peak
zip_ramp_len_mm   = 12.0;   // length of each ramp half
zip_slot_width_mm = 10.0;   // slot width (Y)
zip_slot_h_mm     =  8.0;   // max arch height (Z)
zip_bar_len_mm    = 12.0;   // retaining bar length (X, centred at peak)
zip_bar_h_mm      =  4.0;   // retaining bar height (Z)
zip_tie_x_mm      = 16.0;   // arch start X (near-left corners)
zip_tie_y_mm      = 16.0;   // arch start Y (near-bottom corners)
// Far-corner positions derived so outer edge of slot is 16 mm from each lid face,
// symmetric with the near corners.
zip_tie_x_far_mm  = outer_width_mm  - zip_tie_x_mm - 2 * zip_ramp_len_mm;  // 136
zip_tie_y_far_mm  = outer_height_mm - zip_tie_y_mm - zip_slot_width_mm;     // 150

// ============================================================
// Build-volume assertions (Bambu H2D: 325×320×325 mm)
// ============================================================
assert(outer_width_mm   <= 325, "Width exceeds H2D X build volume");
assert(outer_height_mm  <= 320, "Height exceeds H2D Y build volume");
assert(lid_thickness_mm <= 325, "Thickness exceeds H2D Z build volume");

// ============================================================
// Components
// ============================================================

// Solid lid plate (before subtraction)
// Bounding box: (0,0,0) to (176, 176, 12)
module lid_plate() {
    linear_extrude(lid_thickness_mm)
        rounded_rect_2d(outer_width_mm, outer_height_mm, outer_corner_r_mm);
}

// M3 screw hole with hex nut pocket at the BOTTOM face (Z=0).
// Shaft runs full height; nut pocket opens downward, going up nut_pocket_depth_mm.
module lid_screw_hole() {
    nut_r = (nut_across_flats_mm / 2) / cos(30);
    union() {
        translate([0, 0, -0.01])
            cylinder(h = lid_thickness_mm + 0.02, r = screw_dia_mm / 2);
        translate([0, 0, -0.01])
            rotate([0, 0, 30])
                cylinder(h = nut_pocket_depth_mm + 0.01, r = nut_r, $fn = 6);
    }
}

// All 12 screw holes — same XY positions as diffuser
module all_lid_screw_holes() {
    for (x = [hole_pos_a, hole_pos_b, hole_pos_c]) {
        translate([x, hole_inset_mm,                   0]) lid_screw_hole();
        translate([x, outer_height_mm - hole_inset_mm, 0]) lid_screw_hole();
    }
    for (y = [hole_pos_a, hole_pos_b, hole_pos_c]) {
        translate([hole_inset_mm,                  y, 0]) lid_screw_hole();
        translate([outer_width_mm - hole_inset_mm, y, 0]) lid_screw_hole();
    }
}

// Centre recess on top face — 164×164 mm, 1 mm deep, 6 mm margin all round
// Bounding box: (6, 6, 11) to (170, 170, 12)
module centre_recess() {
    translate([recess_margin_mm, recess_margin_mm, lid_thickness_mm - recess_depth_mm])
        cube([
            outer_width_mm  - 2 * recess_margin_mm,
            outer_height_mm - 2 * recess_margin_mm,
            recess_depth_mm + 0.01
        ]);
}

// One wire-cutout at absolute position (ax, ay), 4 mm deep from top face
module wire_cutout(ax, ay) {
    translate([ax, ay, lid_thickness_mm - cutout_depth_mm])
        cube([cutout_size_mm, cutout_size_mm, cutout_depth_mm + 0.01]);
}

// Front wire cutouts (wire-cutout-left/center/right) — Y 30–70
module wire_cutouts_front() {
    wire_cutout(cutout_x_left_mm,   cutout_y_front_mm);  // wire-cutout-left
    wire_cutout(cutout_x_center_mm, cutout_y_front_mm);  // wire-cutout-center
    wire_cutout(cutout_x_right_mm,  cutout_y_front_mm);  // wire-cutout-right
}

// Rear wire cutouts (wire-cutout-left/center/right) — Y 106–146
module wire_cutouts_rear() {
    wire_cutout(cutout_x_left_mm,   cutout_y_rear_mm);   // wire-cutout-left
    wire_cutout(cutout_x_center_mm, cutout_y_rear_mm);   // wire-cutout-center
    wire_cutout(cutout_x_right_mm,  cutout_y_rear_mm);   // wire-cutout-right
}

// Wire-run channel — X 20–156, Y 65–111, 10 mm deep from top face (46 mm wide, centred on Y=88)
// Bounding box: (20, 65, 2) to (156, 111, 12)
module wire_run() {
    translate([
        wire_run_x_start_mm,
        wire_run_y_start_mm,
        lid_thickness_mm - wire_run_depth_mm
    ])
    cube([
        wire_run_x_end_mm   - wire_run_x_start_mm,   // 136 mm
        wire_run_y_end_mm   - wire_run_y_start_mm,   // 36 mm
        wire_run_depth_mm   + 0.01
    ]);
}

// 40×40 mm fan mount — circular blade opening + 4 corner M3 screw holes.
// Cuts through the wire-run floor (Z=0 to Z=fan_floor_z_mm).
// Centred at (fan_center_x_mm, fan_center_y_mm) = (88, 88).
module fan_mount() {
    half = fan_mount_pattern_mm / 2;   // 16 mm
    translate([fan_center_x_mm, fan_center_y_mm, -0.01]) {
        // Circular airflow opening
        cylinder(h = fan_floor_z_mm + 0.02, r = fan_blade_dia_mm / 2);
        // 4 corner mounting holes
        for (dx = [-half, half])
            for (dy = [-half, half])
                translate([dx, dy, 0])
                    cylinder(h = fan_floor_z_mm + 0.02, r = fan_screw_dia_mm / 2);
    }
}

// 5 mm through-hole running the full X length of the lid at a given Y position.
// Centred on Z (Z = lid_thickness/2 = 6 mm).
module x_through_hole(y_pos) {
    translate([-0.01, y_pos, lid_thickness_mm / 2])
        rotate([0, 90, 0])
            cylinder(h = outer_width_mm + 0.02, r = 5 / 2);
}

// Both x-through-holes: Y=73 (mid(Y)-15) and Y=103 (max(Y)-73)
module all_x_through_holes() {
    x_through_hole(outer_height_mm / 2 - 15);       // Y = 73 mm
    x_through_hole(outer_height_mm - 73);            // Y = 103 mm
}

// Arch cutout for a zip-tie slot — tent profile cut from the bottom face (Z=0).
// Ramp up: Z grows from 0→zip_slot_h_mm over zip_ramp_len_mm in X.
// Ramp down: Z shrinks back to 0 over the next zip_ramp_len_mm.
// At the peak (x_pos + zip_ramp_len_mm) the opening is zip_slot_h_mm tall.
// Bounding box: (x_pos, y_pos, 0) to (x_pos+24, y_pos+10, 8)
module zip_tie_arch(x_pos, y_pos) {
    w = zip_slot_width_mm;
    h = zip_slot_h_mm;
    r = zip_ramp_len_mm;
    // Ramp-up wedge: zero height at x_pos, full height at x_pos+r
    hull() {
        translate([x_pos,     y_pos, -0.01]) cube([0.01, w, 0.02]);
        translate([x_pos + r, y_pos, -0.01]) cube([0.01, w, h + 0.02]);
    }
    // Ramp-down wedge: full height at x_pos+r, zero height at x_pos+2r
    hull() {
        translate([x_pos + r,       y_pos, -0.01]) cube([0.01, w, h + 0.02]);
        translate([x_pos + 2 * r,   y_pos, -0.01]) cube([0.01, w, 0.02]);
    }
}

// Retaining bar inside the arch — a pair of ramps unioned back after the arch cut.
// Peak at (x_pos + zip_ramp_len_mm, Z = zip_bar_h_mm); tapers to Z=0 at both ends.
// Each ramp half = zip_bar_len_mm/2 + 2 mm = 8 mm from peak.
// Y footprint is zip_slot_width_mm + 2 mm (1 mm extra each side) so the bar
// seats into the slot walls for rigidity.
// Bounding box: (x_pos+4, y_pos-1, 0) to (x_pos+20, y_pos+11, 4)
module zip_tie_bar_solid(x_pos, y_pos) {
    peak_x  = x_pos + zip_ramp_len_mm;          // x_pos + 12
    half    = zip_bar_len_mm / 2 + 2;           // 6 + 2 = 8 mm each side
    y_start = y_pos - 1;
    w       = zip_slot_width_mm + 2;            // 1 mm extra each Y side

    // Left ramp: Z=0 at left end → Z=zip_bar_h_mm at peak
    hull() {
        translate([peak_x - half, y_start, 0]) cube([0.01, w, 0.01]);
        translate([peak_x,        y_start, 0]) cube([0.01, w, zip_bar_h_mm]);
    }
    // Right ramp: Z=zip_bar_h_mm at peak → Z=0 at right end
    hull() {
        translate([peak_x,        y_start, 0]) cube([0.01, w, zip_bar_h_mm]);
        translate([peak_x + half, y_start, 0]) cube([0.01, w, 0.01]);
    }
}

// All four zip-tie arch cutouts — one per corner.
module all_zip_tie_arches() {
    zip_tie_arch(zip_tie_x_mm,     zip_tie_y_mm);      // near-left,  near-bottom
    zip_tie_arch(zip_tie_x_far_mm, zip_tie_y_mm);      // near-right, near-bottom
    zip_tie_arch(zip_tie_x_mm,     zip_tie_y_far_mm);  // near-left,  near-top
    zip_tie_arch(zip_tie_x_far_mm, zip_tie_y_far_mm);  // near-right, near-top
}

// All four zip-tie retaining bars — one per corner.
module all_zip_tie_bars() {
    zip_tie_bar_solid(zip_tie_x_mm,     zip_tie_y_mm);
    zip_tie_bar_solid(zip_tie_x_far_mm, zip_tie_y_mm);
    zip_tie_bar_solid(zip_tie_x_mm,     zip_tie_y_far_mm);
    zip_tie_bar_solid(zip_tie_x_far_mm, zip_tie_y_far_mm);
}

// Complete lid assembly
// Bounding box: (0,0,0) to (176, 176, 12)
module lid() {
    union() {
        difference() {
            lid_plate();
            all_lid_screw_holes();
            centre_recess();
            wire_cutouts_front();
            wire_cutouts_rear();
            wire_run();
            fan_mount();
            all_x_through_holes();
            all_zip_tie_arches();
        }
        all_zip_tie_bars();
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
    color("lightblue") lid();
}

module assembly_xray() {
    color("lightblue", 0.25) lid();
}

// ============================================================
// Render
// ============================================================
lid();
// debug_axes();
// assembly_xray();
