// Customizable Flow Meter Box
// Copyright: Olle Johansson 2018
// License: CC BY-SA

//CUSTOMIZER VARIABLES

// Width of the box in mm
width_of_box = 220; // [100:300]

// Length of the box in mm
length_of_box = 82; // [40:200]

// Height of the box in mm
height_of_box = 0; // [20:200]

// Thickness in mm of walls
thickness = 4; // [1:6]

// Radius in mm of rounded corners
corner_radius = 3; // [1:5]

// Percent to scale length of box
length_scale = 80; // [60:130]

// Angle in degrees of box top
angle_of_box_top = 60; // [0:85]

// Y offset in mm from center of displayotron
y_offset_displayotron = 0; // [-40:40]

// Diameter in mm of vote buttons
diameter_of_vote_buttons = 24; // [20:100]

// X offset in mm of vote buttons from center
x_offset_vote_buttons = 69; // [0:80]

// Y offset in mm of vote buttons from center
y_offset_vote_buttons = 0; // [-40:40]

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

module hole(x, y, d=2.75) {
    translate([x, y, 0]) circle(d=d);
}

module four_holes(width=65, height=30, d=2.75) {
    hole(width/2, height/2, d);
    hole(width/2, - height/2, d);
    hole(- width/2, height/2, d);
    hole(- width/2, - height/2, d);
}

/* ** Partials ** */

module main_box() {
    // Top
    rotate([angle_of_box_top, 0, 0])
    translate([0, 0, height_of_box]) {
        box_top();
    }

    // Walls
    y_scale = length_scale / 100;
    linear_extrude(height_of_box, scale = [1, y_scale]) {
        difference() {
            rectangle_rounded(width_of_box, length_of_box / y_scale, corner_radius);
            rectangle_rounded(width_of_box - thickness, length_of_box / y_scale - thickness, corner_radius);
        }
    }
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

module vote_button(x_pos, y_pos, btn_color) {
    %translate([x_pos, y_pos, 0])
    color(btn_color)
    circle(d = 62);
    
    translate([x_pos, y_pos, 0])
    circle(d = diameter_of_vote_buttons);
    
    pin_distance = 18.8;
    translate([x_pos - pin_distance, y_pos, 0])
    circle(d = 4);
    translate([x_pos + pin_distance, y_pos, 0])
    circle(d = 4);
}

module vote_buttons() {
    vote_button(- x_offset_vote_buttons, y_offset_vote_buttons, "GREEN");
    vote_button(x_offset_vote_buttons, y_offset_vote_buttons, "RED");
}

module control_buttons() {
}

module displayotron() {
    // HAT size_ 65 * 56.5
    displayotron_width = 56;
    displayotron_height = 30;
    translate([0, y_offset_displayotron, 0]) {
        translate([2.25, 0, 0])
        rectangle_rounded(displayotron_width + 4.5, displayotron_height);
    
        translate([0, 2, 0])
        four_holes(width = 58, height = 49);
    }
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

module cut_box() {
    difference() {
        flow_meter_box();
        translate([90, 0, 0])
        #cube([100,100,100], center = true);
        translate([-90, 0, 0])
        #cube([100,100,100], center = true);
    }
}

flow_meter_box();
//cut_box();
