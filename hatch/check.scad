// Collision checks. Each `pair` should be EMPTY (rail/groove and pin/hole have clearance).
//   pair: "hatch-front" | "front-mounts" | "hatch-mounts"
// Run: ../../tools/check.sh check.scad 'open_deg=0' 'open_deg=115'
include <whale_hatch.scad>
show_ghost = false; show_all = false; show_hull = false;
pair = "hatch-front";

module A() { rotate([-open_deg, 0, 0]) if (pair == "hatch-front" || pair == "hatch-mounts") hatch(); else front(); }
module B() { if (pair == "hatch-front") rotate([-open_deg, 0, 0]) front(); else mounts(); }
intersection() { A(); B(); }
