#!/usr/bin/env bash
# Regenerate every print file into stl/. Run after changing parameters. mount.stl is the C-clip at
# clip_clr 0; mount_clr-0.2 / +0.2 are the tighter and looser grips. Print the one that snaps on and stays, twice.
# corner.stl is the fit coupon for the cabin-end corner (print_layout.scad part = "corner").
set -e
cd "$(dirname "$0")"
O=/opt/homebrew/bin/openscad
mkdir -p stl
for p in hatch front mount corner; do
  printf '%-12s' "$p"
  "$O" --backend Manifold --export-format binstl -D "part=\"$p\"" -o "stl/$p.stl" print_layout.scad 2>&1 | grep -iE "error|warning" | grep -v NoError || true
  echo "ok"
done
for c in -0.2 0.2; do
  printf '%-12s' "mount $c"
  "$O" --backend Manifold --export-format binstl -D 'part="mount"' -D "clip_clr=$c" -o "stl/mount_clr$c.stl" print_layout.scad 2>&1 | grep -iE "error|warning" | grep -v NoError || true
  echo "ok"
done
"$O" --backend Manifold --export-format binstl -o stl/coupon.stl coupon.scad 2>&1 | grep -iE "error|warning" | grep -v NoError || true
[ -x ../../tools/stlinfo.py ] && ../../tools/stlinfo.py stl/*.stl || true   # workbench-only summary
