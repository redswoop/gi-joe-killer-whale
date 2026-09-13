# Killer W.H.A.L.E. (1984 G.I. Joe hovercraft) replacement parts

Open-source (MIT) OpenSCAD replacement parts for the 1984 G.I. Joe Killer W.H.A.L.E. hovercraft.
On Makerworld: [cannon covers](https://makerworld.com/en/models/690907-gi-joe-killer-whale-cannon-covers); fan shroud listing in progress (`shroud/MAKERWORLD.md`).

## Building
Needs OpenSCAD 2025+ (Manifold backend). Shared helpers live in [`lib/`](lib/README.md) (a vendored copy of the
workbench's `scad/lib/`). Each assembly's `export.sh` regenerates its `stl/`; `print_layout.scad -D part="..."`
gives one part in its print pose; `check.scad` runs the collision pairs. Everything else below is workbench
convention (the viewer and `tools/` are not part of this repo).

## Layout
One folder for the whole toy, one subfolder per assembly. Each assembly has its own `.scad`,
`viewer.json`, coupons, checks, export script and README, so the viewer previews and rebuilds
them separately. The toy is one git repo (this folder).

| Assembly | Folder | State |
|---|---|---|
| Fan shroud + steering vanes | [`shroud/`](shroud/README.md) | Printed and fitted; fused shroud variant is current. |
| Front landing hatch (bow ramp) + hinge | [`hatch/`](hatch/README.md) | Three parts since 2026-09-13: tray with a dovetail socket, flat front plate with the pins, two glue-on brackets. Coupon (dovetail + pin fits) ready, nothing printed yet. Profile still the 3-point circle. |

Viewer: `cd ../viewer && bun run dev` (once), then http://127.0.0.1:5180/whale/shroud/ or
http://127.0.0.1:5180/whale/hatch/. Tools and shared modules are two levels up:
`use <../../lib/shape.scad>`, `../../tools/check.sh check.scad 'pose=..'`.

Reference material outside this repo: `../../WHALE/` (measurements, the small top-hatch 3mf),
`../../GI Joe/` (downloaded Thingiverse parts), `../GI_Joe_Killer_Whale_Blade.stl` (old fan mesh off the web).

Adding an assembly: `../tools/new-model.sh whale/<name>` copies the template into a new subfolder
(it does not run `git init` inside an existing repo).

History: `shroud/` was the `scad/whale/` repo until 2026-09-12; `hatch/` was a separate `scad/whale_hatch/`
repo, merged in with `git subtree add` so its commits are here too.
