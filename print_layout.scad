// Print layouts: each part on the bed (z = 0) in its printing pose.
//   part = "hatch"   standing on its hinge end face (flat, radial), curve in the YZ plane, brim,
//                    no supports: the top leans ~29 deg at most.
include <whale_hatch.scad>
show_ghost = false; show_all = false; show_hull = false;
part = "hatch";

// rotate about X so the plate's tangent at the hinge end points +Z; the hinge end
// face (radial through the origin) then lies flat on z = 0.
// tangent at the hinge end (toward the cabin) is at angle a_hinge + 90 * a_dir in YZ; turn it to +Z.
if (part == "hatch") rotate([90 - (a_hinge + 90 * a_dir), 0, 0]) hatch();
