// Customizable Wall Clock
// Copyright: Olle Johansson 2018
// License: CC BY-SA

//CUSTOMIZER VARIABLES

/* [Clock] */

// Height in mm
height = 20; // [10:50]

// Diameter in mm of clock face
diameter_of_clock = 150; // [100:300]

// Diameter in mm of center hole
diameter_of_hole = 4.0; // [3.0:0.1:10.0]

// Thickness in mm of walls
thickness_of_wall = 5; // [2:0.1:10]

/* [Hours] */

// Type of hour symbols
type_of_hours = "Rotated numbers"; // [None, Numbers, Rotated numbers, Text]

// Height in mm of numbers
height_of_numbers = 2; // [0.5:0.1:4]

// Distance in mm of numbers from edge
distance_of_numbers = 5; // [5:20]

// Font size of numbers
size_of_numbers = 12; // [5:20]

// Font of hour numbers
font_of_hour_numbers = "Gotham";

/* [Hour dots] */

// Show dots for each hour
show_dots = "yes"; // [yes, no]

// Diameter in mm of hour dots
diameter_of_dots = 5; // [2:20]

// Distance in mm of dots from clock edge
distance_of_dots = 25; // [5:40]

/* [Hour texts] */

text_hour_one = "ett";
text_hour_two = "två";
text_hour_three = "tre";
text_hour_four = "fyra";
text_hour_five = "fem";
text_hour_six = "sex";
text_hour_seven = "sju";
text_hour_eight = "åtta";
text_hour_nine = "nio";
text_hour_ten = "tio";
text_hour_eleven = "elva";
text_hour_twelve = "tolv";

//CUSTOMIZER VARIABLES END

/* [Hidden] */

$fn=120;

positions = [ for(angle = [30 : 30 : 360]) angle ];
hours = [
    text_hour_one,
    text_hour_two,
    text_hour_three,
    text_hour_four,
    text_hour_five,
    text_hour_six,
    text_hour_seven,
    text_hour_eight,
    text_hour_nine,
    text_hour_ten,
    text_hour_eleven,
    text_hour_twelve
];

/* ** Utility modules ** */

module circled_pattern(number) {
    rotation_angle = 360 / number;
    last_angle = 360 - rotation_angle;
    for(rotation = [rotation_angle : rotation_angle : 360])
        rotate([0, 0, rotation])
        children();
}

/* ** Main object ** */

module center_hole() {
    cylinder(h=height, d=diameter_of_hole);
}

module backside() {
    cylinder(
        h=height - thickness_of_wall,
        d=diameter_of_clock  - thickness_of_wall * 2);
}

module clock_face() {
    difference() {
        cylinder(h=height, d=diameter_of_clock);
        
        center_hole();
        backside();
    }
}

module hours() {
    if (type_of_hours == "Numbers") hours_numbers();
    else if (type_of_hours == "Rotated numbers") hours_rotated_numbers();
    else if (type_of_hours == "Text") hours_text();
}

module hours_rotated_numbers() {
    for (hour = [1:12]) {
        rotate([0, 0, -positions[hour - 1]])
        translate([diameter_of_clock / 2  - distance_of_numbers, 0, height])
        rotate([0, 0, 270])
        linear_extrude(height_of_numbers)
        text(str(hour), size = size_of_numbers, font = font_of_hour_numbers, halign = "center", valign = "top");
    }
}

module hours_numbers() {
    for (hour = [1:12]) {
        rotate([0, 0, -positions[hour - 1]])
        translate([diameter_of_clock / 2  - distance_of_numbers - size_of_numbers * 0.75, 0, height])
        rotate([0, 0, 270 + positions[hour - 1]])
        linear_extrude(height_of_numbers)
        text(str(hour), size = size_of_numbers, font = font_of_hour_numbers, halign = "center", valign = "center");
    }
}

module hours_text() {
    for (hour = [1:12]) {
        rotate([0, 0, -positions[hour - 1]])
        translate([diameter_of_clock / 2  - distance_of_numbers, 0, height])
        linear_extrude(height_of_numbers)
        text(hours[hour - 1], size = size_of_numbers, font = font_of_hour_numbers, halign = "right", valign = "center");
    }
}

module dots() {
    circled_pattern(12) {
        translate([diameter_of_clock / 2 - distance_of_dots - diameter_of_dots / 2, 0, height])
        cylinder(h = height_of_numbers, d=diameter_of_dots);
    }
}

module clock() {
    union() {
        clock_face();
        hours();
        if (show_dots == "yes") dots();
    }
}

clock();