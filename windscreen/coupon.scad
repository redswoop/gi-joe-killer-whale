// Tolerance coupon: a 20 mm slice of the side rail with three groove clearances,
// labels embossed on the up-facing floor. Prints upside down like the base; the sheet sample is
// print_layout part="strip" (PETG, 0.6 nozzle).
include <windscreen.scad>
show_all = false;

clrs = [0.1, 0.15, 0.25];
seg  = 15;    // rail length per sample
module label(t) { linear_extrude(0.4) text(t, size = 2.6, halign = "center"); }

for (i = [0 : len(clrs) - 1]) translate([i * (seg + 3), 0, 0]) {
    // groove open at z = base_h; printed on this face (see print_layout: base is flipped)
    translate([0, 0, base_h]) rotate([180, 0, 0]) difference() {
        translate([0, -base_w / 2, 0]) cube([seg, base_w, base_h]);
        translate([-1, -panel_t / 2 - clrs[i], base_floor - clrs[i]]) cube([seg + 2, panel_t + 2 * clrs[i], groove_d + 2]);
    }
    translate([seg / 2, -1, base_h]) label(str(clrs[i]));   // on the floor face (up, as printed)
}
