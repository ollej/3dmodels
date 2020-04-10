// Customizable GoPro extrusion mount
// Copyright: Olle Wreede 2020
// License: CC BY-SA

//CUSTOMIZER VARIABLES

// Extended height in mm of GoPro mount
mount_height = 0; // [0:1:10]

// Width in mm of bracket
bracket_width = 45; // [40:1:60]

// Width of extrusion profile
extrusion_width = 30; // [15:15 mm, 20:20 mm, 30:30 mm, 40:40 mm]

// Thickness in mm of bracket
bracket_thickness = 4; // [3:1:6]

// Radius in mm of bracket corners
bracket_corner_radius = 3; // [1:0.5:5]

// Diameter in mm of mount screw holes
mount_hole_diameter = 4; // [3:M3, 4:M4, 5:M5, 6:M6]

// Distance in mm between mount screw holes
mount_hole_distance = 32; // [25:1:40]

//CUSTOMIZER VARIABLES END

/* [Hidden] */

$fn=120;

gopro_size = 15;

/*
 * GoPro Mount
 * by DMCShep, licensed under the BSD License license.
 * https://www.thingiverse.com/thing:3088912
 */

module nut_hole()
{
	rotate([0, 90, 0]) // (Un)comment to rotate nut hole
	rotate([90, 0, 0])
		for(i = [0:(360 / 3):359])
		{
			rotate([0, 0, i]) cube([4.6765, 8.1, 5], center = true);
		}
}

module flap(width, depth = 0)
{
	rotate([90, 0, 0])
	union()
	{
		translate([3.5, -7.5, 0]) cube([4 + depth, 15, width]);
		translate([0, -7.5, 0]) cube([7.5 + depth, 4, width]);
		translate([0, 3.5, 0]) cube([7.5 + depth, 4, width]);

		difference()
		{
			cylinder(h = width, d = 15);
			translate([0, 0, -1]) cylinder(h = width + 2, d = 6);
		}
	}
}

module mount2(depth = 0)
{
	union()
	{
		translate([0, 4, 0]) flap(3, depth);
		translate([0, 10.5, 0]) flap(3, depth);
	}
}

module mount3(depth = 0)
{
	union()
	{
		difference()
		{
			translate([0, -2.5, 0]) flap(8, depth);
			translate([0, -8.5, 0]) nut_hole();
		}

		mount2(depth);
	}
}

/* End of GoPro mount */

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

module mount_holes(hole_diameter, hole_distance, depth, thickness) {
    translate([hole_distance / 2, 0, 0])
    rotate([0, 0, 90])
    cylinder_outer(hole_diameter, thickness, $fn);
    
    translate([-hole_distance / 2, 0, 0])
    rotate([0, 0, 90])
    cylinder_outer(hole_diameter, thickness, $fn);
}

module mount_bracket(width, depth, thickness, radius, hole_diameter, hole_distance) {
    difference() {
        cube_rounded(width, depth, thickness, radius);
        
        // Mount holes
        mount_holes(hole_diameter, hole_distance, depth, thickness);
    }
}

module gopro_mount(bracket_thickness, mount_height) {
    translate([0, 0, gopro_size / 2 + bracket_thickness / 2 + mount_height])
    rotate([0, 90, 90])
    mount3(mount_height);
}

module gopro_bracket() {
    mount_bracket(
        bracket_width,
        extrusion_width,
        bracket_thickness,
        bracket_corner_radius,
        mount_hole_diameter,
        mount_hole_distance);

    gopro_mount(bracket_thickness, mount_height);
}

gopro_bracket();