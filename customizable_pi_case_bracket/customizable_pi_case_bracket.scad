// Customizable Raspberry Pi Case Extrusion Bracket
// Copyright: Olle Wreede 2020
// License: CC BY-SA

//CUSTOMIZER VARIABLES

// Thickness in mm of bracket
bracket_thickness = 4; // [2:0.25:8]

// Radius of corners of bracket
bracket_corner_radius = 1; // [0:0.5:2.5]

// Diameter in mm of mount screw holes
mount_hole_diameter = 4; // [0:None, 3:M3, 4:M4, 5:M5, 6:M6]

// Add slot ridge on back of mount plate
extrusion_slot_ridge = 1; // [0:No, 1:Yes]

// Thickness in mm of back plate
plate_thickness = 4; // [2:0.5:8]

// Depth in mm of Pi case holder
case_depth = 6; // [1:0.5:10]

// Diameter in mm of fan hole on case
fan_hole_diameter = 30; // [20:1:40]

// Air gap in mm behind pi case
air_gap_width = 5; // [0:1:8]

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
// +3mm från kant och botten

// lägg till slot ridge

$fn=120;

slot_width = 8;
slot_thickness = 2;


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
    cylinder_outer(hole_diameter, hole_depth, $fn);
    
    translate([-hole_distance, -hole_distance, 0])
    cylinder_outer(hole_diameter, hole_depth, $fn);
}

module side_plate(thickness, plate_thickness, case_depth, pi_width, corner_radius, fan_diameter) {
    translate([
        plate_height / 2, // Z
        60/2 - thickness, // Y
        -plate_thickness / 2 // X
    ])
    rotate([0, 90, 90])
    difference() {
        linear_extrude(height=thickness)
        polygon(points=[
            [0, case_depth + thickness],
            [pi_width, case_depth + thickness],
            [0, 60 - corner_radius]
        ]);

        // Fan hole
        translate([
            pi_width / 2 + 1, // X
            32.5 + thickness, // Z
            thickness / 2 // Y
        ])
        #cylinder_outer(fan_diameter, thickness, $fn);
    }
}

module slot_ridge(plate_thickness, plate_height, hole_distance) {
    translate([
        0,
        -hole_distance,
        plate_thickness / 2 + slot_thickness / 2
    ])
    cube([plate_height, slot_width, slot_thickness], center=true);

    translate([
        0,
        hole_distance,
        plate_thickness / 2 + slot_thickness / 2
    ])
    cube([plate_height, slot_width, slot_thickness], center=true);
}

module mount_plate(pi_width, pi_height, thickness, plate_thickness, plate_height, case_depth, corner_radius, fan_diameter, air_gap, slot_ridge) {
    translate([0, air_gap, 0])
    translate([
        pi_width / 2 + plate_thickness / 2,
        -pi_height / 2 + thickness,
        plate_height / 2 - (case_depth + thickness) / 2])
    rotate([0, 90, 0])
    difference() {
        union() {
            // Back plate
            cube_rounded(60, plate_height, plate_thickness);

            // Hide rounded corner
            if (air_gap < corner_radius) {
                translate([60 / 2 - corner_radius / 2, plate_height / 2 - corner_radius / 2, 0])
                cube([corner_radius, corner_radius, plate_thickness], center=true);
            }

            // Side plate
            translate([0, -air_gap, 0])
            side_plate(thickness, plate_thickness, case_depth, pi_width, corner_radius, fan_diameter);

            if (slot_ridge == 1) {
                slot_ridge(plate_thickness, plate_height, 15);
            }
        }

        translate([0, 0, slot_ridge * slot_thickness / 2])
        mount_holes(mount_hole_diameter, 15, plate_thickness + slot_ridge * slot_thickness);
    }
}

module case_holder(pi_width, pi_height, thickness, radius, plate_thickness, plate_height, case_depth, fan_diameter, air_gap, slot_ridge) {
    difference() {
        cube_rounded(pi_width + thickness * 2, pi_height + thickness * 2, case_depth + bracket_thickness, radius);
        
        translate([0, 0, thickness / 2])
        cube([pi_width, pi_height, case_depth], center=true);
    }
    
    mount_plate(pi_width, pi_height, thickness, plate_thickness, plate_height, case_depth, radius, fan_diameter, air_gap, slot_ridge);
}

//side_plate(bracket_thickness, plate_thickness, case_depth, pi_width, bracket_corner_radius, fan_hole_diameter);
//mount_plate(pi_width, pi_height, bracket_thickness, plate_thickness, plate_height, case_depth, bracket_corner_radius, fan_hole_diameter, 0, extrusion_slot_ridge);

case_holder(pi_width, pi_height, bracket_thickness, bracket_corner_radius, plate_thickness, plate_height, case_depth, fan_hole_diameter, air_gap_width, extrusion_slot_ridge);