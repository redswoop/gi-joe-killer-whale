// Tolerance coupon for the dovetail: three short socket blocks with the groove at three clearances,
// one 20 mm slice of the front plate's rail to try in each. Labels are the per-face clearance.
// Round 1 (2026-09-13, small rail, 0.1 / 0.15 / 0.25): all far too loose. Round 2: the rail doubled,
// clearances around zero. The pin holes from round 1 are gone: +0.3 was a perfect fit (lib/fit.scad).
include <whale_hatch.scad>
show_ghost = false; show_all = false; show_hull = false;

clrs = [-0.1, 0, 0.1];
L = 20;
module label(t) { linear_extrude(0.6) text(t, size = 3, halign = "center"); }

// socket slices: the block profile (y across, z up) extruded straight up, so the groove is a
// vertical slot traced in every layer, like the real hatch printing on its side. Brim.
for (i = [0 : len(clrs) - 1]) translate([i * 16, 0, 0]) {
    linear_extrude(L) difference() {
        square([sock_d, sock_h]);
        translate([0, -seam_z]) polygon(rail_2d(clrs[i], 1));       // groove at this clearance
    }
    translate([sock_d / 2, -6, 0]) label(str(clrs[i]));
}
// rail slice: front plate 20 wide, 6 tall, rail on top; STANDING on its cut face like the real part
// now prints (the front stands on its bottom edge). Brim.
translate([-20, 0, -(seam_z - 6)])
    intersection() { front_local(); translate([-10, -5, seam_z - 6]) cube([20, 20, 6 + rail_h + 1]); }
