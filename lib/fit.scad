// fit.scad: features for printed fits (holes that print without support, snaps).
//   use <../lib/fit.scad>

// Teardrop hole profile: a circle of radius r with a 45 deg point on the side
// that faces UP while printing (dir = +1 for +x, -1 for -x), so the roof of the
// hole bridges itself. A pin turns on the circular part. Extrude along the axis.
// (A diamond pin in a diamond hole was the first attempt: it cannot rotate.)
module teardrop_2d(r, dir = 1) {
    eps = 0.01;
    hull() { circle(r); translate([dir * (r * sqrt(2) - eps), 0]) square(eps, center = true); }
}

// Keyhole for a bulb-ended pin: the bulb passes through the big hole (d_big),
// the part slides so the pin's shank sits in the working hole (d_pin) at the
// origin, clicking through a throat that is `throat` wide (a little under the
// shank diameter for a detent). The big hole sits `off` in -y.
module keyhole_2d(d_pin, d_big, off, throat) {
    circle(d = d_pin);
    translate([0, -off]) circle(d = d_big);
    translate([-throat / 2, -off]) square([throat, off]);
}
