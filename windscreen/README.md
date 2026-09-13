# WHALE cockpit windscreen: three flat clear panels + base

State as of 2026-09-13. A low, tapered, squared-off C of clear PETG sheet (three separate 1 mm
panels, 0.6 nozzle) held at the right angles by an opaque PLA base (0.4 nozzle) with three
5 x 5 x 2 tabs that plug into the deck. Nothing printed yet.

## Files
| File | What |
|---|---|
| `windscreen.scad` | The model. Panels defined by 3D corner points; the flat outline and the placement both derive from them. |
| `viewer.json` | Part list for the browser viewer (`../../viewer`, `bun run dev`, http://127.0.0.1:5180/whale/windscreen/). |
| `print_layout.scad` | `-D part="back|side_l|side_r|strip|base"`: each part in its printing pose. |
| `check.scad` | Collision pairs; `../../tools/check.sh whale/windscreen/check.scad 'height=10'`. Empty = clear. |
| `coupon.scad` | Groove clearance coupon (0.10 / 0.15 / 0.25 per side) + `strip` sheet sample. |
| `export.sh` / `render.sh` | STLs into `stl/`, PNGs into `renders/`. |
| `ref/` | Nothing yet. |

## Coordinate frame
Z up, base sits on z = 0, tabs hang below. The back (60 mm) panel stands near x = 0, the C opens
toward +X, Y symmetric. Panel bottom edges sit at z = `base_floor` (1).

## Dimensions (outside, from Armen 2026-09-13)
| | base end | top edge |
|---|---|---|
| back panel width | 60 | 65 |
| side panel length (from the back's outer face) | 40 | 44 |
| height (vertical) | 10 | |

A V from the front: the sides lean outward (2.5 mm each over the height, 14 deg). From the side
it is \____| : the side's free edge is square in the flat sheet, so the back leans away from the
opening by 44 - 40 = 4 mm, 21.8 deg. Both angles are derived from the corner points, not typed.

Flat sheets as printed: back is an isosceles trapezoid 60 / 65 x 10.77 tall; each side is a
right trapezoid 38.9 / 42.9 x 10.31 with the angled edge at the corner (trimmed ~1.08 so it butts
on the back panel's inner face). The two sides are the same piece flipped over.

## Parts and how they go together
1. Base (PLA, printed upside down, tabs up): a 5 mm wide, 3 mm tall C rail with tilted 1.3 mm
   grooves 2 mm deep. Tabs: one dead centre under the back rail, one under each side rail with
   a 5 mm gap between the panel's free edge and the tab.
2. Drop the back panel in its groove, then each side; the side sheets butt against the inside
   face of the back. Glue if the groove fit is loose.
3. Tabs into the deck slots.

## Open items
- Coupon unprinted: `stl/coupon.stl` (PLA) + `stl/strip.stl` (PETG). Pick the groove clearance,
  `../../tools/scadset windscreen.scad groove_clr=...`, re-export.
- Tab size/spacing is from Armen's description, not measured against the deck slots. Check
  against the toy before printing the base.
- Rail ends are rounded (stroke_2d); square them off if that looks wrong on the deck.
- Corner joint is a butt joint: the side sheet ends on the back's inner face. No mitre.

## Gotchas learned
- A tilted sheet extruded along its own normal leans a fraction into the neighbouring panel
  (0.013 mm here); `side_trim()` accounts for it so the checks are clean.
- `side_r`'s panel frame has v pointing -Y (right-handed frame with an inward normal), so its
  flat outline comes out mirrored; `print_layout.scad` mirrors it back.
