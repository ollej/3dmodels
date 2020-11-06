// Customizable Tool Changer Purge Bucket
// Copyright: Olle Wreede 2020
// License: CC BY-SA

//CUSTOMIZER VARIABLES

/* [Base values] */

// Height in mm of bucket
height_of_bucket = 35; // [15:100]

// Width in mm of bucket
width_of_bucket = 66.8; // [60:0.2:75]

// Depth in mm of bucket
depth_of_bucket = 60; // [40:0.2:80]

// Cutout width in mm of wiper
wiper_cutout_width = 37.5; // [35:0.1:40]

// Cutout height in mm of wiper
wiper_cutout_height = 30; // [10:0.1:40]

// Thickness in mm of bucket walls
wall_thickness = 2; // [1:0.2:5]

// Diameter in mm of purge hole
diameter_of_purge_hole = 25; // [20:0.1:30]

//CUSTOMIZER VARIABLES END

/* [Hidden] */

$fn=120;
fudge = 0.1;

/* Helper modules */

module cylinder_outer(diameter, height, fn) {
   fudge = 1 / cos(180 / fn);
   cylinder(h=height, r=diameter / 2 * fudge, $fn=fn, center=true);
}

module cube_rounded(width, length, height, radius=1) {
	minkowski() {
		cube([width - 2 * radius, length - 2 * radius, height/2], center = true);
		cylinder(r = radius, h = height/2, center = true);
	}
}

/* Purge Bucket */

module purge_bucket(width, depth, height, cutout_width, cutout_height, diameter, thickness) {
    t = thickness * 2;

    difference() {
        union() {
            translate([width / 2 + thickness / 2, (diameter + t) / 2 - (depth + t) / 2, 0])
            cylinder_outer(diameter + t, height + thickness, $fn);
            
            cube([width + t, depth + t, height + thickness], center = true);
        }
        
        translate([0, 0, thickness]) {
            translate([width / 2 + thickness / 2, (diameter + t) / 2 - (depth + t) / 2, 0])
            cylinder_outer(diameter, height, $fn);

            cube([width, depth, height], center = true);
            
            translate([cutout_width / 2 - width / 2, depth / 2 + thickness / 2, height / 2 - cutout_height / 2 - thickness / 2 + fudge])
            cube([cutout_width, thickness + fudge, cutout_height + fudge], center = true);
        }
    }
}

purge_bucket(
    width = width_of_bucket,
    depth = depth_of_bucket,
    height = height_of_bucket,
    cutout_width = wiper_cutout_width,
    cutout_height = wiper_cutout_height,
    diameter = diameter_of_purge_hole,
    thickness = wall_thickness);