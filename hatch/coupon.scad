// Tolerance coupon for the dovetail: three short socket blocks with the groove at three clearances,
// one 20 mm slice of the front plate's rail to try in each. Labels are the per-face clearance.
// Also three pin holes at three clearances for a spare pin stub.
include <whale_hatch.scad>
show_ghost = false; show_all = false; show_hull = false;

clrs = [0.1, 0.15, 0.25];
L = 20;
module label(t) { linear_extrude(0.6) text(t, size = 3, halign = "center"); }

// socket slices: the block profile (y across, z up) extruded straight up, so the groove is a
// vertical slot traced in every layer, like the real hatch printing on its side. Brim.
for (i = [0 : len(clrs) - 1]) translate([i * 16, 0, 0]) {
    linear_extrude(L) difference() {
        square([sock_d, sock_h]);
        translate([0, -seam_z]) polygon(rail_2d(clrs[i]));          // groove at this clearance
    }
    translate([sock_d / 2, -6, 0]) label(str(clrs[i]));
}
// rail slice: front plate 20 wide, 6 tall, rail on top; printed on its inner face like the real part
translate([-20, 0, front_t]) rotate([-90, 0, 0]) translate([0, 0, -seam_z + 6])
    intersection() { front_local(); translate([-10, -5, seam_z - 6]) cube([20, 20, 6 + rail_h + 1]); }
// pin holes at three clearances, for a printed pin stub
translate([0, 15, 0]) for (i = [0 : 2]) translate([i * 10, 0, 0]) difference() {
    cube([8, 8, mount_t]); translate([4, 4, -1]) cylinder(d = hinge_pin_d + [0.3, 0.4, 0.5][i], h = 6);
}
translate([-8, 19, hinge_pin_d / 2]) rotate([0, 90, 0]) cylinder(d = hinge_pin_d, h = 10);   // the pin stub, lying down
