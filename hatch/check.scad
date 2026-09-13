// Collision checks. Each `pair` should be EMPTY.
//   pair: "hatch-bar"
// Run: ../tools/check.sh check.scad 'open_deg=0' 'open_deg=115'
include <whale_hatch.scad>
show_ghost = false; show_all = false; show_hull = false;
pair = "hatch-bar";

module A() { if (pair == "hatch-bar") hatch(); }
module B() { if (pair == "hatch-bar") slide_bar(); }
intersection() { A(); B(); }
