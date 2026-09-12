// Print layouts: each part on the bed (z = 0) in its printing pose.
//   part = "hatch"  ON ITS SIDE (Armen 2026-09-11, for the smoothest outer face): the +X side face is
//                   the flat plane on the bed, the arc is traced in every layer, 93 tall. Brim.
//   part = "bar"    the slide bar flat on its back, slot up, pins lying on the bed.
include <whale_hatch.scad>
show_ghost = false; show_all = false; show_hull = false;
part = "hatch";

if (part == "hatch") translate([0, 0, hatch_w / 2]) rotate([0, 90, 0]) hatch();     // x = +w/2 face -> z = 0
if (part == "bar")   translate([0, 0, bar_floor + slide_clr]) slide_bar_local();
