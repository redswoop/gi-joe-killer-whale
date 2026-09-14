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
//    mount  x2, a C-clip with the pin hole that snaps over the middle layer's front edge
//           in the gap between the front's side edge and the bay wall (2026-09-13
//           teardown). Captured, no glue. The pins do not touch the hull directly.
//
//  The real part (eBay photos, 2026-09-11) is a shallow tray: a 1.5 plate with a
//  ~3 mm rim on the inside along both sides and the cabin end, a round hinge bar
//  across the hinge edge on the inside with lobed ears and short outward pins,
//  four latch hooks on the side edges, vents + ribbed panels on the outer face.
//  In plan it is six-sided: two angled corner cuts at the cabin end, and the plate is thinner
//  along those angled edges (from the inside) where it rests on tabs in the hull.
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
open_deg   = 0;        // animate: 0 = closed, the cabin end swings UP and over the nose; ~180 = the band
                       // hangs down the nose's front, which is what stops it (fixed 2026-09-13: the sign was
                       // reversed and the checks had been sweeping the ramp down through the bay)
show_rim   = true;     // the tray rim on the inside face
show_detail = true;    // vent grilles, ribbed panels and recessed bars on the outer face

// ---------- plate ----------
hatch_w    = 93.3;     // measured, WHALE/measurements.md "width of ramp"
hatch_len  = 90;       // traced 2026-09-11: y-extent of the fender edge, front lip to where the corner cuts begin
hatch_rise = 18;       // traced: the hinge end sits 18 below the flat end (drops 0 / 4 / 18 at x = 0 / 50 / 90)
hatch_sag  = 5.9;      // circle through the three traced points: R 180.7, chord 91.8, sagitta 5.93
hatch_t    = 1.5;      // Armen 2026-09-11: same as the rest of the shell (the hatch itself is missing)
plate_extra = 0;       // extra full-width plate past the traced hatch_len, in plan. Tune on the print.
                       // The angled corner cuts are IN ADDITION to that: they start at hatch_len + plate_extra
                       // and run top_cut_y further (Armen 2026-09-13, corner coupon: the first cut ended
                       // where it should have started).
top_bevel  = 0;        // angle of the cabin end face from the radial (square) cut; + makes the OUTER
                       // surface the long one. 0 after the eBay photo of the real part (square edge).
top_edge_w = 68.85;    // width of the cabin end after the corner cuts = the wide end of the
                       // top-hatch opening (WHALE/measurements.md "wider opening"). Photo of the real
                       // part scales to ~69 too.
top_cut_deg = 30;      // angle of each angled edge from the cabin end edge, in plan (Armen 2026-09-13:
                       // "like a 30 deg cut"; corner coupon round 1: "perfect"). 0 would be a square end,
                       // 90 no cut at all.
top_cut_x  = (hatch_w - top_edge_w) / 2;          // 12.2: how far each cut comes in from the side
top_cut_y  = top_cut_x * tan(top_cut_deg);        // 7.1: how far it runs along the side

// ---------- cabin-end lip: a ledge that tucks under the top hatch ----------
top_hatch_t = 2.5;     // Armen's top hatch (WHALE/Whale Hatch.3mf) is a 2.5 plate at that edge
lip_clr    = 0.2;      // gap between the top hatch's underside and the ledge
lip_drop   = top_hatch_t + lip_clr;          // ledge's top surface below the outer surface
lip_t      = 1.5;      // ledge thickness
lip_len    = 5;        // ledge reach past the plate's end, under the top hatch (eBay photo ~5-6)

// ---------- tray rim (inside face; PHOTO ESTIMATES) ----------
rim_h      = 3;        // rim height above the plate's inner face (photo: shallow tray)
rim_t      = 1.5;      // rim wall thickness

// ---------- outer face details (eBay outer-face photo, 2026-09-13; scaled at 9.4 px/mm off the 93.3 width) ----------
// Plan coordinates: x across (0 = centre), y along the plate from the front face, as plan_2d. Depths are
// what a 0.4 nozzle prints cleanly with the hatch on its side (the outer face is a vertical wall then;
// features along y are layer-aligned, features along x are traced in each perimeter).
det_d      = 0.3;      // recess depth of a grille field / panel field
vent_w     = 30;       // vent grille, outer size (x by y) and centre position, one each side
vent_h     = 12.5;
vent_x     = 21;
vent_y     = 78.9;
vent_frame = 1.2;      // raised border left around the recessed field
vent_hole  = 1.0;      // through holes in the field, staggered grid
vent_pitch = 2.5;
vent_rows  = 5;
panel_n    = 7;        // ribbed panels in a row across the plate
panel_span = 70.5;     // outer width of the row, centred
panel_h    = 21;       // panel height along y
panel_y    = 30.6;     // row centre along y
panel_gap  = 1.0;      // flat strip between neighbouring panels
rib_pitch  = 1.2;      // grooves along y inside each panel (real ones are finer than a nozzle)
rib_w      = 0.4;
rib_d      = 0.3;      // groove depth below the panel field
bar_y      = [8.1, 13.6];              // two recessed bars under the panels ("PANEL REMOVAL" strip)
bar_x      = [[-36, 9.1], [18.1, 34.5]];
bar_d      = 0.4;

// ---------- angled cabin-end edges: rabbeted underneath, they rest on hull tabs (Armen 2026-09-13) ----------
// The plan outline is six-sided: square hinge edge, two long sides, and two angled edges (top_cut_deg)
// bringing the cabin end down to top_edge_w. Along those angled edges the plate is thinner than hatch_t, from the
// INSIDE (the outer surface stays flush), so it can sit on tabs in the hull's corners that stop the
// hatch falling into the bay. Rim and cabin-end rim end where the rabbet begins.
tab_w      = 4;        // how far the hull tab reaches under the plate, square to the angled edge (corner coupon 1)
tab_edge_t = 1.0;      // plate thickness left over the tab ("a bit thinner than the rest").  ESTIMATE, not yet judged

// ---------- front face + dovetail socket (Armen 2026-09-13) ----------
front_h    = 10;       // vertical front face: outer surface down to the hull's lip level. Tracing: the curve
                       // is 10 above the paper edge at the 90 mark and the paper edge rested on the lip.
front_t    = 4.0;      // the front plate's thickness. Thick enough for the rail and the 2.6 pins; only
                       // its edges show, inside the fenders. 3.5 with the small rail (coupon round 1).
sock_h     = 5.5;      // socket block: outer surface down to the seam with the front plate. Was skin + rim
                       // (4.5); the bigger rail needs the extra 1, so the block hangs 1 below the rim.
sock_back  = 1.5;      // wall behind the groove
// Dovetail, round 2. Round 1 (rail 1.2 tall, 1.2 neck, 1.0 taper, clearances 0.1 / 0.15 / 0.25 per face)
// was "far too loose" at every clearance: features that small come out undersized on the H2C. Rail
// doubled, flank kept steep enough to lock, clearance now tested around zero (coupon.scad).
rail_h     = 2.5;      // dovetail rail up from the front plate's top edge into the groove (1.5 roof left)
rail_neck  = 1.8;      // rail thickness where it leaves the plate (measured back from the inner face)
rail_taper = 1.2;      // extra thickness at the rail's top, toward the OUTER face. One-sided dovetail:
                       // the inner face is flat so the front prints on that face with no overhang.
                       // Leaves a 1.0 hook between the groove's top and the front face.
slide_clr  = 0;        // rail-to-groove clearance per face. ROUND 2 PENDING (coupon: -0.1 / 0 / 0.1)
sock_d     = front_t + slide_clr + sock_back;   // socket block depth aft of the front face

// ---------- hinge pins, out of the front plate's side edges ----------
hinge_pin_d = 2.6;     // pin diameter (photo ~2.6; Cryoguns' replacement bracket bores 3.10)
pin_len     = 3.5;     // how far each pin sticks out past the side edge (photo ~3.5-4.5)
// The real front (web photos 2026-09-13, ref/web_front_*; Armen): two 10 mm bands. The upper one is
// flush with the fenders' front faces (front_h, shared by the socket block and the top of this plate);
// then a 1 mm step OUT; then a lower band, a thin flange about 1.5-2 thick, with the hinge at its
// bottom edge in black bosses on the skirt's top corners (broken off on Armen's hull). The front
// plate replicates that: the upper band 4 thick because the rail needs it, the lower band a thin
// flange 1 proud of it with the pins centred in it, so the flange's bottom sweeps only ~2 mm past
// the axis when the ramp opens (a thick flange with the axis at its back swept 3.7 into the skirt).
// The inner face steps too (Armen: "step the back face as well"), so the part no longer prints
// flat: it stands on the flange's flat bottom edge (print_layout).
front_step  = 1;       // the lower band's face stands this far PROUD of the upper band's (Armen 2026-09-13,
                       // "it steps out")
front_band  = 10;      // lower band height, lip level to its bottom edge (Armen: "another 10 mm drop")
flange_t    = 3;       // lower band thickness: the 2.6 pin plus 0.2 a side. Real part ~1.5-2
flange_ch   = 0.5;     // chamfer on the flange's bottom corners (sweep radius, and a cleaner first layer)
front_in_step = front_t - (flange_t - front_step);   // 2: how far the inner face steps back above the
                                                     // lip; a 45 deg chamfer, since it faces down in print
pin_fwd     = 0.75;    // axis forward of the flange's centre: the pin hole in the C-clip needs a wall between it
                       // and the middle layer's face (2 - 1.45 = 0.55 without this; 1.3 with it). Teardown 2026-09-13
pin_y       = -front_step + flange_t / 2 - pin_fwd;   // -0.25: axis aft of the UPPER band's face
pin_below_lip = front_band - hinge_pin_d / 2;   // 8.7: the pin is tangent to the flange's bottom edge, so
                                                // it lies on the bed when the front prints standing

// ---------- middle layer (the black skirt's upper half) at the bow: teardown 2026-09-13, ref/hull_apart_* ----------
// Armen took the hull apart. The ramp's front band hangs in front of the middle layer's front face,
// which sits ml_inset behind the fenders' front faces ("about 2 mm inset"). The hull-side hinge was two
// very thin plastic panels on the UNDERSIDE of that layer, projecting forward past its leading edge
// with the pin holes in them; both snapped off (symmetric stress lines on the underside: an earlier
// repair). Nothing projects, no drilling, no glue: the bracket has to be CAPTURED by what is there.
// So the bracket is a C-clip over the layer's front edge at each corner, in the gap between the
// front plate's side edge and the bay wall: a lip on the layer's top face, the bridge in the 2 mm
// recess, a leg underneath with a slot that clears the broken panel stub, and the pin boss hanging
// off the bridge's bottom where the original panel was. Once both pins are in, the ramp ties the
// two clips together, and a forward pull on the open ramp wedges them tighter (the axis is in front
// of and below the edge). Every number here is a photo guess until the layer is measured.
ml_inset   = 2;        // the layer's front face behind the fenders' front faces (Armen: "about 2 mm")
ml_face_h  = 10;       // that face's height, lip level to the layer's bottom leading edge (= front_band: the
                       // band covers it; the pin ends up 1.3 above the bottom). UNMEASURED
ml_wall_t  = 2;        // thickness of the front wall behind the face (mock, for the opening sweep). UNMEASURED
ml_edge_r  = 1;        // round on that wall's top edges (mock). UNMEASURED
stub_t     = 1.5;      // the broken panel stubs under the layer: thickness ("very thin"). UNMEASURED
stub_len   = 6;        // how far aft of the leading edge they run. UNMEASURED. Anything forward of the
                       // face gets trimmed flush, the boss sits there
stub_x     = 1.5;      // stub centre in the clip's frame (0 = the clip's inner face): assumed under the pin
stub_clr   = 0.4;      // slot clearance around the stub, total
clip_clr   = 0;        // C opening = ml_face_h + clip_clr; negative = interference. export.sh: -0.2 / 0 / 0.2
clip_lip_t = 1.0;      // top lip on the layer's top face (in the fender gap, nothing above it): thickness
clip_lip_len = 6;      //   and reach aft of the front face
clip_leg_t = 1.2;      // bottom leg under the layer: thickness
clip_leg_len = 10;     //   reach aft
clip_leg_in = 6;       //   extension inboard past the clip's inner face (the slot leaves only a sliver outboard)
clip_boss_d = 6.5;     // boss around the pin hole, hanging off the bridge's bottom in front of the layer

// ---------- mounts: one C-clip per side (section above), pin hole on the axis ----------
pin_clr     = fit_pin_clr();   // 0.3: pin-to-hole clearance, settled by the coupon 2026-09-13 ("perfect
                               // fit"); lives in lib/fit.scad as the known H2C number
mount_t     = 3.0;     // clip thickness across the gap = the gap between the hatch and the fender minus a hair
                       // ((bay_w - hatch_w) / 2 = 3.6 measured, pin_len 3.5 passes through)
mount_clr   = 0.2;     // gap between the front plate's side edge and the clip

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
end_y    = hatch_len + plate_extra + top_cut_y;       // plan y of the cabin end (outer corner)
a_end    = acos((end_y - arc_cen[0]) / arc_R);        // the arc angle there (all arc angles are in 0..180)
a_lip    = a_end + a_dir * lip_len / arc_R * 180 / PI;    // where the ledge ends
end_pt   = arc_cen + arc_R * [cos(a_end), sin(a_end)];   // outer corner at the cabin end

// Hinge end, in the plate frame's YZ (y aft, z up; the outer surface's front corner at 0,0).
// The socket block spans z = 0 .. -sock_h; the front plate hangs below the seam and carries
// the pins on the world X axis once hatch_shift is applied.
seam_z     = -sock_h;                                // socket / front plate seam
front_bot  = -front_h - front_band;                  // front plate's bottom edge (flat: the print's first layer)
pin_axis   = [pin_y, -front_h - pin_below_lip];      // (y, z) of the hinge axis in the plate frame
hatch_shift = [0, -pin_axis[0], -pin_axis[1]];       // plate frame -> world (axis on X)
// The middle layer in the world frame (see its parameter section)
fender_y   = -pin_y;                    // y of the fenders' front faces (plate frame y = 0)
ml_face_y  = fender_y + ml_inset;       // y of the layer's front face
ml_top     = pin_below_lip;             // z of its top face = the lip level
ml_bot     = ml_top - ml_face_h;        // z of its bottom leading edge
echo(str("hinge axis ", pin_axis[0], " aft of the front face, ", pin_below_lip, " below the lip; front plate ",
         seam_z - front_bot, " tall + ", rail_h, " rail"));

// Dovetail rail profile (y, z), grown by g on the fitting faces for the groove (g may be negative
// for an interference fit); ext extends the mouth below the seam so a groove cuts clean through.
// Flat on the inner face (y = front_t), the taper toward the outer face is what holds the front on.
function rail_2d(g = 0, ext = 0) = [[front_t - rail_neck - g, seam_z - ext],
                                    [front_t + g,             seam_z - ext],
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
    cx = top_cut_x; cy = top_cut_y; w = hatch_w / 2; L = end_pt[0];
    offset(delta = -inset) polygon([[-w, -50], [w, -50], [w, L - cy], [w - cx, L], [w - cx, L + 50],
                                    [-w + cx, L + 50], [-w + cx, L], [-w, L - cy]]);
}
module plan_clip(inset = 0) { translate([0, 0, -100]) linear_extrude(300) plan_2d(inset); }

// =====================================================================
//  parts
// =====================================================================
module hatch_plate() {                              // the 1.5 skin alone
    difference() {
        intersection() { across(hatch_w) band_2d(arc_R, arc_R - hatch_t); plan_clip(); }
        if (show_detail) surface_details();
    }
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
        across(hatch_w + 2) polygon(rail_2d(slide_clr, 1));   // the groove, open at both ends
        tab_rabbet();
        if (show_detail) surface_details();
    }
}

// Plan view: a strip tab_w wide inside each angled edge (and everything outside it, which is air).
// The edge runs from (w, L - cy) up-and-in at 180 - top_cut_deg; the strip's local +y points into
// the plate. The strip stops at |x| = top_edge_w / 2, the top-hatch opening: the hull tab cannot
// continue into the opening, and the cabin ledge (cabin_lip) lives there.
module tab_strip_2d() {
    w = hatch_w / 2; L = end_pt[0];
    for (sx = [-1, 1]) mirror([sx < 0 ? 1 : 0, 0]) intersection() {
        translate([w, L - top_cut_y]) rotate(180 - top_cut_deg) translate([-100, -100]) square([200, 100 + tab_w]);
        translate([w - top_cut_x - eps, -100]) square([100, 300]);   // eps: the lip's side face and
    }                                                                // this end face must not coincide
}
// The rabbet: everything under the angled edges from the inner face up to tab_edge_t below the
// outer surface. Cut from the tray only; cabin_lip() is unioned afterwards so it keeps its corners.
// The band runs 10 deg past the cabin end unclipped (not band_2d): a cutter whose end face
// coincides with the tray's end face leaves doubled faces in the export.
module tab_rabbet() {
    a0 = a_hinge - 5 * a_dir; a1 = a_end + 10 * a_dir;
    intersection() {
        across(hatch_w + 2) polygon(concat(arc_seg(arc_R - tab_edge_t, a0, a1),
                                           arc_seg(arc_R - hatch_t - rim_h - 1, a1, a0)));
        translate([0, 0, -100]) linear_extrude(300) tab_strip_2d();
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
    across(hatch_w) front_body_2d();
    across(hatch_w) polygon(rail_2d());
    for (sx = [-1, 1]) translate([sx * hatch_w / 2, pin_axis[0], pin_axis[1]]) rotate([0, sx * 90, 0]) {
        cylinder(d = hinge_pin_d, h = pin_len - hinge_pin_d / 2);
        translate([0, 0, pin_len - hinge_pin_d / 2]) sphere(d = hinge_pin_d);   // rounded tip
    }
}
module front() { translate(hatch_shift) front_local(); }          // world frame, closed pose

// The front plate's profile (y, z), plate frame, counter-clockwise from the bottom. Lower band: a
// flange flange_t thick with its face at y = -front_step, flat bottom with chamfered corners, from
// front_bot up to the lip level. Upper band: y = 0 .. front_t from the lip level to the seam; its
// inner face steps back front_in_step from the flange's inner face through a 45 deg chamfer.
module front_body_2d() {
    y0 = -front_step; y1 = -front_step + flange_t;    // the flange's faces
    polygon([[y0 + flange_ch, front_bot], [y1 - flange_ch, front_bot], [y1, front_bot + flange_ch],
             [y1, -front_h], [front_t, -front_h + front_in_step], [front_t, seam_z], [0, seam_z],
             [0, -front_h], [y0, -front_h], [y0, front_bot + flange_ch]]);
}

// ---- outer face details ----
function a_of_y(y) = acos((y - arc_cen[0]) / arc_R);   // arc angle of the outer surface at plan y

// A recess d deep into the outer surface over x in [x0, x1], plan y in [y0, y1]. Plate frame.
module surf_cut(x0, x1, y0, y1, d) {
    a0 = a_of_y(y0); a1 = a_of_y(y1);
    translate([(x0 + x1) / 2, 0, 0]) across(x1 - x0)
        polygon(concat(arc_seg(arc_R + 1, a0, a1, 6), arc_seg(arc_R - d, a1, a0, 6)));
}
// A round hole through the skin at plan (x, y), bored along the local normal.
module surf_hole(x, y, d) {
    a = a_of_y(y);
    translate([x, arc_cen[0], arc_cen[1]]) rotate([a - 90, 0, 0])
        translate([0, 0, arc_R - hatch_t - 1]) cylinder(d = d, h = hatch_t + 2, $fn = 16);
}
module surface_details() {
    // vent grilles: recessed field inside a raised frame, staggered through holes
    for (sx = [-1, 1]) {
        fx0 = sx * vent_x - vent_w / 2 + vent_frame; fx1 = sx * vent_x + vent_w / 2 - vent_frame;
        fy0 = vent_y - vent_h / 2 + vent_frame;      fy1 = vent_y + vent_h / 2 - vent_frame;
        surf_cut(fx0, fx1, fy0, fy1, det_d);
        rp = (fy1 - fy0 - 1) / (vent_rows - 1);
        for (r = [0 : vent_rows - 1]) let (y = fy0 + 0.5 + r * rp, off = (r % 2) * vent_pitch / 2)
            for (x = [fx0 + 1 + off : vent_pitch : fx1 - 1]) surf_hole(x, y, vent_hole);
    }
    // ribbed panels: each a recessed field with grooves along y
    pw = (panel_span - (panel_n - 1) * panel_gap) / panel_n;
    for (i = [0 : panel_n - 1]) let (x0 = -panel_span / 2 + i * (pw + panel_gap), x1 = x0 + pw) {
        surf_cut(x0, x1, panel_y - panel_h / 2, panel_y + panel_h / 2, det_d);
        for (x = [x0 + rib_pitch : rib_pitch : x1 - rib_pitch / 2])
            surf_cut(x - rib_w / 2, x + rib_w / 2, panel_y - panel_h / 2 + 0.6, panel_y + panel_h / 2 - 0.6, det_d + rib_d);
    }
    // the two bars under the panels
    for (b = bar_x) surf_cut(b[0], b[1], bar_y[0], bar_y[1], bar_d);
}

// One C-clip in its own frame: world y and z (the axis at the origin), x = 0 is the clip's inner
// face toward the front plate, mount_t thick outboard; the bottom leg also runs clip_leg_in inboard.
// clip_2d is the YZ profile: lip on top of the layer, bridge in the recess, leg underneath, the boss
// around the hole clipped to the layer's outline, minus the pin hole.
module clip_2d() {
    lip_z = ml_top + clip_clr / 2;  leg_z = ml_bot - clip_clr / 2;
    difference() {
        union() {
            translate([ml_face_y - eps, lip_z]) square([clip_lip_len + eps, clip_lip_t]);
            translate([fender_y, leg_z - clip_leg_t]) square([ml_inset, lip_z + clip_lip_t - leg_z + clip_leg_t]);
            translate([ml_face_y - eps, leg_z - clip_leg_t]) square([clip_leg_len + eps, clip_leg_t]);
            difference() { circle(d = clip_boss_d); translate([ml_face_y, leg_z]) square(50); }
        }
        circle(d = hinge_pin_d + pin_clr);
    }
}
module mount_local() {
    leg_z = ml_bot - clip_clr / 2 - clip_leg_t;
    difference() {
        union() {
            rotate([90, 0, 90]) linear_extrude(mount_t) clip_2d();
            translate([-clip_leg_in, ml_face_y, leg_z]) cube([clip_leg_in + eps, clip_leg_len, clip_leg_t]);
        }
        // slot for the broken panel stub, under the layer only (aft of its face), open at the front
        // and downward, so it also notches the boss's lower-aft quarter
        translate([stub_x - (stub_t + stub_clr) / 2, ml_face_y - eps, -clip_boss_d])
            cube([stub_t + stub_clr, stub_len + 2 * eps, clip_boss_d + leg_z + clip_leg_t + eps]);
    }
}
// Both clips in the world frame: hole on the hinge axis, inner face mount_clr off the front plate.
module mounts() {
    for (sx = [-1, 1]) mirror([sx < 0 ? 1 : 0, 0, 0]) translate([hatch_w / 2 + mount_clr, 0, 0]) mount_local();
}

// The middle layer's front wall and the broken panel stubs, world frame: the hull side of the
// hinge, for the collision checks and the viewer. A guess (see the parameter section).
module nose_mock() {
    translate([-bay_w / 2, 0, 0]) rotate([90, 0, 90]) linear_extrude(bay_w) hull() {
        translate([ml_face_y, ml_bot]) square([ml_wall_t, eps]);
        for (y = [ml_face_y + ml_edge_r, ml_face_y + ml_wall_t - ml_edge_r])
            translate([y, ml_top - ml_edge_r]) circle(r = ml_edge_r);
    }
    for (sx = [-1, 1]) mirror([sx < 0 ? 1 : 0, 0, 0])
        translate([hatch_w / 2 + mount_clr + stub_x - stub_t / 2, ml_face_y, ml_bot - 3]) cube([stub_t, stub_len, 3]);
}

module hatch() {              // the printed hatch, closed pose, world frame
    translate(hatch_shift) {
        if (show_rim) { hatch_tray(); cabin_lip(); } else { hatch_plate(); socket_block(); }
    }
}

module bay_mock() {           // hull stand-in for the viewer, not printed
    color("DimGray", 0.6) nose_mock();
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
    rotate([open_deg, 0, 0]) { color("OliveDrab") hatch(); color("DarkOliveGreen") front(); }
    color("SlateGray") mounts();
}
