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
vane_edge_r = 0.5;      // fillet on every edge of the bar and plate outlines, both faces (Armen 2026-09-11: 'they look too blocky').
                        // 0.7 at first; the taper's thin edge (vane_t_tip) must stay >= 2 * r
vane_t_tip  = 1.2;      // TAPER (Armen 2026-09-11: 'the slightest taper, widest at the root where they attach to the duct, down to a thin
                        // edge at the outside'): thickness vane_t at the bar's lowest edge (vane_z_root) thinning linearly with z to
                        // vane_t_tip at the plate's farthest edge (hinge_z + fin_depth_bot, z 59), symmetric about the mid-plane.
                        // Both bodies follow the same law, so the bar is 2.0 -> 1.8 and the plate 1.7 -> 1.2. Each face slopes 0.6 deg.
// profile in the YZ plane (y, z), points straight from Sketch 06
vane_top_l = [-45.72, 30.201];  vane_top_r = [47, 31];
vane_end_l = [-45.72, 24.121];  vane_end_r = [47, 28];         // where the vertical ends meet the arcs
vane_arc_l = [[-45.72, 24.121], [-42.111, 20.584], [-41.359, 24.961]];   // start, end, centre
vane_arc_r = [[43.931, 25.813], [47, 28], [44.133, 28.777]];
// Sketch 06 also had two 2 mm pegs under the bar. The +Y one is kept exactly (peg_y / peg_z below:
// it drops into a slot in the Whale's base); the -Y one became the fork dart.

// ---------- vane mechanism (new design, from photos of the real MET-b52 vanes) ----------
// Each vane = fixed root bar (your Sketch 06 body) + a trapezoidal plate hinged
// along the bar's top edge, printed in place (the original used a living
// hinge). A tie bar with eye ends snaps over pins at the plates' bottom corners
// so they steer together. Two tapered slats pivot on axles between the bars.
// Hinge axis is Y (the toy's vertical); +Y is the toy's bottom.
steer        = 0;      // deg, +/-30: pose of the plates and tie bar in the assembly
tilt         = 0;      // deg: pose of the slats
animate      = false;  // true: steer and tilt sweep with $t (View > Animate in the GUI)

// hinge pin (2026-09-11): "printed" = print-in-place pin (current); "filament" = the knuckles get a plain round
//   hole and a length of 1.75 mm filament is pushed through after printing, ends trimmed 1 mm proud and mushroomed
//   with a lighter or iron. Standing, the printed pin is a stack of 1.4 mm discs held by layer adhesion only and
//   snapped as soon as the plate was freed; a filament pin is a continuous strand, and the vertical holes come
//   out round without a teardrop. Root and plate still print together, in place, knuckles aligned.
hinge_pin    = "printed";   // "printed" | "filament". Flip in the viewer's panel or with -D 'hinge_pin="filament"'
fil_d        = 1.75;   // filament pin diameter
fil_clr      = 0.15;   // hole clearance on the filament, per side. Coupon (2026-09-12): 0.10 / 0.15 / 0.20 printed, 0.15 the best fit
fil_proud    = 1;      // pin length = hinge_len + 2 * fil_proud, for the mushroomed ends
barrel_print_d = 4.2;  // hinge knuckle OD with the printed pin (pin + 2 clearances + 2 walls; about the floor)
barrel_fil_d = 4.6;    // ... and with the filament pin: 2.05 hole + 1.28 walls (4.2 would leave 1.08)
barrel_d     = hinge_pin == "filament" ? barrel_fil_d : barrel_print_d;
pin_d        = 1.4;    // printed hinge pin, round; the plate's hole is a teardrop so it prints flat
hinge_clr    = 0.15;   // pin-to-hole clearance, per side. Coupon round 1: 0.35 and 0.45 good, 0.25 not;
                       // printed vanes at 0.4 (2026-09-10): range good but too loose -> 0.3;
                       // 2026-09-11: Armen's tolerance tests say 0.15 -> 0.15 (coupon round 3 ladders 0.15 / 0.20 / 0.25)
knuckle_gap  = 0.4;    // axial gap between neighbouring knuckles
knuckle_l    = 4;      // length of one knuckle
hinge_pts    = [-34, 36];     // Y centres of the two hinge nubs: 10 mm in from each plate end, over the teeth
hinge_len    = 3 * knuckle_l + 2 * knuckle_gap;   // root-plate-root, 12.8 mm
hinge_lift   = 0.6;    // barrel bottom above the bar's top edge; a printed barrel has a flat where it met the bed
hinge_z      = 31 + hinge_lift + barrel_d / 2;
hinge_y0     = vane_top_l[0];  hinge_y1 = 46;   // plate span along the bar. The -Y end is flush with the bar's end (was -44,
                                                // a photo estimate) so both bodies stand on the bed when the vane prints vertically
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
link_pin_inset = 5.8;  // from the trailing edge to the pin axis. 2.8 put the mount at the plate's edge; Armen 2026-09-11: 'move
                       // them downward about 3 mm', and the tie bar's raised middle is flush with the plate's edge (tie_jog)
mount_d       = 4.5;   // the pin's root: a CANOE on the plate's mid-plane about the pin's axis ('these should also canoe up the
mount_cyl     = 2;     // vane'): from the plate's end, a cylinder mount_cyl long, then a cone tail mount_tail long fading up
mount_tail    = 6;     // the plate (-Y); outboard, a nose cone down to the pin diameter, ending mount_nose past the plate's end
                       // (0.3 short of the tie bar, so the eye seats on the pin). Round, so it wraps the tapered corner on both faces.
tie_snap      = 0.15;  // bulb on the pin end, oversize per side
tie_eye_clr   = 0.2;   // working hole clearance per side on the pin
tie_key_gap   = 0.1;   // keyhole: the bulb passes through the big hole freely by this much per side
tie_detent    = 0.1;   // the throat between big hole and working hole is this much narrower than the pin, total
tie_t         = 2;   tie_eye_d = 5.5;  tie_gap = 2.2;   // tie bar: thickness, eye OD, gap below the plates (the mount nose ends 0.3 before it)
tie_w         = 3;   tie_tab = 6;                       // hat-shaped link  _/----\_ : bar width, straight tab at each eye
tie_jog       = link_pin_inset - tie_w / 2;           // raise of the middle: its outer edge lands flush with the plate's outer edge (4.3)
mount_nose    = tie_gap - 0.3;                        // see mount_d
tie_knurl     = [1.2, 0.4, 0.3];                      // cross-hatch on the outer face: pitch, groove width, depth
link_len      = fin_depth_bot - link_pin_inset;      // crank length of the parallelogram

slat_y        = [-34.6, 13.6];   // axle positions along the bar (holes in the bars), from the photo
slat_z        = 26;              // axle height, mid-bar
slat_end_gap  = 0.3;             // plate end to the bar's inner face; the plate used to stop 1.5 short and the slat slid side to side
slat_len_rod  = 2 * (vane_x - slat_end_gap);   // 54.4: the plate spans the bars less the end gaps (was a 52 photo estimate)
slat_len_edge = 40;   slat_depth = 17;                        // trapezoid: long at the rod, short at the trailing edge
slat_t        = 2;    slat_rod_d = 2;  slat_clr = 0.15;       // rod = plate thickness so it prints flat; hole = rod + 2*clr.
                                                              // 0.2 printed loose (2026-09-11) -> 0.15; the slats need not swing freely

panel_recess  = 0.4;  panel_pitch = 1.0;  panel_groove = 0.55;   // ribbed rectangular panels, cosmetic
fin_panels    = [[0.22, 0.45], [0.67, 0.90]];   // along the plate, as fractions of its length
bar_panels    = [[0.18, 0.40], [0.70, 0.92]];

// root-to-shroud, two different teeth per bar (2026-09-11):
//   +Y (the toy's bottom) = the ORIGINAL PEG from Sketch 06. The Whale's base
//   has a small slot this peg drops into, so it keeps the sketch's size exactly:
//   the bar's thickness, 5.27 wide, 2.2 mm below the rim, sharp-edged (Armen:
//   'we can't have them be wider than the original size... the slot is quite
//   small, 1-2 mm depth max'). Weaker than a fork, but the base supports it.
//   -Y (the toy's top) = a FORK DART that straddles the duct wall like a clothes
//   peg on a line: the KEY drops tooth_key into a round notch in the rim
//   (locates along the rim, Z stop); two PRONGS continue below the rim on both
//   faces of the wall and grip it, stopping the vane rocking. The slot between
//   the prongs is the wall's own annulus offset tooth_clr, mouth chamfered. A
//   nub on the key clicks into a dimple in the notch wall.
//   Shape: a slender body of revolution about an axis along Z (the airflow),
//   centred on the bar's mid-plane so it is the same on both faces (the vane
//   prints standing up; a flat-clipped pod 'looked weird'): tangent-ogive nose
//   reaching toward the shroud's mid-height, a short cylinder through the rim,
//   a cone tail fading up the bar. The wall splits the round pod into two D
//   prongs whatever angle the bar crosses the ring at. At the mid-plane the pod
//   sits 50.7 deg around the ring and its outer prong reaches down beside the
//   deco box at 45 deg: deco_box_keepout() shaves the prong where it would
//   touch that box's blend (a small flat, below the rim, among the boxes).
peg_y        = [31.924, 37.191];  peg_z = [19.065, 26.5];   // the +Y peg, straight from Sketch 06: y span, z bottom .. top (buried in the bar)
peg_clr      = 0.15;   // peg / key to notch, per side. Coupon round 1 (2026-09-08): 'tooth fit 0.15 is fine'
tooth_r      = 2.25;   // pod radius (3 was 'far too fat'); each prong is a D 3.9 wide and 1.1 thick beside the 2.3 mm slot
tooth_nose   = 8;      // ogive nose length along the axis
tooth_over   = 1.5;    // the pod stays full round this far past the bar's bottom edge, then the tail cone fades out on the bar's
                       // face (Armen 2026-09-11: the cone met the bar's edge 'as a single point, feels like a failure point')
tooth_tail   = 6.5;    // cone tail length, fading to a point on the bar's face (the -Y one passes the slat hole at r ~1, a hair proud)
tooth_key    = 3;      // notch depth into the rim = key engagement
tooth_prong  = 11;     // the dart's tip is this far below the rim top: 3 of cylinder, then the nose. The prongs grip
                       // wherever the pod is fatter than the wall's half-band (1.15): about 9 mm of it
tooth_clr    = 0.10;   // slot to wall, per face (radial). Coupon round 3 (2026-09-12): 0.10 / 0.15 / 0.20 printed, 0.10 the best fit
tooth_lead   = 0.6;    // chamfer on the slot mouth so the rim finds its way in
tooth_box_clr = 0.3;   // the fork's outer prong keeps this clear of the deco boxes' faces and blends
tooth_nub_d  = 1.4;  tooth_nub_h = 0.35;  tooth_nub_clr = 0.15;   // nub sphere, its protrusion, dimple clearance
duct_r_mid   = (duct_r_in + duct_r_out) / 2;                                   // 45
tooth_ax     = vane_x + vane_t / 2;                                            // pod axis: the bar's mid-plane (28.5) ...
tooth_ay     = sqrt(duct_r_mid * duct_r_mid - tooth_ax * tooth_ax);            // ... where it crosses the wall's mid-radius (|y| 34.84, 50.7 deg)
tooth_tan    = [-tooth_ay, tooth_ax] / duct_r_mid;                             // unit tangent to the ring at the +Y axis
function rim_z(y) = duct_h_mid + y * tan(taper_deg);                            // rim top height at y (the taper plane)
function tooth_key_z(sgn) = rim_z(sgn * tooth_ay) - tooth_key;                  // key bottom for a fork on the +Y (sgn = 1) or -Y side
function tooth_zb(sgn) = tooth_key_z(sgn) - (tooth_prong - tooth_key);          // z of the nose tip (prong tips)

// -Y mount variant (2026-09-11): "fork" = the fork dart above (current); "saddle" = the SHROUD GRABS THE VANE.
//   The fork darts (1.1 mm prongs, printed standing with support) broke off during support removal. In the
//   saddle variant the vane's -Y end has no thin features at all: a block on the rim at each -Y crossing,
//   aligned with the bar and trimmed to r recv_r_in..recv_r_out, is printed flat with the shroud (layers along
//   its loads). The bar's -Y end drops into a CHANNEL through the block: two cheeks up to recv_z_top grip the
//   bar's faces (following the taper) and stop it rocking; below the bar a POCKET takes the sketch's -Y peg,
//   whose -Y face is sloped peg2_slope so the standing vane prints it without support and so it self-centres
//   along the rim as it seats. The pocket's +Y wall and the slope locate the vane along the rim; the pocket
//   floor carries it. A nub on the inner cheek clicks into a dimple in the bar's inner face (the flexing
//   member is the cheek, backed by the boss below the rim). Below the rim the block fades into the wall like
//   the strut boss; above it the outer 2 mm sits on a 45 deg chamfer, clear of the deco boxes.
ny_mount      = "fork";   // "fork" | "saddle". Flip in the viewer's panel or with -D 'ny_mount="saddle"'
peg2_y        = [-38.4382, -31.6641];   // the sketch's -Y peg (Sketch 06 lines 17..26): y span ...
peg2_z0       = 14.7098;                // ... and its bottom, 2.0 below the rim there
peg2_slope    = 45;                     // its -Y face, degrees off the bar's bottom line (45 = printable standing)
chan_clr      = 0.10;                   // cheek to bar face, per side. Untested: saddle coupon ladders 0.05 / 0.10 / 0.15
cheek_t       = 1.6;                    // cheek thickness beside the channel
recv_end_t    = 1.6;                    // block material beyond the pocket's ends, along the bar
recv_r_in     = 41;                     // block's inner face in the bore (the strut boss reaches 40.6)
recv_r_out    = 48;                     // block's outer face, 2 mm proud of the wall (above the deco boxes)
recv_z_low    = 12;                     // bottom of the boss in the bore (pocket floor at 14.56), 45 deg chamfer below it
recv_gap_slat = 0.5;                    // block top stays this far below the slat rod (which passes the bar at slat_z)
recv_fade     = 2;                      // concave fillets blending the boss into the wall's faces, below the rim
recv_nub_h    = 0.25;                   // nub protrusion into the channel; interference on the way in = recv_nub_h - chan_clr
recv_nub_z    = 23;                     // nub height: mid-cheek, at the ring crossing where the inner cheek is full
recv_top_r    = 0.8;                    // round on the block's top edges (rounded_pad; the r 41 arc is concave, hull adds 0.09 mm)
chan_lead     = 0.6;                    // 45 deg lead-in on the channel mouth so the bar finds its way in
recv_z_top    = slat_z - slat_rod_d / 2 - recv_gap_slat;   // 24.5

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

use <../lib/shape.scad>   // rounded_pad, rounded_plate, annulus_2d, wall_blend, arc_sweep, arc_pts, stroke_2d, grooves_2d
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

// nub centre for the tooth on side sgn (in the +X vane's frame): on the key's
// round side, pointing along the ring (tangentially) into the notch's end wall,
// at the wall's mid-radius, half way down the key.
function tooth_nub_c(sgn) = let (t = [tooth_tan[0], sgn * tooth_tan[1]])
    [tooth_ax, sgn * tooth_ay, tooth_key_z(sgn) + tooth_key / 2] + (tooth_r - tooth_nub_h + tooth_nub_d / 2) * [t[0], t[1], 0];

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

// The pod: a (r, z) half-profile (children) revolved about the tooth's axis.
// clr grows the profile (the notch is the same profile offset clr).
module tooth_sweep(sgn, clr = 0) {
    translate([tooth_ax, sgn * tooth_ay, 0]) rotate_extrude($fn = 48)
        intersection() { offset(delta = clr) children(); translate([0, -100]) square([100, 200]); }   // keep the grown profile off the axis
}
// Notches in the rim: the +Y peg's slot straight through the wall, and for
// the -Y fork a round bite tooth_key deep (the wall below stays solid for the
// prongs to grip; its curved end walls locate the key along the rim) with the
// dimple its nub clicks into.
module vane_slots(clr = peg_clr) {
    for (sx = [-1, 1]) mirror([sx < 0 ? 1 : 0, 0, 0]) {
        translate([vane_x - clr, peg_y[0] - clr, peg_z[0] - clr]) cube([vane_t + 2 * clr, peg_y[1] - peg_y[0] + 2 * clr, 30]);
        if (ny_mount == "fork") {
            tooth_sweep(-1, clr) translate([0, tooth_key_z(-1)]) square([tooth_r, 30]);
            translate(tooth_nub_c(-1)) sphere(d = tooth_nub_d + 2 * tooth_nub_clr, $fn = 32);
        }
    }
}

module duct() {
    difference() {
        union() {
            intersection() {
                union() { duct_ring(); for (a = [0, 180]) rotate([0, 0, a]) boss_pad(); }
                below_taper();
            }
            if (ny_mount == "saddle") receivers();
        }
        vane_slots();
        if (ny_mount == "saddle") for (sx = [-1, 1]) mirror([sx < 0 ? 1 : 0, 0, 0]) { channel_cut(); peg2_pocket(); }
        for (a = [0, 180]) rotate([0, 0, a]) pocket();
    }
    if (ny_mount == "saddle") for (sx = [-1, 1]) mirror([sx < 0 ? 1 : 0, 0, 0]) translate(recv_nub_c()) sphere(d = tooth_nub_d, $fn = 32);
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

// ---- tapered, edge-rounded plates ----
vane_z_root = vane_arc_l[1][1];                                   // 20.584: the bar's lowest point, full thickness here and below
function vane_z_tip() = hinge_z + fin_depth_bot;                  // the plate's farthest edge (a function: hinge_z is defined further down)
function vane_thk(z) = let (f = min(max((z - vane_z_root) / (vane_z_tip() - vane_z_root), 0), 1)) vane_t + (vane_t_tip - vane_t) * f;
function vane_face(z, side = 1) = vane_x + vane_t / 2 + side * vane_thk(z) / 2;   // x of the outer (+1) / inner (-1) face at height z
// the slab between the two tapered faces, each pulled in by r, as a (x, z) polygon extruded along y
module thk_wedge(r = 0) {
    cx = vane_x + vane_t / 2;  z0 = vane_z_root;  z1 = vane_z_tip();  h0 = vane_t / 2 - r;  h1 = vane_t_tip / 2 - r;
    rotate([90, 0, 0]) linear_extrude(200, center = true)
        polygon([[cx - h0, -10], [cx + h0, -10], [cx + h0, z0], [cx + h1, z1], [cx + h1, 100], [cx - h1, 100], [cx - h1, z1], [cx - h0, z0]]);
}
// everything outboard of (outer face - depth): what a face_cut may remove
module outer_beyond(depth) {
    cx = vane_x + vane_t / 2;  z0 = vane_z_root;  z1 = vane_z_tip();  h0 = vane_t / 2 - depth;  h1 = vane_t_tip / 2 - depth;
    rotate([90, 0, 0]) linear_extrude(200, center = true)
        polygon([[cx + h0, -10], [cx + 20, -10], [cx + 20, 100], [cx + h1, 100], [cx + h1, z1], [cx + h0, z0]]);
}
// a 2D outline in (y, z) -> the tapered plate about x = vane_x + vane_t / 2, every edge rounded r: the outline
// shrunk by r is extruded, cut to the wedge pulled in by r, then minkowski'd with a sphere (rounded_plate's
// recipe, with the wedge in the middle). The sphere rolls along the sloping faces, so the fillets follow them.
module plate_yz(r = vane_edge_r) {
    minkowski() {
        intersection() {
            translate([vane_x - 1, 0, 0]) rotate([90, 0, 90]) linear_extrude(vane_t + 2) offset(r = -r) children();
            thk_wedge(r);
        }
        sphere(r, $fn = 16);
    }
}

// vane bar profile in the YZ plane: the sketch outline traced as one polygon.
// (A hull of corner circles was wrong here: the arcs are not tangent to the
// vertical ends, so a hull bulges past the top line.)
module vane_2d() {
    polygon(concat([vane_top_l, vane_end_l], arc_pts(vane_arc_l), arc_pts(vane_arc_r), [vane_end_r, vane_top_r]));
}

// The +Y peg: the sketch's rectangle, the bar's full thickness, sharp edges
module peg() { translate([vane_x, peg_y[0], peg_z[0]]) cube([vane_t, peg_y[1] - peg_y[0], peg_z[1] - peg_z[0]]); }

// The fork dart on the +X bar, side sgn (-1 = the -Y end): the pod revolved,
// minus the wall's annulus (offset clr) from the nose up to the key's bottom,
// the chamfered mouth, and the deco boxes' keep-out.
// half-profile of the pod in (radius, z): tangent-ogive nose (an arc of radius
// rho through the tip, tangent to the cylinder), cylinder, cone tail
module tooth_pod_profile_2d(sgn) {
    zb = tooth_zb(sgn);  z0 = bar_bot(sgn * tooth_ay) + tooth_over;   // full round to z0, then the tail
    R = tooth_r;  L = tooth_nose;  rho = (R * R + L * L) / (2 * R);
    polygon(concat([for (i = [0 : 16]) let (t = L * i / 16) [sqrt(rho * rho - (L - t) * (L - t)) + R - rho, zb + t]],
                   [[R, z0], [0, z0 + tooth_tail]]));
}
// every deco box position (the skipped ones too, so both vanes see the same
// thing), grown by the wall blend and clr: outside the wall only
module deco_box_keepout(clr) {
    w = box_w / 2 + wall_blend_r + clr;
    for (i = [0 : box_n - 1]) rotate([0, 0, i * box_step])
        translate([-w, duct_r_out - 0.5, -1]) cube([2 * w, 5, box_z0 + box_h + clr + 1]);
}
module tooth_fork(sgn, clr = tooth_clr) {
    zk = tooth_key_z(sgn);  zb = tooth_zb(sgn);   // key bottom, nose tip
    difference() {
        tooth_sweep(sgn) tooth_pod_profile_2d(sgn);
        translate([0, 0, zb - 1]) linear_extrude(zk - zb + 1) annulus_2d(duct_r_in - clr, duct_r_out + clr);
        rotate_extrude() polygon([[duct_r_in - clr - tooth_lead, zb - 1], [duct_r_out + clr + tooth_lead, zb - 1],
                                  [duct_r_out + clr + tooth_lead, zb], [duct_r_out + clr, zb + tooth_lead],
                                  [duct_r_in - clr, zb + tooth_lead], [duct_r_in - clr - tooth_lead, zb]]);
        deco_box_keepout(tooth_box_clr);
    }
}

// ---- saddle receiver (ny_mount == "saddle"), built for the +X vane's -Y end; mirror in X for the other ----
// The wedge peg in (y, z): the sketch's -Y peg with its -Y face sloped peg2_slope, the slope passing through the
// bar's bottom edge at peg2_y[0] and continued 1 mm up into the bar so the bodies fuse. clr grows it into the pocket.
function peg2_run() = (bar_bot(peg2_y[0]) - peg2_z0) / tan(peg2_slope);   // y run of the sloped face below the bar
module peg2_2d(clr = 0) {
    offset(delta = clr)
        polygon([[peg2_y[0] + peg2_run(), peg2_z0], [peg2_y[1], peg2_z0], [peg2_y[1], bar_bot(peg2_y[1]) + 1],
                 [peg2_y[0] - 1 / tan(peg2_slope), bar_bot(peg2_y[0]) + 1]]);
}
module yz_extrude(x0, w) { translate([x0, 0, 0]) rotate([90, 0, 90]) linear_extrude(w) children(); }   // a (y, z) shape along +X
module peg2()                    { yz_extrude(vane_x, vane_t) peg2_2d(); }
module peg2_pocket(clr = peg_clr) { yz_extrude(vane_x - clr, vane_t + 2 * clr) peg2_2d(clr); }

// the block's plan view, aligned with the bar: cheeks either side of the channel, ends beyond the pocket
function recv_y0() = peg2_y[0] - peg_clr - recv_end_t;
function recv_y1() = peg2_y[1] + peg_clr + recv_end_t;
module recv_box_2d(clr = chan_clr) {
    x0 = vane_x - clr - cheek_t;  x1 = vane_x + vane_t + clr + cheek_t;
    translate([x0, recv_y0()]) square([x1 - x0, recv_y1() - recv_y0()]);
}
module recv_core_2d(clr = chan_clr) { intersection() { recv_box_2d(clr); annulus_2d(recv_r_in, recv_r_out); } }
// the core plus concave fades where its sides meet the wall's two faces (the strut boss's offset trick)
module recv_plan_2d(clr = chan_clr) {
    f = recv_fade;
    intersection() {
        offset(r = -f) offset(r = f) union() { recv_core_2d(clr); annulus_2d(duct_r_in, duct_r_out); }
        offset(delta = f + 1) recv_box_2d(clr);      // the neighbourhood: the wall strip beyond it is dropped
        annulus_2d(recv_r_in, recv_r_out);
    }
}
// printable undersides: outside the wall the block sits on a 45 deg chamfer from just below the lowest rim it
// touches; inside the bore the boss starts at recv_z_low on a 45 deg chamfer. Both are bodies of revolution
// that the block is intersected with.
module recv_ok_out() { z0 = rim_z(recv_y0()); rotate_extrude($fn = 180) polygon([[0, -1], [duct_r_out, -1], [duct_r_out, z0], [duct_r_out + 60, z0 + 60], [0, z0 + 60]]); }
module recv_ok_in()  { rotate_extrude($fn = 180) polygon([[duct_r_in, -1], [110, -1], [110, 200], [0, 200], [0, recv_z_low + duct_r_in], [duct_r_in, recv_z_low]]); }
module receiver(clr = chan_clr) {   // solid; duct() cuts the channel and pocket and adds the nub
    intersection() {
        union() {
            intersection() { linear_extrude(recv_z_top) recv_plan_2d(clr); below_taper(); }   // below the rim, with the fades
            rounded_pad(recv_z_top, recv_top_r, fillet_fn) recv_core_2d(clr);               // the block, rim to top, top edges rounded
        }
        recv_ok_out();
        recv_ok_in();
    }
}
module receivers() { for (sx = [-1, 1]) mirror([sx < 0 ? 1 : 0, 0, 0]) receiver(); }
// the channel: the bar's tapered slab grown clr, from clr under the bar's bottom line up, over the block's length
module channel_cut(clr = chan_clr) {
    y0 = recv_y0() - 1;  y1 = recv_y1() + 1;
    intersection() {
        thk_wedge(-clr);
        yz_extrude(vane_x - 5, vane_t + 10) polygon([[y0, bar_bot(y0) - clr], [y1, bar_bot(y1) - clr], [y1, 100], [y0, 100]]);
    }
    // lead-in: the mouth flares chan_lead at 45 deg over the block's length
    xl = vane_face(recv_z_top, -1) - clr;  xr = vane_face(recv_z_top, 1) + clr;  zt = recv_z_top;
    translate([0, (y0 + y1) / 2, 0]) rotate([90, 0, 0]) linear_extrude(y1 - y0, center = true) polygon([[xl, zt - chan_lead], [xr, zt - chan_lead], [xr + chan_lead + 1, zt + 1], [xl - chan_lead - 1, zt + 1]]);
}
// nub centre: on the inner cheek's face at the ring crossing, sunk so it stands recv_nub_h proud
function recv_nub_c() = [vane_face(recv_nub_z, -1) - chan_clr - (tooth_nub_d / 2 - recv_nub_h), -tooth_ay, recv_nub_z];

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
// the filament pin's hole, straight through the whole nub and out both ends
module fil_hole(yc, clr = fil_clr) { pin_prism(fil_d + 2 * clr, yc - hinge_len / 2 - 1, yc + hinge_len / 2 + 1); }
// root side of one nub: two outer knuckles webbed to the bar, and the pin (or the hole for the filament pin).
// clr is the hole clearance in filament mode; the printed pin has none of its own (the plate's hole carries it)
module hinge_root(yc, clr = fil_clr) {
    difference() {
        for (i = [0, 2]) { y0 = nub_y0(yc, i); barrel(y0, y0 + knuckle_l); web(y0, y0 + knuckle_l, 29, hinge_z); }
        if (hinge_pin == "filament") fil_hole(yc, clr);
    }
    if (hinge_pin == "printed") pin_prism(pin_d, yc - hinge_len / 2, yc + hinge_len / 2);
}
// plate side of one nub: the middle knuckle (solid; the hole is cut afterwards)
module hinge_fin_knuckle(yc) { y0 = nub_y0(yc, 1); barrel(y0, y0 + knuckle_l); }
// what to subtract from the plate around one nub: the pin hole (teardrop on the printed pin, round on the
// filament), and notches so the plate clears the root knuckles
module hinge_fin_cut(yc, clr = hinge_pin == "filament" ? fil_clr : hinge_clr) {
    y0 = nub_y0(yc, 1);
    if (hinge_pin == "filament") fil_hole(yc, clr);
    else teardrop_prism(pin_d / 2 + clr, y0 - 1, y0 + knuckle_l + 1);
    for (i = [0, 2])
        translate([min(hinge_x - barrel_d / 2, vane_x) - 1, nub_y0(yc, i) - knuckle_gap, fin_z_low - 1])
            cube([barrel_d + vane_t + 2, knuckle_l + 2 * knuckle_gap, hinge_z + barrel_d / 2 + knuckle_gap - fin_z_low + 1]);
}

// ---- cosmetic ribbed panels: grooves cut into a face, inside an outline ----
// children: the 2D panel outline in (y, z). Cuts print_up-facing? No: cuts the
// OUTER face (x = vane_x + vane_t) of the +X vane.
module face_cut(depth) {   // extrude a (y,z) 2D shape into the outer face, depth measured from the tapered face
    intersection() {
        translate([vane_x - 1, 0, 0]) rotate([90, 0, 90]) linear_extrude(vane_t + 5) children();
        outer_beyond(depth);
    }
}

// ---- the plate (fin): trapezoid in the YZ plane ----
function fin_depth(y) = fin_depth_top + (fin_depth_bot - fin_depth_top) * (y - hinge_y0) / (hinge_y1 - hinge_y0);
module fin_outline_2d() {   // (y, z)
    offset(r = fin_corner) offset(delta = -fin_corner)
        polygon([[hinge_y0, fin_z_low], [hinge_y1, fin_z_low],
                 [hinge_y1, hinge_z + fin_depth_bot], [hinge_y0, hinge_z + fin_depth_top]]);
    // both inner corners (along the hinge, next to the bar's square end corners) stay square to match it
    // (Armen 2026-09-11); the two outer corners keep fin_corner
    translate([hinge_y0, fin_z_low]) square([fin_corner, fin_corner]);
    translate([hinge_y1 - fin_corner, fin_z_low]) square([fin_corner, fin_corner]);
}
module fin_panel_2d(f) {   // one ribbed panel outline, inset 3 mm, following the taper
    L = hinge_y1 - hinge_y0; y0 = hinge_y0 + f[0] * L; y1 = hinge_y0 + f[1] * L; m = 3;
    polygon([[y0, fin_z_low + m], [y1, fin_z_low + m], [y1, hinge_z + fin_depth(y1) - m], [y0, hinge_z + fin_depth(y0) - m]]);
}
module vane_fin() {
    difference() {
        union() {
            plate_yz() fin_outline_2d();
            for (yc = hinge_pts) hinge_fin_knuckle(yc);
            // linkage pin near the bottom trailing corner, pointing +Y (down), on the plate's mid-plane: the canoe
            // mount (tail cone up the plate, cylinder, nose cone to the pin at the plate's end), the pin, the bulb
            translate([pin_x, hinge_y1, tie_z]) rotate([-90, 0, 0]) {   // local +z = +Y, local 0 = the plate's end
                rotate_extrude($fn = 48) polygon([[0, -mount_cyl - mount_tail], [mount_d / 2, -mount_cyl], [mount_d / 2, 0],
                                                  [link_pin_d / 2, mount_nose], [0, mount_nose]]);
                translate([0, 0, -1]) cylinder(d = link_pin_d, h = link_pin_len + 1);
                translate([0, 0, link_pin_len - (link_pin_d / 2 + tie_snap)]) sphere(d = link_pin_d + 2 * tie_snap);
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
            plate_yz() vane_2d();
            for (yc = hinge_pts) hinge_root(yc);
            peg();                                                                            // +Y: the sketch peg, into the base's slot
            if (ny_mount == "fork") { tooth_fork(-1); translate(tooth_nub_c(-1)) sphere(d = tooth_nub_d, $fn = 32); }   // -Y: the fork dart + its click nub
            else peg2();                                                                                                 // -Y: the wedge peg, into the receiver's pocket
        }
        if (ny_mount == "saddle") translate(recv_nub_c()) sphere(d = tooth_nub_d + 2 * tooth_nub_clr, $fn = 32);       // dimple for the receiver's nub
        for (y = slat_y) translate([vane_x - 8, y, slat_z]) rotate([0, 90, 0]) cylinder(d = slat_rod_d + 2 * slat_clr, h = vane_t + 9);   // long enough to pass any pod material on the inside face
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
pin_x   = vane_x + vane_t / 2;   // the pin's x on the +X vane: the plate's mid-plane (was flush with the outer face for flat printing)
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


