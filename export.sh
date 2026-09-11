#!/usr/bin/env bash
# Regenerate every print file into stl/. Run after changing parameters in shroud.scad.
# Variants: the -Y mount (ny_mount fork | saddle) and the hinge pin (hinge_pin printed | filament) are switches in
# shroud.scad; the plain file names are the defaults, suffixes name the alternates (_saddle, _filpin, _saddle_filpin).
# Jobs run in parallel (one per core).
set -e
cd "$(dirname "$0")"
O=/opt/homebrew/bin/openscad
mkdir -p stl
tmp="$(mktemp -d)"; n=0
job() {   # job NAME OUT.stl FILE.scad [-D ...]
  local name="$1" out="$2" f="$3"; shift 3
  n=$((n + 1))
  { printf '%q ' "$O" --backend Manifold --export-format binstl "$@" -o "$out" "$f"; printf '> %q 2>&1; printf "%%-24s ok\\n" %q\n' "$tmp/$n.log" "$name"; } > "$tmp/$n.sh"
}
for p in vane_right vane_left tie_bar slat shroud strut; do job "$p" "stl/$p.stl" print_layout.scad -D "part=\"$p\""; done
for p in shroud vane_right vane_left; do job "${p}_saddle" "stl/${p}_saddle.stl" print_layout.scad -D "part=\"$p\"" -D 'ny_mount="saddle"'; done
for p in vane_right vane_left; do
  job "${p}_filpin"        "stl/${p}_filpin.stl"        print_layout.scad -D "part=\"$p\"" -D 'hinge_pin="filament"'
  job "${p}_saddle_filpin" "stl/${p}_saddle_filpin.stl" print_layout.scad -D "part=\"$p\"" -D 'ny_mount="saddle"' -D 'hinge_pin="filament"'
done
job hinge_coupon        stl/hinge_coupon.stl        hinge_coupon.scad
job hinge_coupon_filpin stl/hinge_coupon_filpin.stl hinge_coupon.scad -D 'hinge_pin="filament"'
job saddle_coupon       stl/saddle_coupon.stl       saddle_coupon.scad
job tab_coupon          stl/tab_coupon.stl          tab_coupon.scad
/bin/ls "$tmp"/*.sh | xargs -P "$(sysctl -n hw.ncpu 2>/dev/null || echo 4)" -n1 bash
grep -ihE "error|warning" "$tmp"/*.log | grep -v NoError || true
../tools/stlinfo.py stl/*.stl
