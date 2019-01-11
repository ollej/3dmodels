// Customizable Wall Clock
// Copyright: Olle Johansson 2018
// License: CC BY-SA

//CUSTOMIZER VARIABLES

/* [Clock] */

// Height in mm
height = 5; // [5:50]

// Diameter in mm of clock face
diameter_of_clock = 150; // [100:300]

// Diameter in mm of center hole
diameter_of_hole = 4.0; // [3.0:0.1:10.0]

// Thickness in mm of walls
thickness_of_wall = 5; // [2:0.1:10]

// Width in mm of chamfer of clock edge
width_of_chamfer = 0; // [0:0.1:10]

/* [Hours] */

// Type of hour symbols
type_of_hours = "Rotated numbers"; // [None, Numbers, Rotated numbers, Text, Roman]

// Raise or cutout hours
raise_hours = "Raise"; // [Raise, Cutout]

// Height in mm of numbers
height_of_hours = 2; // [0.5:0.1:4]

// Distance in mm of numbers from edge
distance_of_hours = 5; // [5:20]

// Font size of numbers
size_of_hours = 12; // [5:20]

// Font of hour numbers
font_of_hours = "Gotham";

/* [Hour dots] */

// Show dots for each hour
show_dots = "yes"; // [yes, no]

// Diameter in mm of hour dots
diameter_of_dots = 5; // [2:20]

// Distance in mm of dots from clock edge
distance_of_dots = 25; // [5:80]

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
hours_text = [
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
roman_numerals = [
    "I", "II", "III", "IV", "V", "VI",
    "VII", "VIII", "IX", "X", "XI", "XII"
];

function hour_text(hour) = hours_text[hour - 1];
function hour_roman(hour) = roman_numerals[hour - 1];

/* ** Utility modules ** */

module circled_pattern(number) {
    rotation_angle = 360 / number;
    last_angle = 360 - rotation_angle;
    for(rotation = [rotation_angle : rotation_angle : 360])
        rotate([0, 0, rotation])
        children();
}

/* ** Clock base ** */

module center_hole() {
    cylinder(h=height, d=diameter_of_hole);
}

module backside() {
    cylinder(
        h=height - thickness_of_wall,
        d=diameter_of_clock  - thickness_of_wall * 2);
}

module clock_base() {
    difference() {
        hull() {
            cylinder(h=height, d=diameter_of_clock - width_of_chamfer);
            cylinder(h=height - width_of_chamfer, d=diameter_of_clock);
        }
        
        center_hole();
        backside();
    }
}

/* ** Clock face ** */

module clock_face() {
    union() {
        hours();
        if (show_dots == "yes") dots();
    }
}

module hours() {
    if (type_of_hours == "Numbers") hours_numbers();
    else if (type_of_hours == "Rotated numbers") hours_rotated_numbers();
    else if (type_of_hours == "Roman") hours_roman();
    else if (type_of_hours == "Text") hours_text();
}

module hours_rotated_numbers() {
    for (hour = [1:12]) {
        rotate([0, 0, -positions[hour - 1]])
        translate([diameter_of_clock / 2  - distance_of_hours, 0, height])
        rotate([0, 0, 270])
        linear_extrude(height_of_hours)
        text(str(hour), size = size_of_hours, font = font_of_hours, halign = "center", valign = "top");
    }
}

module hours_numbers() {
    for (hour = [1:12]) {
        rotate([0, 0, -positions[hour - 1]])
        translate([diameter_of_clock / 2  - distance_of_hours - size_of_hours * 0.75, 0, height])
        rotate([0, 0, 270 + positions[hour - 1]])
        linear_extrude(height_of_hours)
        text(str(hour), size = size_of_hours, font = font_of_hours, halign = "center", valign = "center");
    }
}

module hours_roman() {
    for (hour = [1:12]) {
        rotate([0, 0, -positions[hour - 1]])
        translate([diameter_of_clock / 2  - distance_of_hours - size_of_hours * 0.75, 0, height])
        rotate([0, 0, 270 + positions[hour - 1]])
        linear_extrude(height_of_hours)
        text(hour_roman(hour), size = size_of_hours, font = font_of_hours, halign = "center", valign = "center");
    }
}

module hours_text() {
    for (hour = [1:12]) {
        rotate([0, 0, -positions[hour - 1]])
        translate([diameter_of_clock / 2  - distance_of_hours, 0, height])
        linear_extrude(height_of_hours)
        text(hour_text(hour), size = size_of_hours, font = font_of_hours, halign = "right", valign = "center");
    }
}

module dots() {
    circled_pattern(12) {
        translate([diameter_of_clock / 2 - distance_of_dots - diameter_of_dots / 2, 0, height])
        cylinder(h = height_of_hours, d=diameter_of_dots);
    }
}

/* ** Main object ** */

module clock() {
    if (raise_hours == "Raise") {
        union() {
            color("gray") clock_base();
            color("white") clock_face();
        }
    } else {
        difference() {
            clock_base();
            
            translate([0, 0, -height_of_hours])
            clock_face();
        }
    }
}

clock();