// Print layouts: each part on the bed (z = 0) in its printing pose.
//   part = "hatch"   standing on its cabin end face (square, radial; 73 wide after the chamfers),
//                    tray opening toward +Y. The hinge bar and pins end up at the top. Brim.
include <whale_hatch.scad>
show_ghost = false; show_all = false; show_hull = false;
part = "hatch";

// tangent at the cabin end (toward the hinge) is at angle a_end - 90 * a_dir in YZ; turn it to +Z,
// then slide the cabin-end corner (end_pt) to the origin so the end face sits on z = 0.
if (part == "hatch") rotate([90 - (a_end - 90 * a_dir), 0, 0]) translate([0, -end_pt[0], -end_pt[1]]) hatch();
