// =====================================================================
//  Killer W.H.A.L.E. fan shroud  --  OpenSCAD port of Armen's Shapr3D model
//
//  Every number below was read out of Shroud.shapr (sketch JSON + history
//  tree). Sections follow the Shapr3D history order so the two can be read
//  side by side.  Units mm.  Duct axis = Z, base face at z=0, tab at +Y.
// =====================================================================

// ---------- switches ----------
show_ghost  = true;    // overlay Armen's STL as a translucent reference
show_shroud = true;
show_strut  = true;
show_vanes  = true;

// ---------- Sketch 01 / 02 + Extrusion 01 + Split: the duct ----------
duct_r_in   = 44;
duct_r_out  = 46;
duct_h_max  = 22;      // height at the tab side (+Y)
duct_h_min  = 16;      // height at the opposite side (-Y)
duct_h_mid  = (duct_h_max + duct_h_min) / 2;                 // 19
taper_deg   = atan((duct_h_max - duct_h_min) / (2 * duct_r_out)); // 3.73°

// ---------- Extrusion 03 + Fillet 01 + Pattern 02 + Deletion 04: deco boxes ----------
box_r_out    = 47;     // 1 mm proud of the wall
box_w        = 4.92;   // chord width at r=47  (6° of arc)
box_z0       = 1;
box_h        = 12;
box_n        = 24;     // pattern count
box_step     = 360 / box_n;
box_skip     = [0, 1, 2, 22, 23];   // pattern instances deleted (centred on the tab)

// ---------- Extrusion 04: the L tab ----------
tab_z0 = 1.75;
tab_h  = 5.2;
tab_grip = 0.7;   // shorten the stem by this much: pulls the hook foot in toward the wall so it
                  // bites the Whale's lip (as sketched the gap was 2.442 and the shroud rocked / slid out).
                  // Tab coupon 2026-09-10: 0.8 held best but a tad tight, 0.5 too loose -> 0.7
tab_stem_extra = 0.2;   // widen the stem by this much toward the foot (the head stays 4.03 wide, the foot's
                      // overhang shrinks from 1.43 by the same amount). The Whale's opening is a square
                      // for the head, then a channel the stem slides along; the channel is wider than
                      // the 2.6 stem and the shroud shifts left/right. Coupon round 2 (2026-09-10): 0.15 and
                      // 0.3 both good, 0.3 a tad much -> 0.2
// plan-view outline, as sketched (x, y); inner points pushed to r=45 to fuse with the wall.
// A function of the grip and stem width so tab_coupon.scad can print ladders.
function tab_outline(grip = tab_grip, stem_extra = tab_stem_extra) =
    [[-0.687, 45], [-0.687, 49.778 - grip], [3.344, 49.778 - grip],
     [3.344, 48.442 - grip], [1.916 + stem_extra, 48.442 - grip], [1.916 + stem_extra, 45]];
tab_pts = tab_outline(tab_grip, tab_stem_extra);
tab_slot = 48.442 - duct_r_out;   // slot between the wall and the hook foot before any grip (2.442)

// ---------- Sketch 04 + Extrusion 06/08/09: strut plate and hub ----------
strut_w_center = 18;       // full width at x=0
strut_w_wall   = 9.66;     // full width where it meets r=44
strut_t        = 2;        // z -1 .. +1
strut_slope    = (strut_w_center - strut_w_wall) / 2 / 43.734;  // 0.0954

hub_core_r  = 5.385;  hub_core_t = 5;      // z ±2.5
hub_bite_r  = 1.5;    hub_bite_n = 6;  hub_bite_a0 = 30;
hub_ring_ri = 6.874;  hub_ring_ro = 8;  hub_ring_t = 4;   // z ±2
bore_r      = 2.5;

// ---------- Sketch 05 + Extrusion 10 + Fillet 03: underside panels ----------
panel_x0     = 10.005;
panel_len    = 9.997;
panel_gap    = 1.895;
panel_n      = 3;
panel_inset  = 2.072;   // vertical distance from strut edge to panel edge
panel_corner = 0.9;
panel_t      = 0.7;     // z -1 .. -1.7

// ---------- Plane offset + Sketch 06 + Extrusion 11 + Mirror: vane bars ----------
vane_x     = 27.5;      // inner face; 2 mm thick outward
vane_t     = 2;
// profile in the YZ plane (y, z), points straight from Sketch 06
vane_top_l = [-45.72, 30.201];  vane_top_r = [47, 31];
vane_end_l = [-45.72, 24.121];  vane_end_r = [47, 28];         // where the vertical ends meet the arcs
vane_arc_l = [[-45.72, 24.121], [-42.111, 20.584], [-41.359, 24.961]];   // start, end, centre
vane_arc_r = [[43.931, 25.813], [47, 28], [44.133, 28.777]];
peg_a      = [[-38.438, 14.71], [-31.664, 22.5]];   // [y,z] min / max
peg_b      = [[ 31.924, 19.065], [37.191, 26.5]];

// ---------- vane mechanism (new design, from photos of the real MET-b52 vanes) ----------
// Each vane = fixed root bar (your Sketch 06 body) + a trapezoidal plate hinged
// along the bar's top edge, printed in place (the original used a living
// hinge). A tie bar with eye ends snaps over pins at the plates' bottom corners
// so they steer together. Two tapered slats pivot on axles between the bars.
// Hinge axis is Y (the toy's vertical); +Y is the toy's bottom.
steer        = 0;      // deg, +/-30: pose of the plates and tie bar in the assembly
tilt         = 0;      // deg: pose of the slats
animate      = false;  // true: steer and tilt sweep with $t (View > Animate in the GUI)

barrel_d     = 4.2;    // hinge knuckle OD (pin + 2 clearances + 2 walls; about the floor)
pin_d        = 1.4;    // hinge pin, round; the plate's hole is a teardrop so it prints flat
hinge_clr    = 0.3;    // pin-to-hole clearance, per side. Coupon round 1: 0.35 and 0.45 good, 0.25 not;
                       // printed vanes at 0.4 (2026-09-10): range good but too loose -> 0.3
knuckle_gap  = 0.4;    // axial gap between neighbouring knuckles
knuckle_l    = 4;      // length of one knuckle
hinge_pts    = [-34, 36];     // Y centres of the two hinge nubs: 10 mm in from each plate end, over the teeth
hinge_len    = 3 * knuckle_l + 2 * knuckle_gap;   // root-plate-root, 12.8 mm
hinge_lift   = 0.6;    // barrel bottom above the bar's top edge; a printed barrel has a flat where it met the bed
hinge_z      = 31 + hinge_lift + barrel_d / 2;
hinge_y0     = -44;  hinge_y1 = 46;         // plate span along the bar
hinge_in     = true;   // barrel on the inside face (toward the fan), hidden between the vanes
hinge_x      = hinge_in ? vane_x + vane_t - barrel_d / 2 : vane_x + barrel_d / 2;   // barrel tangent to one face
print_face   = "outer";   // which face of the vane lies on the bed: "outer" (no supports; panels against the bed)
                          // or "inner" (barrels down, needs support under the plate; panels print as the top surface)
print_up     = print_face == "outer" ? -1 : 1;   // "up" in X while printing; the teardrop roofs point this way

fin_depth_top = 15;    // plate depth from the hinge line at the -Y (top) end     <-- photo estimates
fin_depth_bot = 25.5;  // ... and at the +Y (bottom) end: the trapezoid is the "angled cut"
fin_corner    = 2;     // corner radius
fin_z_low     = hinge_z - 0.5;   // plate's lower edge, just above the bar between the nubs

link_pin_d    = 2.4;   // pin at the plate's bottom trailing corner, pointing +Y (down); flush with the outer face
link_pin_len  = 7;     // long enough that the bulb sits past the tie bar and captures it
link_pin_inset = 2.8;  // from the trailing edge to the pin axis
bullet_d      = 4.5;   bullet_len = 2.5;   // bullet-shaped root reinforcing the pin, like the original (clipped flat at the outer face)
tie_snap      = 0.15;  // bulb on the pin end, oversize per side
tie_eye_clr   = 0.2;   // working hole clearance per side on the pin
tie_key_gap   = 0.1;   // keyhole: the bulb passes through the big hole freely by this much per side
tie_detent    = 0.1;   // the throat between big hole and working hole is this much narrower than the pin, total
tie_t         = 2;   tie_eye_d = 5.5;  tie_gap = 2.2;   // tie bar: thickness, eye OD, gap below the plates (clears the bullet)
tie_w         = 3;   tie_tab = 6;  tie_jog = 3;         // hat-shaped link  _/----\_ : bar width, straight tab at each eye, raise of the middle (0 = straight bar)
tie_knurl     = [1.2, 0.4, 0.3];                      // cross-hatch on the outer face: pitch, groove width, depth
link_len      = fin_depth_bot - link_pin_inset;      // crank length of the parallelogram

slat_y        = [-34.6, 13.6];   // axle positions along the bar (holes in the bars), from the photo
slat_z        = 26;              // axle height, mid-bar
slat_len_rod  = 52;   slat_len_edge = 40;  slat_depth = 17;   // trapezoid: long at the rod, short at the trailing edge
slat_t        = 2;    slat_rod_d = 2;  slat_clr = 0.2;        // rod = plate thickness so it prints flat; hole = rod + 2*clr

panel_recess  = 0.4;  panel_pitch = 1.0;  panel_groove = 0.55;   // ribbed rectangular panels, cosmetic
fin_panels    = [[0.22, 0.45], [0.67, 0.90]];   // along the plate, as fractions of its length
bar_panels    = [[0.18, 0.40], [0.70, 0.92]];

// root-to-shroud: each peg is a tooth that drops into a notch in the rim and
// clicks in: a spherical nub on the tooth's inner face snaps into a dimple in
// the notch wall. The nub sits at the end of the tooth where the oblique wall
// crossing leaves solid material behind it.
peg_clr      = 0.15;   // tooth to notch, per side
tooth_extra  = 3;      // pegs extended this much deeper than the sketch (5 mm engagement instead of 2)
tooth_nub_d  = 1.4;  tooth_nub_h = 0.35;  tooth_nub_clr = 0.15;   // nub sphere, its protrusion, dimple clearance
tooth_nub_off = 2;     // nub position along the tooth from its centre, toward the outer end

// strut-to-shroud: EARS IN POCKETS. The bar's ends bend up into curved ears
// that hug the bore wall; a boss on the wall at each end has a pocket, open at
// the base and blind halfway up the shroud. Slide the bar in from the base
// side until the ears hit the pocket ceilings. On the toy the hull sits under
// the bar and keeps it there. Nothing flexes.
ear_top    = duct_h_mid / 2;   // ears reach half the shroud's height (9.5)
ear_t      = strut_t;          // ear thickness, radial; same as the plate
ear_r_in   = duct_r_in - ear_t;                                       // ear hugs the bore: r 42..44
ear_w      = strut_w_center - 2 * strut_slope * (duct_r_in - 5);      // ear width = the bow-tie's width just short of the wall
ear_clr = 0.2;              // ear to pocket, per face (coupon: 0.1 / 0.2 / 0.3)
pocket_lip = 1.2;              // boss material inside the pocket (keeps the ear against the wall)
pocket_side = 1.5;             // boss material beside the pocket
pocket_lid = 1.5;              // boss material above the pocket (the ear's stop)
boss_r_in  = ear_r_in - ear_clr - pocket_lip;                      // boss's inner face, x at the +X end (40.6)
boss_w     = ear_w + 2 * ear_clr + 2 * pocket_side;
boss_top   = ear_top + ear_clr + pocket_lid;
boss_fade  = 3;                // concave fillet radius blending the boss into the bore wall, both sides and the top (max 3.4: the boss's proudness)

// ---------- Fillet 01 / 02 / 03 ----------
box_fillet_out   = 0.5;   // Fillet 01: convex rounds on the box's outer face edges
wall_blend_r     = 0.3;   // Fillet 02: concave blend where boxes and tab meet the wall
panel_fillet     = 0.5;   // Fillet 03: convex rounds on the panel free faces
fillet_fn        = 24;    // facets on fillet arcs (19 boxes x several fillets, keep modest)

$fn = 120;
eps = 0.01;

use <../lib/shape.scad>   // rounded_pad, annulus_2d, wall_blend, arc_sweep, arc_pts, stroke_2d, grooves_2d
use <../lib/fit.scad>     // teardrop_2d, keyhole_2d

// =====================================================================
//  helpers
// =====================================================================

// Half-space below the taper plane.  Rotating a huge cube about X by
// taper_deg tilts its top face; translate puts that face through z=19 at y=0.
module below_taper() {
    L = 200;
    translate([0, 0, duct_h_mid]) rotate([taper_deg, 0, 0])
        translate([-L, -L, -2 * L]) cube([2 * L, 2 * L, 2 * L]);
}

// 2D bow-tie: the strut plan view, extended into the wall
module strut_2d() {
    X = duct_r_out;                          // run it into the wall
    w = strut_w_center / 2 - strut_slope * X;
    polygon([[-X, -w], [0, -strut_w_center / 2], [X, -w],
             [ X,  w], [0,  strut_w_center / 2], [-X, w]]);
}

// One deco box in a local frame: centred on +Y, standing on the wall.
// The pad's own z axis becomes the radial direction; 0.5 mm is buried in the
// wall so the flat pad base clears the wall's curvature.
module deco_box() {
    bury = 0.5;
    translate([0, duct_r_out - bury, 0]) rotate([-90, 0, 0]) mirror([0, 1, 0])
        rounded_pad(box_r_out - duct_r_out + bury, box_fillet_out, fillet_fn)
            translate([-box_w / 2, box_z0]) square([box_w, box_h]);
    wall_blend(duct_r_out, box_w, box_z0, box_h, wall_blend_r, fillet_fn);
}

// one underside panel (2D), symmetric about y=0, tapered like the strut
module panel_2d(x0) {
    x1 = x0 + panel_len;
    h  = function(x) strut_w_center / 2 - strut_slope * x - panel_inset;
    c  = panel_corner;
    hull() for (x = [x0 + c, x1 - c], s = [-1, 1])
        translate([x, s * (h(x) - c)]) circle(c);   // corners follow the taper (approx.)
}

// =====================================================================
//  parts
// =====================================================================
module duct_ring() {
    difference() {
        cylinder(r = duct_r_out, h = duct_h_max);
        translate([0, 0, -1]) cylinder(r = duct_r_in, h = duct_h_max + 2);
    }
}

// nub centre for a tooth (in the +X vane's frame): [x, y, z]
function tooth_nub_c(p) = let (yc = (p[0][0] + p[1][0]) / 2, sgn = yc > 0 ? 1 : -1)
    [vane_x + tooth_nub_d / 2 - tooth_nub_h, yc + tooth_nub_off * sgn, p[0][1] - tooth_extra + 2];

// Plan view of the +X ear: a strip of the bore wall's annulus. With clr it is
// the pocket's plan view.
module ear_2d(clr = 0) {
    intersection() {
        difference() { circle(r = duct_r_in + clr); circle(r = ear_r_in - clr); }
        translate([ear_r_in - 5, -ear_w / 2 - clr]) square([10, ear_w + 2 * clr]);
    }
}
// Boss on the bore wall at the +X end (rotate 180 for the other end), fading
// into the wall with concave fillets of radius boss_fade on its two sides and
// its top. Each view is the 2D shape of "boss + a strip of wall" run through
// offset(r = +f) then offset(r = -f): growing the shape by f and shrinking it
// back fills every inside corner with a radius-f fillet and leaves convex
// corners sharp. The plan view is extruded up, the side view across, and the
// boss is their intersection.
function polar(r, a) = r * [cos(a), sin(a)];
module boss_plan_2d() {
    R = duct_r_in;  f = boss_fade;
    th_w = asin((boss_w / 2) / boss_r_in);     // half-angle of the radial side faces (boss_w wide at the inner face)
    intersection() {
        offset(r = -f) offset(r = f) union() {
            intersection() { circle(r = R + 1.5); polygon([[0, 0], polar(60, -th_w), polar(60, th_w)]); }   // the boss's sector, 1.5 mm into the wall
            difference() { circle(r = R + 1.5); circle(r = R); }                                             // a strip of wall for the fillets to land on
        }
        polygon([[0, 0], polar(60, -th_w - 30), polar(60, th_w + 30)]);   // keep the neighbourhood; the wall strip beyond is dropped
        difference() { circle(r = R + 1.5); circle(r = boss_r_in); }      // the boss's inner face (concentric with the bore)
    }
}
module boss_roof_2d() {                        // side view (x radial, y up): boss slab + wall strip, top corner filleted
    R = duct_r_in;  f = boss_fade;
    offset(r = -f) offset(r = f) union() {
        translate([boss_r_in - 1, 0]) square([R + 2 - boss_r_in + 1, boss_top]);
        translate([R, 0]) square([2, boss_top + f + 5]);
    }
}
module boss_pad() {
    intersection() {
        linear_extrude(boss_top + boss_fade + 1) boss_plan_2d();
        rotate([90, 0, 0]) linear_extrude(60, center = true) boss_roof_2d();
    }
}

// The pocket: the ear's strip from below the base up to the ceiling, plus a
// notch through the lip at the bottom for the plate to pass.
module pocket(clr = ear_clr) {
    translate([0, 0, -1]) linear_extrude(1 + ear_top + clr) ear_2d(clr);
    translate([boss_r_in - 1, -ear_w / 2 - clr, -1]) cube([ear_r_in - boss_r_in + 2, ear_w + 2 * clr, 1 + strut_t / 2 + clr]);
}

// Notches for the teeth, cut down from the rim; plus the dimples the nubs click into
module vane_slots() {
    for (sx = [-1, 1]) mirror([sx < 0 ? 1 : 0, 0, 0])
        for (p = [peg_a, peg_b]) {
            translate([vane_x - peg_clr, p[0][0] - peg_clr, p[0][1] - tooth_extra - peg_clr])
                cube([vane_t + 2 * peg_clr, p[1][0] - p[0][0] + 2 * peg_clr, 30]);
            translate(tooth_nub_c(p)) sphere(d = tooth_nub_d + 2 * tooth_nub_clr, $fn = 32);
        }
}

module duct() {
    difference() {
        intersection() {
            union() { duct_ring(); for (a = [0, 180]) rotate([0, 0, a]) boss_pad(); }
            below_taper();
        }
        vane_slots();
        for (a = [0, 180]) rotate([0, 0, a]) pocket();
    }
}

module deco_boxes() {
    for (i = [0 : box_n - 1])
        if (len(search(i, box_skip)) == 0)
            rotate([0, 0, i * box_step]) deco_box();
}

module tab(grip = tab_grip, stem_extra = tab_stem_extra) {
    pts = tab_outline(grip, stem_extra);
    translate([0, 0, tab_z0]) linear_extrude(tab_h) polygon(pts);
    // Fillet 02 also blends the tab stem into the wall
    stem_x0 = pts[0][0]; stem_x1 = pts[4][0];
    rotate([0, 0, -atan((stem_x0 + stem_x1) / 2 / duct_r_out)])
        wall_blend(duct_r_out, stem_x1 - stem_x0, tab_z0, tab_h, wall_blend_r, fillet_fn);
}

module shroud() {
    duct();
    deco_boxes();
    tab();
}

module strut() {
    difference() {
        union() {
            // plate, running to the bore wall
            intersection() {
                translate([0, 0, -strut_t / 2]) linear_extrude(strut_t) strut_2d();
                cylinder(r = duct_r_in, h = 10, center = true);
            }
            // hub core with six bites
            difference() {
                cylinder(r = hub_core_r, h = hub_core_t, center = true);
                for (k = [0 : hub_bite_n - 1])
                    rotate([0, 0, hub_bite_a0 + k * 360 / hub_bite_n])
                        translate([hub_core_r, 0, 0]) cylinder(r = hub_bite_r, h = hub_core_t + 2, center = true);
            }
            // outer ring
            difference() {
                cylinder(r = hub_ring_ro, h = hub_ring_t, center = true);
                cylinder(r = hub_ring_ri, h = hub_ring_t + 2, center = true);
            }
            // underside panels, three per side
            intersection() {
                for (s = [-1, 1], k = [0 : panel_n - 1])
                    mirror([s < 0 ? 1 : 0, 0, 0])
                        translate([0, 0, -strut_t / 2 + eps]) mirror([0, 0, 1])   // hang the pad off the underside, eps into the plate
                            rounded_pad(panel_t + eps, panel_fillet, fillet_fn)
                                panel_2d(panel_x0 + k * (panel_len + panel_gap));
                cylinder(r = duct_r_in, h = 10, center = true);
            }
            for (a = [0, 180]) rotate([0, 0, a]) ear();
        }
        cylinder(r = bore_r, h = 20, center = true);   // shaft bore
    }
}

// Ear at the +X end: the plate's end turned up along the bore wall
module ear() {
    translate([0, 0, -strut_t / 2]) linear_extrude(strut_t / 2 + ear_top) ear_2d();
}

// vane bar profile in the YZ plane: the sketch outline traced as one polygon.
// (A hull of corner circles was wrong here: the arcs are not tangent to the
// vertical ends, so a hull bulges past the top line.)
module vane_2d() {
    polygon(concat([vane_top_l, vane_end_l], arc_pts(vane_arc_l), arc_pts(vane_arc_r), [vane_end_r, vane_top_r]));
    for (p = [peg_a, peg_b]) translate([p[0][0], p[0][1] - tooth_extra]) square([p[1][0] - p[0][0], p[1][1] - p[0][1] + tooth_extra]);
}

// ---- hinge pieces (all built for the +X vane; the -X vane is a mirror) ----
// Each nub: root knuckle, plate knuckle, root knuckle, on a short pin.
function nub_y0(yc, i) = yc - hinge_len / 2 + i * (knuckle_l + knuckle_gap);

// round pin along +Y on the hinge axis
module pin_prism(d, y0, y1) {
    translate([hinge_x, y0, hinge_z]) rotate([-90, 0, 0]) cylinder(d = d, h = y1 - y0);
}
// teardrop hole along +Y: a circle with a 45 deg point on the print-up side,
// so the roof of the hole needs no bridging. The pin turns on the circular part.
// (A diamond pin in a diamond hole was the first attempt: it cannot rotate.)
module teardrop_prism(r, y0, y1) {
    translate([hinge_x, y0, hinge_z]) rotate([-90, 0, 0]) linear_extrude(y1 - y0) teardrop_2d(r, print_up);
}
module barrel(y0, y1) {
    translate([hinge_x, y0, hinge_z]) rotate([-90, 0, 0]) cylinder(d = barrel_d, h = y1 - y0);
}
module web(y0, y1, z0, z1) {   // 2 mm plate joining a knuckle to the bar
    translate([vane_x, y0, z0]) cube([vane_t, y1 - y0, z1 - z0]);
}
// root side of one nub: two outer knuckles webbed to the bar, and the pin
module hinge_root(yc) {
    for (i = [0, 2]) { y0 = nub_y0(yc, i); barrel(y0, y0 + knuckle_l); web(y0, y0 + knuckle_l, 29, hinge_z); }
    pin_prism(pin_d, yc - hinge_len / 2, yc + hinge_len / 2);
}
// plate side of one nub: the middle knuckle (solid; the hole is cut afterwards)
module hinge_fin_knuckle(yc) { y0 = nub_y0(yc, 1); barrel(y0, y0 + knuckle_l); }
// what to subtract from the plate around one nub: the pin hole, and notches so
// the plate clears the root knuckles
module hinge_fin_cut(yc, clr = hinge_clr) {
    y0 = nub_y0(yc, 1);
    teardrop_prism(pin_d / 2 + clr, y0 - 1, y0 + knuckle_l + 1);
    for (i = [0, 2])
        translate([min(hinge_x - barrel_d / 2, vane_x) - 1, nub_y0(yc, i) - knuckle_gap, fin_z_low - 1])
            cube([barrel_d + vane_t + 2, knuckle_l + 2 * knuckle_gap, hinge_z + barrel_d / 2 + knuckle_gap - fin_z_low + 1]);
}

// ---- cosmetic ribbed panels: grooves cut into a face, inside an outline ----
// children: the 2D panel outline in (y, z). Cuts print_up-facing? No: cuts the
// OUTER face (x = vane_x + vane_t) of the +X vane.
module face_cut(depth) {   // extrude a (y,z) 2D shape into the outer face
    translate([vane_x + vane_t - depth, 0, 0]) rotate([90, 0, 90]) linear_extrude(depth + 1) children();
}

// ---- the plate (fin): trapezoid in the YZ plane ----
function fin_depth(y) = fin_depth_top + (fin_depth_bot - fin_depth_top) * (y - hinge_y0) / (hinge_y1 - hinge_y0);
module fin_outline_2d() {   // (y, z)
    offset(r = fin_corner) offset(delta = -fin_corner)
        polygon([[hinge_y0, fin_z_low], [hinge_y1, fin_z_low],
                 [hinge_y1, hinge_z + fin_depth_bot], [hinge_y0, hinge_z + fin_depth_top]]);
}
module fin_panel_2d(f) {   // one ribbed panel outline, inset 3 mm, following the taper
    L = hinge_y1 - hinge_y0; y0 = hinge_y0 + f[0] * L; y1 = hinge_y0 + f[1] * L; m = 3;
    polygon([[y0, fin_z_low + m], [y1, fin_z_low + m], [y1, hinge_z + fin_depth(y1) - m], [y0, hinge_z + fin_depth(y0) - m]]);
}
module vane_fin() {
    difference() {
        union() {
            translate([vane_x, 0, 0]) rotate([90, 0, 90]) linear_extrude(vane_t) fin_outline_2d();
            for (yc = hinge_pts) hinge_fin_knuckle(yc);
            // linkage pin at the bottom trailing corner, pointing +Y (down): bullet root, pin, bulb.
            // Everything is clipped flat at the outer face so the vane still prints on it.
            intersection() {
                translate([pin_x, hinge_y1 - 1, hinge_z + fin_depth_bot - link_pin_inset]) rotate([-90, 0, 0]) {
                    cylinder(d = link_pin_d, h = link_pin_len + 1);
                    cylinder(d1 = bullet_d, d2 = link_pin_d, h = bullet_len + 1);
                    translate([0, 0, link_pin_len + 1 - (link_pin_d / 2 + tie_snap)]) sphere(d = link_pin_d + 2 * tie_snap);
                }
                translate([vane_x - 5, hinge_y0, 0]) cube([vane_t + 5, 200, 100]);
            }
        }
        for (yc = hinge_pts) hinge_fin_cut(yc);
        for (f = fin_panels) { L = hinge_y1 - hinge_y0;
            face_cut(panel_recess) grooves_2d(hinge_y0 + f[0] * L, hinge_y0 + f[1] * L, panel_pitch, panel_groove) fin_panel_2d(f); }
    }
}

// ---- the root bar: your bar and pegs, hinge nubs, slat axle holes, ribbed panels ----
function bar_bot(y) = 20.584 + (25.860 - 20.584) / (44.693 + 42.111) * (y + 42.111);   // sketch bottom line
function bar_top(y) = vane_top_l[1] + (vane_top_r[1] - vane_top_l[1]) * (y - vane_top_l[0]) / (vane_top_r[0] - vane_top_l[0]);
module bar_panel_2d(f) {
    L = vane_top_r[0] - vane_top_l[0]; y0 = vane_top_l[0] + f[0] * L; y1 = vane_top_l[0] + f[1] * L; m = 1.5;
    polygon([[y0, bar_bot(y0) + m], [y1, bar_bot(y1) + m], [y1, bar_top(y1) - m], [y0, bar_top(y0) - m]]);
}
module vane_root() {
    difference() {
        union() {
            translate([vane_x, 0, 0]) rotate([90, 0, 90]) linear_extrude(vane_t) vane_2d();
            for (yc = hinge_pts) hinge_root(yc);
            for (p = [peg_a, peg_b]) translate(tooth_nub_c(p)) sphere(d = tooth_nub_d, $fn = 32);   // click nubs
        }
        for (y = slat_y) translate([vane_x - 1, y, slat_z]) rotate([0, 90, 0]) cylinder(d = slat_rod_d + 2 * slat_clr, h = vane_t + 2);
        for (f = bar_panels) { L = vane_top_r[0] - vane_top_l[0];
            face_cut(panel_recess) grooves_2d(vane_top_l[0] + f[0] * L, vane_top_l[0] + f[1] * L, panel_pitch, panel_groove) bar_panel_2d(f); }
    }
}

// ---- tie bar: a hat-shaped link with eye ends that snap over the plates' pins ----
// Built as a 2D outline in (x, z), then extruded tie_t along +Y from tie_y0.
tie_y0 = hinge_y1 + tie_gap;           // its upper face, just below the plates' bottom edges
tie_z  = hinge_z + fin_depth_bot - link_pin_inset;   // pin height
function tie_path() = [        // centreline: eye, tab, 45 deg ramp, raised middle, ramp, tab, eye
    [-pin_x, tie_z], [-pin_x + tie_tab, tie_z], [-pin_x + tie_tab + tie_jog, tie_z + tie_jog],
    [ pin_x - tie_tab - tie_jog, tie_z + tie_jog], [pin_x - tie_tab, tie_z], [pin_x, tie_z]];
key_off = link_pin_d / 2 + tie_snap + tie_key_gap + link_pin_d / 2 + tie_eye_clr - 0.4;   // big hole centre, forward (-Z) of the working hole
module tie_outline_2d() {
    stroke_2d(tie_path(), tie_w);
    for (sx = [-1, 1]) translate([sx * pin_x, tie_z]) hull() { circle(d = tie_eye_d); translate([0, -key_off]) circle(d = tie_eye_d); }
}
// keyhole: bulb goes through the big hole, the bar shifts aft and the pin clicks
// through a slightly narrow throat into the working hole
module tie_keyhole_2d() {
    keyhole_2d(link_pin_d + 2 * tie_eye_clr, link_pin_d + 2 * tie_snap + 2 * tie_key_gap, key_off, link_pin_d - tie_detent);
}
module tie_sheet(y_from, depth) {   // map a (x, z) 2D child to a slab along +Y
    translate([0, y_from, 0]) rotate([-90, 0, 0]) linear_extrude(depth) mirror([0, 1, 0]) children();
}
module tie_bar() {
    difference() {
        tie_sheet(tie_y0, tie_t) difference() {
            tie_outline_2d();
            for (sx = [-1, 1]) translate([sx * pin_x, tie_z]) tie_keyhole_2d();
        }
        // knurl: two families of diagonal grooves on the outer (+Y) face, middle section only
        tie_sheet(tie_y0 + tie_t - tie_knurl[2], tie_knurl[2] + 1)
            intersection() {
                offset(delta = -0.5) stroke_2d([tie_path()[2], tie_path()[3]], tie_w);
                for (a = [45, -45]) rotate(a) for (i = [-80 : tie_knurl[0] : 80]) translate([i, -100]) square([tie_knurl[1], 200]);
            }
    }
}

// ---- slats: tapered plates on an axle between the bars ----
// Built with the rod along X through the origin and the plate trailing in +Z.
module slat() {
    rod_len = 2 * (vane_x + vane_t);
    rotate([0, 90, 0]) cylinder(d = slat_rod_d, h = rod_len, center = true);
    rotate([90, 0, 0]) linear_extrude(slat_t, center = true)
        polygon([[-slat_len_rod / 2, 0], [slat_len_rod / 2, 0], [slat_len_edge / 2, slat_depth], [-slat_len_edge / 2, slat_depth]]);
}
tilt_eff = animate ? 20 * sin($t * 720) : tilt;
module slats() { for (y = slat_y) translate([0, y, slat_z]) rotate([tilt_eff, 0, 0]) slat(); }

// lay a +X vane (or its mirror, side = -1) flat on the face opposite the barrel
module lay_flat(side = 1) {
    outer = print_face == "outer";
    a = (outer ? 90 : -90) * side;
    z = outer ? vane_x + vane_t : -vane_x;
    translate([0, 0, z]) rotate([0, a, 0]) children();
}

// ---- assembly ----
steer_eff = animate ? 30 * sin($t * 360) : steer;

// The linkage is a four-bar, not a true parallelogram: each pin sits
// pin_off outboard of its hinge axis and the left vane mirrors the right, so
// the cranks mirror too. steer drives the right plate; the left plate's angle
// is solved so the tie bar length stays constant (it ends up ~0.8 deg off at 30).
pin_x   = vane_x + vane_t - link_pin_d / 2;   // the pin's x on the +X vane: flush with the outer face, so it prints flat
pin_off = pin_x - hinge_x;
function pin_r(t) = [ hinge_x + pin_off * cos(t) + link_len * sin(t), hinge_z - pin_off * sin(t) + link_len * cos(t)];
function pin_l(t) = [-hinge_x - pin_off * cos(t) + link_len * sin(t), hinge_z + pin_off * sin(t) + link_len * cos(t)];
function bar_err(tr, tl) = norm(pin_r(tr) - pin_l(tl)) - 2 * pin_x;
function solve_left(tr, lo = -60, hi = 60, n = 40) =   // bisection on the left angle
    n == 0 ? (lo + hi) / 2 :
    let (m = (lo + hi) / 2) (bar_err(tr, lo) * bar_err(tr, m) <= 0) ? solve_left(tr, lo, m, n - 1) : solve_left(tr, m, hi, n - 1);
steer_left = solve_left(steer_eff);

module place_fin(side) {   // rotate a plate about its own hinge axis
    t = side > 0 ? steer_eff : steer_left;
    translate([side * hinge_x, 0, hinge_z]) rotate([0, t, 0]) translate([-side * hinge_x, 0, -hinge_z])
        mirror([side < 0 ? 1 : 0, 0, 0]) vane_fin();
}
module vane_roots() { vane_root(); mirror([1, 0, 0]) vane_root(); }
module vane_fins()  { place_fin(1); place_fin(-1); }
module tie_bar_placed() {
    pl = pin_l(steer_left); pr = pin_r(steer_eff);
    phi = -atan2(pr[1] - pl[1], pr[0] - pl[0]);
    translate([pl[0], 0, pl[1]]) rotate([0, phi, 0]) translate([pin_x, 0, -tie_z]) tie_bar();
}
module vanes() { vane_roots(); vane_fins(); tie_bar_placed(); slats(); }

// =====================================================================
//  assembly
// =====================================================================
if (show_ghost)  %import("Shroud.stl");
if (show_shroud) color("SteelBlue") shroud();
if (show_strut)  color("Goldenrod") strut();
if (show_vanes) {
    color("IndianRed")  vane_roots();
    color("Salmon")     vane_fins();
    color("LightCoral") tie_bar_placed();
    color("Peru")       slats();
}


