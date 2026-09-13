// Print layouts: each part on the bed (z = 0) in its printing pose.
//   part = "front"   clear PETG, 0.6 nozzle, OUTER face down (the mitre and top bevels are then slopes)
//   part = "side_l"  same, +Y side
//   part = "side_r"  same, -Y side. Mirror image of side_l (the mitre is on the other end), so
//                    print one of each, NOT two side_l.
//   part = "strip"   15 x 10 sample of the sheet for the coupon grooves (PETG, 0.6 nozzle)
//   part = "base"    UPSIDE DOWN: tabs point up, grooves face the bed (a 1.3 mm bridge each)
//   part = "top"     cap face down, grooves up. No supports.
include <windscreen.scad>
show_all = false;
part = "front";

if (part == "front")  panel_unplace(front_corners())  front();
if (part == "side_l") panel_unplace(side_corners(+1)) side_l();
if (part == "side_r") panel_unplace(side_corners(-1)) side_r();
if (part == "strip")  cube([15, 10, panel_t]);
if (part == "base")   translate([0, 0, base_h]) rotate([180, 0, 0]) base();
if (part == "top")    translate([0, 0, top_z + top_cap]) rotate([180, 0, 0]) top();
