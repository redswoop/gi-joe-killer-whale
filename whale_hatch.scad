// =====================================================================
//  Killer W.H.A.L.E. front landing hatch (bow ramp) + replacement hinge
//
//  Units mm. Frame: hinge axis = X at the origin, +Y aft toward the cabin,
//  +Z up. The plate is drawn CLOSED: its hinge edge along X at y = 0, its
//  top edge at y = hatch_len, arching up over the bay like the fenders.
//  Parameters first, one section per feature; modules below; assembly last.
// =====================================================================

// ---------- switches ----------
show_ghost = false;    // no reference STL yet
show_all   = true;
show_hull  = true;     // grey mock of the bay: floor + fenders, for the viewer only
open_deg   = 0;        // animate: 0 = closed, ~115 = ramp lowered over the nose
hinge_style = "none";  // "none" (shape-check prints) | "eyes" (placeholder eyes at the hinge corners)

// ---------- plate (PHOTO ESTIMATES unless noted, 2026-09-11) ----------
hatch_w    = 93.3;     // measured, WHALE/measurements.md "width of ramp"
hatch_len  = 90;       // traced 2026-09-11: x-extent of the side edge, flat (cabin) end to the hinge end
hatch_rise = 18;       // traced: the hinge end sits 18 below the flat end (drops 0 / 4 / 18 at x = 0 / 50 / 90)
hatch_sag  = 5.9;      // circle through the three traced points: R 180.7, chord 91.8, sagitta 5.93
hatch_t    = 1.5;      // Armen 2026-09-11: same as the rest of the shell (the hatch itself is missing)
edge_r     = 1.0;      // rounding on the outer face's long edges (cosmetic, not applied yet)
top_bevel  = 45;       // Armen 2026-09-11: the cabin end is cut at 45. Angle of that end face from the
                       // radial (square) cut; + leans the face so the OUTER surface is the long one
                       // (a wedge that tucks under the cabin lip), - makes the inner surface longer.

// ---------- hinge ----------
hinge_pin_d = 3.0;     // Cryoguns' replacement bracket uses a 3.10 hole, so the original pins were ~3
hinge_ear_w = 6;       // width of each eye along X
hinge_ear_r = 4;       // eye outer radius
hinge_clr   = 0.3;     // pin-to-eye clearance per side (coupon)

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
// Circle through the hinge edge (0,0), the top edge (hatch_len, hatch_rise)
// and bulging hatch_sag above the chord's midpoint, in the YZ plane.
// Chord length c, sagitta s  ->  R = (c^2/4 + s^2) / (2 s).
chord_c  = sqrt(hatch_len * hatch_len + hatch_rise * hatch_rise);
arc_R    = (chord_c * chord_c / 4 + hatch_sag * hatch_sag) / (2 * hatch_sag);
chord_a  = atan2(hatch_rise, hatch_len);              // chord tilt above +Y
arc_half = asin(chord_c / 2 / arc_R);                 // half the arc's angle
// centre: from the chord midpoint, go (R - s) along the chord's inward normal
arc_cen  = [chord_c / 2 * cos(chord_a), chord_c / 2 * sin(chord_a)]
         + (arc_R - hatch_sag) * [sin(chord_a), -cos(chord_a)];
// angle (in the YZ plane, measured from +Y toward +Z) of the arc's two ends
a_hinge  = atan2(0 - arc_cen[1], 0 - arc_cen[0]);
a_top    = atan2(hatch_rise - arc_cen[1], hatch_len - arc_cen[0]);

// 2D section of the plate in the YZ plane (as [y, z] points): outer arc out,
// inner arc back, so the plate has thickness hatch_t measured radially. The
// band is drawn a little past the cabin end and then clipped by the bevel plane.
function arc_seg(r, a0, a1, n = 48) = [for (i = [0 : n]) let (a = a0 + (a1 - a0) * i / n)
    arc_cen + r * [cos(a), sin(a)]];
a_dir  = sign(a_top - a_hinge);                       // which way the arc's angle runs, hinge -> cabin
a_over = a_top + 10 * a_dir;                          // 10 deg of spare band past the cabin end
function plate_band() = concat(
    arc_seg(arc_R,           a_hinge, a_over),
    arc_seg(arc_R - hatch_t, a_over,  a_hinge));
top_pt = [hatch_len, hatch_rise];                     // outer corner at the cabin end
module plate_section_2d() {
    intersection() {
        polygon(plate_band());
        // Half-plane on the hinge side of the cut line through top_pt. The square's local
        // +X is its outward normal; the tangent toward the cabin is a_top + 90 * a_dir, and
        // top_bevel pivots the line about the outer corner toward the hinge.
        translate(top_pt) rotate(a_top + (90 + top_bevel) * a_dir)
            translate([-500, -500]) square([500, 1000]);
    }
}

// =====================================================================
//  parts
// =====================================================================
module hatch_plate() {
    // The section lives in YZ; extrude along X and centre it on the hinge.
    rotate([90, 0, 90]) translate([0, 0, -hatch_w / 2])
        linear_extrude(hatch_w) plate_section_2d();
}

module hinge_eyes() {
    // Two eyes on the inside of the plate at the hinge edge, bored along X.
    for (sx = [-1, 1]) translate([sx * (hatch_w / 2 - hinge_ear_w / 2), 0, 0])
        difference() {
            hull() {
                rotate([0, 90, 0]) cylinder(r = hinge_ear_r, h = hinge_ear_w, center = true);
                // web up onto the plate's inner face
                translate([-hinge_ear_w / 2, 0, 0]) cube([hinge_ear_w, hinge_ear_r + 4, eps]);
            }
            rotate([0, 90, 0]) cylinder(d = hinge_pin_d + 2 * hinge_clr, h = hinge_ear_w + 1, center = true);
        }
}

module hatch() {              // the printed part, closed pose
    hatch_plate();
    if (hinge_style == "eyes") hinge_eyes();
}

module bay_mock() {           // hull stand-in for the viewer, not printed
    color("DimGray", 0.35) {
        // floor
        translate([-bay_w / 2, 0, -bay_depth]) cube([bay_w, bay_len, 2]);
        // fenders: their inner top edge follows the same arc as the plate
        for (sx = [-1, 1]) translate([sx * (bay_w / 2 + fender_w / 2), 0, 0])
            rotate([90, 0, 90]) translate([0, 0, -fender_w / 2]) linear_extrude(fender_w)
                polygon(concat(arc_seg(arc_R, a_hinge, a_top), [[bay_len, -bay_depth], [0, -bay_depth]]));
    }
}

// =====================================================================
//  assembly
// =====================================================================
if (show_hull) bay_mock();
if (show_all) rotate([-open_deg, 0, 0]) color("OliveDrab") hatch();
