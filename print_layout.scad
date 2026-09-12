// Print layouts: each part laid on the bed (z=0) in its printing pose.
//   part = "vane_right" | "vane_left" | "tie_bar" | "slat" | "shroud" | "strut" | "fin_right" | "fin_left"
// vane_mount = "fused" (-D 'vane_mount="fused"'): "shroud" carries the root bars (base down; the bars bridge the bore, slicer
// supports under them), "fin_*" is the plate alone standing on its -Y end, "slat" has its axle barrel flush on the bed.
// The vane prints STANDING on its -Y end (the toy's top): the hinge pins are
// vertical, the round dart is the same on both faces, the ribbed panels print
// as wall detail (Armen 2026-09-11: flat printing lost the detail). Footprint is
// the bar's and the plate's end faces (1.3 mm wide at the first layer because
// of the edge fillets): use a brim. vane_pose = "flat" is the old pose on the
// outer face, kept for reference; the round dart no longer lies flat.
// The tie bar prints face down with its pegs up.
include <shroud.scad>
show_ghost = false; show_shroud = false; show_strut = false; show_vanes = false;
part = "vane_right";
vane_pose = "vertical";

module vane_print(side) {
    if (vane_pose == "vertical")
        translate([0, 0, -vane_top_l[0]]) rotate([90, 0, 0]) mirror([side < 0 ? 1 : 0, 0, 0]) { vane_root(); vane_fin(); }
    else if (side > 0) lay_flat(1)  { vane_root(); vane_fin(); }
    else               lay_flat(-1) mirror([1, 0, 0]) { vane_root(); vane_fin(); }
}
if (part == "vane_right") vane_print(1);
if (part == "vane_left")  vane_print(-1);
if (part == "fin_right")  translate([0, 0, -hinge_y0]) rotate([90, 0, 0]) vane_fin();                    // plate alone, standing on its -Y end (fused: goes on with a filament pin)
if (part == "fin_left")   translate([0, 0, -hinge_y0]) rotate([90, 0, 0]) mirror([1, 0, 0]) vane_fin();
if (part == "tie_bar")    translate([0, 0, -tie_y0]) rotate([90, 0, 0]) tie_bar();          // flat, knurled face up, holes vertical
if (part == "slat")       translate([0, 0, fused ? slat_barrel_d / 2 : slat_t / 2]) rotate([-90, 0, 0]) slat();   // flat, rod (fused: the barrel's flush face) on the bed
if (part == "shroud")     { duct(); deco_boxes(); tab(); if (fused) vane_roots(); }   // fused: the root bars are part of the shroud
if (part == "strut")      translate([0, 0, duct_r_in]) rotate([0, -90, 0]) strut();   // standing on one ear's outer face (0.3 mm of curve across it; brim); no supports
