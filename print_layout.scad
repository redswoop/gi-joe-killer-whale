// Print layouts: each part on the bed (z = 0) in its printing pose.
//   part = "hatch"   standing on its hinge edge, curve in XZ, no supports
include <whale_hatch.scad>
show_ghost = false; show_all = false; show_hull = false;
part = "hatch";

if (part == "hatch") translate([0, 0, hinge_ear_r]) hatch();
