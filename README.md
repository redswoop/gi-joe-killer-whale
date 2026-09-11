# Killer W.H.A.L.E. front landing hatch (bow ramp) with replacement hinge

State as of 2026-09-11. Parametric skeleton in place (arc plate + hinge eyes + bay mock); every plate number except the width is a photo estimate. Waiting on calipers/tracing of the real plate and close-ups of the hull's hinge points.

## What the part is
The bow ramp of the 1984 Killer W.H.A.L.E. (part "landing ramp" / "sled launch ramp door"). A large curved plate
that closes the bow opening, hinged along its bottom edge, folding forward and down to lie as a ramp
(treaded face inside). Armen's example: the plate survives, the hinges are completely broken off, so the
plate gets remodelled to the same curve with a new hinge that mounts to the existing hull.

## Reference material found (2026-09-11)
- `../../WHALE/measurements.md`: ramp width 93.3 mm. That is the only ramp number on disk.
- `../../GI Joe/GI Joe Killer WHALE Landing Ramp Hinge Replacements - 4094032.zip` (Cryoguns, Thingiverse
  thing:4094032, CC BY-NC): a pair of glue-on hinge brackets for this exact ramp. Summary: "One of the worst
  [breakages] was breaking the front landing ramp hinge pins"; cut the original hinge remnants out with a
  razor saw and glue these in. Bracket 21.4 x 8.1 x 11.1 mm, two uprights with a **3.10 mm pin hole**,
  axis 4.55 mm above the bracket's base, plus a triangular gusset. Renders in `renders/` once render.sh runs.
- Not the ramp: `../../WHALE/Whale Hatch.3mf` (55 x 72 x 6.2 mm) is the small TOP hatch, and thing:6660330
  "Hatch Hinge" is that top hatch's pin.
- No photos of the ramp or the bow exist on disk.

## Files
| File | What |
|---|---|
| `whale_hatch.scad` | The model (template body so far). |
| `viewer.json` | Part list for the browser viewer (`../viewer`, `SCAD_PROJECT=../whale_hatch bun run dev`, http://127.0.0.1:5180/). |
| `print_layout.scad` | `-D part="..."`: each part in its printing pose. |
| `check.scad` | Collision pairs; `../tools/check.sh check.scad 'pose=..'`. Empty = clear. |
| `coupon.scad` | Tolerance test print. |
| `export.sh` / `render.sh` | STLs into `stl/`, PNGs into `renders/`. |

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

## Needed from Armen before modelling
1. Photos: hatch outside face, inside face, and edge-on along the hinge axis (shows the curve); the bow
   opening with the hatch off, and close-ups of whatever hinge remnants are on the hull.
2. Calipers on the hatch: width, height (hinge edge to top edge), plate thickness, and the curve as
   chord + sagitta (lay it convex-up on a flat table: gap under the middle, and at the quarter points
   to tell one arc from a compound curve). Which way does it curve: around a vertical axis (bow is
   round in plan) or around the hinge axis, or both?
3. Hull side: distance between the two hinge points, what is left of them (stubs, holes, a slot), how far
   the hinge axis sits from the hull face, and whether the original pins were on the hatch or the hull.
4. Behaviour: open angle when lowered (flat on the ground?), and how the top edge latches closed
   ("UNLATCH" tabs on the deck).

## Open items
- Everything above. Coupon not yet printed.
