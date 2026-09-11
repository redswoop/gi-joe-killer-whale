#!/usr/bin/env bash
# Regenerate every print file into stl/. Run after changing parameters in shroud.scad.
set -e
cd "$(dirname "$0")"
O=/opt/homebrew/bin/openscad
mkdir -p stl
for p in vane_right vane_left tie_bar slat shroud strut; do
  printf '%-12s' "$p"
  "$O" --backend Manifold --export-format binstl -D "part=\"$p\"" -o "stl/$p.stl" print_layout.scad 2>&1 | grep -iE "error|warning" | grep -v NoError || true
  echo "ok"
done
printf '%-12s' coupon
"$O" --backend Manifold --export-format binstl -o stl/hinge_coupon.stl hinge_coupon.scad 2>&1 | grep -iE "error|warning" | grep -v NoError || true
echo "ok"
for p in shroud vane_right vane_left; do   # the saddle-mount alternative (ny_mount = "saddle")
  printf '%-12s' "${p}_saddle"
  "$O" --backend Manifold --export-format binstl -D "part=\"$p\"" -D 'ny_mount="saddle"' -o "stl/${p}_saddle.stl" print_layout.scad 2>&1 | grep -iE "error|warning" | grep -v NoError || true
  echo "ok"
done
printf '%-12s' saddle_coupon
"$O" --backend Manifold --export-format binstl -o stl/saddle_coupon.stl saddle_coupon.scad 2>&1 | grep -iE "error|warning" | grep -v NoError || true
echo "ok"
printf '%-12s' tab_coupon
"$O" --backend Manifold --export-format binstl -o stl/tab_coupon.stl tab_coupon.scad 2>&1 | grep -iE "error|warning" | grep -v NoError || true
echo "ok"

../tools/stlinfo.py stl/*.stl
