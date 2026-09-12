# Killer W.H.A.L.E. fan shroud + steering vanes (OpenSCAD)

State as of 2026-09-12. Parametric port of Armen's Shapr3D shroud, plus a new print-in-place
vane mechanism reconstructed from photos of the real MET-b52 parts.

## Files
| File | What |
|---|---|
| `shroud.scad` | The whole model. Parameters at the top, one section per Shapr3D operation, then the vane mechanism. |
| `viewer.json` | Part list for the browser viewer (`../viewer`, `bun run dev`, open http://127.0.0.1:5180/). |
| `print_layout.scad` | `-D part="..."`: each part in its printing pose. Vanes stand on their -Y end (`vane_pose = "vertical"`). With `-D 'vane_mount="fused"'`: `shroud` carries the root bars, `fin_right` / `fin_left` are the plates alone (standing), `slat` has its axle barrel on the bed. |
| `hinge_coupon.scad` | Tolerance test print: hinge x3 (standing, pins vertical; `-D 'hinge_pin="filament"'` ladders the filament hole 0.10 / 0.15 / 0.20 instead), slat axle holes x3, keyhole eyes x3, strut pockets x3 + one ear, fork darts x3 (standing) + a piece of rim. |
| `saddle_coupon.scad` | Fit test for the saddle-mount alternative: three rim pieces with receivers at `chan_clrs` = 0.05 / 0.10 / 0.15, plus a standing stub of the bar's -Y end with the wedge peg. |
| `tab_coupon.scad` | Tab fit test print: four 108° arcs of the shroud (30 % of the ring, centred on the tab, `keep = 0.3`) with tab `variants` = [grip, stem_extra] pairs, labelled on a tag. Round 1 laddered the grip; round 2 ladders the stem width at grip 0.7. |
| `check.scad` | Collision pairs (`-D pair="..."`, `steer`, `tilt`, `strut_dz`). Run them all: `../tools/check.sh check.scad 'steer=0' 'steer=30' 'steer=-30 tilt=20' 'strut_dz=8'`. Every argument is a pose, so the fused table is `'vane_mount="fused"' 'vane_mount="fused" steer=30' ...` (there `roots-duct` is skipped: one body by design). |
| `compare.scad` | Volume diff against the Shapr3D export (`ref_bodies/` = the STL split per shell). Numeric version: `../tools/voxcmp.py stl/shroud.stl ref_bodies/shroud.stl`. |
| `export.sh` | Regenerates every STL in `stl/` in parallel. Plain names are the defaults; `_saddle`, `_filpin` and `_saddle_filpin` are the alternates, `_fused` is the fused variant (`shroud_fused`, `fin_right_fused`, `fin_left_fused`, `slat_fused`), plus `saddle_coupon.stl` and `hinge_coupon_filpin.stl`. Run after changing parameters. |
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

Print the **coupon** first and put the winning numbers into `hinge_clr`, `slat_clr`, `tooth_clr` (settled: 0.10, round 3, 2026-09-12), `tie_eye_clr`, `ear_clr`.

## Print next (as of 2026-09-12)
0. **Fused variant** (Armen's idea, 2026-09-12, see below): `stl/shroud_fused.stl` (base down, 36 mm tall; the two bars bridge the bore
   about 20 mm up, so enable supports under them: support PLA, 0 interface distance, as the vane reprint used), `stl/fin_right_fused.stl` +
   `stl/fin_left_fused.stl` (standing on the -Y end, brim, no support), `stl/slat_fused.stl` x2 (flat), `stl/tie_bar.stl`, plus 2 x 15 mm and
   2 x 61 mm of 1.75 filament. Nothing of it has been printed yet.
0. Filament hinge settled (`fil_clr = 0.15`) and fork dart settled (`tooth_clr = 0.10`): the vanes can print now as
   `vane_right_filpin.stl` + `vane_left_filpin.stl` (fork mount), or `_saddle_filpin` if the saddle wins below.
0. `stl/saddle_coupon.stl` (103 x 39 mm, flat, no supports; the stub wants a brim): decide fork vs saddle. If saddle: put the
   winning cheek clearance into `chan_clr`, then print `shroud_saddle.stl` and `vane_*_saddle.stl` instead of the fork files.
1. `stl/hinge_coupon.stl` (89 x 109 mm): hinge 0.15 / 0.20 / 0.25, slat holes 0.10 / 0.15 / 0.20, fork teeth 0.10 / 0.15 / 0.20 on a piece of rim, strut ear pockets 0.10 / 0.20 / 0.30, keyhole eyes, bullet pins.
2. `stl/shroud.stl`: settled tab, strut pockets, and the new shallow (3 mm) key notches.
3. `stl/strut.stl` (ears in pockets, standing on an ear, brim) once the pocket clearance is known.
4. Vanes and slats once the coupon confirms `hinge_clr`, `tooth_clr` and `slat_clr`.

## Fused variant: bars part of the shroud (2026-09-12)
`vane_mount = "fused"` (the default `"teeth"` is everything above; `-D 'vane_mount="fused"'` or the viewer panel).
Armen: "what if I just combined the shroud and the vane roots? That would give me a single, strong shape". So:
- **Root bars are part of the shroud.** Each bar stands on a `post()` at both wall crossings: the bar's own slab from
  `post_bury` (2) below the rim top up into the bar, trimmed to the wall's annulus at every height so it grows straight
  out of the wall with no overhang (the sketch pegs' boxes are longer than the oblique crossing and their corners
  would hang over the bore and past the outer face), with a `post_fillet` (1 mm) concave foot where the bar's faces
  meet the rim. No notches, teeth, receivers, pegs or darts: `vane_slots()`, `tooth_fork()`, `peg()`, `peg2()`,
  `receiver()` are all off. The +Y crossing keeps the same silhouette inside the wall as the sketch peg did in its notch.
- **Plates are separate parts** on the filament hinge (`hinge_pin` is forced to `"filament"` via `hinge_pin_eff`):
  drop the plate's middle knuckle between the root's two, push 15 mm of 1.75 through, trim 1 mm proud, mushroom.
  The root's holes print lying down in the shroud, so they are teardrops with the roof up (`fil_hole(roof = 1)`);
  the plate's holes print vertical and stay round.
- **Slats ride on filament axles** (`slat_axle()`, 61 mm): rigid bars cannot be sprung apart for a printed rod. The
  slat carries a barrel `slat_barrel_d` (3.45) on the axle, flush with its bed face and proud on the other, with a
  teardrop hole `slat_fil_clr` (0.10, untested; snugger than the bar's `fil_clr` so the slat stays where it is
  put). The bar's holes are `fil_d + 2 * fil_clr` teardrops. Push the filament in from outside the bar (open air
  above the rim), through the slat, out the other bar; mushroom both ends.
- **Print**: `shroud_fused.stl` base down as always. The bars float about 20 mm up and span the bore (70 mm between
  the posts, plus 10 mm cantilevers outside the wall): slicer supports under them. The root-to-rim joint is now in
  the layer-adhesion direction (a sideways push on a vane peels layers at the post), but the joint is the whole
  wall crossing (2 x 4.2 mm) plus the fillet foot, instead of 1.1 mm prongs. Plates print standing as before.
- **Checks**: fused collision table all clear at steer 0 / 30 / -30, tilt +-20, strut_dz 8 (`roots-duct` skipped;
  `slats-roots` includes the axles). `shroud_fused.stl` is one watertight shell (15.65 cm3). The `teeth` variant's STLs
  are unchanged in volume and area by the switch.
- Untested: everything. Bridging / support removal under the bars, `slat_fil_clr`, how the posts look on the toy, and
  whether the Whale's base slot still meets the +Y crossing the way it met the peg.

## Hinge pin: printed or filament (2026-09-12)
`hinge_pin = "printed"` (default, the print-in-place pin) or `"filament"`. **Why**: the vertical vane print
(2026-09-11) came out beautifully, then the hinges snapped as soon as the plates were freed. Standing, the 1.4 mm pin
is printed along its axis: a stack of discs held by layer adhesion, sheared by the first twist. **Filament**: the
knuckles get a plain round hole (`fil_d` 1.75 + 2 x `fil_clr` 0.15 = 2.05) straight through the nub and out both
ends, the barrel grows to `barrel_fil_d` 4.6 for 1.28 mm walls (the hinge line rises 0.2 with it; collision table
still all clear, with either mount), and the teardrop is gone since the vertical holes print round. Root and plate
still print together in place, knuckles aligned. **Assembly**: cut 15 mm of 1.75 filament per nub (`hinge_len` 12.8 +
2 x `fil_proud`), push it through, trim 1 mm proud each end, mushroom the ends with a lighter or soldering iron. No
freeing step, and `hinge_clr` no longer matters. `fil_clr = 0.15` confirmed on the filament coupon (2026-09-12: 0.10 / 0.15 / 0.20
printed, 0.15 best). Untested: how a mushroomed end looks on the inside face. Renders: `renders/filpin_hinge.png`, `filpin_end.png`, `filpin_coupon.png`.

## -Y mount: two variants side by side (2026-09-11)
`ny_mount = "fork"` (default, the current design) or `"saddle"` (the alternative). Flip it in the viewer's parameter
panel to compare; on the CLI `-D 'ny_mount="saddle"'`. The fork variant's STLs are geometrically unchanged by the
switch (same volume and area, zero `voxcmp` difference against the pre-switch export).

**Why**: the fork darts (1.1 mm prongs on the vane, printed standing, with support) broke off during support removal.
**Saddle**: the shroud grabs the vane instead. `receiver()` is a block on the rim at each -Y crossing, aligned with
the bar and trimmed to r `recv_r_in` 41 .. `recv_r_out` 48, printed flat with the shroud so its layers run along its
loads. `channel_cut()` runs the bar's tapered slab (grown `chan_clr`) through it from `chan_clr` under the bar's
bottom line up: two 1.6 mm cheeks up to `recv_z_top` (24.5, half a millimetre under the slat rod) grip the bar's faces
and stop it rocking; the mouth has a 0.6 mm lead-in. Below the bar, `peg2_pocket()` takes the sketch's own -Y peg
(`peg2()`: y -38.44 .. -31.66, bottom z 14.71) with its -Y face sloped 45° (`peg2_slope`), so the standing vane prints
it without support and it self-centres along the rim on the way in; the pocket's +Y wall and floor locate the vane.
A nub on the inner (fan-side) cheek at `recv_nub_z` clicks into a dimple in the bar; the cheek, backed by the boss
below the rim, is the flexing member (interference = `recv_nub_h` - `chan_clr` = 0.15). Below the rim the block fades
into both faces of the wall with 2 mm concave fillets (`recv_plan_2d`, the strut boss's offset trick) and stands on
45° chamfers: `recv_ok_in()` inside the bore from `recv_z_low` 12, `recv_ok_out()` outside from just under the rim,
2.4 mm above the deco boxes. Top edges rounded `recv_top_r`. Both cheeks exist only where the bar is inside the
annulus (the outer one for the +Y 6 mm of the block, the inner for the -Y 8 mm; both over the middle 3.6 mm).
Collision table all clear at steer 0 / 30 / -30+tilt 20 / tilt -20 / strut_dz 8. The +Y peg and its base slot are
untouched. Renders: `renders/saddle_receiver.png`, `saddle_vane_in.png`, `saddle_bore.png`, `saddle_peg.png`,
`saddle_coupon.png`, `saddle_asm_iso.png`. Untested: `chan_clr` (coupon), the nub's click, how the block reads on the toy.

## Design notes
- Hinge (printed pin): two 13 mm nubs per vane at y = -34 / 36 (over the teeth), barrel 4.2, round pin 1.4, teardrop holes, barrels on the inside face. Printed vanes at `hinge_clr = 0.4` swung through the full range but were too loose (2026-09-10); Armen's own tolerance tests say 0.15 (2026-09-11) -> `hinge_clr = 0.15`. **Confirmed 2026-09-11 on a full vane printed at 45° with the pins near vertical: "perfect, almost feels oiled".** (Coupon round 1 called 0.25 stuck, but that was printed flat with horizontal pins; the number depends on the pin being vertical.) `hinge_lift = 0.6` keeps the barrel off the bar's top edge (a printed barrel has a flat where it met the bed).
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
- Fork darts: too fragile for support removal at `tooth_r = 2.25`. Options on the table: fatter pod (r 2.6 gives 1.5 mm prongs), shorter dart, a teardrop section that prints self-supporting standing up, or a sacrificial bridge across the prong tips. **Or the saddle variant above (`ny_mount = "saddle"`), which has no thin features on the vane at all.**
- Coupon round 3 not yet printed: hinge 0.15 / 0.20 / 0.25, slat holes, fork teeth 0.10 / 0.15 / 0.20, ear-in-pocket fit (0.10 / 0.20 / 0.30), keyhole click, bullet-rooted pins.
- Fallback if the keyhole/pins still misbehave: a separate reinforced peg that tabs into a slot in the plate.
- Mounting tab: settled by two coupon rounds on 2026-09-10 (olive green). Round 1 grip 0.8 best but a tad tight, 0.5 loose -> `tab_grip = 0.7`. Round 2 stem width: +0.15 and +0.3 both good, +0.3 a tad much -> `tab_stem_extra = 0.2`. Not yet tested on a full shroud print.
- Fans and the spin box are out of scope so far. The strut is removable, so a fan on its hub goes in from the base side
  whatever the vane mount; in the fused variant the bars start about 20 mm up the bore and cannot move, so a fan's blade
  tips and downstream edge must stay below that with the strut seated (a `check.scad` pair once the fan is sketched).
- Fused variant (2026-09-12): unprinted. See its section above for what to watch.

## Gotchas learned
- This OpenSCAD nightly renders a small-angle `rotate_extrude` as a single chord; `arc_sweep()` hulls per-degree slabs instead.
- Bun.serve drops idle connections after 10 s: the viewer server sets `idleTimeout: 0` and heartbeats.
