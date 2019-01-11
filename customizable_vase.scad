// Customizable Vase
// Copyright: Olle Johansson 2019
// License: CC BY-SA

//CUSTOMIZER VARIABLES

/* [Main] */

// Type of vase
type_of_vase = "Bulbed bowl"; // [Bulbed bowl, Twisted vase, Bulbed vase]

// Diameter of vase in mm
diameter_of_vase = 100; // [75:200]

// Height of vase in mm
height_of_vase = 200; // [50:300]

/* [Bulbed bowl] */

// Top cut off scale
bowl_top_cut_off = 3; // [2:0.25:10]

// Bottom cut off scale
bowl_bottom_cut_off = 3; // [2:0.25:10]

// How much to scale bowl in X direction
bowl_scale_x = 0; // [0:100]

// How much to scale bowl in Y direction
bowl_scale_y = 0; // [0:100]

/* [Twisted vase] */

// Type of edge bumps for vase
type_of_bump = "Rounded"; // [None, Rounded, Triangle]

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

/* [Bulbed vase] */

// Brim width in mm of opening
opening_brim_width = 5; // [2:35]

// Scale of neck part of vase
bulbed_neck_scale = 75; // [10:90]

// Scale of lower bulb part of vase
bulbed_bulb_scale = 75; // [1:100]

//CUSTOMIZER VARIABLES END

/* [Hidden] */

z_step = 10;

$fn = 120;

/* ** Utility modules ** */

module circled_pattern(number) {
    rotation_angle = 360 / number;
    last_angle = 360 - rotation_angle;
    for(rotation = [0 : rotation_angle : last_angle])
        rotate([0, 0, rotation])
        children();
}

/* ** Vase ** */

module rounded_bump(diameter) {
    translate([diameter / 2 - width_of_bump / 8, 0, 0])
    scale([0.8,1,1])
    circle(d = width_of_bump, center = true);
}

module triangle_bump(diameter) {
    triangle_height = sqrt(3) / 2 * width_of_bump;
    translate([diameter / 2, 0, 0])
    circle(d = width_of_bump, $fn=3, center = true);
}

module bump(diameter) {
    if (type_of_bump == "Rounded") rounded_bump(diameter);
    else if (type_of_bump == "Triangle") triangle_bump(diameter);
}

module edge_bumps(diameter) {
    circled_pattern(number_of_bumps)
        bump(diameter);
}

module vase_base(diameter) {
    circle(d = diameter, center = true);
    if (type_of_bump != "None") edge_bumps(diameter);
}

/* ** Main object ** */

module twisted_vase(diameter, height) {
    linear_extrude(height = height, convexity = 1, twist = degrees_of_twist, slices = number_of_slices, scale=[top_scale_x / 100, top_scale_y / 100])
    vase_base(diameter);
}

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

module complex_vase(diameter, height) {
    union() {
        for( z_offset = [ 0 : z_step : height ] ) {
            z_height = height / z_step;
            translate([0, 0, z_offset])
            linear_extrude(
                height = z_step,
                convexity = 10,
                twist = - degrees_of_twist / z_height, 
                slices = number_of_slices / z_height
            )
            rotate([0, 0, degrees_of_twist / height * z_offset])
            vase_base(diameter);
        }
        //linear_extrude(height = z_change, convexity = 1, 

        // TODO: multiple scale points vertically
    }
}

module vase() {
    if (type_of_vase == "Twisted vase") twisted_vase(diameter_of_vase, height_of_vase);
    else if (type_of_vase == "Bulbed bowl") bulbed_bowl(diameter_of_vase, height_of_vase);
    else if (type_of_vase == "Bulbed vase") bulbed_vase(diameter_of_vase, height_of_vase);
    else if (type_of_vase == "Complex Vase") complex_vase(diameter_of_vase, height_of_vase);
}

vase();
