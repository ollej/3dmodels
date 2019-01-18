// Customizable Dish Rack End Stops
// Copyright: Olle Wreede 2019
// License: CC BY-SA

//CUSTOMIZER VARIABLES

// Height in mm
height = 10; // [8:20]

// Depth of hole in mm
depth_of_hole = 10; // [4:0.1:20]

// Diameter in mm of hole
diameter_of_hole = 4.0; // [3.0:0.1:6.0]

// Diameter in mm of cylinder
diameter_of_cylinder = 7.5; // [5:0.1:10]

// Diameter in mm of shoulder
diameter_of_shoulder = 12; // [10:0.1:16]

// Thickness in mm of shoulder
thickness_of_shoulder = 2; // [0.6:0.1:4.0]

//CUSTOMIZER VARIABLES END

/* [Hidden] */

$fn=120;

module cylinder_outer(height, diameter, fn) {
   fudge = 1 / cos(180 / fn);
   cylinder(h=height, r=diameter / 2 * fudge, $fn=fn);
}

module plopp(height, diameter, thickness_of_shoulder, diameter_of_shoulder) {
    difference() {
        union() {
            // Cylinder
            cylinder_outer(height, diameter, $fn);

            // Shoulder
            cylinder_outer(thickness_of_shoulder, diameter_of_shoulder, $fn);
        }
        
        translate([0, 0, height - depth_of_hole])
        //cylinder(h=depth_of_hole, d=diameter_of_hole');
        cylinder_outer(depth_of_hole, diameter_of_hole, $fn);
    }
}

plopp(height, diameter_of_cylinder, thickness_of_shoulder, diameter_of_shoulder);