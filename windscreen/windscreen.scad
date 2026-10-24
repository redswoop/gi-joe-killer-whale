// =====================================================================
//  windscreen — WHALE cockpit windscreen: three flat clear panels, a base
//  and an optional top frame
//
//  Units mm. Frame: Z up, the base sits on z = 0. The FRONT panel (the 60 mm
//  one) stands near x = 0 and the C opens toward +X (the pilot); Y symmetric.
//  "bot" = the base end of the taper, "top" = the free upper edge.
//
//  Each panel is a flat sheet defined by its four 3D corners on the OUTER
//  face (P0 P1 = the bottom edge, P3 P2 = the top edge, counter-clockwise
//  seen from inside the C). From those we derive the panel frame (u along
//  the bottom edge, v up the sheet, n = inward normal) which places a flat
//  sheet into the assembly and, inverted, lays the finished panel flat on
//  the bed. One set of numbers, no rotation angles typed by hand.
//
//  Taper: the front widens 60 -> 65 so the sides lean outward (a V from the
//  front); the sides lengthen 40 -> 44 while their free (open) edge stays
//  square in the sheet, which means the front leans away from the opening
//  by exactly `rake` = 44 - 40 over the height (\____| from the side).
//
//  Edges: two square-cut sheets meeting at a skewed corner cannot be flush,
//  so each panel is a slab clipped by planes: the corner edges are mitred
//  on the bisector plane and the top edges are cut horizontal (a flat rim
//  for the top frame). Those bevels are a few layers on a 1 mm sheet; print
//  every sheet OUTER face down and they are slopes, not overhangs.
// =====================================================================

// ---------- switches ----------
show_all   = true;
show_top   = true;     // the optional top frame
base_lines = true;     // cosmetic vertical lines on the base rail's outer faces

// ---------- panels (OUTSIDE dimensions, clear PETG, 0.6 nozzle) ----------
front_bot = 60;    // front panel width along the base
front_top = 65;    // front panel width at the top edge (Armen 2026-09-13: a V from the front)
side_bot  = 40;    // side panel length along the base, from the front's outer face
side_top  = 44;    // side panel length at the top
height    = 10;    // vertical height of the screen above the panel seat (Armen 2026-09-13)
panel_t   = 1;     // one wall of the 0.6 nozzle
joint_clr = 0;     // gap at the mitred corners (0 = faces touch; glue)

// ---------- base (opaque PLA, 0.4 nozzle) ----------
base_floor = 1;     // material under the panel edge
groove_d   = 2;     // how deep the panels sit in the base
base_w     = 5;     // rail width, centred on the panel's outer face
groove_clr = 0.15;  // per side, PETG sheet in a PLA groove   (coupon)
tab        = 5;     // square tab, 5 x 5
tab_t      = 2;     // tab thickness (across the rail)
tab_inset  = 5;     // side tabs: gap between the side panel's free edge and the tab

// ---------- base cosmetics ----------
line_pitch = 4;     // vertical lines on the outer faces, this far apart
line_w     = 0.6;   // one 0.4-nozzle line wide
line_d     = 0.4;   // depth into the face

// ---------- top frame (optional, opaque PLA) ----------
top_skin     = 1.2;   // wall on each face of the glass (three 0.4 lines)
top_groove_d = 2;     // how far the skirt reaches down the glass
top_cap      = 1;     // material above the panel edge
top_r        = 0.8;   // rounding of the profile's edges (< half the profile width)

$fn = 48;
eps = 0.01;
BIG = 500;          // "infinite" half-space size

use <armenscad/shape.scad>
use <armenscad/fit.scad>

// ---------- derived ----------
rake   = side_top - side_bot;             // front leans away from the opening by this over `height`
seat_z = base_floor;                      // z of the panel bottom edges
top_z  = seat_z + height;                 // z of the panel top edges
base_h = base_floor + groove_d;
c_in   = [side_bot / 2, 0, top_z - height / 2];   // a point inside the C (sanity check for normals)
margin = 5;                               // how far the uncut slab overshoots before clipping

// =====================================================================
//  panel geometry (functions: pure math, no geometry yet)
// =====================================================================
function unit(v) = v / norm(v);

// Outer-face corners, bottom edge first, counter-clockwise seen from inside.
function front_corners() = [
    [0,     -front_bot / 2, seat_z],
    [0,      front_bot / 2, seat_z],
    [-rake,  front_top / 2, top_z],
    [-rake, -front_top / 2, top_z]];

// s = +1 for the +Y side, -1 for the -Y side. The -Y list runs the other way
// along the bottom edge so that both are counter-clockwise from inside.
function side_corners(s) = s > 0 ?
    [[0,        front_bot / 2, seat_z], [side_bot, front_bot / 2, seat_z],
     [side_bot, front_top / 2, top_z],  [-rake,    front_top / 2, top_z]] :
    [[side_bot, -front_bot / 2, seat_z], [0,     -front_bot / 2, seat_z],
     [-rake,    -front_top / 2, top_z],  [side_bot, -front_top / 2, top_z]];

function side_corner_pt(s) = [0,        s * front_bot / 2, seat_z];   // where the side meets the front
function side_free_pt(s)   = [side_bot, s * front_bot / 2, seat_z];   // its free end

// Panel frame from its corners.
function panel_u(P) = unit(P[1] - P[0]);                                       // along the bottom edge
function panel_v(P) = let(d = P[3] - P[0], u = panel_u(P)) unit(d - (d * u) * u); // up the sheet, in-plane
function panel_n(P) = let(n = cross(panel_u(P), panel_v(P)))                   // right-handed => inward
    assert(n * (c_in - P[0]) > 0, "panel corners must be counter-clockwise seen from inside") n;

// The flat outline: each corner expressed in (u, v) from P0.
function panel_2d(P) = [for (p = P) [(p - P[0]) * panel_u(P), (p - P[0]) * panel_v(P)]];

// A 4x4 whose columns say where the X, Y, Z axes and the origin go.
function frame(u, v, n, o) = [[u[0], v[0], n[0], o[0]],
                              [u[1], v[1], n[1], o[1]],
                              [u[2], v[2], n[2], o[2]],
                              [0,    0,    0,    1]];
// Its inverse (rotation transposed, origin pulled back through it).
function unframe(u, v, n, o) = [[u[0], u[1], u[2], -(u * o)],
                                [v[0], v[1], v[2], -(v * o)],
                                [n[0], n[1], n[2], -(n * o)],
                                [0,    0,    0,    1]];

// =====================================================================
//  panel modules
// =====================================================================
// Move children from the flat frame (bottom edge on +X, sheet growing +Z)
// into the panel's plane, and back again.
module panel_place(P)   { multmatrix(frame(panel_u(P), panel_v(P), panel_n(P), P[0]))   children(); }
module panel_unplace(P) { multmatrix(unframe(panel_u(P), panel_v(P), panel_n(P), P[0])) children(); }

// Everything on the side of the plane through `c` that `n` points to.
module halfspace(c, n) {
    e = abs(n[0]) < 0.9 ? [1, 0, 0] : [0, 1, 0];      // any vector not parallel to n
    a = unit(cross(n, e)); b = cross(unit(n), a);      // two in-plane axes
    multmatrix(frame(a, b, unit(n), c)) translate([-BIG, -BIG, 0]) cube(2 * BIG);
}

// The uncut sheet: outline grown by `edge`, thickness grown by `face` each way.
module panel_slab(P, edge = 0, face = 0) {
    panel_place(P) translate([0, 0, -face]) linear_extrude(panel_t + 2 * face)
        offset(delta = edge) polygon(panel_2d(P));
}

// Mitre plane between panel P and its neighbour Q through corner point c,
// keeping P's side; `push` moves it toward Q (for grown groove cutters).
module mitre(P, Q, c, push = 0) {
    m = panel_n(Q) - panel_n(P);
    halfspace(c - push * unit(m), m);
}

// `clr` > 0 gives the groove cutter: the same panel grown by clr everywhere.
module front_body(clr = 0) {
    F = front_corners();
    intersection() {
        panel_slab(F, margin, clr);
        halfspace(F[0] - clr * panel_v(F), panel_v(F));                 // bottom: square to the sheet
        halfspace([0, 0, top_z + clr], [0, 0, -1]);                     // top: horizontal
        // NOT a plain `for`: inside intersection() a for-loop's iterations are unioned
        // into one child. intersection_for() intersects them one by one.
        intersection_for (s = [-1, 1]) mitre(F, side_corners(s), side_corner_pt(s), clr + joint_clr / 2);
    }
}

module side_body(s, clr = 0) {
    S = side_corners(s);
    intersection() {
        panel_slab(S, margin, clr);
        halfspace(S[0] - clr * panel_v(S), panel_v(S));                 // bottom: square to the sheet
        halfspace(side_free_pt(s) + [clr, 0, 0], [-1, 0, 0]);           // free edge: square (x = side_bot)
        halfspace([0, 0, top_z + clr], [0, 0, -1]);                     // top: horizontal
        mitre(S, front_corners(), side_corner_pt(s), clr + joint_clr / 2);
    }
}

module front()  { front_body(); }
module side_l() { side_body(+1); }
module side_r() { side_body(-1); }

// Every panel, grown by the groove clearance: subtract from a rail.
module panel_cutters() {
    front_body(groove_clr);
    for (s = [-1, 1]) side_body(s, groove_clr);
}

// =====================================================================
//  rails: base and top frame
// =====================================================================
// A polyline stroked `w` wide with square ends (the lib's stroke_2d rounds them).
module rail_2d(pts, w) {
    for (i = [0 : len(pts) - 2]) hull() {
        translate(pts[i])     square(w, center = true);
        translate(pts[i + 1]) square(w, center = true);
    }
}

// The base rail follows the panels' bottom edges and ends flush with the sides' free edges.
function base_path() = let(x1 = side_bot - base_w / 2, y = front_bot / 2)
    [[x1, -y], [0, -y], [0, y], [x1, y]];

module base() {
    difference() {
        union() {
            linear_extrude(base_h) rail_2d(base_path(), base_w);
            tabs();
        }
        panel_cutters();
        if (base_lines) base_line_cuts();
    }
}

// Three 5 x 5 x 2 tabs hanging below the base (they plug into the deck):
// one dead centre under the front rail, one under each side rail `tab_inset`
// in from the panel's free edge. Long side along the rail, thickness across it.
module tabs() {
    translate([0, 0, -tab]) {
        translate([-tab_t / 2, -tab / 2, 0]) cube([tab_t, tab, tab + eps]);
        for (s = [-1, 1])
            translate([side_bot - tab_inset - tab, s * front_bot / 2 - tab_t / 2, 0]) cube([tab, tab_t, tab + eps]);
    }
}

// Vertical grooves on the three outer faces of the base rail.
module base_line_cuts() {
    h = base_h + 2 * eps;
    // front face at x = -base_w/2, lines along Y
    for (y = [-front_bot / 2 + line_pitch / 2 : line_pitch : front_bot / 2 - line_pitch / 4])
        translate([-base_w / 2 - eps, y - line_w / 2, -eps]) cube([line_d + eps, line_w, h]);
    // side faces at y = +-(front_bot/2 + base_w/2), lines along X
    for (s = [-1, 1], x = [line_pitch / 2 : line_pitch : side_bot - base_w / 2 - line_pitch / 4])
        translate([x - line_w / 2, s * (front_bot / 2 + base_w / 2) - (s > 0 ? line_d : eps), -eps])
            cube([line_w, line_d + eps, h]);
}

// Top frame: a channel over each panel's top edge whose walls lean with the
// glass. The profile is drawn in the panel's own frame, (a, b) = (v, n): sides
// parallel to the sheet, bottom square to it, top horizontal in the world so
// the three segments share one flat face (the print face). All four corners
// rounded, then extruded along u and mitred at the corners like the panels.
function panel_top_v(P) = (P[3] - P[0]) * panel_v(P);          // v of the top edge
function world_z(P, a, b) = P[0][2] + a * panel_v(P)[2] + b * panel_n(P)[2];
function top_a(P, b, z) = (z - P[0][2] - b * panel_n(P)[2]) / panel_v(P)[2];   // a where the profile column b hits height z

module top_profile_2d(P) {
    b0 = -groove_clr - top_skin; b1 = panel_t + groove_clr + top_skin;
    a0 = panel_top_v(P) - top_groove_d;
    z1 = top_z + top_cap;
    offset(r = top_r) offset(delta = -top_r)      // round every convex corner
        polygon([[a0, b0], [a0, b1], [top_a(P, b1, z1), b1], [top_a(P, b0, z1), b0]]);
}

// The profile swept along the whole top edge, overshooting both ends for the clips.
module top_seg(P) {
    ext = 2 * margin;
    panel_place(P) translate([-ext, 0, 0]) rotate([90, 0, 90])   // 2D (a, b) -> local (v, n), extrude along u
        linear_extrude(norm(P[1] - P[0]) + 2 * ext) top_profile_2d(P);
}

module top() {
    F = front_corners();
    difference() {
        union() {
            // segments overlap by eps at the mitre; exactly touching solids leave slivers in the union
            intersection() {
                top_seg(F);
                intersection_for (s = [-1, 1]) mitre(F, side_corners(s), side_corner_pt(s), eps);
            }
            for (s = [-1, 1]) intersection() {
                top_seg(side_corners(s));
                mitre(side_corners(s), F, side_corner_pt(s), eps);
                halfspace(side_free_pt(s), [-1, 0, 0]);               // free end square, x = side_bot
            }
        }
        panel_cutters();
    }
}

// =====================================================================
//  assembly
// =====================================================================
if (show_all) {
    color("LightSkyBlue", 0.5) { front(); side_l(); side_r(); }
    color("DimGray") base();
    if (show_top) color("DarkSlateGray") top();
}
