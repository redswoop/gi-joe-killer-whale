# Killer W.H.A.L.E. fan shroud + steering vanes (OpenSCAD)

State as of 2026-09-11 (evening). Parametric port of Armen's Shapr3D shroud, plus a new print-in-place
vane mechanism reconstructed from photos of the real MET-b52 parts.

## Files
| File | What |
|---|---|
| `shroud.scad` | The whole model. Parameters at the top, one section per Shapr3D operation, then the vane mechanism. |
| `viewer.json` | Part list for the browser viewer (`../viewer`, `bun run dev`, open http://127.0.0.1:5180/). |
| `print_layout.scad` | `-D part="..."`: each part in its printing pose. Vanes stand on their -Y end (`vane_pose = "vertical"`). |
| `hinge_coupon.scad` | Tolerance test print: hinge x3 (standing, pins vertical), slat axle holes x3, keyhole eyes x3, strut pockets x3 + one ear, fork darts x3 (standing) + a piece of rim. |
| `tab_coupon.scad` | Tab fit test print: four 108° arcs of the shroud (30 % of the ring, centred on the tab, `keep = 0.3`) with tab `variants` = [grip, stem_extra] pairs, labelled on a tag. Round 1 laddered the grip; round 2 ladders the stem width at grip 0.7. |
| `check.scad` | Collision pairs (`-D pair="..."`, `steer`, `tilt`, `strut_dz`). Run them all: `../tools/check.sh check.scad 'steer=0' 'steer=30' 'steer=-30 tilt=20' 'strut_dz=8'`. |
| `compare.scad` | Volume diff against the Shapr3D export (`ref_bodies/` = the STL split per shell). Numeric version: `../tools/voxcmp.py stl/shroud.stl ref_bodies/shroud.stl`. |
| `export.sh` | Regenerates every STL in `stl/`. Run after changing parameters. |
| `render.sh` | Headless PNGs into `renders/`. |
| `Shroud.shapr/.step/.stl` | Armen's originals. Read the .shapr with `../tools/shapr_dump.py Shroud.shapr`. |

Generic helpers (`rounded_pad`, `wall_blend`, `arc_sweep`, `arc_pts`, `stroke_2d`, `grooves_2d`, `teardrop_2d`, `keyhole_2d`) moved to `../lib/` on 2026-09-09; STL output was hash-identical before and after.

## Coordinate frame
Z = duct axis (airflow exits +Z). Y = the toy's vertical, **+Y (tab side) = the toy's bottom**. X = port/starboard.

## Parts and how they go together
1. **Shroud** (`shroud.stl`, base down, no supports). Has: tooth notches in the rim for the vanes, pocket bosses in the bore at 3/9 o'clock for the strut.
2. **Strut / hub bar** (`strut.stl`, prints standing on one ear, brim, no supports). From the base side, line the ears up with the two pockets and push the bar in until the ears hit the pocket ceilings. The Whale's hull holds it there.
3. **Vanes** (`vane_right.stl`, `vane_left.stl`, standing on the -Y end, 99 mm tall, brim; the dart's underside may want a little support). Armen's call (2026-09-11): vertical prints the ribbed panels as wall detail and puts the hinge pins vertical. Print-in-place hinge: free each plate by working it back and forth. The +Y peg drops through the rim slot into the slot in the Whale's base; the -Y fork dart pushes down over the rim: key into the round notch, prongs straddling the wall, nub clicks.
4. **Slats** (`slat.stl` x2, flat). Spring the 59 mm rods into the holes in the two bars before the vanes go into the shroud. The plate now nearly spans the bars (0.3 mm end gaps), so they stay put sideways.
5. **Tie bar** (`tie_bar.stl`, knurl up). Bulbs go through the big keyholes, slide the bar aft, pins click into the working holes.

Print the **coupon** first and put the winning numbers into `hinge_clr`, `slat_clr`, `tooth_clr`, `tie_eye_clr`, `ear_clr`.

## Print next (as of 2026-09-11 evening)
1. `stl/hinge_coupon.stl` (89 x 109 mm): hinge 0.15 / 0.20 / 0.25, slat holes 0.10 / 0.15 / 0.20, fork teeth 0.10 / 0.15 / 0.20 on a piece of rim, strut ear pockets 0.10 / 0.20 / 0.30, keyhole eyes, bullet pins.
2. `stl/shroud.stl`: settled tab, strut pockets, and the new shallow (3 mm) key notches.
3. `stl/strut.stl` (ears in pockets, standing on an ear, brim) once the pocket clearance is known.
4. Vanes and slats once the coupon confirms `hinge_clr`, `tooth_clr` and `slat_clr`.

## Design notes
- Hinge: two 13 mm nubs per vane at y = -34 / 36 (over the teeth), barrel 4.2, round pin 1.4, teardrop holes, barrels on the inside face. Printed vanes at `hinge_clr = 0.4` swung through the full range but were too loose (2026-09-10); Armen's own tolerance tests say 0.15 (2026-09-11) -> `hinge_clr = 0.15`. **Confirmed 2026-09-11 on a full vane printed at 45° with the pins near vertical: "perfect, almost feels oiled".** (Coupon round 1 called 0.25 stuck, but that was printed flat with horizontal pins; the number depends on the pin being vertical.) `hinge_lift = 0.6` keeps the barrel off the bar's top edge (a printed barrel has a flat where it met the bed).
- **Teeth** (2026-09-11). The two ends of each bar differ:
  - **+Y (toy's bottom): the original Sketch 06 peg**, `peg()`: the bar's thickness, 5.27 wide (y 31.9..37.2), 2.2 mm below the rim (z 19.065), sharp-edged, no nub. It drops into a small slot in the Whale's base, so it must keep the sketch's size exactly ("the slot is quite small, 1-2 mm depth max"). Weak on its own; the base supports it. The rim slot is the peg + `peg_clr`.
  - **-Y (toy's top): a fork dart**, `tooth_fork(-1)`: a slender body of revolution about an axis along Z on the bar's mid-plane, so it is the same on both faces. Tangent-ogive nose `tooth_nose = 8` reaching `tooth_prong = 11` below the rim (tip near the shroud's mid-height), cylinder `tooth_r = 2.25` through the rim (3 was "far too fat") and on past the bar's bottom edge by `tooth_over = 1.5`, so the pod straddles the edge at full width (the cone used to meet the edge at a point, "feels like a failure point"), then cone tail `tooth_tail = 6.5` fading up the bar's face; it runs into the slat hole, where it is only a hair proud of the bar. The wall's annulus (offset `tooth_clr`) splits it into two D prongs 3.9 wide and 1.1 thick that grip the wall; the key drops `tooth_key = 3` into a round bite in the rim whose curved end walls locate it along the rim; a nub on the key clicks into a dimple. At the mid-plane the pod sits 50.7° around the ring, and its outer prong reaches down beside the deco box at 45°: `deco_box_keepout()` shaves a small flat off that side (`tooth_box_clr = 0.3` from the box and its blend), below the rim, among the boxes. History: flat dart with fillets (49ceeaa, "ugly"), fat canoe pod clipped flat on the outer face (506b449, "looks weird"), then this.
- **Taper** (2026-09-11, "the slightest taper, widest at the root where they attach to the duct, down to a thin edge at the outside"): both plates thin linearly with z from `vane_t = 2` at the bar's lowest edge (z 20.6) to `vane_t_tip = 1.2` at the plate's farthest corner (z 59.2), symmetric about the mid-plane (`vane_thk(z)`, `thk_wedge()`); each face slopes 0.6°. So the bar runs 2.0 -> 1.8 and the plate 1.7 -> 1.2. The panel grooves are cut from the sloping face (`face_cut` uses `outer_beyond`) so they keep their 0.4 depth. The link pin moved to the mid-plane (`pin_x`); its mount wraps the thin corner on both faces, so it stays rooted (see the tie bar note). The +Y peg keeps its full 2 mm (it is 0.06 proud of the bar at its top, invisible). Section: `renders/vane_taper_section.png`; pin: `renders/pin_corner.png`.
- **Rounded edges** (2026-09-11, "they look too blocky"): `plate_yz()` builds each plate as the outline shrunk by r, extruded, cut to the tapered wedge pulled in by r, then minkowski'd with a sphere (the `rounded_plate()` recipe from `../lib/shape.scad` with the wedge in the middle). `vane_edge_r = 0.5` (0.7 before the taper; the 1.2 mm tip needs r <= 0.6) on every edge of both faces; convex outline corners come out rounded too. The +Y peg is deliberately not rounded. The plate's two inner corners (along the hinge, next to the bar's square end corners) are square in plan to match it; the two outer corners keep `fin_corner = 2`. Standing vertically, the end faces on the bed are ~1.4 mm wide at the first layer: brim. The hinge webs, knuckle ends, tie bar and slats are still sharp-edged. Render: `renders/vane_edges.png`.
- **Plate span**: `hinge_y0` is now the bar's -Y end (-45.72, was -44) so the plate stands on the bed with the bar when printing vertically.
- Slats: `slat_clr = 0.15` (0.2 printed loose), and the plate spans the bars less `slat_end_gap = 0.3` per side (54.4 at the rod) instead of the 52 mm photo estimate, so a slat cannot shuffle sideways.
- Linkage is a four-bar, solved in `solve_left()`; ~0.8° asymmetry at 30°.
- The tie bar is the hat-shaped `_/----\_` original with a knurled middle. Its raised middle's outer edge is flush with the plates' outer edge at rest (`tie_jog = link_pin_inset - tie_w / 2`, 4.3), per Armen 2026-09-11.
- **Link pin mounts** (2026-09-11, "these should also canoe up the vane; move them about 3 mm from the edge"): `link_pin_inset = 5.8` (was 2.8), so the mount sits 3.5 mm inside the plate's outer edge. The root is a canoe about the pin's axis on the plate's mid-plane, `mount_d = 4.5` like the tooth: a cone tail `mount_tail = 6` fading up the plate (-Y), a cylinder `mount_cyl = 2` to the plate's end, a nose cone down to the pin ending `mount_nose` (tie_gap - 0.3) past the end so the eye seats on the pin, then the pin and its bulb. Renders: `renders/pin_corner.png`, `renders/tie_flush.png`, `renders/tie_closeup.png`.
- Strut mount v4 (2026-09-10): **ears in pockets**. The bar's ends turn up into 2 mm curved ears hugging the bore wall, half the shroud's height (`ear_top = 9.5`). A boss on the wall at each end (13.7 wide, 3.4 proud, 11.2 tall, fading into the wall with 3 mm concave fillets on its sides and top: `boss_fade`, built with the `offset(r = -f) offset(r = f)` trick) holds a pocket open at the base and blind at the top, with a notch through its inner lip for the plate. Insert from the base side. `ear_clr = 0.2` per face, untested. Bar plane back at z = 0 as in the Shapr3D original. Earlier ideas in git history: v3 twist lock (be6d171), dovetail slides (9d956e5).
- Slats never reach the hinge line thanks to their taper; the plates first touch a slat at 40° steer.
- `print_face = "inner"` flips the vane to print barrels-down with support PLA, putting the ribbed panels on top.

## Open items
- All plate/slat/pin dimensions are photo estimates scaled off the 92 mm bar; calipers on the real parts would firm them up. Also unmeasured: the slot in the Whale's base that the +Y peg drops into (assumed to fit the sketch peg).
- Vane print 2026-09-11 (Armen, 45°, forks toward the bed): hinge perfect; **the fork darts broke off during support removal** (1.1 mm prongs). Second print in progress lying on its side, hinges down, support PLA with 0 interface distance. Fork geometry needs strengthening or a support-free orientation; see the open item below.
- Fork darts: too fragile for support removal at `tooth_r = 2.25`. Options on the table: fatter pod (r 2.6 gives 1.5 mm prongs), shorter dart, a teardrop section that prints self-supporting standing up, or a sacrificial bridge across the prong tips.
- Coupon round 3 not yet printed: hinge 0.15 / 0.20 / 0.25, slat holes, fork teeth 0.10 / 0.15 / 0.20, ear-in-pocket fit (0.10 / 0.20 / 0.30), keyhole click, bullet-rooted pins.
- Fallback if the keyhole/pins still misbehave: a separate reinforced peg that tabs into a slot in the plate.
- Mounting tab: settled by two coupon rounds on 2026-09-10 (olive green). Round 1 grip 0.8 best but a tad tight, 0.5 loose -> `tab_grip = 0.7`. Round 2 stem width: +0.15 and +0.3 both good, +0.3 a tad much -> `tab_stem_extra = 0.2`. Not yet tested on a full shroud print.
- Fans and the spin box are out of scope so far.

## Gotchas learned
- This OpenSCAD nightly renders a small-angle `rotate_extrude` as a single chord; `arc_sweep()` hulls per-degree slabs instead.
- Bun.serve drops idle connections after 10 s: the viewer server sets `idleTimeout: 0` and heartbeats.
