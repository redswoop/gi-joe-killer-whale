// =====================================================================
//  Killer W.H.A.L.E. front landing hatch (bow ramp) + replacement hinge
//
//  Units mm. Frame: hinge axis = X at the origin, +Y aft toward the cabin,
//  +Z up. The hatch is drawn CLOSED: its hinge edge along X at y = 0, its
//  cabin end near y = hatch_len, arching up over the bay like the fenders.
//  The outer (top) surface passes through the origin at the hinge edge.
//
//  The real part (eBay photos, 2026-09-11) is a shallow tray: a 1.5 plate with a
//  ~3 mm rim on the inside along both sides and the cabin end, a round hinge bar
//  across the hinge edge on the inside with lobed ears and short outward pins,
//  four latch hooks on the side edges, vents + ribbed panels on the outer face.
//  A separate black treaded "liner" snaps into the tray (not modelled yet).
//  Parameters first, one section per feature; modules below; assembly last.
// =====================================================================

// ---------- switches ----------
show_ghost = false;    // no reference STL yet
show_all   = true;
show_hull  = true;     // grey mock of the bay: floor + fenders, for the viewer only
open_deg   = 0;        // animate: 0 = closed, ~115 = ramp lowered over the nose
hinge_style = "slide"; // "slide": separate bar (printed flat) slides along X onto a dovetail tongue on the
                       //          hatch's hinge edge; the fender holes then lock it in place
                       // "pins":  bar + ears + pins integral with the hatch (needs the hatch printed on an end)
                       // "none":  bare shape check
show_rim   = true;     // the tray rim on the inside face

// ---------- plate ----------
hatch_w    = 93.3;     // measured, WHALE/measurements.md "width of ramp"
hatch_len  = 90;       // traced 2026-09-11: x-extent of the fender edge, cabin face to the front lip
hatch_rise = 18;       // traced: the hinge end sits 18 below the flat end (drops 0 / 4 / 18 at x = 0 / 50 / 90)
hatch_sag  = 5.9;      // circle through the three traced points: R 180.7, chord 91.8, sagitta 5.93
hatch_t    = 1.5;      // Armen 2026-09-11: same as the rest of the shell (the hatch itself is missing)
plate_extra = 0;       // full-thickness plate past the traced 90 (the cabin face). Tune on the print.
top_bevel  = 0;        // angle of the cabin end face from the radial (square) cut; + makes the OUTER
                       // surface the long one. 0 after the eBay photo of the real part (square edge).
top_edge_w = 68.85;    // width of the cabin end after the 45 deg corner cuts = the wide end of the
                       // top-hatch opening (WHALE/measurements.md "wider opening"). Photo of the real
                       // part scales to ~69 too.
top_chamfer = (hatch_w - top_edge_w) / 2;   // 12.2: leg of each 45 deg corner cut, in plan

// ---------- cabin-end lip: a ledge that tucks under the top hatch ----------
top_hatch_t = 2.5;     // Armen's top hatch (WHALE/Whale Hatch.3mf) is a 2.5 plate at that edge
lip_clr    = 0.2;      // gap between the top hatch's underside and the ledge
lip_drop   = top_hatch_t + lip_clr;          // ledge's top surface below the outer surface
lip_t      = 1.5;      // ledge thickness
lip_len    = 5;        // ledge reach past the plate's end, under the top hatch (eBay photo ~5-6)

// ---------- tray rim (inside face; PHOTO ESTIMATES) ----------
rim_h      = 3;        // rim height above the plate's inner face (photo: shallow tray)
rim_t      = 1.5;      // rim wall thickness

// ---------- hinge (PHOTO ESTIMATES off the eBay pictures, scaled on the 93.3 width) ----------
hinge_pin_d = 2.6;     // pin diameter (photo ~2.6; Cryoguns' replacement bracket bores 3.10)
pin_len     = 3.5;     // how far each pin sticks out past the side edge (photo ~3.5-4.5)
pin_drop    = 3.0;     // pin/bar axis inside the outer surface, measured along the plate's normal
pin_back    = -0.85;   // pin/bar axis along the plate: + = past the hinge edge, - = under the plate.
                       // -0.85 puts the pin's underside on the bed when the slide bar prints flat.
bar_d       = 4;       // ("pins" style) hinge bar diameter (photo ~3-4)
ear_r       = 3.5;     // ear lobe radius about the axis
ear_w       = 5;       // ear width along X (from the side edge inward)
ear_up      = 8;       // ("pins" style) ear web reach up the plate's inner face

// ---------- slide bar ("slide" style; the bar is a separate flat print) ----------
tongue_len = 4;        // dovetail tongue on the hatch's hinge edge: reach along the plate
tongue_t   = 3.0;      // its thickness at the very edge (tapers back to hatch_t over tongue_len)
slide_clr  = 0.15;     // tongue-to-slot clearance per face (coupon)
bar_floor  = 2.0;      // bar material beyond the tongue tip
bar_in     = 5.0;      // bar reach into the tray (from the outer surface), i.e. the inner wall's outside
bar_out    = 0.6;      // lip over the outer surface at the hinge edge (keeps the bar from lifting inward)
bar_lip_len = 2.5;     // that lip's reach along the plate
bar_reach  = 5.5;      // inner wall's reach along the plate (> tongue_len so it grips the plain plate)

// ---------- bay mock (photo estimates, viewer only) ----------
bay_w      = 100.5;    // ruler across the bay near the cabin: 0.2 .. 10.2 cm
bay_len    = 102;      // ruler along the bay: fender corner at the cabin to the front lip
bay_depth  = 25;       // floor below the hinge line. Unmeasured
fender_w   = 30;

$fn = 96;
eps = 0.01;

use <../lib/shape.scad>
use <../lib/fit.scad>

// =====================================================================
//  geometry helpers
// =====================================================================
// Circle through the hinge edge (0,0), the traced top (hatch_len, hatch_rise)
// and bulging hatch_sag above the chord's midpoint, in the YZ plane.
// Chord length c, sagitta s  ->  R = (c^2/4 + s^2) / (2 s).
chord_c  = sqrt(hatch_len * hatch_len + hatch_rise * hatch_rise);
arc_R    = (chord_c * chord_c / 4 + hatch_sag * hatch_sag) / (2 * hatch_sag);
chord_a  = atan2(hatch_rise, hatch_len);              // chord tilt above +Y
arc_half = asin(chord_c / 2 / arc_R);                 // half the arc's angle
// centre: from the chord midpoint, go (R - s) along the chord's inward normal
arc_cen  = [chord_c / 2 * cos(chord_a), chord_c / 2 * sin(chord_a)]
         + (arc_R - hatch_sag) * [sin(chord_a), -cos(chord_a)];
// angles (in YZ, from +Y toward +Z) of the hinge edge, the traced top, and the real end
a_hinge  = atan2(0 - arc_cen[1], 0 - arc_cen[0]);
a_top    = atan2(hatch_rise - arc_cen[1], hatch_len - arc_cen[0]);
a_dir    = sign(a_top - a_hinge);                     // which way the angle runs, hinge -> cabin
a_end    = a_top + a_dir * plate_extra / arc_R * 180 / PI;
a_lip    = a_end + a_dir * lip_len / arc_R * 180 / PI;    // where the ledge ends
end_pt   = arc_cen + arc_R * [cos(a_end), sin(a_end)];   // outer corner at the cabin end
in_sign  = -a_dir;                                    // local-frame sign: +Y into the plate

function arc_seg(r, a0, a1, n = 48) = [for (i = [0 : n]) let (a = a0 + (a1 - a0) * i / n)
    arc_cen + r * [cos(a), sin(a)]];

// A band of the arc between radii r_out and r_in (r_out > r_in), from the hinge
// edge to 10 deg past the cabin end, then clipped by the cabin end face (bevel).
module band_2d(r_out, r_in, a0 = a_hinge, a1 = a_end + 10 * a_dir) {
    intersection() {
        polygon(concat(arc_seg(r_out, a0, a1), arc_seg(r_in, a1, a0)));
        // Half-plane on the hinge side of the cut line through end_pt. The square's local
        // +X is its outward normal; the tangent toward the cabin is a_end + 90 * a_dir, and
        // top_bevel pivots the line about the outer corner toward the hinge.
        translate(end_pt) rotate(a_end + (90 + top_bevel) * a_dir)
            translate([-500, -500]) square([500, 1000]);
    }
}

// Extrude a YZ section across X and clip it to a plan outline.
module across(w) { rotate([90, 0, 90]) translate([0, 0, -w / 2]) linear_extrude(w) children(); }
module plan_2d(inset = 0) {                         // plate outline in XY with the corner cuts
    c = top_chamfer; w = hatch_w / 2; L = end_pt[0];
    offset(delta = -inset) polygon([[-w, -50], [w, -50], [w, L - c], [w - c, L + 50], [-w + c, L + 50], [-w, L - c]]);
}
module plan_clip(inset = 0) { translate([0, 0, -100]) linear_extrude(300) plan_2d(inset); }

// =====================================================================
//  parts
// =====================================================================
module hatch_plate() {                              // the 1.5 skin alone
    intersection() { across(hatch_w) band_2d(arc_R, arc_R - hatch_t); plan_clip(); }
}

// Ledge under the top hatch: a band lip_t thick, its top lip_drop below the outer surface,
// from just inside the rim's end wall (so they fuse) to lip_len past the plate's end.
module cabin_lip() {
    a0 = a_end - a_dir * (rim_t + eps) / arc_R * 180 / PI;
    across(top_edge_w) polygon(concat(
        arc_seg(arc_R - lip_drop,         a0,    a_lip, 16),
        arc_seg(arc_R - lip_drop - lip_t, a_lip, a0,    16)));
}

module hatch_tray() {                               // skin + rim: a thicker plate minus the pocket
    difference() {
        intersection() { across(hatch_w) band_2d(arc_R, arc_R - hatch_t - rim_h); plan_clip(); }
        // pocket: everything inside the skin, inset rim_t from the sides and the cabin end,
        // open at the hinge end (the bar closes that side)
        intersection() {
            across(hatch_w + 1) band_2d(arc_R - hatch_t, arc_R - hatch_t - rim_h - 1,
                                        a_hinge - 5 * a_dir, a_end - a_dir * rim_t / arc_R * 180 / PI);
            plan_clip(rim_t);
        }
        // "slide": the bar's inner wall wraps the hinge edge, so the side rims stop short of it
        if (hinge_style == "slide") hinge_frame() across(hatch_w + 1) polygon([
            [in_sign * hatch_t, -1], [in_sign * (hatch_t + rim_h + 1), -1],
            [in_sign * (hatch_t + rim_h + 1), bar_reach + slide_clr], [in_sign * hatch_t, bar_reach + slide_clr]]);
    }
}

// Local frame at the hinge edge: origin on the outer surface at x = 0, +Z along the
// plate toward the cabin, +Y into the plate's thickness (in_sign takes care of the arc's sense).
module hinge_frame() { rotate([(a_hinge + 90 * a_dir) - 90, 0, 0]) children(); }

module hinge_bar() {
    axis = [0, in_sign * pin_drop, -pin_back];
    hinge_frame() translate(axis) {
        // the bar across the full width
        rotate([0, 90, 0]) cylinder(d = bar_d, h = hatch_w - 2 * ear_w + eps, center = true);
        for (sx = [-1, 1]) {
            // ear lobe + web up to the plate's inner face
            hull() {
                translate([sx * (hatch_w / 2 - ear_w / 2), 0, 0]) rotate([0, 90, 0]) cylinder(r = ear_r, h = ear_w, center = true);
                translate([sx > 0 ? hatch_w / 2 - ear_w : -hatch_w / 2, -in_sign * (pin_drop - hatch_t) - (in_sign > 0 ? eps : rim_h), ear_up - ear_r])
                    cube([ear_w, rim_h + eps, ear_r]);
            }
            // pin, rounded tip
            translate([sx * hatch_w / 2, 0, 0]) rotate([0, sx * 90, 0]) {
                cylinder(d = hinge_pin_d, h = pin_len - hinge_pin_d / 2);
                translate([0, 0, pin_len - hinge_pin_d / 2]) sphere(d = hinge_pin_d);
            }
        }
    }
}

// Dovetail tongue along the hinge edge, on the inside face (local frame: u into the
// thickness, v along the plate). Thick at the edge, tapering back to the plain plate.
module hinge_tongue() {
    hinge_frame() across(hatch_w) polygon([
        [in_sign * (hatch_t - eps), 0], [in_sign * tongue_t, 0], [in_sign * (hatch_t - eps), tongue_len]]);
}

// The slide bar: a channel along X whose slot matches the tongue (+ clearance), open toward
// the plate (+Z local). Ear lobes at both ends carry the pins. Modelled in the hinge frame,
// i.e. in its installed position on the hatch.
module slide_bar_local() {
    c = slide_clr; L = hatch_w + 2 * c;                  // a hair longer than the plate for the ends
    axis = [in_sign * pin_drop, pin_back];              // (y, z) of the pin axis
    difference() {
        union() {
            // channel body: floor + outer lip (full depth to lip_len), inner wall up to bar_reach
            translate([-L / 2, 0, 0]) mirror([0, in_sign < 0 ? 1 : 0, 0]) {
                translate([0, -bar_out, -bar_floor - c]) cube([L, bar_out + bar_in, bar_floor + c + bar_lip_len]);
                translate([0, 0, -bar_floor - c])        cube([L, bar_in, bar_floor + c + bar_reach]);
            }
            // ear lobes, flat on the far side so the bar prints on its back
            for (sx = [-1, 1]) intersection() {
                translate([sx * (hatch_w / 2 - ear_w / 2), axis[0], axis[1]])
                    rotate([0, 90, 0]) cylinder(r = ear_r, h = ear_w, center = true);
                translate([-100, -100, -bar_floor - c]) cube([200, 200, 100]);
            }
        }
        // the slot: tongue + clearance, open at the top
        across(L + 2) polygon([
            [in_sign * -c, -c], [in_sign * (tongue_t + c), -c],
            [in_sign * (hatch_t + c), tongue_len], [in_sign * (hatch_t + c), 100], [in_sign * -c, 100]]);
    }
    // pins, rounded tips
    for (sx = [-1, 1]) translate([sx * hatch_w / 2, axis[0], axis[1]]) rotate([0, sx * 90, 0]) {
        cylinder(d = hinge_pin_d, h = pin_len - hinge_pin_d / 2);
        translate([0, 0, pin_len - hinge_pin_d / 2]) sphere(d = hinge_pin_d);
    }
}
module slide_bar() { hinge_frame() slide_bar_local(); }   // in the assembly frame

module hatch() {              // the printed hatch, closed pose
    if (show_rim) { hatch_tray(); cabin_lip(); } else hatch_plate();
    if (hinge_style == "pins") hinge_bar();
    if (hinge_style == "slide") hinge_tongue();
}

module bay_mock() {           // hull stand-in for the viewer, not printed
    color("DimGray", 0.35) {
        translate([-bay_w / 2, 0, -bay_depth]) cube([bay_w, bay_len, 2]);
        for (sx = [-1, 1]) translate([sx * (bay_w / 2 + fender_w / 2), 0, 0])
            across(fender_w) polygon(concat(arc_seg(arc_R, a_hinge, a_top), [[bay_len, -bay_depth], [0, -bay_depth]]));
    }
}

// =====================================================================
//  assembly
// =====================================================================
if (show_hull) bay_mock();
if (show_all) rotate([-open_deg, 0, 0]) {
    color("OliveDrab") hatch();
    if (hinge_style == "slide") color("DarkOliveGreen") slide_bar();
}
