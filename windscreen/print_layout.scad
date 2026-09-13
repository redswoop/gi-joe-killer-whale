// Print layouts: each part on the bed (z = 0) in its printing pose.
//   part = "back"    flat sheet, clear PETG, 0.6 nozzle
//   part = "side_l"  flat sheet (+Y side)
//   part = "side_r"  flat sheet (-Y side). Same outline as side_l flipped over; a 1 mm sheet has no
//                    inside face, so printing two side_l is equivalent.
//   part = "strip"   15 x 10 sample of the sheet for the coupon grooves (PETG, 0.6 nozzle)
//   part = "base"    UPSIDE DOWN: tabs point up, grooves face the bed (a 1.3 mm bridge each)
include <windscreen.scad>
show_all = false;
part = "back";

if (part == "back")   panel_flat(back_corners());
if (part == "side_l") panel_flat(side_corners(+1, side_trim()));
if (part == "side_r") mirror([0, 1, 0]) panel_flat(side_corners(-1, side_trim()));   // its frame has v pointing -Y
if (part == "strip")  cube([15, 10, panel_t]);
if (part == "base")   translate([0, 0, base_h]) rotate([180, 0, 0]) base();
