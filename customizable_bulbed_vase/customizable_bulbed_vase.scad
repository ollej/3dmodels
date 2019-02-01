// Customizable Bulbed Vase
// Copyright: Olle Wreede 2019
// License: CC BY-SA

//CUSTOMIZER VARIABLES

// Diameter of vase in mm
diameter_of_vase = 100; // [75:200]

// Height of vase in mm
height_of_vase = 200; // [50:300]

// Brim width in mm of opening
opening_brim_width = 15; // [2:35]

// Scale of neck part of vase
bulbed_neck_scale = 75; // [10:90]

// Scale of lower bulb part of vase
bulbed_bulb_scale = 75; // [1:100]

//CUSTOMIZER VARIABLES END

/* [Hidden] */

$fn = 120;

/* ** Main object ** */

module bulbed_vase_form(diameter, height) {
    difference() {
        union() {
            square(size = [diameter / 2, height], center = true);
            
            // Bulbed lower part
            translate([diameter / 4, - height / 4, 0])
            scale([bulbed_bulb_scale / 100, height / diameter / 2, 1])
            circle(d = diameter, center = true);
        }

        // Neck upper part
        translate([diameter / 4, height / 4, 0])
        scale([bulbed_neck_scale / 100, height / diameter / 2, 1])
        circle(d = diameter, center = true);
        
        // Opening
        translate([diameter / 4 - opening_brim_width / 2, height / 2 - height / 8, 0])
        square(size = [opening_brim_width, height / 4], center = true);
    }
}

module bulbed_vase(diameter, height) {
    rotate_extrude()
    translate([diameter / 4, height / 2, 0])
    bulbed_vase_form(diameter, height);
}

module vase() {
    bulbed_vase(diameter_of_vase, height_of_vase);
}

vase();
