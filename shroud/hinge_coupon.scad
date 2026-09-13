// Tolerance coupon: print this first, then put the winning numbers into
// shroud.scad. Three hinge samples at three clearances (standing, pins vertical), three slat axle holes,
// three holes for the tie-bar peg, three strut pockets, and three fork teeth
// with one piece of rim to try them on.  Everything prints flat.
include <shroud.scad>
show_ghost = false; show_shroud = false; show_strut = false; show_vanes = false;

clearances = hinge_pin == "filament" ? [0.10, 0.15, 0.20]    // filament pin: hole clearance on the 1.75 filament, per side
                                     : [0.15, 0.20, 0.25];   // printed pin, per side (round 3: 0.4 printed loose, Armen's tests say 0.15)
slat_clrs  = [0.10, 0.15, 0.20];   // slat axle hole clearance, per side (0.2 printed loose)
peg_hole_clr = [0.05, 0.10, 0.15]; // tie-bar eye clearance on the plate's link pin, per side
tooth_clrs = [0.10, 0.15, 0.20];   // fork tooth slot to wall, per face

// one hinge nub with a stub of bar and a stub of fin, standing on its -Y end
// with the pin vertical, like the real vane prints (2026-09-11: vertical).
// -D 'hinge_pin="filament"' ladders the filament hole instead: push a 15 mm piece of 1.75 through each.
module hinge_sample(clr) {
    translate([0, 0, hinge_len / 2]) rotate([90, 0, 0]) {
        translate([vane_x, -hinge_len / 2, 23]) cube([vane_t, hinge_len, 31 - 23]);   // bar stub, top edge at z = 31 like the real bar
        hinge_root(0, clr);
        difference() {
            union() {
                translate([vane_x, -hinge_len / 2, fin_z_low]) cube([vane_t, hinge_len, 8]);             // fin stub
                hinge_fin_knuckle(0);
            }
            hinge_fin_cut(0, clr);
        }
    }
}
for (i = [0 : 2]) translate([i * 14 - 22, 40, 0]) hinge_sample(clearances[i]);   // x 3..13, 17..27, 31..41; y 4..17

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
for (i = [0 : 2]) translate([i * 14 + 3, 18.5, 0]) linear_extrude(0.6) text(str(clearances[i]), size = 2.5);   // above the samples
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

// fork darts: three stubs of bar with the -Y fork at three slot clearances,
// standing on the stub's end like the real vane prints (on a thin foot), and
// one piece of the rim around that tooth's notch, base down. Push each dart
// onto the rim: the key should seat in the round notch and the prongs should
// grip the wall without rocking.
module tooth_sample(clr) {
    yc = -tooth_ay;
    translate([0, 0, -(yc - 10)]) rotate([90, 0, 0]) {
        translate([vane_x, yc - 10, bar_bot(yc)]) cube([vane_t, 20, bar_top(yc) - bar_bot(yc)]);   // bar stub
        tooth_fork(-1, clr);
        translate(tooth_nub_c(-1)) sphere(d = tooth_nub_d, $fn = 32);
    }
    translate([vane_x - 2, -bar_top(yc) - 1, 0]) cube([vane_t + 4, bar_top(yc) - bar_bot(yc) + 2, 0.8]);   // foot under the stub's end
}
for (i = [0 : 2]) translate([-25 + i * 14, 108, 0]) tooth_sample(tooth_clrs[i]);   // x 0..7, 14..21, 28..35; y 76..103
translate([42 - 17, 68 + 46, 0]) intersection() { duct(); translate([17, -46, -1]) cube([23, 24, 30]); }   // rim piece with the -Y notch, x 42..65, y 68..92
translate([0, 72, 0]) linear_extrude(0.6) text("tooth .10 .15 .20", size = 2.2);
