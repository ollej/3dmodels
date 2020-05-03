// Customizable GoPro angled extension
// Copyright: Olle Wreede 2020
// License: BSD License

//CUSTOMIZER VARIABLES

extension_width = 12; // [12:0.5:20]

extension_thickness = 15;  // [15:0.5:25]

extension_length = 50; // [25:5:200]

corner_radius = 2;

// Extended height in mm of GoPro mount
mount_height = 4; // [0:1:10]

// Rotate trapped nut in GoPro mount
rotate_gopro_nut = 90; // [0:No, 90:Yes]

//CUSTOMIZER VARIABLES END

/* [Hidden] */

$fn=120;

gopro_size = 15;
gopro_height = gopro_size + mount_height;

/*
 * GoPro Mount
 * by DMCShep, licensed under the BSD License license.
 * https://www.thingiverse.com/thing:3088912
 */

module nut_hole(nut_angle = 90)
{
	//rotate([0, 90, 0]) // (Un)comment to rotate nut hole
	rotate([90, nut_angle, 0])
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

module mount3(depth = 0, nut_angle = 90)
{
	union()
	{
		difference()
		{
			translate([0, -2.5, 0]) flap(8, depth);
			translate([0, -8.5, 0]) nut_hole(nut_angle);
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

/* Model */


module gopro_extension() {
    cube_rounded(
        extension_width,
        extension_thickness,
        extension_length,
        corner_radius);
    gopro_mount2_width = 11.5;
    gopro_mount3_width = 21;
    
    translate([gopro_mount2_width / 2, 0, -extension_length / 2 - mount_height - gopro_size / 2])
    rotate([0, 270, 90])
    mount2(mount_height);

    translate([
        -extension_width / 2 - gopro_size / 2,
        0,
        extension_length / 2 - gopro_mount3_width / 2])
    rotate([90, 0, 0])
    mount3(mount_height, rotate_gopro_nut);
}

gopro_extension();