# Killer W.H.A.L.E. front landing hatch (bow ramp) with replacement hinge

State as of 2026-09-11. One line on what this is and where it goes.

## Files
| File | What |
|---|---|
| `whale_hatch.scad` | The model. Parameters at the top, one section per feature. |
| `viewer.json` | Part list for the browser viewer (`../viewer`, `SCAD_PROJECT=../whale_hatch bun run dev`, http://127.0.0.1:5180/). |
| `print_layout.scad` | `-D part="..."`: each part in its printing pose. |
| `check.scad` | Collision pairs; `../tools/check.sh check.scad 'pose=..'`. Empty = clear. |
| `coupon.scad` | Tolerance test print. |
| `export.sh` / `render.sh` | STLs into `stl/`, PNGs into `renders/`. |

## Coordinate frame
Z up, part sits on z = 0. FRAME_NOTE

## Parts and how they go together
1. ...

## Design notes
- ...

## Open items
- Coupon not yet printed.

## Gotchas learned
- ...
