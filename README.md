# Killer W.H.A.L.E. (1984 G.I. Joe hovercraft) replacement parts

Open-source (MIT) OpenSCAD replacement parts for the 1984 G.I. Joe Killer W.H.A.L.E. hovercraft.
On Makerworld: [cannon covers](https://makerworld.com/en/models/690907-gi-joe-killer-whale-cannon-covers); fan shroud listing in progress (`shroud/MAKERWORLD.md`).

## Building
Needs OpenSCAD 2025+ (Manifold backend). Shared helpers come from the armenscad workbench (https://github.com/redswoop/armenscad, `lib/armenscad/`),
used as `use <armenscad/shape.scad>`; install it (`/plugin install armenscad --marketplace redswoop/armenscad`, then `armenscad install`) so OpenSCAD finds it. Each assembly's `export.sh` regenerates its `stl/`; `print_layout.scad -D part="..."`
gives one part in its print pose; `check.scad` runs the collision pairs. Everything else below is workbench
convention (the viewer and `tools/` are not part of this repo).

## Layout
One folder for the whole toy, one subfolder per assembly. Each assembly has its own `.scad`,
`viewer.json`, coupons, checks, export script and README, so the viewer previews and rebuilds
them separately. The toy is one git repo (this folder).

| Assembly | Folder | State |
|---|---|---|
| Fan shroud + steering vanes | [`shroud/`](shroud/README.md) | Printed and fitted; fused shroud variant is current. |
| Front landing hatch (bow ramp) + hinge | [`hatch/`](hatch/README.md) | Three parts: tray with a dovetail socket, stepped front plate with the pins, two glue-on brackets. Tray's cabin end confirmed by two corner coupons; outer-face details modelled. Dovetail coupon round 2 exported, unprinted; pin fit settled (0.3). Hull apart 2026-09-13: brackets redone as captured C-clips over the middle layer's front edge (three grips exported, unprinted); opening direction fixed. 2026-09-13 late. |
| Cockpit windscreen (3 clear panels, base, top frame) | [`windscreen/`](windscreen/README.md) | Modelled 2026-09-13 (60/65 x 40/44 x 10, mitred corners, flat top rim, tabbed base with lines, optional top frame). Coupon unprinted. |

Viewer: `armenscad browse .` from this folder, then http://127.0.0.1:5180/shroud/,
/hatch/ or /windscreen/. Collision checks: `armenscad check check.scad 'pose=..'`.

Reference material outside this repo: `../../WHALE/` (measurements, the small top-hatch 3mf),
`../../GI Joe/` (downloaded Thingiverse parts), `../GI_Joe_Killer_Whale_Blade.stl` (old fan mesh off the web).

Adding an assembly: `armenscad init <name>` here copies the template into a new subfolder
(it does not run `git init` inside an existing repo).

History: `shroud/` was the `projects/gi_joe/whale/` repo until 2026-09-12; `hatch/` was a separate `projects/gi_joe/whale_hatch/`
repo, merged in with `git subtree add` so its commits are here too.
