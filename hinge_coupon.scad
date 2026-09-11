// Tolerance coupon: print this first, then put the winning numbers into
// shroud.scad. Three 15 mm hinge samples at three clearances, three pockets
// for a 2 mm peg, and three holes for the tie-bar peg.  Everything prints flat.
include <shroud.scad>
show_ghost = false; show_shroud = false; show_strut = false; show_vanes = false;

clearances = [0.25, 0.35, 0.45];   // hinge pin clearance, per side
pocket_clr = [0.10, 0.15, 0.20];   // root peg pocket clearance, per side
peg_hole_clr = [0.05, 0.10, 0.15]; // tie-bar eye clearance on the plate's link pin, per side

// one hinge nub with a stub of bar and a stub of fin, laid on its inner face like the real part
module hinge_sample(clr) {
    lay_flat(1) {
        translate([vane_x, -hinge_len / 2, 23]) cube([vane_t, hinge_len, 31 - 23]);   // bar stub, top edge at z = 31 like the real bar
        hinge_root(0);
        difference() {
            union() {
                translate([vane_x, -hinge_len / 2, fin_z_low]) cube([vane_t, hinge_len, 8]);             // fin stub
                hinge_fin_knuckle(0);
            }
            hinge_fin_cut(0, clr);
        }
    }
}
for (i = [0 : 2]) translate([i * 14 + 5, 8, 0]) hinge_sample(clearances[i]);

// pockets: the real root peg is 2 x 6.774; a loose test peg is included
translate([0, 22, 0]) difference() {
    cube([42, 11, 5]);
    for (i = [0 : 2]) translate([3 + i * 13 - pocket_clr[i], 2 - pocket_clr[i], 2])
        cube([vane_t + 2 * pocket_clr[i], 6.774 + 2 * pocket_clr[i], 10]);
}
translate([48, 22, 0]) cube([vane_t, 6.774, 6]);       // test peg, stands on end

// tie-bar eye holes on the link pin, and one loose pin with its snap bulb
translate([0, 37, 0]) difference() {
    cube([42, 8, 4]);
    for (i = [0 : 2]) translate([6 + i * 13, 4, -1]) cylinder(d = link_pin_d + 2 * peg_hole_clr[i], h = 6);
}
translate([48, 40, 0]) { cylinder(d = link_pin_d, h = 5); translate([0, 0, 5 - link_pin_d / 2]) sphere(d = link_pin_d + 2 * tie_snap); }

// labels
for (i = [0 : 2]) translate([i * 14 + 3, 2, 0]) linear_extrude(0.6) text(str(clearances[i]), size = 2.5);
translate([0, 34, 0]) linear_extrude(0.6) text("pocket .10 .15 .20", size = 2.2);
translate([0, 46, 0]) linear_extrude(0.6) text("eye .05 .10 .15", size = 2.2);

// strut pockets: three pieces of the bore wall with a boss and pocket at three
// clearances, and one bar end with its ear, standing on the ear's outer face
// like the real bar prints. Slide the ear up each pocket: it should run freely
// to the ceiling without wobbling.
ear_clrs = [0.10, 0.20, 0.30];
module boss_piece(clr) {
    difference() {
        intersection() { union() { duct_ring(); boss_pad(); } translate([39, -9, 0]) cube([8, 18, boss_top + 1]); }
        pocket(clr);
    }
}
for (i = [0 : 2]) translate([-36 + i * 12, 58, 0]) boss_piece(ear_clrs[i]);            // pieces at x 3..11, 15..23, 27..35
translate([44, 58, duct_r_in]) rotate([0, 90, 0]) intersection() { strut(); translate([39, -9, -3]) cube([8, 18, 15]); }
translate([0, 68, 0]) linear_extrude(0.6) text("strut pocket .10 .20 .30", size = 2.2);
