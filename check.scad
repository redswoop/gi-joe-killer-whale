// Collision checks for the steering mechanism. Each `pair` should be EMPTY.
//   pair: "fins-roots" | "fins-duct" | "roots-duct" | "tie-fins" | "fins-fins" | "tie-duct" | "slats-fins" | "slats-roots" | "slats-duct" | "strut-duct"
// Run with -D steer=<deg>. An empty export (84-byte STL) means no collision.
include <shroud.scad>
show_ghost = false; show_shroud = false; show_strut = false; show_vanes = false;
pair = "fins-roots";
strut_dz = 0;       // strut pose: 0 = seated on the slot floor, >0 = lifted that far while sliding in
module A() {
    if (pair == "strut-duct") translate([0, 0, strut_dz]) strut_placed();
    if (pair == "slats-fins" || pair == "slats-roots" || pair == "slats-duct") slats();
    if (pair == "fins-roots" || pair == "fins-duct" || pair == "fins-fins") vane_fins();
    if (pair == "roots-duct") vane_roots();
    if (pair == "tie-fins" || pair == "tie-duct") tie_bar_placed();
}
module B() {
    if (pair == "strut-duct") { duct(); deco_boxes(); tab(); }
    if (pair == "slats-fins") vane_fins();
    if (pair == "slats-roots") vane_roots();
    if (pair == "slats-duct") { duct(); deco_boxes(); tab(); }
    if (pair == "fins-roots") vane_roots();
    if (pair == "fins-duct" || pair == "roots-duct" || pair == "tie-duct") { duct(); deco_boxes(); tab(); }
    if (pair == "tie-fins") vane_fins();
    if (pair == "fins-fins") place_fin(-1);      // vs place_fin(1) inside A: they only collide if they cross the centreline
}
if (pair == "fins-fins") intersection() { place_fin(1); place_fin(-1); }
else intersection() { A(); B(); }
