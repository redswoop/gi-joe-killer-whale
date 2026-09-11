# Killer W.H.A.L.E. fan shroud + steering vanes (OpenSCAD)

State as of 2026-09-11 (evening). Parametric port of Armen's Shapr3D shroud, plus a new print-in-place
vane mechanism reconstructed from photos of the real MET-b52 parts.

## Files
| File | What |
|---|---|
| `shroud.scad` | The whole model. Parameters at the top, one section per Shapr3D operation, then the vane mechanism. |
| `viewer.json` | Part list for the browser viewer (`../viewer`, `bun run dev`, open http://127.0.0.1:5180/). |
| `print_layout.scad` | `-D part="..."`: each part laid flat/upright in its printing pose. |
| `hinge_coupon.scad` | Tolerance test print: hinge x3, slat axle holes x3, keyhole eyes x3, strut pockets x3 + one ear, fork teeth x3 + a piece of rim. |
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
3. **Vanes** (`vane_right.stl`, `vane_left.stl`, outer face down, no supports, brim). Print-in-place hinge: free each plate by working it back and forth. The fork teeth push down over the rim: the key drops into the notch, the prongs straddle the wall, the nub clicks.
4. **Slats** (`slat.stl` x2, flat). Spring the 59 mm rods into the holes in the two bars before the vanes go into the shroud. The plate now nearly spans the bars (0.3 mm end gaps), so they stay put sideways.
5. **Tie bar** (`tie_bar.stl`, knurl up). Bulbs go through the big keyholes, slide the bar aft, pins click into the working holes.

Print the **coupon** first and put the winning numbers into `hinge_clr`, `slat_clr`, `tooth_clr`, `tie_eye_clr`, `ear_clr`.

## Print next (as of 2026-09-11 evening)
1. `stl/hinge_coupon.stl` (89 x 109 mm): hinge 0.15 / 0.20 / 0.25, slat holes 0.10 / 0.15 / 0.20, fork teeth 0.10 / 0.15 / 0.20 on a piece of rim, strut ear pockets 0.10 / 0.20 / 0.30, keyhole eyes, bullet pins.
2. `stl/shroud.stl`: settled tab, strut pockets, and the new shallow (3 mm) key notches.
3. `stl/strut.stl` (ears in pockets, standing on an ear, brim) once the pocket clearance is known.
4. Vanes and slats once the coupon confirms `hinge_clr`, `tooth_clr` and `slat_clr`.

## Design notes
- Hinge: two 13 mm nubs per vane at y = -34 / 36 (over the teeth), barrel 4.2, round pin 1.4, teardrop holes, barrels on the inside face. Printed vanes at `hinge_clr = 0.4` swung through the full range but were too loose (2026-09-10); Armen's own tolerance tests say 0.15 (2026-09-11) -> `hinge_clr = 0.15`, coupon ladders 0.15 / 0.20 / 0.25. Note coupon round 1 called 0.25 stuck, so 0.15 may need freeing with more force. `hinge_lift = 0.6` keeps the barrel off the bar's top edge (a printed barrel has a flat where it met the bed).
- **Fork teeth** (2026-09-11, replacing the drop-in pegs, which sat loose and rocked): each tooth is a 9 mm wide block in the bar's plane with a slot that is the duct wall's own annulus offset `tooth_clr`. The key in the middle drops `tooth_key = 3` into a notch in the rim (locates along the rim, Z stop); the two prongs run `tooth_prong = 7` below the rim top on both faces of the wall and grip it. The slot follows the curve, so the fit is tight even though the bar crosses the ring at ~50°. Slot mouth chamfered 0.6. The click nub moved to the key's inside face at the wall's mid-radius. Renders: `renders/fork_tooth.png`, `renders/fork_tooth_sec.png`. The outer prongs are visible on the shroud's outside between deco boxes, clear of them by ~2°.
- Slats: `slat_clr = 0.15` (0.2 printed loose), and the plate spans the bars less `slat_end_gap = 0.3` per side (54.4 at the rod) instead of the 52 mm photo estimate, so a slat cannot shuffle sideways.
- Linkage is a four-bar, solved in `solve_left()`; ~0.8° asymmetry at 30°.
- The tie bar is the hat-shaped `_/----\_` original with a knurled middle.
- Strut mount v4 (2026-09-10): **ears in pockets**. The bar's ends turn up into 2 mm curved ears hugging the bore wall, half the shroud's height (`ear_top = 9.5`). A boss on the wall at each end (13.7 wide, 3.4 proud, 11.2 tall, fading into the wall with 3 mm concave fillets on its sides and top: `boss_fade`, built with the `offset(r = -f) offset(r = f)` trick) holds a pocket open at the base and blind at the top, with a notch through its inner lip for the plate. Insert from the base side. `ear_clr = 0.2` per face, untested. Bar plane back at z = 0 as in the Shapr3D original. Earlier ideas in git history: v3 twist lock (be6d171), dovetail slides (9d956e5).
- Slats never reach the hinge line thanks to their taper; the plates first touch a slat at 40° steer.
- `print_face = "inner"` flips the vane to print barrels-down with support PLA, putting the ribbed panels on top.

## Open items
- All plate/slat/pin dimensions are photo estimates scaled off the 92 mm bar; calipers on the real parts would firm them up.
- Coupon round 3 not yet printed: hinge 0.15 / 0.20 / 0.25, slat holes, fork teeth 0.10 / 0.15 / 0.20, ear-in-pocket fit (0.10 / 0.20 / 0.30), keyhole click, bullet-rooted pins.
- Fallback if the keyhole/pins still misbehave: a separate reinforced peg that tabs into a slot in the plate.
- Mounting tab: settled by two coupon rounds on 2026-09-10 (olive green). Round 1 grip 0.8 best but a tad tight, 0.5 loose -> `tab_grip = 0.7`. Round 2 stem width: +0.15 and +0.3 both good, +0.3 a tad much -> `tab_stem_extra = 0.2`. Not yet tested on a full shroud print.
- Fans and the spin box are out of scope so far.

## Gotchas learned
- This OpenSCAD nightly renders a small-angle `rotate_extrude` as a single chord; `arc_sweep()` hulls per-degree slabs instead.
- Bun.serve drops idle connections after 10 s: the viewer server sets `idleTimeout: 0` and heartbeats.
