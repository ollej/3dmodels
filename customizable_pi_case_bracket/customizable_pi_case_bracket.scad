// Customizable Raspberry Pi Case Extrusion Bracket
// Copyright: Olle Wreede 2020
// License: CC BY-SA

//CUSTOMIZER VARIABLES

// Thickness in mm of bracket
bracket_thickness = 2; // [2:1:6]

// Radius of corners of bracket
bracket_corner_radius = 1; // [0:0.5:2.5]

// Diameter in mm of mount screw holes
mount_hole_diameter = 4; // [0:None, 3:M3, 4:M4, 5:M5, 6:M6]

// Thickness in mm of back plate
plate_thickness = 4; // [2:0.5:8]

// Depth in mm of Pi case holder
case_depth = 5; // [1:0.5:10]

// Diameter in mm of fan hole on case
fan_hole_diameter = 30;

//CUSTOMIZER VARIABLES END

/* [Hidden] */

pi_width = 60.3;

pi_height = 30;

plate_height = 60;

// 30mm
// 90mm
// 60.3mm
// 5mm

// fläkthål
// 30 mm dia
// 30mm från sidan
// 32mm från botten

// Tjockare bakplatta
// Luftficka bakom pi

$fn=120;


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

module mount_holes(hole_diameter, hole_distance, hole_depth) {
    translate([hole_distance, -hole_distance, 0])
    #cylinder_outer(hole_diameter, hole_depth, $fn);
    
    translate([-hole_distance, -hole_distance, 0])
    #cylinder_outer(hole_diameter, hole_depth, $fn);
}

module side_plate(thickness, case_depth, pi_width, corner_radius, fan_diameter) {
    translate([0, 60/2 - thickness, thickness/2])
    rotate([0, 90, 90])
    difference() {
        linear_extrude(height=thickness)
        polygon(points=[
            [thickness, -30 + case_depth + thickness],
            [pi_width + thickness, -30 + case_depth + thickness],
            [thickness, 30 - corner_radius]
        ]);

        // Fan hole
        translate([30 + thickness, 2, thickness/2])
        cylinder_outer(fan_diameter, thickness, $fn);
    }
}

module mount_plate(pi_width, pi_height, thickness, plate_thickness, height, case_depth, corner_radius, fan_diameter) {
    translate([
        pi_width / 2 + plate_thickness / 2,
        -pi_height / 2 + thickness,
        height / 2 - (case_depth + thickness) / 2])
    rotate([0, 90, 0])
    difference() {
        union() {
            // Back plate
            cube_rounded(60, height, plate_thickness);

            // Side plate
            side_plate(thickness, case_depth, pi_width, corner_radius, fan_diameter);

            // Hide rounded corner
            translate([60 / 2 - corner_radius / 2, height / 2 - corner_radius / 2, 0])
            cube([corner_radius, corner_radius, plate_thickness], center=true);
        }

        mount_holes(mount_hole_diameter, 15, plate_thickness);
    }
}

module case_holder(pi_width, pi_height, thickness, radius, plate_thickness, plate_height, case_depth, fan_diameter) {
    difference() {
        cube_rounded(pi_width + thickness * 2, pi_height + thickness * 2, case_depth + bracket_thickness, radius);
        
        translate([0, 0, thickness / 2])
        cube([pi_width, pi_height, case_depth], center=true);
    }
    
    mount_plate(pi_width, pi_height, thickness, plate_thickness, plate_height, case_depth, radius, fan_diameter);
}

case_holder(pi_width, pi_height, bracket_thickness, bracket_corner_radius, plate_thickness, plate_height, case_depth, fan_hole_diameter);