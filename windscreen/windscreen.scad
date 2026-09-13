// =====================================================================
//  windscreen — WHALE cockpit windscreen: three flat clear panels + a base
//
//  Units mm. Frame: Z up, the base sits on z = 0. The back panel (the 60 mm
//  one) stands near x = 0 and the C opens toward +X; Y is symmetric.
//  "bot" = the base end of the taper, "top" = the free upper edge.
//
//  Each panel is a flat quad defined by its four 3D corners (P0 P1 = the
//  bottom edge, P3 P2 = the top edge). From those corners we derive a panel
//  frame (u along the bottom edge, v up the panel, n = inward normal) which
//  gives both the flat 2D print outline and the matrix that places the
//  printed sheet back into the assembly. One set of numbers, no rotation
//  angles typed by hand.
//
//  Taper: the back widens 60 -> 65 so the sides lean outward (a V from the
//  front); the sides lengthen 40 -> 44 while their free (open) edge stays
//  square in the flat sheet, which means the back panel leans away from the
//  opening by exactly `rake` = 44 - 40 over the height (\____| from the
//  side). Both angles fall out of the corner points.
// =====================================================================

// ---------- switches ----------
show_all = true;

// ---------- panels (OUTSIDE dimensions, clear PETG, 0.6 nozzle) ----------
back_bot  = 60;    // back panel width along the base
back_top  = 65;    // back panel width at the free top edge (Armen 2026-09-13: a V from the front)
side_bot  = 40;    // side panel length along the base, from the back's outer face
side_top  = 44;    // side panel length at the top
height    = 10;    // vertical height of the screen above the panel seat (Armen 2026-09-13)
panel_t   = 1;     // one wall of the 0.6 nozzle

// ---------- base (opaque PLA, 0.4 nozzle) ----------
base_floor = 1;     // material under the panel edge
groove_d   = 2;     // how deep the panels sit in the base
base_w     = 5;     // rail width, centred on the panel
groove_clr = 0.15;  // per side, PETG sheet in a PLA groove   (coupon)
tab        = 5;     // square tab, 5 x 5
tab_t      = 2;     // tab thickness (across the rail)
tab_inset  = 5;     // side tabs: gap between the side panel's free edge and the tab

$fn = 48;
eps = 0.01;

use <../lib/shape.scad>   // stroke_2d
use <../lib/fit.scad>

// ---------- derived ----------
rake   = side_top - side_bot;             // back leans away from the opening by this over `height`
seat_z = base_floor;                      // z of the panel bottom edges
base_h = base_floor + groove_d;
c_in   = [side_bot / 2, 0, seat_z + height / 2];   // a point inside the C, used to orient normals

// =====================================================================
//  panel geometry (functions: pure math, no geometry yet)
// =====================================================================
function unit(v) = v / norm(v);

// Corners, bottom edge first, counter-clockwise seen from inside the C.
function back_corners() = [
    [0,     -back_bot / 2, seat_z],
    [0,      back_bot / 2, seat_z],
    [-rake,  back_top / 2, seat_z + height],
    [-rake, -back_top / 2, seat_z + height]];

// s = +1 for the +Y side, -1 for the -Y side. `trim` shortens the corner
// edge so the sheet butts against the back panel's INNER face instead of
// overlapping it: the back is the full 60 wide, the sides sit inside it.
function side_corners(s, trim = 0) = [
    [trim,        s * back_bot / 2, seat_z],
    [side_bot,    s * back_bot / 2, seat_z],
    [side_bot,    s * back_top / 2, seat_z + height],
    [-rake + trim, s * back_top / 2, seat_z + height]];

// Panel frame from its corners.
function panel_u(P) = unit(P[1] - P[0]);                                // along the bottom edge
function panel_n(P) = let(n = unit(cross(P[1] - P[0], P[3] - P[0])))    // plane normal ...
                      (n * (c_in - P[0]) < 0) ? -n : n;                 // ... pointed into the C
function panel_v(P) = cross(panel_n(P), panel_u(P));                    // "up" the panel, in-plane

// The flat outline: each corner expressed in (u, v) from P0.
function panel_2d(P) = [for (p = P) [(p - P[0]) * panel_u(P), (p - P[0]) * panel_v(P)]];

// How far along the side's bottom edge to start the sheet so it clears the
// back's inner face: panel_t (a hair more, the back is raked) plus the bit
// the side's own thickness leans toward the back (its inward normal is not
// quite parallel to the back plane).
function side_trim() = let(B = back_corners(), S = side_corners(1),
                           lean = max(0, -(panel_n(S) * panel_n(B))))
    panel_t * (1 + lean) / (panel_u(S) * panel_n(B));

// =====================================================================
//  panel modules
// =====================================================================
// Place children (modelled flat: bottom edge on +X from the origin, sheet
// growing in +Z) into the panel's plane. multmatrix takes a 4x4 whose
// columns say where the X, Y and Z axes go, plus the origin.
module panel_place(P) {
    u = panel_u(P); v = panel_v(P); n = panel_n(P);
    multmatrix([[u[0], v[0], n[0], P[0][0]],
                [u[1], v[1], n[1], P[0][1]],
                [u[2], v[2], n[2], P[0][2]],
                [0,    0,    0,    1]])
        children();
}

// The sheet as printed: flat on the bed, thickness in +Z. `grow` = extra
// on every edge and face (used for the groove cutter).
module panel_flat(P, grow = 0) {
    translate([0, 0, -grow]) linear_extrude(panel_t + 2 * grow)
        offset(delta = grow) polygon(panel_2d(P));
}

module panel_3d(P, grow = 0) { panel_place(P) panel_flat(P, grow); }

module back()   { panel_3d(back_corners()); }
module side(s)  { panel_3d(side_corners(s, side_trim())); }
module side_l() { side(+1); }
module side_r() { side(-1); }

// =====================================================================
//  base
// =====================================================================
// Footprint: the panel bottom edges as a polyline, stroked base_w wide.
function base_path() = [[side_bot, -back_bot / 2], [0, -back_bot / 2], [0, back_bot / 2], [side_bot, back_bot / 2]];

module base() {
    difference() {
        union() {
            linear_extrude(base_h) stroke_2d(base_path(), base_w);
            tabs();
        }
        // grooves: the three panels, enlarged by the clearance, cut out of the rail
        panel_3d(back_corners(), groove_clr);
        for (s = [-1, 1]) panel_3d(side_corners(s, side_trim()), groove_clr);
    }
}

// Three 5 x 5 x 2 tabs hanging below the base (they plug into the deck):
// one dead centre on the back rail, one on each side rail `tab_inset` in
// from the panel's free edge. Long side along the rail, thickness across it.
module tabs() {
    translate([0, 0, -tab]) {
        translate([-tab_t / 2, -tab / 2, 0]) cube([tab_t, tab, tab + eps]);
        for (s = [-1, 1])
            translate([side_bot - tab_inset - tab, s * back_bot / 2 - tab_t / 2, 0]) cube([tab, tab_t, tab + eps]);
    }
}

// =====================================================================
//  assembly
// =====================================================================
if (show_all) {
    color("LightSkyBlue", 0.5) { back(); side_l(); side_r(); }
    color("DimGray") base();
}
