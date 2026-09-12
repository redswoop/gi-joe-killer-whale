// Print layouts: each part laid on the bed (z=0) in its printing pose.
//   part = "vane_right" | "vane_left" | "tie_bar" | "slat" | "shroud" | "strut" | "fin_right" | "fin_left" | "fan" | "shaft"
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
show_ghost = false; show_shroud = false; show_strut = false; show_vanes = false; show_fan = false;
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
// The plate alone (fused: goes on with a filament pin). fin_print = "edge": upside down, standing on its long outer edge
// with the knuckles up; that edge is the trapezoid's slanted side, so after the flip it is levelled by rotating about X
// by fin_slant (6.5 deg) and lifted so the edge sits on the bed. "vertical": on its -Y end like the whole vane.
fin_slant = atan((fin_depth_bot - fin_depth_top) / (hinge_y1 - hinge_y0));
module fin_print(side) {
    if (fin_print == "edge")
        translate([0, 0, (hinge_z + fin_depth_top) * cos(fin_slant) - hinge_y0 * sin(fin_slant)])
            rotate([fin_slant, 0, 0]) rotate([0, 180, 0]) mirror([side < 0 ? 1 : 0, 0, 0]) vane_fin();
    else translate([0, 0, -hinge_y0]) rotate([90, 0, 0]) mirror([side < 0 ? 1 : 0, 0, 0]) vane_fin();
}
if (part == "fin_right")  fin_print(1);
if (part == "fin_left")   fin_print(-1);
if (part == "tie_bar")    translate([0, 0, -tie_y0]) rotate([90, 0, 0]) tie_bar();          // flat, knurled face up, holes vertical
if (part == "slat")       translate([0, 0, fused ? slat_barrel_d / 2 : slat_t / 2]) rotate([-90, 0, 0]) slat();   // flat, rod (fused: the barrel's flush face) on the bed
if (part == "shroud")     { duct(); deco_boxes(); tab(); if (fused) vane_roots(); }   // fused: the root bars are part of the shroud
if (part == "fan")        fan();                                                                        // flat, hub bottom and blade undersides on the bed, no supports
if (part == "shaft")      translate([0, 0, shaft_d / 2 - shaft_flat]) rotate([0, -90, 0]) shaft();          // lying on its D flat, tab at -X (tip 0.65 off the bed: a 1 mm overhang)
if (part == "strut")      translate([0, 0, duct_r_in]) rotate([0, -90, 0]) strut();   // standing on one ear's outer face (0.3 mm of curve across it; brim); no supports
