// Customizable Flow Meter Box
// Copyright: Olle Johansson 2018
// License: CC BY-SA

//CUSTOMIZER VARIABLES

// Width of the box in mm
width_of_box = 200; // [40:300]

// Length of the box in mm
length_of_box = 150; // [40:200]

// Height of the box in mm
height_of_box = 30; // [20:200]

// Thickness in mm of walls
thickness = 3; // [3:6]

// Radius in mm of rounded corners
corner_radius = 3; // [1:5]

// Angle in degrees of box top
angle_of_box_top = 60; // [0:85]

// Y offset in mm from center of displayotron
y_offset_displayotron = 40; // [0:100]

// Diameter in mm of vote buttons
diameter_of_vote_buttons = 60; // [20:100]

// X offset (negative) in mm of vote buttons from center
x_offset_vote_buttons = 40; // [0:20]

// Y offset in mm of vote buttons from center
y_offset_vote_buttons = 25; // [0:20]

left_distance_of_usb = 20;

bottom_distance_of_usb = 5;

//CUSTOMIZER VARIABLES END

/* [Hidden] */

$fn=100;

/* ** Utility modules ** */

module rectangle_rounded(width, height, radius=1) {
	minkowski() {
		circle(r = radius);
		square([width - 2 * radius, height - 2 * radius], center = true);
	}
}

/* ** Partials ** */

module main_box() {
    // Top
    rotate([angle_of_box_top, 0, 0])
    translate([0, 0, height_of_box]) {
        box_top();
    }

    // Walls
/*
    linear_extrude(height_of_box) {
        difference() {
            rectangle_rounded(width_of_box, length_of_box, corner_radius);
            rectangle_rounded(width_of_box - thickness, length_of_box - thickness, corner_radius);
        }
    }
*/
}

module box_top() {
    linear_extrude(height = thickness)
    difference() {
        rectangle_rounded(width_of_box, length_of_box, corner_radius);

        displayotron();
        vote_buttons();
    }
}

module bottom_lid() {
    // Base
    linear_extrude(height = thickness)
    rectangle_rounded(width_of_box, length_of_box, corner_radius);
    // TODO: Add ridge
    // TODO: Add latches
}

module vote_buttons() {
    translate([- x_offset_vote_buttons, - y_offset_vote_buttons, 0])
    circle(d = diameter_of_vote_buttons);
    translate([x_offset_vote_buttons, - y_offset_vote_buttons, 0])
    circle(d = diameter_of_vote_buttons);
}

module control_buttons() {
}

module displayotron() {
    displayotron_width = 56;
    displayotron_height = 30;
    translate([0, y_offset_displayotron, 0])
    rectangle_rounded(displayotron_width, displayotron_height);
}

module USB() {
    usb_w = 12;
    usb_h = 8;
    translate([left_distance_of_usb, bottom_distance_of_usb + thickness + usb_h/2, 0])
        rectangle_rounded(usb_w, usb_h);
}

/* ** Main object ** */

module flow_meter_box() {
    difference() {
        main_box();
        
        control_buttons();
        USB();
    }
}

flow_meter_box();
