// Numeric comparison of the port against the Shapr3D export, per body group.
//   group: "shroud" | "strut" | "vanes" | "all"
//   mode:  "port" | "ref" | "ref-port" (missing in port) | "port-ref" (extra in port)
// The reference STL is four overlapping shells, so they are imported one per
// file (ref_bodies/) and unioned here before any volume is measured.
fine = false;             // -D fine=true for a tessellation-independent check (must precede the include:
                          // OpenSCAD evaluates an overridden variable at its first assignment)
include <shroud.scad>
show_ghost = false; show_shroud = false; show_strut = false; show_vanes = false;
$fn = fine ? 480 : 120;
group = "all";
mode  = "port";

function has(g) = group == "all" || group == g;
module port_g() {
    if (has("shroud")) shroud();
    if (has("strut"))  strut();
    if (has("vanes"))  vanes();
}
module ref_g() union() {
    if (has("shroud")) import("ref_bodies/shroud.stl");
    if (has("strut"))  import("ref_bodies/strut.stl");
    if (has("vanes"))  { import("ref_bodies/vane_left.stl"); import("ref_bodies/vane_right.stl"); }
}
if (mode == "port")     port_g();
if (mode == "ref")      ref_g();
if (mode == "ref-port") difference() { ref_g();  port_g(); }
if (mode == "port-ref") difference() { port_g(); ref_g();  }
