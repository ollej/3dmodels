// Customizable Filament Pickup for the E3D Tool Changer
// Copyright: Olle Wreede 2020
// License: CC BY-SA

// TODO
// * Add hole for bowden coupling
// * Add filter

//CUSTOMIZER VARIABLES

// Height in mm of pickup
height = 60; // [30:5:100]

// Width in mm of pickup base
width = 15; // [15:30]

// Depth in mm of pickup base
depth = 9; // [5:0.5:15]

// Width in mm of pickup top
width_top = 15; // [10:20]

// Depth in mm of pickup top
depth_top = 9; // [5:0.5:15]

// Diameter in mm of filament hole
filament_hole_diameter = 2.4; // [1.8:0.1:4]

// Diameter in mm of bowden tube hole
bowden_hole_diameter = 4.2; // [4:0.1:8]

// Diameter in mm of mount screw holes
mount_hole_diameter = 3; // [0:None, 2.5:M2.5, 3:M3, 4:M4, 5:M5, 6:M6]

// Distance in mm of mount holes from edge
mount_hole_distance = 15; // [10:0.5:20]

//CUSTOMIZER VARIABLES END

/* [Hidden] */

$fn=120;

/* Helper modules */

module cylinder_outer(diameter, height, fn) {
   fudge = 1 / cos(180 / fn);
   cylinder(h=height, r=diameter / 2 * fudge, $fn=fn, center=true);
}

module cube_rounded(width, height, thickness, radius=1) {
	minkowski() {
		cube([width - 2 * radius, height - 2 * radius, thickness/2], center = true);
		cylinder(r = radius, h = thickness/2, center = true);
	}
}

/* Mount */

module mount_holes(hole_diameter, hole_distance, hole_depth) {
    translate([hole_distance / 2, 0, 0])
    cylinder_outer(hole_diameter, hole_depth, $fn);
    
    translate([-hole_distance / 2, 0, 0])
    cylinder_outer(hole_diameter, hole_depth, $fn);
}

module filament_pickup_base(width, depth, mount_hole_diameter, mount_hole_distance) {
    base_height = 15;
    
    translate([0, 0, width/2])
    difference() {
        union() {
            translate([-width/2, 0, 0])
            cylinder_outer(depth, base_height, $fn);

            cube([width, depth, base_height], center=true);

            translate([width/2, 0, 0])
            cylinder_outer(depth, base_height, $fn);
        }
    }
}

module filament_pickup_top(width, depth, height, filament_hole_diameter, bowden_hole_diameter) {
    translate([0, 0, height])
    rotate([0, 90, 0])
    cylinder_outer(depth, width, $fn);
}

module filament_pickup(width, height, depth, filament_hole_diameter, bowden_hole_diameter, mount_hole_diameter, mount_hole_distance, width_top, depth_top) {

    difference() {
        hull() {
            filament_pickup_base(width, depth, mount_hole_diameter, mount_hole_distance);
            filament_pickup_top(, width_top, depth_top, height, filament_hole_diameter, bowden_hole_diameter);
        }
        
        // Filament hole
        translate([0, 0, height])
        rotate([0, 90, 0]) {
            translate([0, 0, -width/2])
            cylinder_outer(filament_hole_diameter, width, $fn);
            
            // Inner filament hole fillet
            cylinder(h=1, d1=filament_hole_diameter, d2=filament_hole_diameter+1, center=true);
            
            // Outer filament hole fillet
            translate([0, 0, -width_top/2 - 0.35])
            #cylinder(h=2, d1=filament_hole_diameter+1, d2=filament_hole_diameter, center=true);

            // Bowden hole
            translate([0, 0, width/2])
            cylinder_outer(bowden_hole_diameter, width, $fn);

            // Outer bowden hole fillet
            translate([0, 0, width_top/2 + 0.35])
            #cylinder(h=2, d1=bowden_hole_diameter, d2=bowden_hole_diameter+1, center=true);
        }

        // Mount holes
        mount_hole_depth = 8.5;
        translate([0, 0, mount_hole_depth/2])
        #mount_holes(mount_hole_diameter, mount_hole_distance, mount_hole_depth);
    }
}

filament_pickup(
    width,
    height,
    depth,
    filament_hole_diameter,
    bowden_hole_diameter,
    mount_hole_diameter,
    mount_hole_distance,
    width_top,
    depth_top);