// Customizable Wall Clock
// Copyright: Olle Johansson 2018
// License: CC BY-SA

//CUSTOMIZER VARIABLES

/* [Clock] */

// Height in mm of clock face
height_of_clock = 5; // [5:50]

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
type_of_hours = "Numbers"; // [None, Numbers, Text, Roman]

// Raise or inset hours
raise_hours = "Raise"; // [Raise, Inset]

// Rotate hours
rotation_of_hours = "None"; // [None, Rotated, Angled]

// Height in mm of numbers
height_of_hours = 2; // [0.5:0.1:4]

// Distance in mm of numbers from edge
distance_of_hours = 5; // [5:20]

// Font size of numbers
size_of_hours = 12; // [5:20]

// Font of hour numbers
font_of_hours = "Gotham";

/* [Hour markers] */

// Type of hour markers
type_of_hour_markers = "Circle"; // [None, Circle, Line, Triangle In, Triangle Out]

// Width in mm of hour markers
width_of_markers = 5; // [1:20]

// Height (or diameter) in mm of hour markers
height_of_markers = 10; // [1:20]

// Distance in mm of markers from clock edge
distance_of_markers = 25; // [5:80]

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

$fn = 120;

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
    cylinder(h = height_of_clock, d = diameter_of_hole);
}

module backside() {
    cylinder(
        h = height_of_clock - thickness_of_wall,
        d = diameter_of_clock  - thickness_of_wall * 2);
}

module clock_base() {
    difference() {
        hull() {
            cylinder(h = height_of_clock, d = diameter_of_clock - width_of_chamfer);
            cylinder(h = height_of_clock - width_of_chamfer, d = diameter_of_clock);
        }
        
        center_hole();
        backside();
    }
}

/* ** Clock face ** */

function rotation_angle(hour) = (rotation_of_hours == "None")
    ? 270 + positions[hour - 1]
    : (rotation_of_hours == "Rotated")
        ? 270 : 0;

module clock_face() {
    union() {
        if (type_of_hours != "None") hours();
        if (type_of_hour_markers != "None") hour_markers();
    }
}

module hour_text(hour, size, font) {
    if (type_of_hours == "Roman")
        text(roman_numerals[hour - 1], size = size, font = font, halign = "center", valign = "center");
    else if (type_of_hours == "Text")
        text(hour_text(hour), size = size, font = font, halign = "center", valign = "center");
    else text(str(hour), size = size, font = font, halign = "center", valign = "center");
}

module hours() {
    for (hour = [1:12]) {
        hour_offset = size_of_hours * 0.75;
        rotate([0, 0, -positions[hour - 1]])
        translate([diameter_of_clock / 2  - distance_of_hours - hour_offset, 0, height_of_clock])
        rotate([0, 0, rotation_angle(hour)])
        linear_extrude(height_of_hours)
        hour_text(hour, size_of_hours, font_of_hours);
    }
}

module hour_marker() {
    if (type_of_hour_markers == "Circle")
        scale([1, width_of_markers / height_of_markers, 1])
        circle(d = height_of_markers);
    else if (type_of_hour_markers == "Line")
        square(size = [height_of_markers, width_of_markers], center = true);
    else if (type_of_hour_markers == "Triangle In")
        polygon(points = [
            [height_of_markers / 2, - width_of_markers / 2],
            [height_of_markers / 2, width_of_markers / 2],
            [-height_of_markers / 2, 0]]);
    else if (type_of_hour_markers == "Triangle Out")
        polygon(points = [
            [-height_of_markers / 2, - width_of_markers / 2],
            [-height_of_markers / 2, width_of_markers / 2],
            [height_of_markers / 2, 0]]);
}

module hour_markers() {
    circled_pattern(12) {
        translate([diameter_of_clock / 2 - distance_of_markers - height_of_markers / 2, 0, height_of_clock])
        linear_extrude(height_of_hours)
        hour_marker();
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