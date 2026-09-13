// Collision checks. Each `pair` should be EMPTY (the base has groove_clr around every panel).
//   pair: "back-side_l" | "back-side_r" | "base-back" | "base-side_l" | "base-side_r"
// Run (from scad/): tools/check.sh whale/windscreen/check.scad 'height=10'
include <windscreen.scad>
show_all = false;
pair = "back-side_l";

module A() {
    if (pair == "back-side_l" || pair == "back-side_r") back();
    else base();
}
module B() {
    if (pair == "back-side_l" || pair == "base-side_l") side_l();
    if (pair == "back-side_r" || pair == "base-side_r") side_r();
    if (pair == "base-back") back();
}
intersection() { A(); B(); }
