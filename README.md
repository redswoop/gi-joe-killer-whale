# Killer W.H.A.L.E. fan shroud + steering vanes (OpenSCAD)

State as of 2026-09-10. Parametric port of Armen's Shapr3D shroud, plus a new print-in-place
vane mechanism reconstructed from photos of the real MET-b52 parts.

## Files
| File | What |
|---|---|
| `shroud.scad` | The whole model. Parameters at the top, one section per Shapr3D operation, then the vane mechanism. |
| `viewer.json` | Part list for the browser viewer (`../viewer`, `bun run dev`, open http://127.0.0.1:5180/). |
| `print_layout.scad` | `-D part="..."`: each part laid flat/upright in its printing pose. |
| `hinge_coupon.scad` | Tolerance test print: hinge x3, tooth notches x3, keyhole eyes x3, strut pockets x3 + one ear. |
| `tab_coupon.scad` | Tab fit test print: four 108° arcs of the shroud (30 % of the ring, centred on the tab, `keep = 0.3`) with the L tab at `grips = [0.2, 0.5, 0.8, 1.1]`, labelled `g0.2` etc. on a tag. |
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
3. **Vanes** (`vane_right.stl`, `vane_left.stl`, outer face down, no supports, brim). Print-in-place hinge: free each plate by working it back and forth. Teeth click down into the rim notches.
4. **Slats** (`slat.stl` x2, flat). Spring the 59 mm rods into the holes in the two bars before the vanes go into the shroud.
5. **Tie bar** (`tie_bar.stl`, knurl up). Bulbs go through the big keyholes, slide the bar aft, pins click into the working holes.

Print the **coupon** first and put the winning numbers into `hinge_clr`, `peg_clr`, `tie_eye_clr`.

## Design notes
- Hinge: two 13 mm nubs per vane at y = -34 / 36 (over the teeth), barrel 4.2, round pin 1.4, teardrop holes, barrels on the inside face. `hinge_lift = 0.6` keeps the barrel off the bar's top edge (a printed barrel has a flat where it met the bed).
- Linkage is a four-bar, solved in `solve_left()`; ~0.8° asymmetry at 30°.
- The tie bar is the hat-shaped `_/----\_` original with a knurled middle.
- Strut mount v4 (2026-09-10): **ears in pockets**. The bar's ends turn up into 2 mm curved ears hugging the bore wall, half the shroud's height (`ear_top = 9.5`). A boss on the wall at each end (13.7 wide, 3.4 proud, 11.2 tall, fading into the wall with 3 mm concave fillets on its sides and top: `boss_fade`, built with the `offset(r = -f) offset(r = f)` trick) holds a pocket open at the base and blind at the top, with a notch through its inner lip for the plate. Insert from the base side. `ear_clr = 0.2` per face, untested. Bar plane back at z = 0 as in the Shapr3D original. Earlier ideas in git history: v3 twist lock (be6d171), dovetail slides (9d956e5).
- Slats never reach the hinge line thanks to their taper; the plates first touch a slat at 40° steer.
- `print_face = "inner"` flips the vane to print barrels-down with support PLA, putting the ribbed panels on top.

## Open items
- All plate/slat/pin dimensions are photo estimates scaled off the 92 mm bar; calipers on the real parts would firm them up.
- Coupon round 3 not yet printed: ear-in-pocket fit (0.10 / 0.20 / 0.30), keyhole click, bullet-rooted pins.
- Fallback if the keyhole/pins still misbehave: a separate reinforced peg that tabs into a slot in the plate.
- Mounting tab: as sketched the shroud rocked and slid off the Whale (slot 2.44 between wall and hook foot). `tab_grip` shortens the stem and narrows the slot. **Print `stl/tab_coupon.stl` next**: four 108° arcs at grip 0.2 / 0.5 / 0.8 / 1.1 (slot 2.24 / 1.94 / 1.64 / 1.34). Put the winner into `tab_grip`. If none holds, the next knobs are the foot length (`tab_pts[2][0]`) and tab height (`tab_h`), or a second tab.
- Fans and the spin box are out of scope so far.

## Gotchas learned
- This OpenSCAD nightly renders a small-angle `rotate_extrude` as a single chord; `arc_sweep()` hulls per-degree slabs instead.
- Bun.serve drops idle connections after 10 s: the viewer server sets `idleTimeout: 0` and heartbeats.
