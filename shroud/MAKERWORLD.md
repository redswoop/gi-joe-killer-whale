# G.I. Joe Killer W.H.A.L.E. Fan Shroud & Steering Vanes (1984)

A replacement fan shroud, steering vanes, and fan for the 1984 G.I. Joe Killer W.H.A.L.E. hovercraft. Designed from scratch in OpenSCAD using nothing but reference photos found online, test-fitted on my own extremely worn-out Whale. Fully open source.

## Why this exists

My brother and I had a Whale as kids (technically it was his, but we both loved it). It's one of the most iconic play-set vehicles ever made, and unfortunately one of the most brittle. The fan shrouds, vanes, and all the little bits broke off even back in the day. If yours looks like mine, this is the fix. Print two for a full set.

I also designed the Whale's cannon hatches, which people seem to like:
https://makerworld.com/en/models/690907-gi-joe-killer-whale-cannon-covers

## What makes this one different

- **Fully parametric CAD.** Written in OpenSCAD, so every tolerance (hinge clearance, strut fit, shaft fit) is a number at the top of the file. If your printer runs tight or loose, change one value and re-export instead of sanding. Use MakerWorld's Customize button: pick the part, tweak the clearances, generate.
- **Designed for PLA, not for the museum.** This is not a 100% faithful recreation. I took some liberties with the original so it prints at the best quality and strength. The vane roots and the shroud are one piece instead of separate snap-on parts, because that joint is where the original always broke.
- **Snap together, no glue.** The only extra thing you need is a few short lengths of 1.75 mm filament, which serve as the hinge pins for the vanes.

## Assembly

1. Print the shroud, the two vane plates, the slats, the tie bar, the strut, the fan, and the shaft.
2. Hinge the vanes: drop each vane plate between the knuckles on the shroud's vane roots, push a short piece of 1.75 mm filament through, trim it about 1 mm proud, and mushroom the ends with a lighter or soldering iron.
3. Slats ride on filament too: push a length through one root bar, through the slat, and out the other bar. Mushroom both ends.
4. Fit the tie bar across the vanes so they steer together.
5. Push the shaft into the socket under the fan hub and drop the fan into the shroud.
6. Lock in the strut last. It slides into the pockets inside the bore from the base side and holds the fan and shaft in place. The Whale's hull keeps it seated once the shroud is installed.

## Printing

- **Filament:** Bambu PLA Matte Dark Green.
- **Profile:** 0.16 mm High Quality on a Bambu.
- **Orientation matters.** Every part is oriented in the profile for the best combination of looks and strength. The vane plates stand on their long edge, the shaft lies on its flat, the shroud prints base down. If you reorient parts, some of them (the hinges and the thin vane features especially) will come out too brittle. Tread carefully.
- **Supports:** the shroud's root bars bridge the bore, so enable supports under them. The other parts print without support.

## Source

The OpenSCAD source is on GitHub (MIT): https://github.com/redswoop/gi-joe-killer-whale (the shroud is in `shroud/`). Tweak the tolerances, remix it, port it to another printer.
