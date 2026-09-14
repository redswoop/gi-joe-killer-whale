// Collision checks. Each `pair` should be EMPTY (rail/groove and pin/hole have clearance). The nose
// mock touches the front plate's flange and the clips at 0 deg by design (faces coincide).
//   pair: "hatch-front" | "front-mounts" | "hatch-mounts" | "hatch-nose" | "front-nose" | "mounts-nose"
// Run: ../../tools/check.sh check.scad 'open_deg=0' 'open_deg=45' 'open_deg=90' 'open_deg=135' 'open_deg=180'
include <whale_hatch.scad>
show_ghost = false; show_all = false; show_hull = false;
pair = "hatch-front";
cut = search("-", pair)[0];
function sub(s, a, b) = a >= b ? "" : str(s[a], sub(s, a + 1, b));
module part(n) {
    if (n == "hatch") rotate([open_deg, 0, 0]) hatch();
    else if (n == "front") rotate([open_deg, 0, 0]) front();
    else if (n == "mounts") mounts();
    else if (n == "nose") nose_mock();
}
intersection() { part(sub(pair, 0, cut)); part(sub(pair, cut + 1, len(pair))); }
