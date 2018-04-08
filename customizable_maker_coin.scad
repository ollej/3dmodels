// Customizable Maker Coin
// Copyright: Olle Johansson 2018
// License: CC BY-SA

//CUSTOMIZER VARIABLES

/* [Coin] */

// Type of coin
type_of_coin = 2; // [0:Rounded, 1:Cylinder, 2:Torus]

// Add design in middle
type_of_inner_design = 1; // [0:None, 1:Sun, 2:Text, 3:Image]

// Should inner design be raised or cutout?
raise_inner_design = "yes"; // [yes,no]

// Diameter of coin in mm
diameter_of_coin = 50; // [40:60]

// Thickness of coin in mm
thickness_of_coin = 10; // [6:12]

// Distance of inner circle from outer edge
distance_to_inner_circle = 15; // [5:20]
diameter_of_inner_circle = diameter_of_coin - distance_to_inner_circle;

/* [Notches] */

// Add notches on edge of coin
display_notches = "yes"; // [yes, no]

// Type of notches
type_of_notch = 1; // [0:Rounded, 1:Twisted, 2:Globe]

// Width in mm of each notch on edge
width_of_notches = 10; // [5:15]

// Number of notches around edge
number_of_notches = 12; // [6:16]

/* [Inner Sun] */

// Diameter of sun in mm (excluding rays)
diameter_of_sun = 17; // [10:25]

// Height in mm of sun ray triangles
height_sun_ray = 5; // [2:8]

// Number of triangle rays on sun
number_of_sun_rays = 48; // [8:99]

/* [Inner text] */

// Text in middle of coin
inner_text = "OLLEJ";

// Font to use on the inner text
font_on_inner_text = "Gotham";

// Size of inner text
size_of_inner_text = 5; // [1:15]

/* [Inner image] */

// Image to show in center of coin
inner_image = "logo.png"; // [image_surface:150x150]

/* [Circle text] */

// Show text in circle around edge of coin
display_circle_text = "yes"; // [yes, no]

// Text to print in a circle around the coin
text_around_coin = "Exalted Printing";

// Font to use on the circle text
font_on_circle_text = "Gotham";

// Rotation angle in degrees of circle text
rotation_of_circle_text = 100; // [0:360]

// Distance of text in mm from inner circle
distance_of_text = 3; // [1:5]
// TODO: Allow text to be on outer circle?

//CUSTOMIZER VARIABLES END

/* [Hidden] */

$fn=100;

/* ** Utility modules ** */

module circled_pattern(number) {
    rotation_angle = 360 / number;
    last_angle = 360 - rotation_angle;
    for(rotation = [0 : rotation_angle : last_angle])
        rotate([0, 0, rotation])
        children();
}

/* ** Modifications ** */

module circle_text() {
    translate([0, 0, thickness_of_coin / 4])
    text_on_circle(
        t = text_around_coin,
        r = diameter_of_inner_circle / 2 - distance_of_text,
        font = font_on_circle_text,
        spacing = 1.7,
        extrusion_height = thickness_of_coin / 2,
        rotate = rotation_of_circle_text,
        center = true);
}

module inner_circle() {
    translate([0, 0, thickness_of_coin / 2])
    scale(v = [1, 1, 0.25])
    sphere(d = diameter_of_inner_circle);
}

/* ** Base coin ** */

module coin() {
    if (type_of_coin == 0) rounded_coin();
    else if (type_of_coin == 1) cylinder_coin();
    else if (type_of_coin == 2) torus_coin();
}

module cylinder_coin() {
    cylinder(h = thickness_of_coin, d = diameter_of_coin, center = true);
}

module rounded_coin() {
    intersection() {
        cylinder(h = thickness_of_coin, d = diameter_of_coin, center = true);
        scale([1, 1, 0.3])
        sphere(h = thickness_of_coin * 2, d = diameter_of_coin + 1, center = true);
    }
}

module torus_coin() {
    hull() {
        rotate_extrude(convexity = 10)
        translate([diameter_of_coin / 2 - thickness_of_coin / 2, 0, 0])
        circle(d = thickness_of_coin, center = true);

        cylinder(h = thickness_of_coin, d = diameter_of_coin - thickness_of_coin, center = true);
    }
}

/* ** Notches ** */

module edge_notches() {
    circled_pattern(number_of_notches)
        notch();
}

module notch() {
    if (type_of_notch == 0) rounded_notch();
    else if (type_of_notch == 1) twisted_notch();
    else if (type_of_notch == 2) sphere_notch();
}

module sphere_notch() {
    translate([diameter_of_coin / 2, 0, 0])
    scale([0.9, 1, 1])
    sphere(d = width_of_notches, center = true);
}

module rounded_notch() {
    translate([diameter_of_coin / 2, 0, - thickness_of_coin / 2])
    scale([0.9, 1, 1])
    cylinder(h = thickness_of_coin, d = width_of_notches);
}

module twisted_notch() {
    translate([diameter_of_coin / 2, 0, - thickness_of_coin / 2])
    scale([0.9, 1, 1])
    linear_extrude(height = thickness_of_coin, convexity = 1, twist = 180, slices = 100)
    circle(d = width_of_notches, $fn = 6);
}

/* ** Inner design ** */

module inner_design(raised = false) {
    if (type_of_inner_design == 1) inner_design_sun();
    else if (type_of_inner_design == 2) inner_design_text(raised);
    else if (type_of_inner_design == 3) inner_design_image();
}

module inner_design_image() {
    scale_xy = 0.25 * diameter_of_coin / 80;
    translate([0, 0, thickness_of_coin / 4])
    //scale([0.14, 0.14, 0.06])
    scale([scale_xy, scale_xy, 0.06])
    surface(file = inner_image, center = true, convexity = 10, invert = true);
}

module inner_design_text(raised = true) {
    if (raised == true) {
        translate([0, 0, thickness_of_coin / 8])
        linear_extrude(thickness_of_coin / 4)
        text(inner_text, size = size_of_inner_text, font = font_on_inner_text, halign = "center", valign = "center");
    } else {
        translate([0, 0, - thickness_of_coin / 4])
        linear_extrude(thickness_of_coin / 2)
        text(inner_text, size = size_of_inner_text, font = font_on_inner_text, halign = "center", valign = "center");
    }
}

module inner_design_sun() {
    translate([0, 0, - thickness_of_coin / 2])
    linear_extrude(height = thickness_of_coin - thickness_of_coin / 4)
    union() {
        circle(d = diameter_of_sun, center = true);
        
        // Triangle rays on outside of circle
        circled_pattern(number_of_sun_rays)
            ray_triangle();
    }
}

module ray_triangle(diameter) {
    //height_sun_ray = sqrt(side_sun_ray * side_sun_ray + side_sun_ray/2 * side_sun_ray/2);
    side_sun_ray = (2 * height_sun_ray) / sqrt(height_sun_ray);
    translate([diameter_of_sun / 2 + height_sun_ray / 2, 0, 0])
    rotate([0, 0, 135])
    polygon(points=[[0, 0], [side_sun_ray, 0], [0, side_sun_ray]], paths = [[0, 1, 2]]);
}

/* ** Main object ** */

module maker_coin() {
    union() {
        difference() {
            coin();
            
            inner_circle();
            if (display_circle_text == "yes") circle_text();
            if (display_notches == "yes") edge_notches();
            if (raise_inner_design == "no") inner_design();
        }

        if (raise_inner_design == "yes") inner_design(raised = true);
    }
}

maker_coin();

// Placed last to preserve line numbers when debugging.
include <text_on.scad>
