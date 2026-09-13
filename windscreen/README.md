# WHALE cockpit windscreen: three flat clear panels, base, top frame

State as of 2026-09-13. A low, tapered, squared-off C of clear PETG sheet (three separate 1 mm
panels, 0.6 nozzle) held at the right angles by an opaque PLA base (0.4 nozzle) with three
5 x 5 x 2 tabs that plug into the deck, plus an optional top frame capping the top edges.
Corners are mitred, top edges cut flat. Nothing printed yet.

## Files
| File | What |
|---|---|
| `windscreen.scad` | The model. Panels defined by 3D corner points; the flat outline and the placement both derive from them. |
| `viewer.json` | Part list for the browser viewer (`../../viewer`, `bun run dev`, http://127.0.0.1:5180/whale/windscreen/). |
| `print_layout.scad` | `-D part="front|side_l|side_r|strip|base|top"`: each part in its printing pose. |
| `check.scad` | Collision pairs; `../../tools/check.sh whale/windscreen/check.scad 'height=10'`. Empty = clear. |
| `coupon.scad` | Groove clearance coupon (0.10 / 0.15 / 0.25 per side) + `strip` sheet sample. |
| `export.sh` / `render.sh` | STLs into `stl/`, PNGs into `renders/`. |
| `ref/` | Nothing yet. |

## Coordinate frame
Z up, base sits on z = 0, tabs hang below. The FRONT (60 mm) panel stands near x = 0, the C opens
toward +X (the pilot), Y symmetric. Panel bottom edges sit at z = `base_floor` (1).

## Dimensions (outside, from Armen 2026-09-13)
| | base end | top edge |
|---|---|---|
| front panel width | 60 | 65 |
| side panel length (from the front's outer face) | 40 | 44 |
| height (vertical) | 10 | |

A V from the front: the sides lean outward (2.5 mm each over the height, 14 deg). From the side
it is \____| : the side's free edge is square in the sheet, so the front leans away from the
opening by 44 - 40 = 4 mm, 21.8 deg. Both angles are derived from the corner points, not typed.

Each panel is an oversized flat slab clipped by planes (`halfspace()`): bottom square to the
sheet (sits in the groove), top horizontal (flush rim for the top frame), free edge square, and
the corner edge mitred on the bisector plane between the two sheets. Two square-cut sheets at a
skewed corner cannot be flush; the mitre fixes that. The bevels are a few layers deep on a 1 mm
sheet; every sheet prints OUTER face down so they are slopes, not overhangs.

Flat sheets as printed (outer face): front 60 / 65 x 10.77; sides 40 / 44 x 10.31 with the mitre
at the corner end. side_r is the mirror image of side_l (mitre on the other end): print one each.

## Parts and how they go together
1. Base (PLA, printed upside down, tabs up): a 5 mm wide, 3 mm tall C rail, square ends flush
   with the sides' free edges, tilted 1.3 mm grooves 2 mm deep (cut by the panels themselves,
   grown by `groove_clr`). Tabs: one dead centre under the front rail, one under each side rail
   with a 5 mm gap between the panel's free edge and the tab. Vertical cosmetic lines every 4 mm
   on the three outer faces (`base_lines`, `line_pitch/w/d`).
2. Drop the front panel in its groove, then each side; the mitred corners meet face to face
   (`joint_clr` = 0). Glue if the groove fit is loose.
3. Top frame (optional, `show_top`; PLA, printed cap down): a 4 wide x 3 tall inverted C rail
   with the same grooves, 2 deep, 1 mm cap. Pushes down over the flat top rim. It is chunky next
   to a 10 mm screen; `top_w`, `top_groove_d`, `top_cap` to taste.
4. Tabs into the deck slots.

## Open items
- Coupon unprinted: `stl/coupon.stl` (PLA) + `stl/strip.stl` (PETG). Pick the groove clearance,
  `../../tools/scadset windscreen.scad groove_clr=...`, re-export.
- Tab size/spacing is from Armen's description, not measured against the deck slots. Check
  against the toy before printing the base.
- Rail ends are rounded (stroke_2d); square them off if that looks wrong on the deck.
- Corner joint is a butt joint: the side sheet ends on the back's inner face. No mitre.

## Gotchas learned
- `for` inside `intersection()` unions its iterations into ONE child, so two mitre planes in a
  loop clipped nothing. `intersection_for()` is the loop that intersects.
- The half-space cubes are 1000 mm; OpenSCAD's preview sizes the camera from every primitive,
  so PNGs came out blank until `render.sh` got `--render` (full evaluation first). The viewer
  is unaffected.
- The -Y side's corner list runs the other way along the bottom edge so every panel frame is
  right-handed with an inward normal (`panel_n()` asserts it). That is what makes
  `panel_unplace()` a true inverse and the printed side_r a real mirror part, not a flipped copy.
