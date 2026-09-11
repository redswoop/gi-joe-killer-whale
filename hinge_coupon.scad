// Tolerance coupon: print this first, then put the winning numbers into
// shroud.scad. Three hinge samples at three clearances, three slat axle holes,
// three holes for the tie-bar peg, three strut pockets, and three fork teeth
// with one piece of rim to try them on.  Everything prints flat.
include <shroud.scad>
show_ghost = false; show_shroud = false; show_strut = false; show_vanes = false;

clearances = [0.15, 0.20, 0.25];   // hinge pin clearance, per side (round 3: 0.4 printed loose, Armen's tests say 0.15)
slat_clrs  = [0.10, 0.15, 0.20];   // slat axle hole clearance, per side (0.2 printed loose)
peg_hole_clr = [0.05, 0.10, 0.15]; // tie-bar eye clearance on the plate's link pin, per side
tooth_clrs = [0.10, 0.15, 0.20];   // fork tooth slot to wall, per face

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

// slat axle holes: a 2 mm plate with three vertical holes, exactly like the bar
// prints (it lies on its face, so the holes stand up), and a 10 mm length of rod
translate([0, 22, 0]) difference() {
    cube([42, 8, vane_t]);
    for (i = [0 : 2]) translate([6 + i * 13, 4, -1]) cylinder(d = slat_rod_d + 2 * slat_clrs[i], h = vane_t + 2);
}
translate([44, 26, slat_rod_d / 2]) rotate([0, 90, 0]) cylinder(d = slat_rod_d, h = 10);   // test rod, lying flat like the slat's

// tie-bar eye holes on the link pin, and one loose pin with its snap bulb
translate([0, 37, 0]) difference() {
    cube([42, 8, 4]);
    for (i = [0 : 2]) translate([6 + i * 13, 4, -1]) cylinder(d = link_pin_d + 2 * peg_hole_clr[i], h = 6);
}
translate([48, 40, 0]) { cylinder(d = link_pin_d, h = 5); translate([0, 0, 5 - link_pin_d / 2]) sphere(d = link_pin_d + 2 * tie_snap); }

// labels
for (i = [0 : 2]) translate([i * 14 + 30, 16, 0]) linear_extrude(0.6) text(str(clearances[i]), size = 2.5);   // above the samples, which sit at x 28.., 42.., 56.., y 1.6..14.4
translate([0, 31, 0]) linear_extrude(0.6) text("slat .10 .15 .20", size = 2.2);
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

// fork teeth: three bar stubs with the +Y tooth at three slot clearances, lying
// on the outer face like the real vane, and one piece of the rim around that
// tooth's notch, base down. Push each tooth onto the rim: the key should seat
// in the notch and the prongs should grip the wall without rocking.
module tooth_sample(clr) {
    yc = tooth_yc;
    lay_flat(1) {
        translate([vane_x, yc - 10, bar_bot(yc)]) cube([vane_t, 20, bar_top(yc) - bar_bot(yc)]);   // bar stub, wider than the tooth and its fillets
        tooth_fork(1, clr);
        translate(tooth_nub_c(1)) sphere(d = tooth_nub_d, $fn = 32);
    }
}
for (i = [0 : 2]) translate([-8 + i * 20, 100 - tooth_yc, 0]) tooth_sample(tooth_clrs[i]);   // stubs at x 6..23, 26..43, 46..63, y 90..110
translate([66 - 17, 90 - 22, 0]) intersection() { duct(); translate([17, 22, -1]) cube([23, 24, 30]); }   // rim piece with the notch, x 66..89
translate([0, 86, 0]) linear_extrude(0.6) text("tooth .10 .15 .20", size = 2.2);
