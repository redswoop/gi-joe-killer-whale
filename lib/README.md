# lib/ shared OpenSCAD modules

Copy of the workbench's shared `scad/lib/` as of 2026-09-13, vendored so this repo builds on its own.
Pull in with `use <../lib/shape.scad>` from a model folder. `use` (not `include`) so the
library sees no model globals: every module takes what it needs as parameters. `$fn`
still flows in from the caller.

| File | Contents |
|---|---|
| `shape.scad` | `rounded_pad(h, r, fn)`, `fillet_collar(r, fn)`, `bar_profile_2d(w, h, r)`, `frame_sweep(x, y, r, w)`, `stadium_sweep(l)` + `stadium_2d(l, w)`, `full_profile()`, `annulus_2d`, `wall_blend(R, w, z0, h, r, fn)`, `arc_sweep(a0, a1)`, `arc_pts(arc, n)`, `stroke_2d(pts, w)`, `grooves_2d(x0, x1, pitch, groove)` |
| `fit.scad` | `teardrop_2d(r, dir)`, `keyhole_2d(d_pin, d_big, off, throat)` |
