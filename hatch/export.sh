#!/usr/bin/env bash
# Regenerate every print file into stl/. Run after changing parameters. Print mount.stl twice.
set -e
cd "$(dirname "$0")"
O=/opt/homebrew/bin/openscad
mkdir -p stl
for p in hatch front mount; do
  printf '%-12s' "$p"
  "$O" --backend Manifold --export-format binstl -D "part=\"$p\"" -o "stl/$p.stl" print_layout.scad 2>&1 | grep -iE "error|warning" | grep -v NoError || true
  echo "ok"
done
"$O" --backend Manifold --export-format binstl -o stl/coupon.stl coupon.scad 2>&1 | grep -iE "error|warning" | grep -v NoError || true
[ -x ../../tools/stlinfo.py ] && ../../tools/stlinfo.py stl/*.stl || true   # workbench-only summary
