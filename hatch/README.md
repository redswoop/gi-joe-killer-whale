# Killer W.H.A.L.E. front landing hatch (bow ramp) with replacement hinge

State as of 2026-09-13 (night). Dovetail + pin coupon printed: pins settled (`pin_clr 0.3`, now `fit_pin_clr()` in lib/fit.scad), dovetail far too loose at every clearance, so the rail is doubled (2.5 tall, 1.8 neck, 1.2 taper, front plate 4.0, socket 5.5) and round 2 of the coupon tests -0.1 / 0 / 0.1. Two corner coupons printed. Round 1 showed the plate short by the corner cuts' run, fixed (`end_y = hatch_len + plate_extra + top_cut_y`); round 2 (25 wide, lengthened) fits: angle, tab reach and length all confirmed on the hull. Plan outline fixed: the cabin-end corner cuts are now real 30 deg cuts (the old polygon produced an 11 deg sliver) and the plate is rabbeted thinner along them to sit on the hull's corner tabs. Three printed parts: the arched tray (`hatch`) with a dovetail socket under its front edge, a flat front plate (`front`) that slides into it along X and carries the hinge pins out of its side edges, and two brackets (`mount`) with pin holes that glue to the fenders. Pin position and bracket size are estimates.

## What the part is
The bow ramp of the 1984 Killer W.H.A.L.E. (part "landing ramp" / "sled launch ramp door"). A large curved plate
that closes the bow opening, hinged along its bottom edge, folding forward and down to lie as a ramp
(treaded face inside). Armen's example is missing the hatch entirely (2026-09-11), so the plate is designed from the hull:
its side-edge profile is traced off the fenders' inner top edges, which the closed ramp sits flush with.

## Reference material found (2026-09-11)
- `../../../WHALE/measurements.md`: ramp width 93.3 mm. That is the only ramp number on disk.
- `../../../GI Joe/GI Joe Killer WHALE Landing Ramp Hinge Replacements - 4094032.zip` (Cryoguns, Thingiverse
  thing:4094032, CC BY-NC): a pair of glue-on hinge brackets for this exact ramp. Summary: "One of the worst
  [breakages] was breaking the front landing ramp hinge pins"; cut the original hinge remnants out with a
  razor saw and glue these in. Bracket 21.4 x 8.1 x 11.1 mm, two uprights with a **3.10 mm pin hole**,
  axis 4.55 mm above the bracket's base, plus a triangular gusset. Renders in `renders/` once render.sh runs.
- Not the ramp: `../../../WHALE/Whale Hatch.3mf` (55 x 72 x 6.2 mm) is the small TOP hatch, and thing:6660330
  "Hatch Hinge" is that top hatch's pin.
- `ref/web_front_*.jpeg` (2026-09-13, from yojoe.com and a blog): the bow with the ramp closed (iso and
  straight on) and lowered flat. They show the hinge end the eBay photos could not: the ramp's front face is a
  band that hangs BELOW the fenders' front faces (about as tall again as the 10 mm fender drop, "RAMP ACCESS"
  label on it), flanked by the black nose's rounded top corners, and a round black boss on the nose at each
  end of that band is the hull-side hinge: the ramp's pins go into those bosses. Lowered, the ramp pivots at
  the top of the nose and lies flat on the table. So `pin_below_lip 3` is probably far too small and the
  hull-side hinge points are on the black lower hull, not the green fenders.
- `ref/`: Armen's pencil tracing of the fender edge (`profile_tracing.jpeg`: 28 / 24 / 10 above the paper edge at
  0 / 50 / 90), his five hull photos (`hull_photo_*.jpeg`) and the eBay photos of the real ramp (`ebay_*`).
  Recovered from the 2026-09-11 session transcript on 2026-09-12.

## Files
| File | What |
|---|---|
| `whale_hatch.scad` | The model: `hatch()`, `front()`, `mounts()`, `bay_mock()`. |
| `viewer.json` | Part list for the browser viewer (`../../viewer`, `bun run dev`, open http://127.0.0.1:5180/whale/hatch/). |
| `print_layout.scad` | `-D part="..."`: each part in its printing pose; `corner` is the cabin-end fit coupon. |
| `check.scad` | Collision pairs; `../../tools/check.sh check.scad 'pose=..'`. Empty = clear. |
| `coupon.scad` | Tolerance test print. |
| `export.sh` / `render.sh` | STLs into `stl/`, PNGs into `renders/`. |
| `ref/` | The tracing, hull photos and eBay photos; captions and the tracing's pixel scale in `ref/index.json`. Shown in the viewer's gallery. |
| `annotations.json` | Viewer notes and the overlay placement. `../../tools/notes whale/hatch` lists them. |

## Coordinate frame
Hinge axis = X at the origin, +Y aft toward the cabin, +Z up. The plate is modelled closed, in a "plate frame"
whose origin is the outer surface's front corner (top of the front face); the arc runs to (hatch_len, hatch_rise)
arching hatch_sag above that chord. `hatch_shift` (computed) moves the plate so the pin axis lands on X; the
console echoes where the axis sits relative to the front face and the lip level. `open_deg` swings it down over the nose.

## What the 2026-09-11 photos showed (Armen's hull, ruler in cm)
- The bay is an open-topped box between two fenders, cabin at the back, black treaded floor. The closed ramp
  is a shallow arched lid over it, flush with the fenders' curved top edges, hinged at the front lip;
  lowered, it folds forward over the nose to the ground.
- Bay width at the cabin end ~100.5 (ruler across); lip to the fender corner at the cabin ~102 (ruler along).
  Ramp width 93.3 (measurements.md) leaves ~3.5 per side for the side rails / channel seen along the floor edges.
- The round "nub" at each front fender corner is a fender rivet: the same ring-and-stub repeats all over both
  fenders. Not a hinge remnant. The hull-side hinge points are still unidentified.
- Left side of the bay has a black channel with slots along the floor edge; right side a rail with three
  rectangular notches. Purpose unknown (sled guide? ramp latch?).

## Settled 2026-09-11
- Profile: Armen traced the fender edge on paper: drops 0 / 4 / 18 below the baseline at 0 / 50 / 90 mm.
  Circle through those: R 180.7, chord 91.8, sagitta 5.9 -> `hatch_len 90, hatch_rise 18, hatch_sag 5.9`.
  The steep end is the hinge (front lip), the flat end sits at the cabin. The 90 runs from the lip to where
  the angled corner cuts BEGIN (first corner coupon, 2026-09-13); the cuts add `top_cut_y 7.1` beyond it,
  so the outer corner of the plate is at `end_y 97.1` (`plate_extra` adds to that if the print says so).
- Thickness 1.5 (`hatch_t`), "same as the rest of the shell". A 93 x 92 plate at 1.5 will flex; ribs on the
  inside face (the original had tread there) are the fix if it does.

## Needed from Armen
1. Hull side: the pin holes in the fenders' inner faces at the front lip: diameter, height above the floor,
   distance behind the lip. These set `pin_drop`, `pin_back` and `hinge_pin_d`.
2. After the first print: where it stands proud or falls short, and by how much.

## What the real part looks like (eBay photos, 2026-09-11)
- A shallow tray: the plate with a ~3 mm rim on the inside along both sides and the cabin end. A separate
  black treaded "liner" (two tread strips, side clips) snaps into the tray. Mold number M-3798-4.
- Hinge: a round bar across the whole hinge edge on the inside, lobed ears at both ends, short pins (~2.6 dia,
  ~3.5-4.5 long) pointing outward into holes in the fenders. Width 93.3 + 2 x 3.5 pins = 100.3, which matches
  the ~100.5 measured between the fenders.
- Cabin end: square edge with angled corner cuts in plan bringing the edge to `top_edge_w 68.85`, the wide
  end of the top-hatch opening. Armen 2026-09-13: the cut is "like a 30 deg cut" measured from the cabin end
  edge (`top_cut_deg 30`), so each cut comes in `top_cut_x 12.2` and runs only `top_cut_y 7.1` along the side.
  The plate is thinner along those two edges, from the inside, because the hull has tabs there that the
  hatch rests on: `tab_w 4` reach (corner coupon round 1: angle and reach "look perfect"), `tab_edge_t 1.0`
  left (still an estimate). The rabbet stops at the top-hatch
  opening (|x| = top_edge_w / 2) so the cabin ledge keeps its corners; the side rims and the cabin-end rim
  end where the rabbet begins. Verified by probing the export: 1.0 thick within 4 mm of the angled edge,
  1.5 beyond. A ledge (`lip_drop 2.7` below the outer surface, `lip_t 1.5`, `lip_len 5`)
  tucks under Armen's 2.5 top hatch; it is the step visible on the inside of the real part. The plate
  scales to ~97 long on the photo vs the 90 traced lip-to-cabin: that is the corner cuts' run (97.1 now).
- Four small latch hooks on the side edges (two per side, ~14 % and ~48 % of the length from the cabin end),
  engaging the notched rails on the fenders. Not modelled yet.
- Outer face: two perforated vent grilles near the cabin end, seven ribbed panels, "PANEL REMOVAL" /
  "UNLATCH" / "RAMP ACCESS" labels. Cosmetic, not modelled yet.

## Hinge end (Armen 2026-09-13): the front is its own part, dovetailed to the plate
Armen: "the entire front and hinge assembly should dovetail to the top ... then the front we can iterate on.
The front should be flat, with the joints coming out the sides", plus a mount for the pins that sits outside
the front and fixes inside the hull.

- **Socket** (`hatch`): a block under the plate's front edge, `sock_d 5.5` deep, from the outer surface down
  `sock_h 5.5` (skin + rim + 1: the bigger rail needs the depth, so the block hangs 1 below the rim). A dovetail groove runs the full
  width, open at both ends, mouth on the seam face. The block's front face is the top 5.5 of the vertical
  front drop. It is clipped against the outer arc only (`band_2d` would cut it along the slanted radial
  line at the plate's front corner and shave the groove's lip off; that bug is fixed).
- **Front** (`front`): `hatch_w` wide, flat inner face, stepped outer face. Armen 2026-09-13: the real front
  is "2 x 10 mm sections: one flush with the top, then a 1 mm step, then another 10 mm drop where the hinges
  are", about 1.5-2 thick, and the step goes OUT. Here: the upper band (seam to lip level, with the socket
  block's face above it making up `front_h 10`) is `front_t 4.0` thick because the rail needs it; below the
  lip the face steps out `front_step 1` and the lower band (`front_band 10` tall) ends in a half-round of
  radius `flange_r 3.7` about the pin axis, tangent to its face. The inner face stays flat for printing, so
  that lower band is 5 thick, not 2; only its face and the step show. No point of the bottom is further
  than `flange_r` from the axis, so the swinging front clears the skirt. 14.5 tall + the 2.5 rail.
  Shelled from the inner face (Armen 2026-09-13): `front_skin 1.5` on the outer face, step, bottom round and
  under the rail, `front_end_wall 4` solid at each end around the pins, pocket open to the bed. Volume 3.7 cm3
  instead of 6.7. Its top edge carries the rail: `rail_h 2.5` up, `rail_neck 1.8`
  thick where it leaves the plate, widening by `rail_taper 1.2` toward the OUTER face. One-sided dovetail: the
  inner face is flat so the front prints on that face with no overhang and the taper is a top-side slope.
  Round 1 of the coupon (rail 1.2 / 1.2 / 1.0, plate 3.5, clearances 0.1 / 0.15 / 0.25 per face) was far too
  loose everywhere, so the rail doubled on 2026-09-13; `slide_clr` is 0 until round 2 says otherwise.
  Pins `hinge_pin_d 2.6` x `pin_len 3.5` straight out of the side edges, axis `pin_y` = 2.7 aft of the outer
  face (so they lie on the bed) and `pin_below_lip` = `front_band - flange_r` = 6.3 below the lip level.
  `rail_2d(g, ext)` gives the profile, grown by `g` for the groove (`slide_clr` per face; negative = interference).
- **Mounts** (`mounts`, print `mount.stl` twice): a `mount_len 14` x `mount_h 10` x `mount_t 3.0` plate with a
  `hinge_pin_d + pin_clr` hole (`pin_clr = fit_pin_clr()` = 0.3 on the diameter, coupon 2026-09-13: "perfect fit") `mount_hole_back 5` from its front edge and `mount_hole_up 4` above its
  bottom, corners `mount_r 1.5`. `mount_t` is the fender gap ((100.5 - 93.3) / 2 = 3.6) minus a hair, so the
  3.5 pin passes through; `mount_clr 0.2` off the front's side edge. Glue face = the outer face.
- **Assembly**: slide the front into the socket from one side (the brackets stop it sliding back out), put a
  bracket on each pin, set the hatch closed and flush in the bay, glue the brackets where the skirt's own
  hinge bosses were (the black round bosses on the skirt's top corners in the web photos; broken off on
  Armen's hull, 2026-09-13). The bracket's glue face and footprint must follow the broken stubs, so the
  14 x 10 x 3 plate is a placeholder until there is a photo of a stub with a ruler. No hull holes needed.
- The angled skirt and the tilted slide bar from earlier on 2026-09-13 are gone (git history has them). The
  front plate is the place to bring an overhang back if the hull wants it.
- `check.scad`: `hatch-front`, `front-mounts`, `hatch-mounts` all clear at 0 and 115 deg.

## Print next (as of 2026-09-13)
0. `stl/corner.stl`: the fit coupon for the cabin end (Armen 2026-09-13). The -X 25 mm of the tray at full
   length, standing on its cut face (101.7 x 22.8 footprint, 25 tall, brim). Round 1 (50 wide) showed the
   plate short by the cut's run; round 2 has the fix and Armen reports it "great angle and fit wise". Done. Checks the 30 deg corner cut,
   the rabbet on the hull tab, the cabin ledge under the top hatch, and the lip-to-cabin length.
   `corner_w` in `print_layout.scad` sets the width.
1. `stl/coupon.stl` ROUND 2: three 20 mm socket slices with the doubled rail's groove at -0.1 / 0 / 0.1 per
   face (standing, slot vertical like the real hatch) + one 20 mm rail slice printed on its inner face.
   Round 1 (small rail, 0.1 / 0.15 / 0.25) was far too loose at all three; the pins settled at +0.3.
   Report which slide is snug-but-moving; write back `slide_clr`.
2. `stl/hatch.stl` ON ITS SIDE: the +X side face on the bed, footprint 23.8 x 101.7, 93.3 tall. Brim. Arc,
   front face and groove are traced in every layer.
3. `stl/front.stl` flat on its inner face, 100.3 x 17.0 x 5.0, pins lying on the bed, the proud lower band on top,
   the pocket facing the bed (the skin bridges a 12 mm span; no support).
4. `stl/mount.stl` x2, flat, 14 x 10 x 3.
- Fit checks: curve flush with the fender edges and the front face flush with their 10 mm front drop; the
  front slides in and stays; brackets fit the fender gap (`mount_t`); the pin height that lets the ramp open
  over the lip (`pin_below_lip`); cabin end under the top hatch (`plate_extra`, `lip_len`); width between
  the rails.

## Tracing overlay (2026-09-12)
`profile_tracing.jpeg` is placed in the viewer as overlay `o1`: plane YZ (the plate runs along +Y, Z up), calibrated
on the 50 and 90 mm ticks (0.0613 mm/px), flipped horizontally so the hinge end is at y = 0, origin at the curve's
hinge end (px 1438, 1257). Side view + Ortho shows the pencil line over the model's edge; they agree to within the
pencil width on a first look. The 0 mm tick is just off the left of the photo, so the cabin end of the curve is not
in frame.

## Open items
- Dovetail clearance (`slide_clr`): coupon round 2 pending. Pins done.
- Cabin-end corners: angle (`top_cut_deg 30`), tab reach (`tab_w 4`) and the plate length (`end_y 97.1`)
  confirmed by the two corner coupons (2026-09-13). Not explicitly judged yet: the thickness over the tab
  (`tab_edge_t`, is the outer surface flush?) and the straight width between the tabs (`top_edge_w`); the
  full-width hatch print will show both.
  A flexible tape along the fender curve would settle the width numbers the ruler could not.
- Hull side: `front_band 10` and `front_step 1` are Armen's reading of the photos; the hull's own numbers
  (fender front bottom edge down to the boss's hole centre) would confirm. Bracket shape: photo of a broken
  boss stub with a ruler. No lip or skirt in `bay_mock` yet.
- Trace the fender edge properly: `k` (points tool) along the pencil line on overlay `o1`, Enter, then
  `../../tools/notes whale/hatch points <id> --scad fender_pts --2d` gives a `[y, z]` list. The single circle
  (`hatch_sag`) sits a little low mid-span and a little high at the hinge; a polyline or two-arc profile through the
  traced points would replace it.
