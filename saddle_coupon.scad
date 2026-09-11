// Saddle-mount fit coupon (ny_mount = "saddle"): three pieces of rim, each carrying one receiver at a
// different cheek clearance, and one stub of the +X bar's -Y end with the wedge peg and the nub dimple,
// standing on its end like the real vane prints (on a thin foot). Drop the stub into each receiver: the
// peg should seat on the pocket floor with the +Y face against the pocket wall, the cheeks should hold
// the bar without rocking, and the nub should click. Put the winner into chan_clr in shroud.scad.
// The pocket clearance is peg_clr (0.15, the +Y peg's proven fit) on all three.
include <shroud.scad>
show_ghost = false; show_shroud = false; show_strut = false; show_vanes = false;
ny_mount = "saddle";

chan_clrs = [0.05, 0.10, 0.15];
box = [[vane_x - 7, recv_y0() - 4], [vane_x + vane_t + 7, recv_y1() + 4]];   // plan window around the receiver

// one receiver on its piece of rim, base down, exactly as duct() builds it
module recv_piece(clr) {
    difference() {
        union() {
            intersection() { duct_ring(); below_taper(); }
            receiver(clr);
        }
        channel_cut(clr);
        peg2_pocket();
        translate([-200, -200, -1]) cube([400, 400, 1]);   // nothing below the base
    }
    translate(recv_nub_c()) sphere(d = tooth_nub_d, $fn = 32);
}
module recv_window() { translate([box[0][0], box[0][1], -1]) cube([box[1][0] - box[0][0], box[1][1] - box[0][1], 40]); }

for (i = [0 : len(chan_clrs) - 1])
    translate([i * 20 - box[0][0], -box[0][1], 0]) {
        intersection() { recv_piece(chan_clrs[i]); recv_window(); }
    }
for (i = [0 : len(chan_clrs) - 1])
    translate([i * 20 + 4, box[1][1] - box[0][1] + 2, 0]) linear_extrude(0.6) text(str(chan_clrs[i]), size = 3);

// the bar stub: the +X vane's root from its -Y end to just past the receiver, standing on the -Y end
stub_y1 = recv_y1() + 3;
translate([70, 20, 0]) {
    translate([0, 0, -vane_top_l[0]]) rotate([90, 0, 0])
        intersection() { vane_root(); translate([vane_x - 5, vane_top_l[0] - 1, 0]) cube([vane_t + 10, stub_y1 - vane_top_l[0] + 1, 40]); }
    translate([vane_x - 3, -bar_top(vane_top_l[0]) - 2, 0]) cube([vane_t + 6, bar_top(vane_top_l[0]) - vane_end_l[1] + 4, 0.8]);   // foot under the end face
}
translate([64, 8, 0]) linear_extrude(0.6) text("stub", size = 3);
