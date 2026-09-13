# Killer W.H.A.L.E. front landing hatch (bow ramp) with replacement hinge

State as of 2026-09-11. Tray + hinge modelled from eBay photos of the real part (M-3798-4): 1.5 skin, 3 mm rim, hinge bar with ears and 2.6 pins. First print is a fit check; all hinge and rim numbers are photo estimates.

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
| `whale_hatch.scad` | The model (template body so far). |
| `viewer.json` | Part list for the browser viewer (`../../viewer`, `bun run dev`, open http://127.0.0.1:5180/whale/hatch/). |
| `print_layout.scad` | `-D part="..."`: each part in its printing pose. |
| `check.scad` | Collision pairs; `../../tools/check.sh check.scad 'pose=..'`. Empty = clear. |
| `coupon.scad` | Tolerance test print. |
| `export.sh` / `render.sh` | STLs into `stl/`, PNGs into `renders/`. |
| `ref/` | The tracing, hull photos and eBay photos; captions and the tracing's pixel scale in `ref/index.json`. Shown in the viewer's gallery. |
| `annotations.json` | Viewer notes and the overlay placement. `../../tools/notes whale/hatch` lists them. |

## Coordinate frame
Hinge axis = X at the origin, +Y aft toward the cabin, +Z up. The plate is modelled closed: hinge edge at
y = 0, top edge at (hatch_len, hatch_rise), arching hatch_sag above that chord. `open_deg` swings it down
over the nose.

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

## Hinge end (Armen 2026-09-11, after the first print): a flange, and a slide-on bar on its free edge
- The bow end of the plate bends ~90 deg into the hull: `flange_len 5`, `flange_t 1.5` (`flange_deg 90`).
  The pins sit at the bottom of that flange, so the hinge axis is ~6 below the outer surface at the bow.
  (This is the "bar" seen edge-on in the eBay photos.) The flange also closes the tray's hinge end.
- The hatch prints on its side for smoothness, so the pins live on a separate flat print: the flange's free
  edge carries a dovetail tongue on its cabin-side face (`tongue_t 3.0` at the edge tapering to 1.5 over
  `tongue_len 2.5`); the bar is a channel with the matching slot (`slide_clr 0.15` per face, coupon), an
  outer lip (`bar_out 0.6` over `bar_lip_len 2.5`) so it cannot lift inward, an inner wall `bar_reach 3.0`
  up the flange, ear lobes `ear_r 3.5` and pins `hinge_pin_d 2.6` x `pin_len 3.5` at `pin_drop 1.5` /
  `pin_back -0.85`. It slides on along X; the fender holes then lock it. Rigid, no snap (shroud lesson).
- The side rims stop `max(bar_in, pin_drop + ear_r) - flange_t + clr` (3.65) short of the flange so the
  channel and lobes seat. `check.scad` pair `hatch-bar` is clear.

## Print next (as of 2026-09-11)
- `stl/hatch.stl` ON ITS SIDE: the +X side face is a flat plane on the bed, footprint an arc 4.5 wide x 95
  long, 93.3 tall. Brim. The arc is traced in every layer, so the outer face is a true vertical wall.
- `stl/bar.stl` flat on its back, slot up, pins lying on the bed (`pin_back -0.85` puts their underside at
  z = 0). 100.3 long, 5.15 tall.
- Fit checks: curve flush with the fender edges; bar slides on and pins reach the fender holes; cabin end
  under the lip (`plate_extra`, `lip_len` if it hits); width between the rails.

## Tracing overlay (2026-09-12)
`profile_tracing.jpeg` is placed in the viewer as overlay `o1`: plane YZ (the plate runs along +Y, Z up), calibrated
on the 50 and 90 mm ticks (0.0613 mm/px), flipped horizontally so the hinge end is at y = 0, origin at the curve's
hinge end (px 1438, 1257). Side view + Ortho shows the pencil line over the model's edge; they agree to within the
pencil width on a first look. The 0 mm tick is just off the left of the photo, so the cabin end of the curve is not
in frame.

## Open items
- Everything above. Coupon not yet printed.
- Trace the fender edge properly: `k` (points tool) along the pencil line on overlay `o1`, Enter, then
  `../../tools/notes whale/hatch points <id> --scad fender_pts --2d` gives a `[y, z]` list. The single circle
  (`hatch_sag`) sits a little low mid-span and a little high at the hinge; a polyline or two-arc profile through the
  traced points would replace it.
