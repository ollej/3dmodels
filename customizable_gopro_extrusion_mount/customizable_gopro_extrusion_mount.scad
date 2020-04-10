// Customizable GoPro extrusion mount
// Copyright: Olle Wreede 2020
// License: CC BY-SA

//CUSTOMIZER VARIABLES

// Width of extrusion profile
extrusion_width = 30; // [20:20 mm, 30:30 mm]

// Slot mount option
slot_mount = 1; // [0:None, 1:Slot Ridge, 2:Twist Nut, 3:Twist Nut Rotated]

// Extended height in mm of GoPro mount
mount_height = 0; // [0:1:10]

// Width in mm of bracket
bracket_width = 45; // [40:1:60]

// Thickness in mm of bracket
bracket_thickness = 4; // [3:1:6]

// Radius in mm of bracket corners
bracket_corner_radius = 3; // [1:0.5:5]

// Diameter in mm of mount screw holes
mount_hole_diameter = 4; // [0:None, 3:M3, 4:M4, 5:M5, 6:M6]

// Distance in mm between mount screw holes
mount_hole_distance = 32; // [25:1:40]

//CUSTOMIZER VARIABLES END

/* [Hidden] */

// 3030 slot
// 8.2mm slot hole width
// 16.5 slot width
// 2mm thickness

// 2020 slot
// 6.2 mm slot hole width
// 11 mm slot width
// 1.8 thickness


$fn=120;

gopro_size = 15;

slot_width = (extrusion_width == 30) ? 8 : 6;
slot_thickness = (extrusion_width == 30) ? 2 : 1.8;


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

module mount_holes(hole_diameter, hole_distance, hole_depth) {
    translate([hole_distance / 2, 0, 0])
    rotate([0, 0, 90])
    cylinder_outer(hole_diameter, hole_depth, $fn);
    
    translate([-hole_distance / 2, 0, 0])
    rotate([0, 0, 90])
    cylinder_outer(hole_diameter, hole_depth, $fn);
}

module slot_ridge(width, thickness, slot_width, slot_thickness) {
    translate([- width / 2, -slot_width / 2, - thickness / 2 - slot_thickness])
    cube([width, slot_width, slot_thickness]);
}

module twist_nut(hole_diameter, bracket_thickness, angle) {
    cylinder_diameter = 8;
    cylinder_height = 6;
    nut_width = 16;
    nut_height = cylinder_height - slot_thickness;
    translate([0, 0, -cylinder_height/2 - bracket_thickness/2])
    rotate([180, 0, angle])
    union() {
        cylinder_outer(cylinder_diameter, cylinder_height, $fn);

        translate([-nut_width / 2, 0, slot_thickness/2 - nut_height/2])
        rotate([90, 0, 0])
        linear_extrude(height = cylinder_diameter, center=true)
        polygon(points=[
            [0, 0],
            [nut_width, 0],
            [nut_width, 1],
            [nut_width/2 + cylinder_diameter/2, nut_height],
            [nut_width/2 - cylinder_diameter/2, nut_height],
            [0, 1]
        ]);

    }
}

module mount_bracket(width, depth, thickness, radius, hole_diameter, hole_distance, slot_thickness) {
    difference() {
        union() {
            cube_rounded(width, depth, thickness, radius);
        
            if (slot_thickness > 0) {
                slot_ridge(width, thickness, slot_width, slot_thickness);
            }
        }
        
        // Mount holes
        if (hole_diameter > 0) {
            hole_depth = thickness + slot_thickness;
            //echo("hole_depth: ", thickness, hole_depth);
            translate([0, 0, - slot_thickness / 2])
            #mount_holes(hole_diameter, hole_distance, hole_depth);
        }
    }
}

module gopro_mount(bracket_thickness, mount_height) {
    translate([0, 0, gopro_size / 2 + bracket_thickness / 2 + mount_height])
    rotate([0, 90, 90])
    mount3(mount_height);
}

module gopro_bracket() {
    slot_ridge_thickness = (slot_mount == 1) ? slot_thickness : 0;
    mount_bracket(
        bracket_width,
        extrusion_width,
        bracket_thickness,
        bracket_corner_radius,
        mount_hole_diameter,
        mount_hole_distance,
        slot_ridge_thickness);

    gopro_mount(bracket_thickness, mount_height);

    if (slot_mount >= 2) {
        nut_angle = (slot_mount - 2) * 90;
        twist_nut(mount_hole_diameter, bracket_thickness, nut_angle);
    }
}

gopro_bracket();