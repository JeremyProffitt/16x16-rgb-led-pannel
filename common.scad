/**
 * common.scad — Shared parameters and primitives for the 16×16 LED grid system.
 * Include this in diffuse_led_grid_v2.scad and led_grid_lid.scad.
 */

// ============================================================
// LED Panel Specs  (WS2812B 16×16, 160×160 mm, 10 mm pitch)
// ============================================================
led_count_x   = 16;
led_count_y   = 16;
led_pitch_mm  = 10.0;

// ============================================================
// Plate Geometry
// ============================================================
wall_thickness_mm = 2.0;   // inter-cell wall thickness
panel_border_mm   = 1.0;   // original cell-grid border
extension_mm      = 8.0;   // mounting border added per side
outer_border_mm   = panel_border_mm + extension_mm;  // 9.0 mm
outer_corner_r_mm = 1.0;   // XY corner radius

// Derived outer plate dimensions
// 9 + 16×8 + 15×2 + 9 = 176 mm per axis
cell_size_mm    = led_pitch_mm - wall_thickness_mm;   // 8.0 mm
outer_width_mm  = outer_border_mm
                  + led_count_x * cell_size_mm
                  + (led_count_x - 1) * wall_thickness_mm
                  + outer_border_mm;
outer_height_mm = outer_border_mm
                  + led_count_y * cell_size_mm
                  + (led_count_y - 1) * wall_thickness_mm
                  + outer_border_mm;

// ============================================================
// Screw Hole Specs  (M3, ⌀5 mm countersunk head)
// ============================================================
screw_dia_mm         = 3.0;
head_dia_mm          = 5.0;
hole_inset_mm        = 4.0;   // hole-centre to outer plate edge
countersink_depth_mm = (head_dia_mm - screw_dia_mm) / 2;  // 1.0 mm

// Positions along each 176 mm side: 20 mm from ends, one at centre
hole_pos_a = 20.0;
hole_pos_b = outer_width_mm / 2;        // 88 mm
hole_pos_c = outer_width_mm - 20.0;     // 156 mm

// ============================================================
// M3 Nut Spec  (DIN 934, standard hex nut)
// ============================================================
nut_across_flats_mm = 5.8;   // 5.5 mm nominal + 0.3 mm print clearance
nut_thickness_mm    = 2.4;   // standard M3 nut height
nut_pocket_depth_mm = 2.0;   // pocket depth inset from surface (use thin M3 nut)

// ============================================================
// Render quality
// ============================================================
$fn = 64;

// ============================================================
// Shared primitives
// ============================================================

// 2-D rounded rectangle; bounding box (0,0) to (w, h)
module rounded_rect_2d(w, h, r) {
    hull() {
        translate([r,   r  ]) circle(r);
        translate([w-r, r  ]) circle(r);
        translate([r,   h-r]) circle(r);
        translate([w-r, h-r]) circle(r);
    }
}
