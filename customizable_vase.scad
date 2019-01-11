// Customizable Vase
// Copyright: Olle Johansson 2019
// License: CC BY-SA

//CUSTOMIZER VARIABLES

/* [Vase] */

// Type of vase
type_of_vase = "Bowl"; // [Bowl, Vase]

// Type of edge bumps
type_of_bump = "Rounded"; // [None, Rounded, Triangle]

// Diameter of base in mm
diameter_of_base = 100; // [50:200]

// Height of vase in mm
height_of_vase = 200; // [50:300]

// Width of each bump in mm
width_of_bump = 20; // [10:30]

// Number of bumps around the edge
number_of_bumps = 20; // [4:100]

// Number of slices in twist
number_of_slices = 50; // [1:200]

// Degrees of twist
degrees_of_twist = 20; // [0:360]

// Scale of top of vase in percent
top_scale_x = 150; // [100:400]

// Scale of top of vase in percent
top_scale_y = 250; // [100:400]

z_step = 10;

//CUSTOMIZER VARIABLES END

/* [Hidden] */

$fn=100;

/* ** Utility modules ** */

module circled_pattern(number) {
    rotation_angle = 360 / number;
    last_angle = 360 - rotation_angle;
    for(rotation = [0 : rotation_angle : last_angle])
        rotate([0, 0, rotation])
        children();
}

/* ** Vase ** */

module rounded_bump() {
    translate([diameter_of_base / 2 - width_of_bump / 8, 0, 0])
    scale([0.8,1,1])
    circle(d = width_of_bump, center = true);
}

module triangle_bump(diameter) {
    triangle_height = sqrt(3) / 2 * width_of_bump;
    translate([diameter_of_base / 2, 0, 0])
    circle(d = width_of_bump, $fn=3, center = true);
}

module bump() {
    if (type_of_bump == "Rounded") rounded_bump();
    else if (type_of_bump == "Triangle") triangle_bump();
}

module edge_bumps() {
    circled_pattern(number_of_bumps)
        bump();
}

module vase_base() {
    circle(d = diameter_of_base, center = true);
    if (type_of_bump != 0) edge_bumps();
}

/* ** Main object ** */

module simple_bowl() {
    linear_extrude(height = height_of_vase, convexity = 1, twist = degrees_of_twist, slices = number_of_slices, scale=[top_scale_x / 100, top_scale_y / 100])
    vase_base();
}

module complex_vase() {
    union() {
        for( z_offset = [ 0 : z_step : height_of_vase ] ) {
            z_height = height_of_vase / z_step;
            translate([0, 0, z_offset])
            linear_extrude(
                height = z_step,
                convexity = 10,
                twist = - degrees_of_twist / z_height, 
                slices = number_of_slices / z_height
            )
            rotate([0, 0, degrees_of_twist / height_of_vase * z_offset])
            vase_base();
        }
        //linear_extrude(height = z_change, convexity = 1, 

        // TODO: multiple scale points vertically
    }
}

module vase() {
    if (type_of_vase == "Bowl") simple_bowl();
    else if (type_of_vase == "Vase") complex_vase();
}

vase();
