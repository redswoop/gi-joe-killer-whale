// Collision checks. Rails have groove_clr around every panel, so those pairs should be EMPTY;
// the mitred corners touch face to face (joint_clr = 0), so front-side pairs report `touch`.
//   pair: "front-side_l" | "front-side_r" | "base-front" | "base-side_l" | "base-side_r" | "top-front" | "top-side_l" | "top-side_r"
// Run (from scad/): tools/check.sh whale/windscreen/check.scad 'height=10'
include <windscreen.scad>
show_all = false;
pair = "front-side_l";

a = pair == "front-side_l" || pair == "front-side_r" ? "front" : pair == "base-front" || pair == "base-side_l" || pair == "base-side_r" ? "base" : "top";
b = pair == "base-front" || pair == "top-front" ? "front" : pair == "front-side_l" || pair == "base-side_l" || pair == "top-side_l" ? "side_l" : "side_r";

module pick(n) { if (n == "front") front(); if (n == "side_l") side_l(); if (n == "side_r") side_r(); if (n == "base") base(); if (n == "top") top(); }
intersection() { pick(a); pick(b); }
