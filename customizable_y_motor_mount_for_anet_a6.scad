// Customizable Y Motor Mount for Anet A6
// Copyright: Olle Johansson 2019
// License: CC BY-SA

//CUSTOMIZER VARIABLES

// Thickness in mm of backplate
backplate_thickness = 6; // [4:10]

// Distance in mm that motor is lowered from default
motor_lowered_by = 2; // [0:0.1:4]

// Use round or teardrop mount holes
type_of_mount_hole = "Teardrop"; // [Teardrop, Round]

// Diameter in mm of mount hole
mount_hole_diameter = 3; // [2:0.1:4]

// Length in mm of mount hole
mount_hole_length = 12; // [8:0.1:14]

depth_of_trapped_nut_hole = 2.6;

width_of_trapped_nut_hole = 7;

height_of_trapped_nut_hole = 5.4;

//CUSTOMIZER VARIABLES END

/* [Hidden] */

height_of_base = 15 - motor_lowered_by;

$fn=120;


/* From http://www.thingiverse.com/thing:3457
   © 2010 whosawhatsis */
module teardrop(radius, length, angle) {
	rotate([0, angle, 0]) union() {
		linear_extrude(height = length, center = true, convexity = radius, twist = 0)
			circle(r = radius, center = true, $fn = 30);
		linear_extrude(height = length, center = true, convexity = radius, twist = 0)
			projection(cut = false) rotate([0, -angle, 0]) translate([0, 0, radius * sin(45) * 1.5]) cylinder(h = radius * sin(45), r1 = radius * sin(45), r2 = 0, center = true, $fn = 30);
    }
}

module cylinder_outer(diameter, height, fn) {
   fudge = 1 / cos(180 / fn);
   cylinder(h=height, r=diameter / 2 * fudge, $fn=fn, center=true);
}

module mount_hole(diameter, length) {
    if (type_of_mount_hole == "Teardrop") {
        rotate([0, 270, 0])
        teardrop(diameter/2, length, 90);
    } else {
        cylinder_outer(diameter, length, $fn);
    }
}

module motor_mount_plate() {
    translate([51/2, 47 - 8/2, 56/2])
    difference() {
        cube([51, 8, 56], center=true);
        
        // Motor shaft hole
        translate([6/3, 0, height_of_base/2])
        rotate([90, 0, 0])
        cylinder_outer(23, 8, $fn);
        
        // Motor mount holes
        translate([6/3 - 31/2, 0, height_of_base/2 + 31/2])
        rotate([90, 90, 0])
        mount_hole(mount_hole_diameter, 8, $fn);
        
        translate([6/3 - 31/2, 0, height_of_base/2 - 31/2])
        rotate([90, 90, 0])
        mount_hole(mount_hole_diameter, 8, $fn);
        
        translate([6/3 + 31/2, 0, height_of_base/2 + 31/2])
        rotate([90, 90, 0])
        mount_hole(mount_hole_diameter, 8, $fn);
 
        translate([6/3 + 31/2, 0, height_of_base/2 - 31/2])
        rotate([90, 90, 0])
        mount_hole(mount_hole_diameter, 8, $fn);
   }    
}

module bottom_plate() {
    translate([51/2, 47/2, height_of_base/2])
    difference() {
        cube([51, 47, height_of_base], center=true);

        translate([0, 0, -4])
        cube([51, 31, 8], center=true);
    }
}

module back_plate() {
    translate([3, 47/2, 43/2])
    cube([backplate_thickness, 47, 43], center=true);
    
    translate([-4, 47 - 8/2, 43/2 + 15/2])
    cube([8, 8, 15], center=true);
    
    translate([-4, 8/2, 43/2 + 15/2])
    cube([8, 8, 15], center=true);
}

module backplate_mount_holes() {
    translate([backplate_thickness, 4, 10])
    rotate([0, 90, 0])
    %mount_hole(mount_hole_diameter, mount_hole_length);
    
    // Trapped nut hole
    translate([backplate_thickness, width_of_trapped_nut_hole/2, 10])
    cube([depth_of_trapped_nut_hole, width_of_trapped_nut_hole, height_of_trapped_nut_hole], center=true);

    translate([backplate_thickness, 47-4, 10])
    rotate([0, 90, 0])
    mount_hole(mount_hole_diameter, mount_hole_length);

    // Trapped nut hole
    translate([backplate_thickness, 47 - width_of_trapped_nut_hole/2, 10])
    cube([depth_of_trapped_nut_hole, width_of_trapped_nut_hole, height_of_trapped_nut_hole], center=true);

    translate([backplate_thickness, 47-4, 39])
    rotate([0, 90, 0])
    mount_hole(mount_hole_diameter, mount_hole_length);
    
    // Trapped nut hole
    translate([backplate_thickness, 47 - width_of_trapped_nut_hole/2, 39])
    cube([depth_of_trapped_nut_hole, width_of_trapped_nut_hole, height_of_trapped_nut_hole], center=true);
}

module motor_mount() {
    difference() {
        union() {
            bottom_plate();
            back_plate();
            motor_mount_plate();
        }
        
        backplate_mount_holes();
    }
}

motor_mount();