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
hinge_style = "pins";  // "pins" (like the original: bar + ears + outward pins) | "none" (bare shape check)
show_rim   = true;     // the tray rim on the inside face

// ---------- plate ----------
hatch_w    = 93.3;     // measured, WHALE/measurements.md "width of ramp"
hatch_len  = 90;       // traced 2026-09-11: x-extent of the fender edge, cabin face to the front lip
hatch_rise = 18;       // traced: the hinge end sits 18 below the flat end (drops 0 / 4 / 18 at x = 0 / 50 / 90)
hatch_sag  = 5.9;      // circle through the three traced points: R 180.7, chord 91.8, sagitta 5.93
hatch_t    = 1.5;      // Armen 2026-09-11: same as the rest of the shell (the hatch itself is missing)
cabin_tuck = 5;        // the plate continues past the traced 90 under the cabin lip (eBay photo: plate
                       // ~97 long on the 93.3 width). Set 0 if the print hits the cabin.
top_bevel  = 0;        // angle of the cabin end face from the radial (square) cut; + makes the OUTER
                       // surface the long one. 0 after the eBay photo of the real part (square edge).
top_chamfer = 10;      // 45 deg corner cuts at the cabin end, in plan (photo: ~10 mm legs)

// ---------- tray rim (inside face; PHOTO ESTIMATES) ----------
rim_h      = 3;        // rim height above the plate's inner face (photo: shallow tray)
rim_t      = 1.5;      // rim wall thickness

// ---------- hinge (PHOTO ESTIMATES off the eBay pictures, scaled on the 93.3 width) ----------
hinge_pin_d = 2.6;     // pin diameter (photo ~2.6; Cryoguns' replacement bracket bores 3.10)
pin_len     = 3.5;     // how far each pin sticks out past the side edge (photo ~3.5-4.5)
pin_drop    = 3.0;     // pin/bar axis inside the outer surface, measured along the plate's normal
pin_back    = 0;       // pin/bar axis behind the hinge edge, along the plate (+ = past the edge)
bar_d       = 4;       // hinge bar diameter (photo ~3-4)
ear_r       = 4;       // ear lobe radius about the axis
ear_w       = 5;       // ear width along X (from the side edge inward)
ear_up      = 8;       // ear web reach up the plate's inner face

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
a_end    = a_top + a_dir * cabin_tuck / arc_R * 180 / PI;
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

module hatch() {              // the printed part, closed pose
    if (show_rim) hatch_tray(); else hatch_plate();
    if (hinge_style == "pins") hinge_bar();
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
if (show_all) rotate([-open_deg, 0, 0]) color("OliveDrab") hatch();
