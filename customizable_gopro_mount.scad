// Customizable GoPro mount for Anet A6 Z motor
// Copyright: Olle Johansson 2019
// License: CC BY-SA

// 31 between mount holes
// 12 mm deep
// 7 mm to holes from edge

// 19 mm diameter of z axis
// 23 mm to center of z axis

//CUSTOMIZER VARIABLES

// Angle of GoPro mount
gopro_angle = 0; // [-25:25]

// Width in mm of bracket
bracket_width = 45;

// Depth in mm of bracket
bracket_depth = 14;

// Thickness in mm of bracket
bracket_thickness = 4;

// Radius in mm of bracket corners
bracket_corner_radius = 3; // [1:0.5:5]

// Diameter in mm of mount screw holes
mount_hole_diameter = 3;

// Distance in mm between mount screw holes
mount_hole_distance = 31;

// Position of trapped nut
trapped_nut_position = 0; // [180:Left, 0:Right]

// Distance in mm from edge to center of mount hole
mount_hole_distance_from_edge = 7;

// Distance in mm to center of Z axis
z_axis_distance = 23;

// Diameter in mm of Z axis hole
z_axis_diameter = 23;

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

module mount_holes(hole_diameter, hole_distance, hole_edge, depth, thickness) {
    translate([hole_distance / 2, hole_edge - depth / 2, 0])
    rotate([0, 0, 90])
    cylinder_outer(hole_diameter, thickness, $fn);
    translate([-hole_distance / 2, hole_edge - depth / 2, 0])
    rotate([0, 0, 90])
    cylinder_outer(hole_diameter, thickness, $fn);
}

module mount_bracket(width, depth, thickness, radius, hole_diameter, hole_distance, hole_edge) {
    difference() {
        cube_rounded(width, depth, thickness, radius);
        
        // Mount holes
        mount_holes(hole_diameter, hole_distance, hole_edge, depth, thickness);
    }
}

module gopro_arm(width, length) {
    polyhedron(points=[
        [0, 0, 0], // 0 B UL
        [width, 0, 0], // 1 B UR
        [width, -length, 0], // 2 B LR
        [0, -length, 0], // 3 B LL
        [width, -length, gopro_size], // 4 T LR
        [0, -length, gopro_size] // 5 T LL
    ],
    faces=[
        [0, 3, 2, 1], // Bottom
        [0, 1, 4, 5], // Top
        [3, 5, 4, 2], // Back
        [0, 5, 3], // Left
        [2, 4, 1], // Right
    ]);
}

module gopro_mount(bracket_depth, bracket_thickness, angle) {
    translate([0, - gopro_size / 2 - bracket_depth / 2, gopro_size / 2 - bracket_thickness / 2])
    rotate([angle, 0, 90])
    mount3();

    translate([-10.5, bracket_depth / 2, - bracket_thickness / 2])
    gopro_arm(21, bracket_depth);
}

module gopro_bracket() {
    difference() {
        union() {
            mount_bracket(bracket_width, bracket_depth, bracket_thickness, bracket_corner_radius, mount_hole_diameter, mount_hole_distance, mount_hole_distance_from_edge);

            translate([0, - abs(gopro_angle) / 6, 0])
            rotate([0, 0, gopro_angle])
            gopro_mount(bracket_depth, bracket_thickness, trapped_nut_position);
        }

        // Z axis cutout
        translate([0, z_axis_distance - bracket_depth / 2, 0])
        cylinder_outer(z_axis_diameter, bracket_thickness, $fn);
    }
}

gopro_bracket();