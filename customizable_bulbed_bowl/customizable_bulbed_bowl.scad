// Customizable Bulbed Bowl
// Copyright: Olle Wreede 2020
// License: CC BY-SA

//CUSTOMIZER VARIABLES

// Diameter of vase in mm
diameter_of_vase = 100; // [75:200]

// Height of vase in mm
height_of_vase = 200; // [50:300]

// Top cut off scale
bowl_top_cut_off = 3; // [2:0.25:10]

// Bottom cut off scale
bowl_bottom_cut_off = 3; // [2:0.25:10]

// How much to scale bowl in X direction
bowl_scale_x = 0; // [0:100]

// How much to scale bowl in Y direction
bowl_scale_y = 0; // [0:100]

/* [Hidden] */

$fn = 120;

module bulbed_bowl(diameter, height) {
    scale([bowl_scale_x / 100 + 1, bowl_scale_y / 100 + 1, 1])
    translate([0, 0, height / 2 - height / bowl_bottom_cut_off])
    difference() {
        scale([1, 1, height / diameter])
        sphere(d = diameter, center = true);
        
        // Cut off top
        translate([0, 0, height / 2 - height / bowl_top_cut_off / 2])
        cube([diameter, diameter, height / bowl_top_cut_off], center = true);

        // Cut off bottom
        translate([0, 0, -height / 2 + height / bowl_bottom_cut_off / 2])
        cube([diameter, diameter, height / bowl_bottom_cut_off], center = true);
    }
}

module bowl() {
    bulbed_bowl(diameter_of_vase, height_of_vase);
}

bowl();
