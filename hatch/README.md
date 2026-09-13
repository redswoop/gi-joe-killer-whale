# Killer W.H.A.L.E. front landing hatch (bow ramp) with replacement hinge

State as of 2026-09-13 (evening). Three printed parts: the arched tray (`hatch`) with a dovetail socket under its front edge, a flat front plate (`front`) that slides into it along X and carries the hinge pins out of its side edges, and two brackets (`mount`) with pin holes that glue to the fenders. Coupon for the dovetail and pin fits is ready and unprinted. Pin position and bracket size are estimates.

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
- `ref/`: Armen's pencil tracing of the fender edge (`profile_tracing.jpeg`: 28 / 24 / 10 above the paper edge at
  0 / 50 / 90), his five hull photos (`hull_photo_*.jpeg`) and the eBay photos of the real ramp (`ebay_*`).
  Recovered from the 2026-09-11 session transcript on 2026-09-12.

## Files
| File | What |
|---|---|
| `whale_hatch.scad` | The model: `hatch()`, `front()`, `mounts()`, `bay_mock()`. |
| `viewer.json` | Part list for the browser viewer (`../../viewer`, `bun run dev`, open http://127.0.0.1:5180/whale/hatch/). |
| `print_layout.scad` | `-D part="..."`: each part in its printing pose. |
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
  The steep end is the hinge (front lip), the flat end sits at the cabin.
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
- Cabin end: square edge with 45 deg corner cuts in plan bringing the edge to `top_edge_w 68.85`, the wide
  end of the top-hatch opening. A ledge (`lip_drop 2.7` below the outer surface, `lip_t 1.5`, `lip_len 5`)
  tucks under Armen's 2.5 top hatch; it is the step visible on the inside of the real part. The plate
  scales to ~97 long on the photo vs the 90 traced lip-to-cabin, which is that ledge.
- Four small latch hooks on the side edges (two per side, ~14 % and ~48 % of the length from the cabin end),
  engaging the notched rails on the fenders. Not modelled yet.
- Outer face: two perforated vent grilles near the cabin end, seven ribbed panels, "PANEL REMOVAL" /
  "UNLATCH" / "RAMP ACCESS" labels. Cosmetic, not modelled yet.

## Hinge end (Armen 2026-09-13): the front is its own part, dovetailed to the plate
Armen: "the entire front and hinge assembly should dovetail to the top ... then the front we can iterate on.
The front should be flat, with the joints coming out the sides", plus a mount for the pins that sits outside
the front and fixes inside the hull.

- **Socket** (`hatch`): a block under the plate's front edge, `sock_d 5.15` deep, from the outer surface down
  `sock_h 4.5` (= skin + rim, so the seam is level with the rim's underside). A dovetail groove runs the full
  width, open at both ends, mouth on the seam face. The block's front face is the top 4.5 of the vertical
  front drop. It is clipped against the outer arc only (`band_2d` would cut it along the slanted radial
  line at the plate's front corner and shave the groove's lip off; that bug is fixed).
- **Front** (`front`): a flat plate `front_t 3.5` thick, `hatch_w` wide, from the seam down to
  `pin_edge 2.5` below the pin axis (11 tall). Its top edge carries the rail: `rail_h 1.2` up, `rail_neck 1.2`
  thick where it leaves the plate, widening by `rail_taper 1.0` toward the OUTER face. One-sided dovetail: the
  inner face is flat so the front prints on that face with no overhang and the taper is a top-side slope.
  Pins `hinge_pin_d 2.6` x `pin_len 3.5` straight out of the side edges, axis `pin_y` = 2.2 aft of the outer
  face (so they lie on the bed) and `pin_below_lip 3` below the lip level (PHOTO ESTIMATE; the hull decides).
  `rail_2d(g)` gives the profile, grown by `g` for the groove (`slide_clr 0.15` per face, coupon).
- **Mounts** (`mounts`, print `mount.stl` twice): a `mount_len 14` x `mount_h 10` x `mount_t 3.0` plate with a
  `hinge_pin_d + pin_clr 0.4` hole `mount_hole_back 5` from its front edge and `mount_hole_up 4` above its
  bottom, corners `mount_r 1.5`. `mount_t` is the fender gap ((100.5 - 93.3) / 2 = 3.6) minus a hair, so the
  3.5 pin passes through; `mount_clr 0.2` off the front's side edge. Glue face = the outer face.
- **Assembly**: slide the front into the socket from one side (the brackets stop it sliding back out), put a
  bracket on each pin, set the hatch closed and flush in the bay, glue the brackets to the fenders' inner
  faces with the hatch as the jig. No hull holes needed; the pins never touch the hull.
- The angled skirt and the tilted slide bar from earlier on 2026-09-13 are gone (git history has them). The
  front plate is the place to bring an overhang back if the hull wants it.
- `check.scad`: `hatch-front`, `front-mounts`, `hatch-mounts` all clear at 0 and 115 deg.

## Print next (as of 2026-09-13)
1. `stl/coupon.stl` first: three 20 mm socket slices (groove at 0.1 / 0.15 / 0.25 per face, standing so the
   slot is vertical like the real hatch) + one 20 mm rail slice printed on its inner face; three pin holes
   (+0.3 / 0.4 / 0.5) + a pin stub. Report which slide is snug-but-moving and which hole turns freely;
   write back `slide_clr` and `pin_clr`.
2. `stl/hatch.stl` ON ITS SIDE: the +X side face on the bed, footprint 22.8 x 94.8, 93.3 tall. Brim. Arc,
   front face and groove are traced in every layer.
3. `stl/front.stl` flat on its inner face, 100.3 x 12.2 x 3.5, pins lying on the bed.
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
- Everything above. Coupon not yet printed.
- Hull side: how far below the lip the axis must sit for the front plate to swing clear of the lip's front
  face (`pin_below_lip`), and whether the bracket's 14 x 10 footprint has a flat fender face to glue to at
  that spot. No lip in `bay_mock` yet.
- The front plate is flat; the real part's angled skirt / overhang could return as a feature of `front`.
- Trace the fender edge properly: `k` (points tool) along the pencil line on overlay `o1`, Enter, then
  `../../tools/notes whale/hatch points <id> --scad fender_pts --2d` gives a `[y, z]` list. The single circle
  (`hatch_sag`) sits a little low mid-span and a little high at the hinge; a polyline or two-arc profile through the
  traced points would replace it.
