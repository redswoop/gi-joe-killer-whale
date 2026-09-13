// Tab fit coupon: four arcs of the shroud's lower side (the +Y side, the
// toy's bottom, where the L tab lives) with a ladder of tab variants.
// Clip each one onto the Whale; the one that seats without rocking and
// does not slide off wins.  Put its grip into tab_grip in shroud.scad.
//
// The arc keeps the base face and the wall radius so the coupon sits
// on the toy exactly like the real shroud does.  Vane slots and strut ribs
// are left out: they play no part in the tab fit.
include <shroud.scad>
show_ghost = false; show_shroud = false; show_strut = false; show_vanes = false;

// Round 1 (2026-09-10): grips 0.2 / 0.5 / 0.8 / 1.1 -> 0.8 held best but a tad tight, 0.5 loose: tab_grip = 0.7.
// Round 2: grip fixed at 0.7, the stem widened to take up the left/right play in the Whale's channel.
variants = [[0.7, 0.15], [0.7, 0.3], [0.7, 0.45], [0.7, 0.6]];   // [grip, stem_extra]; foot overhang 1.28 / 1.13 / 0.98 / 0.83
labels   = ["s.15", "s.3", "s.45", "s.6"];
keep  = 0.3;                        // fraction of the ring to print, centred on the tab (0.5 = the whole lower half)
pitch = [90, 30];                   // grid spacing on the bed
tag   = [16, 9, 1.2];               // label tag lying on the bed at the +X end of the arc
text_h = 0.6;

half_a = keep * 180;                                        // half the kept arc, degrees
end_x  = duct_r_out * cos(90 - half_a);                     // where the outer wall meets the cut, +X end
end_y  = duct_r_out * sin(90 - half_a);

// pie wedge about +Y spanning the kept arc: a fan of points on a big circle, then extruded
module wedge_2d() {
    R = 100;
    polygon(concat([[0, 0]], [for (a = [90 - half_a : 2 : 90 + half_a]) R * [cos(a), sin(a)]], [[0, 0]]));
}

module half_shroud(v) {
    intersection() {
        union() {
            intersection() { duct_ring(); below_taper(); }
            deco_boxes();
            tab(v[0], v[1]);
        }
        translate([0, 0, -1]) linear_extrude(30) wedge_2d();
    }
}

module label_tag(label) {
    // tag hangs off the +X cut end, square to the cut face
    translate([end_x, end_y, 0]) rotate([0, 0, 90 - half_a]) translate([-tag[0], -tag[1], 0]) {
        cube(tag);
        translate([tag[0] / 2, tag[1] / 2, tag[2] - eps])
            linear_extrude(text_h + eps)
                text(label, size = 5, halign = "center", valign = "center", font = "Liberation Sans:style=Bold");
    }
}

for (i = [0 : len(variants) - 1])
    translate([(i % 2) * pitch[0], floor(i / 2) * pitch[1], 0]) {
        half_shroud(variants[i]);
        label_tag(labels[i]);
    }
