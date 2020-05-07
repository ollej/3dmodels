// Customizable Stepdown Converter Case
// Copyright: Olle Wreede 2020
// License: CC BY-SA

//CUSTOMIZER VARIABLES

/* [Base values] */

// Inner height in mm of case
height_of_case = 18; // [15:30]

// Inner width in mm of case
width_of_case = 25; // [15:35]

// Inner length in mm of case
length_of_case = 55; // [30:100]

// Thickness in mm of case walls
wall_thickness = 3; // [1:0.5:5]

// Corner radius in mm of case
corner_radius_of_case = 1; // [0:0.1:3]

// Diameter in mm of mount screw holes
mount_hole_diameter = 2.5; // [0:None, 2.5:M2.5, 3:M3, 4:M4]

//CUSTOMIZER VARIABLES END

/* [Hidden] */

$fn=20;
fudge = 0.1;
right_hole_ypos = 17.2;
left_hole_ypos = -17.7;

// TODO: Add holes for cables
// TODO: Create lid
// TODO: Add extrusion mount
// TODO: Raised bottom, 7.5 from holes towards center
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

/* Model */

module mount_holes(diameter, depth, width, length, height) {
    translate([9.95, right_hole_ypos, -height/2 - depth/2])
    cylinder_outer(diameter, depth + fudge, $fn);

    translate([-9.85, left_hole_ypos, -height/2 - depth/2])
    cylinder_outer(diameter, depth + fudge, $fn);
}

module raised_bottom(width, length, height, thickness, hole_diameter) {
    raised_bottom_zpos = -height / 2 + thickness / 2;
    difference() {
        union() {
            raised_bottom_length = 7.5 + hole_diameter + 2;
            translate([
                0,
                right_hole_ypos + hole_diameter/2 + 2 - raised_bottom_length / 2,
                raised_bottom_zpos])
            cube([width, 9.5 + hole_diameter, thickness], center=true);
            
            translate([
                0,
                left_hole_ypos - hole_diameter/2 - 2 + raised_bottom_length / 2,
                raised_bottom_zpos])
            cube([width, 9.5 + hole_diameter, thickness], center=true);
        }
        
        translate([0, 0, thickness])
        mount_holes(hole_diameter, thickness, width, length, height);
    }
}

module case(width, length, height, thickness, corner_radius, hole_diameter) {
    difference() {
        cube_rounded(
            width + thickness * 2,
            length + thickness * 2,
            height + thickness * 2,
            corner_radius);

        cube_rounded(
            width,
            length,
            height,
            corner_radius);
   
        mount_holes(hole_diameter, thickness, width, length, height);
        
        // Cable holes
        translate([0, length / 2 + thickness / 2, - height / 2 + 5 + thickness])
        rotate([0, 90, 90])
        cylinder_outer(3, thickness + fudge, $fn);
        translate([0, -length / 2 - thickness / 2, - height / 2 + 5 + thickness])
        rotate([0, 90, 90])
        cylinder_outer(3, thickness + fudge, $fn);
        
        // Remove lid
        translate([0, 0, height / 2 + thickness / 2 ])
        cube([
            width + thickness * 2 + fudge,
            length + thickness * 2 + fudge,
            thickness + fudge],
            center = true);
    }
    
    raised_bottom(width, length, height, thickness, hole_diameter);
}

case(
    width_of_case,
    length_of_case,
    height_of_case + wall_thickness,
    wall_thickness,
    corner_radius_of_case,
    mount_hole_diameter);