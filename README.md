# Killer W.H.A.L.E. (1984 G.I. Joe hovercraft) replacement parts

One folder for the whole toy, one subfolder per assembly. Each assembly has its own `.scad`,
`viewer.json`, coupons, checks, export script and README, so the viewer previews and rebuilds
them separately. The toy is one git repo (this folder).

| Assembly | Folder | State |
|---|---|---|
| Fan shroud + steering vanes | [`shroud/`](shroud/README.md) | Printed and fitted; fused shroud variant is current. |
| Front landing hatch (bow ramp) + hinge | [`hatch/`](hatch/README.md) | First fit-check print pending. Hinge end redone 2026-09-13: 10 mm vertical front face, angled skirt, bar below the lip; skirt numbers are photo estimates. Profile still the 3-point circle. |

Viewer: `cd ../viewer && bun run dev` (once), then http://127.0.0.1:5180/whale/shroud/ or
http://127.0.0.1:5180/whale/hatch/. Tools and shared modules are two levels up:
`use <../../lib/shape.scad>`, `../../tools/check.sh check.scad 'pose=..'`.

Reference material outside this repo: `../../WHALE/` (measurements, the small top-hatch 3mf),
`../../GI Joe/` (downloaded Thingiverse parts), `../GI_Joe_Killer_Whale_Blade.stl` (old fan mesh off the web).

Adding an assembly: `../tools/new-model.sh whale/<name>` copies the template into a new subfolder
(it does not run `git init` inside an existing repo).

History: `shroud/` was the `scad/whale/` repo until 2026-09-12; `hatch/` was a separate `scad/whale_hatch/`
repo, merged in with `git subtree add` so its commits are here too.
