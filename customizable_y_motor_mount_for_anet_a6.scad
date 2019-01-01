// Customizable Y Motor Mount for Anet A6
// Copyright: Olle Johansson 2018
// License: CC BY-SA

//CUSTOMIZER VARIABLES

backplate_thickness = 6;

type_of_mount_hole = "Teardrop"; // [Teardrop, Round]
mount_hole_diameter = 3;
mount_hole_length = 12;

//CUSTOMIZER VARIABLES END

/* [Hidden] */

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
        translate([6/3, 0, 15/2])
        rotate([90, 0, 0])
        cylinder_outer(23, 8, $fn);
        
        // Motor mount holes
        translate([6/3 - 31/2, 0, 15/2 + 31/2])
        rotate([90, 90, 0])
        mount_hole(mount_hole_diameter, 8, $fn);
        
        translate([6/3 - 31/2, 0, 15/2 - 31/2])
        rotate([90, 90, 0])
        mount_hole(mount_hole_diameter, 8, $fn);
        
        translate([6/3 + 31/2, 0, 15/2 + 31/2])
        rotate([90, 90, 0])
        mount_hole(mount_hole_diameter, 8, $fn);
 
        translate([6/3 + 31/2, 0, 15/2 - 31/2])
        rotate([90, 90, 0])
        mount_hole(mount_hole_diameter, 8, $fn);
   }    
}

module bottom_plate() {
    translate([51/2, 47/2, 15/2])
    difference() {
        cube([51, 47, 15], center=true);

        translate([0, 0, -4])
        cube([51, 31, 7], center=true);
    }
}

module back_plate() {
    translate([3, 47/2, 43/2])
    cube([6, 47, 43], center=true);
    
    translate([-4, 47 - 8/2, 43/2+15/2])
    cube([8, 8, 15], center=true);
    
    translate([-4, 8/2, 43/2+15/2])
    cube([8, 8, 15], center=true);
}

module backplate_mount_holes() {
    translate([6, 4, 10])
    rotate([0, 90, 0])
    mount_hole(mount_hole_diameter, mount_hole_length);
    
    // Trapped nut hole
    translate([6, 3.5, 10])
    cube([2.6, 7, 5.4], center=true);    

    translate([6, 47-4, 10])
    rotate([0, 90, 0])
    mount_hole(mount_hole_diameter, mount_hole_length);

    // Trapped nut hole
    translate([6, 47-3.5, 10])
    cube([2.6, 7, 5.4], center=true);    

    translate([6, 47-4, 39])
    rotate([0, 90, 0])
    mount_hole(mount_hole_diameter, mount_hole_length);
    
    // Trapped nut hole
    translate([6, 47-3.5, 39])
    cube([2.6, 7, 5.4], center=true);
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