// Customizable LED strip extrusion mount
// Copyright: Olle Wreede 2020
// License: CC BY-SA

//CUSTOMIZER VARIABLES

// Width of extrusion profile
extrusion_width = 30; // [20:20 mm, 30:30 mm]

// Slot mount option
extrusion_slot_mount = 1; // [0:None, 1:Slot Ridge]

// Width in mm of bracket
bracket_width = 30; // [15:1:60]

// Length in mm of bracket
bracket_length = 350; // [150:10:500]

// Thickness in mm of bracket
bracket_thickness = 4; // [2:0.5:6]

// Radius in mm of bracket corners
bracket_corner_diameter = 3; // [1:0.5:5]

// Width in mm of LED wedge
led_wedge_width = 15; // [10:20]

// Height in mm of LED wedge
led_wedge_height = 15; // [5:20]

// Width in mm of cutoff of top of wedge
led_wedge_corner_diameter = 2; // [0:0.2:5]

// Diameter in mm of mount screw holes
mount_hole_diameter = 4; // [0:None, 3:M3, 4:M4, 5:M5, 6:M6]

// Distance in mm of mount holes from edge
mount_hole_distance = 10; // [4:0.5:10]

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

// TODO:
// * Add snap fit mounting option

$fn=120;

// slot_width = (extrusion_width == 30) ? 8 : 6;
// slot_thickness = (extrusion_width == 30) ? 2 : 1.8;

extrusion_slot_width = (extrusion_width == 30) ? 10.1 : 6.9;
extrusion_slot_thickness = (extrusion_width == 30) ? 1 : 0.5; 

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

module slot_ridge(height, thickness, slot_width, slot_thickness) {
    rotate([0, 0, 90])
    translate([- height / 2, -slot_width / 2, - thickness / 2 - slot_thickness])
    cube([height, slot_width, slot_thickness]);
}

module mount_bracket(width, height, thickness, corner_diameter, hole_diameter, hole_distance, slot_width, slot_thickness) {
    difference() {
        union() {
            cube_rounded(width, height, thickness, corner_diameter);
        
            if (slot_thickness > 0) {
                slot_ridge(height, thickness, slot_width, slot_thickness);
            }
        }
        
        // Mount holes
        if (hole_diameter > 0) {
            hole_depth = thickness + slot_thickness;
            rotate([0, 0, 90])
            translate([0, 0, - slot_thickness / 2])
            #mount_holes(hole_diameter, height - hole_distance * 2, hole_depth);
        }
    }
}

module led_wedge(width, height, length, corner_diameter) {
    translate([width / 2, length / 2, 0])
    rotate([90, 270, 0])
    linear_extrude(height=length)
    hull() {
        polygon(points=[
            [0, 0],
            [0, width],
            [height - corner_diameter / 2, width],
            [height - corner_diameter / 2, width - corner_diameter]
        ]);
        translate([height - corner_diameter / 2, width - corner_diameter/2, 0])
        #circle(d = corner_diameter, center=true);
    }
}

module led_strip_mount() {
    union() {
        mount_bracket(
            bracket_width,
            bracket_length,
            bracket_thickness,
            bracket_corner_diameter,
            mount_hole_diameter,
            mount_hole_distance,
            extrusion_slot_width,
            extrusion_slot_mount > 0
                ? extrusion_slot_thickness
                : 0);
        
        translate([0, 0, bracket_thickness / 2])
        led_wedge(
            led_wedge_width,
            led_wedge_height,
            bracket_length - mount_hole_distance * 4,
            led_wedge_corner_diameter);
    }
}

led_strip_mount();