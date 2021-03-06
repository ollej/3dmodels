// Customizable Knife Holder
// Copyright: Olle Wreede 2019
// License: CC BY-SA

//CUSTOMIZER VARIABLES

// Width in mm of knife holder base
width_of_base = 15; // [10:1:30]

// Length in mm of knife holder base
length_of_base = 100; // [100:10:250]

// Height in mm of knife holder base
height_of_base = 5; // [3:0.5:8]

// Radius of corners of base in mm
radius_of_base_corners = 2; // [0:0.2:5]

// Height in mm of dividers
height_of_divider = 25; // [15:1:30]

// Thickness in mm of dividers
thickness_of_divider = 10; // [2:1:20]

// Number of dividers
number_of_dividers = 7; // [5:20]

// Radius of rounded tip of divider
radius_of_divider_tip = 5; // [0:0.5:15]

//CUSTOMIZER VARIABLES END

/* [Hidden] */

$fn = 100;

module rectangle_rounded(width, height, radius=1) {
	minkowski() {
		circle(r = radius);
		square([width - 2 * radius, height - 2 * radius], center = true);
	}
}

module triangle(height, width) {
    polygon(points = [
        [0, 0],
        [height, width / 2],
        [0, width]
    ]);
}

module rounded_triangle(height, width, radius=2) {
    difference() {
        triangle(height, width);
        
        translate([height - radius * 2, width/2, 0])
        difference() {
            translate([radius, 0, 0])
            square([radius * 2, radius * 2], center = true);
            circle(r = radius);
        }
    }
}

module base(width, length, height, radius) {
    linear_extrude(height = height, center = true)
    rectangle_rounded(length, width, radius);
}

module divider(height, width, thickness, tip_radius) {
    translate([0, -width / 2, 0])
    rotate([0, -90, 0])
    linear_extrude(height = thickness, center = true)
    rounded_triangle(height, width, tip_radius);
}

module dividers(width, length, height, thickness, number, tip_radius) {
    divider_distance = (length - number * thickness) / number;
    translate([ - (length - divider_distance) / 2 + thickness / 2, 0, 0])
    for(position = [0 : divider_distance + thickness : length - divider_distance])
        translate([position, 0, 0])
        divider(height, width, thickness, tip_radius);
}

module knife_holder() {
    union() {
        base(width=width_of_base, length=length_of_base, height=height_of_base, radius=radius_of_base_corners);
        translate([0, 0, height_of_base/2])
        dividers(width_of_base, length_of_base, height_of_divider, thickness_of_divider, number_of_dividers, radius_of_divider_tip);
    }
}

knife_holder();