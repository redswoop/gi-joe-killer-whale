// Print layouts: each part laid flat on the bed (z=0) in its printing pose.
//   part = "vane_right" | "vane_left" | "tie_bar" | "slat" | "shroud" | "strut"
// The vane prints on the face opposite its hinge barrels, which are tangent
// to the other face, so nothing overhangs. The tie bar prints face down with its pegs up.
include <shroud.scad>
show_ghost = false; show_shroud = false; show_strut = false; show_vanes = false;
part = "vane_right";

module vane_print(side) {   // the face opposite the hinge barrel goes on the bed
    if (side > 0) lay_flat(1)  { vane_root(); vane_fin(); }
    else          lay_flat(-1) mirror([1, 0, 0]) { vane_root(); vane_fin(); }
}
if (part == "vane_right") vane_print(1);
if (part == "vane_left")  vane_print(-1);
if (part == "tie_bar")    translate([0, 0, -tie_y0]) rotate([90, 0, 0]) tie_bar();          // flat, knurled face up, holes vertical
if (part == "slat")       translate([0, 0, slat_t / 2]) rotate([-90, 0, 0]) slat();              // flat, rod along the bed
if (part == "shroud")     { duct(); deco_boxes(); tab(); }
if (part == "strut")      translate([0, 0, shoe_x]) rotate([0, -90, 0]) strut();   // standing on one shoe's flat face; no supports needed
