// Customizable Flow Meter Box
// Copyright: Olle Johansson 2018
// License: CC BY-SA

//CUSTOMIZER VARIABLES

// Width of the box in mm
width_of_box = 100; // [40:200]

// Length of the box in mm
length_of_box = 80; // [40:200]

// Height of the box in mm
height_of_box = 30; // [20:200]

// Thickness in mm of walls
thickness = 3; // [3:6]

// Radius in mm of rounded corners
corner_radius = 3; // [1:5]

// Diameter in mm of vote buttons
diameter_of_vote_buttons = 60; // [20:100]

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
    // Base
    linear_extrude(height = thickness)
    rectangle_rounded(width_of_box, length_of_box, corner_radius);

    // Walls
    translate([0, 0, thickness]) {
        linear_extrude(height_of_box - thickness) {
            difference() {
                rectangle_rounded(width_of_box, length_of_box, corner_radius);
                rectangle_rounded(width_of_box - thickness, length_of_box - thickness, corner_radius);
            }
        }
    }
}

module vote_buttons() {
    translate([])
    circle(d = diameter_of_vote_buttons);
    translate([])
    circle(d = diameter_of_vote_buttons);
}

module control_buttons() {
}

module displayotron() {
    displayotron_width = 56;
    displayotron_height = 30;
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
        
        displayotron();
        vote_buttons();
        control_buttons();
        USB();
    }
}

flow_meter_box();
