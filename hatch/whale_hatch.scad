// =====================================================================
//  Killer W.H.A.L.E. front landing hatch (bow ramp) + replacement hinge
//
//  Units mm. Frame: hinge axis = X at the origin, +Y aft toward the cabin,
//  +Z up. The hatch is drawn CLOSED, arching up over the bay like the fenders.
//  The plate is built in a "plate frame" whose origin is the outer surface's
//  front corner (top of the front face); hatch_shift moves it so the pin axis
//  lands on the world X axis, and open_deg swings the hatch about that.
//
//  Three printed parts (Armen 2026-09-13):
//    hatch  the arched tray. Under its front edge a dovetail SOCKET runs the full
//           width, open at both ends.
//    front  a flat plate carrying the front face and the hinge pins out of its side
//           edges; a dovetail RAIL on its top edge slides into the socket along X.
//           This is the part to iterate on.
//    mount  x2, a plate with a pin hole that sits between the front's side edge and
//           the fender's inner face and is glued to the fender, with the closed hatch
//           as the jig. The pins do not touch the hull directly.
//
//  The real part (eBay photos, 2026-09-11) is a shallow tray: a 1.5 plate with a
//  ~3 mm rim on the inside along both sides and the cabin end, a round hinge bar
//  across the hinge edge on the inside with lobed ears and short outward pins,
//  four latch hooks on the side edges, vents + ribbed panels on the outer face.
//  A separate black treaded "liner" snaps into the tray (not modelled yet).
//  Bow end, side view, front to the right: the arch ends in a vertical front face that
//  drops 10 to the hull's lip level (the pencil tracing) and the front plate continues
//  below the lip to the hinge pins.
//  Parameters first, one section per feature; modules below; assembly last.
// =====================================================================

// ---------- switches ----------
show_ghost = false;    // no reference STL yet
show_all   = true;
show_hull  = true;     // grey mock of the bay: floor + fenders, for the viewer only
open_deg   = 0;        // animate: 0 = closed, ~115 = ramp lowered over the nose
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

// ---------- front face + dovetail socket (Armen 2026-09-13) ----------
front_h    = 10;       // vertical front face: outer surface down to the hull's lip level. Tracing: the curve
                       // is 10 above the paper edge at the 90 mark and the paper edge rested on the lip.
front_t    = 3.5;      // the front plate's thickness. Thick enough for the rail and the 2.6 pins; only
                       // its edges show, inside the fenders.
sock_h     = 4.5;      // socket block: outer surface down to the seam with the front plate (= skin + rim)
sock_back  = 1.5;      // wall behind the groove
rail_h     = 1.2;      // dovetail rail up from the front plate's top edge into the groove
rail_neck  = 1.2;      // rail thickness where it leaves the plate (measured back from the inner face)
rail_taper = 1.0;      // extra thickness at the rail's top, toward the OUTER face. One-sided dovetail:
                       // the inner face is flat so the front prints on that face with no overhang.
slide_clr  = 0.15;     // rail-to-groove clearance per face (coupon.scad)
sock_d     = front_t + slide_clr + sock_back;   // socket block depth aft of the front face

// ---------- hinge pins, out of the front plate's side edges ----------
hinge_pin_d = 2.6;     // pin diameter (photo ~2.6; Cryoguns' replacement bracket bores 3.10)
pin_len     = 3.5;     // how far each pin sticks out past the side edge (photo ~3.5-4.5)
pin_below_lip = 3;     // pin axis below the lip level.                               PHOTO ESTIMATE
pin_edge    = 2.5;     // front plate material below the pin axis
pin_y       = front_t - hinge_pin_d / 2;   // axis aft of the outer face: the pin lies on the bed when
                                            // the front prints on its inner face

// ---------- mounts: one bracket per side, pin hole, glued to the fender's inner face ----------
pin_clr     = 0.4;     // pin-to-hole clearance (coupon; hinge_clr from the shroud was 0.4)
mount_t     = 3.0;     // bracket thickness = the gap between the hatch and the fender minus a hair
                       // ((bay_w - hatch_w) / 2 = 3.6 measured, pin_len 3.5 passes through)
mount_clr   = 0.2;     // gap between the front plate's side edge and the bracket
mount_len   = 14;      // bracket along Y
mount_h     = 10;      // bracket along Z
mount_hole_back = 5;   // hole centre from the bracket's front edge
mount_hole_up   = 4;   // hole centre above the bracket's bottom edge
mount_r     = 1.5;     // corner radius

// ---------- bay mock (photo estimates, viewer only) ----------
bay_w      = 100.5;    // ruler across the bay near the cabin: 0.2 .. 10.2 cm
bay_len    = 102;      // ruler along the bay: fender corner at the cabin to the front lip
bay_depth  = 25;       // floor below the hinge line. Unmeasured
fender_w   = 30;

$fn = 96;
eps = 0.01;

use <../../lib/shape.scad>
use <../../lib/fit.scad>

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

// Hinge end, in the plate frame's YZ (y aft, z up; the outer surface's front corner at 0,0).
// The socket block spans z = 0 .. -sock_h; the front plate hangs below the seam and carries
// the pins on the world X axis once hatch_shift is applied.
seam_z     = -sock_h;                                // socket / front plate seam
front_bot  = -front_h - pin_below_lip - pin_edge;    // front plate's bottom edge
pin_axis   = [pin_y, -front_h - pin_below_lip];      // (y, z) of the hinge axis in the plate frame
hatch_shift = [0, -pin_axis[0], -pin_axis[1]];       // plate frame -> world (axis on X)
echo(str("hinge axis ", pin_axis[0], " aft of the front face, ", pin_below_lip, " below the lip; front plate ",
         seam_z - front_bot, " tall + ", rail_h, " rail"));

// Dovetail rail profile (y, z), grown by g on the fitting faces for the groove. Flat on the
// inner face (y = front_t), the taper toward the outer face is what holds the front on.
function rail_2d(g = 0) = [[front_t - rail_neck - g, seam_z - (g > 0 ? 1 : 0)],
                           [front_t + g,             seam_z - (g > 0 ? 1 : 0)],
                           [front_t + g,             seam_z + rail_h + g],
                           [front_t - rail_neck - rail_taper - g, seam_z + rail_h + g]];

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

module hatch_tray() {                               // skin + rim + socket block, minus pocket and groove
    difference() {
        union() {
            intersection() { across(hatch_w) band_2d(arc_R, arc_R - hatch_t - rim_h); plan_clip(); }
            socket_block();
        }
        // pocket: everything inside the skin, inset rim_t from the sides and the cabin end,
        // stopping at the socket block's back wall (y = sock_d)
        intersection() {
            across(hatch_w + 1) band_2d(arc_R - hatch_t, arc_R - hatch_t - rim_h - 1,
                                        a_hinge - 5 * a_dir, a_end - a_dir * rim_t / arc_R * 180 / PI);
            plan_clip(rim_t);
            translate([-100, sock_d, -100]) cube([200, 300, 200]);
        }
        across(hatch_w + 2) polygon(rail_2d(slide_clr));   // the groove, open at both ends
    }
}

// Socket block under the plate's front edge: y = 0 .. sock_d, from the seam up to the outer surface.
// Clipped against the outer arc only (band_2d would also cut it along the slanted radial line at T
// and take the groove's lip with it).
module socket_block() {
    intersection() {
        across(hatch_w) polygon([[0, seam_z], [sock_d, seam_z], [sock_d, 5], [0, 5]]);
        across(hatch_w + 1) polygon(concat(arc_seg(arc_R, a_hinge - 5 * a_dir, a_hinge + 10 * a_dir), [[30, -30], [-10, -30]]));
    }
}

// The front plate: flat, y = 0 .. front_t, from the seam down to front_bot, with the rail on
// top and a pin out of each side edge. Plate frame. Prints on its inner face (print_layout).
module front_local() {
    across(hatch_w) polygon([[0, front_bot], [front_t, front_bot], [front_t, seam_z], [0, seam_z]]);
    across(hatch_w) polygon(rail_2d());
    for (sx = [-1, 1]) translate([sx * hatch_w / 2, pin_axis[0], pin_axis[1]]) rotate([0, sx * 90, 0]) {
        cylinder(d = hinge_pin_d, h = pin_len - hinge_pin_d / 2);
        translate([0, 0, pin_len - hinge_pin_d / 2]) sphere(d = hinge_pin_d);   // rounded tip
    }
}
module front() { translate(hatch_shift) front_local(); }          // world frame, closed pose

// One mount bracket, in its own frame: a plate in YZ, thickness along +X from x = 0,
// front-bottom corner at the origin, hole through it at (mount_hole_back, mount_hole_up).
module mount_local() {
    rotate([90, 0, 90]) linear_extrude(mount_t) difference() {
        offset(r = mount_r) offset(delta = -mount_r) square([mount_len, mount_h]);
        translate([mount_hole_back, mount_hole_up]) circle(d = hinge_pin_d + pin_clr);
    }
}
// Both brackets in the world frame: hole on the hinge axis, inner face mount_clr off the front plate.
module mounts() {
    for (sx = [-1, 1]) mirror([sx < 0 ? 1 : 0, 0, 0])
        translate([hatch_w / 2 + mount_clr, -mount_hole_back, -mount_hole_up]) mount_local();
}

module hatch() {              // the printed hatch, closed pose, world frame
    translate(hatch_shift) {
        if (show_rim) { hatch_tray(); cabin_lip(); } else { hatch_plate(); socket_block(); }
    }
}

module bay_mock() {           // hull stand-in for the viewer, not printed
    color("DimGray", 0.35) translate(hatch_shift) {
        translate([-bay_w / 2, 0, -bay_depth]) cube([bay_w, bay_len, 2]);
        // fenders: the arch, then the 10 mm vertical drop at the front, down to the floor
        for (sx = [-1, 1]) translate([sx * (bay_w / 2 + fender_w / 2), 0, 0])
            across(fender_w) polygon(concat(arc_seg(arc_R, a_hinge, a_top), [[bay_len, -bay_depth], [0, -bay_depth]]));
    }
}

// =====================================================================
//  assembly
// =====================================================================
if (show_hull) bay_mock();
if (show_all) {
    rotate([-open_deg, 0, 0]) { color("OliveDrab") hatch(); color("DarkOliveGreen") front(); }
    color("SlateGray") mounts();
}
