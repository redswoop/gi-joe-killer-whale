// Tab fit coupon: four copies of the shroud's lower half (the +Y half, the
// toy's bottom, where the L tab lives) with a ladder of hook slot widths.
// Clip each one onto the Whale; the one that seats without rocking and
// does not slide off wins.  Put its grip into tab_grip in shroud.scad.
//
// The half ring keeps the base face and the wall radius so the coupon sits
// on the toy exactly like the real shroud does.  Vane slots and strut ribs
// are left out: they play no part in the tab fit.
include <shroud.scad>
show_ghost = false; show_shroud = false; show_strut = false; show_vanes = false;

grips = [0.2, 0.5, 0.8, 1.1];       // stem shortening; slot = tab_slot - grip = 2.24 / 1.94 / 1.64 / 1.34
pitch = [104, 54];                  // grid spacing on the bed (half ring is 94 x 50 with the boxes)
tag   = [16, 9, 1.2];               // label tag lying on the bed at the +X end of the cut
text_h = 0.6;

module half_shroud(grip) {
    intersection() {
        union() {
            intersection() { duct_ring(); below_taper(); }
            deco_boxes();
            tab(grip);
        }
        translate([-60, 0, -1]) cube([120, 60, 30]);   // keep y >= 0
    }
}

module label_tag(grip) {
    translate([duct_r_out - tag[0], -tag[1], 0]) {
        cube(tag);
        translate([tag[0] / 2, tag[1] / 2, tag[2] - eps])
            linear_extrude(text_h + eps)
                text(str("g", grip), size = 5, halign = "center", valign = "center", font = "Liberation Sans:style=Bold");
    }
}

for (i = [0 : len(grips) - 1])
    translate([(i % 2) * pitch[0], floor(i / 2) * pitch[1], 0]) {
        half_shroud(grips[i]);
        label_tag(grips[i]);
    }
