// Print layouts: each part on the bed (z = 0) in its printing pose.
//   part = "hatch"  ON ITS SIDE (Armen 2026-09-11, for the smoothest outer face): the +X side face is
//                   the flat plane on the bed; arc, front face and dovetail groove are traced in every layer.
//                   93.3 tall. Brim.
//   part = "front"  flat on its INNER face: the rail's flat side and the pins lie on the bed, the
//                   dovetail taper is a top-side slope. Outer face up.
//   part = "mount"  flat on its glue face. Print two.
//   part = "corner" fit coupon (Armen 2026-09-13): the -X edge of the tray, corner_w wide, full length,
//                   so it carries the angled corner cut, the rabbet, the cabin ledge, the rim and the
//                   front face with its groove. Stands on the cut face, like the hatch on its side.
include <whale_hatch.scad>
show_ghost = false; show_all = false; show_hull = false;
part = "hatch";
corner_w = 50;   // width of the corner coupon, from the -X side edge inward

if (part == "hatch") translate([0, 0, hatch_w / 2]) rotate([0, 90, 0]) hatch();     // x = +w/2 face -> z = 0
if (part == "front") translate([0, 0, front_t]) rotate([-90, 0, 0]) translate([0, 0, -front_bot]) front_local();
if (part == "mount") rotate([0, -90, 0]) mount_local();                              // x = 0 face -> z = 0
if (part == "corner") translate([0, 0, corner_w - hatch_w / 2]) rotate([0, 90, 0])   // cut face -> z = 0
    intersection() { hatch(); translate([-hatch_w / 2 - 1, -50, -100]) cube([corner_w + 1, 300, 200]); }
