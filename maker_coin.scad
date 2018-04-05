// Customizable Maker Coin
// Copyright: Olle Johansson 2018
// License: CC BY-SA

//CUSTOMIZER VARIABLES

/* [Coin] */

// Diameter of coin in mm
diameter_of_coin = 50; // [30:80]

// Thickness of coin in mm
thickness_of_coin = 12; // [6:12]

/* [Notches] */

// Add notches on edge of coin
display_notches = 1; // [1:Yes, 0:No]

// Type of notches
type_of_notch = 0; // [1:Twist, 0:Round]

// Width in mm of each notch on edge
width_of_notches = 10; // [5:15]

// Number of notches around edge
number_of_notches = 12; // [6:16]

/* [Sun] */

// Add sun in middle
display_sun = 1; // [1:Yes, 0:No]

// Diameter of sun in mm (excluding rays)
diameter_of_sun = 17; // [10:25]

// Height in mm of sun ray triangles
height_sun_ray = 5; // [2:8]

// Number of triangle rays on sun
number_of_sun_rays = 48; // [8:99]

/* [Text] */

// Show text in circle
display_text = 1; // [1:Yes, 0:No]

// Text to print in a circle around the coin
text_around_coin = "Exalted Printing";

// Font to use on the text
font_on_text = "Gotham";

// Distance of text in mm from inner circle
distance_of_text = 3; // [1:5]

//CUSTOMIZER VARIABLES END

/* [Hidden] */

// FIXME: Configurable?
diameter_of_inner_circle = diameter_of_coin - 15;

$fn=100;

module logo_text() {
    translate([0, 0, thickness_of_coin / 4])
    text_on_circle(
        t = text_around_coin,
        r = diameter_of_inner_circle / 2 - distance_of_text,
        font = font_on_text,
        spacing = 1.7,
        extrusion_height = thickness_of_coin / 2,
        rotate = 100,
        center = true);
}

module inner_circle() {
    translate([0, 0, thickness_of_coin / 2])
    scale(v = [1, 1, 0.25])
    sphere(d = diameter_of_inner_circle);
}

module coin() {
    intersection() {
        cylinder(h = thickness_of_coin, d = diameter_of_coin, center = true);
        scale([1, 1, 0.3])
        sphere(h = thickness_of_coin * 2, d = diameter_of_coin + 1, center = true);
    }
}

module edge_notches() {
    rotation_angle = 360 / number_of_notches;
    last_angle = 360 - rotation_angle;
    for(rotation = [0 : rotation_angle : last_angle])
        rotate([0, 0, rotation])
        notch();
}

module notch() {
    if (type_of_notch == 1) twisted_notch();
    else if (type_of_notch == 0) round_notch();
}

module round_notch() {
    translate([diameter_of_coin / 2, 0, - thickness_of_coin / 2])
    scale([0.9, 1, 1])
    linear_extrude(height = thickness_of_coin)
    circle(d = width_of_notches);
}

module twisted_notch() {
    translate([diameter_of_coin / 2, 0, - thickness_of_coin / 2])
    scale([0.9, 1, 1])
    linear_extrude(height = thickness_of_coin, convexity = 1, twist = 180, slices = 100)
    circle(d = width_of_notches, $fn = 6);
}

module sun() {
    //height_sun_ray = sqrt(side_sun_ray * side_sun_ray + side_sun_ray/2 * side_sun_ray/2);
    side_sun_ray = (2 * height_sun_ray) / sqrt(height_sun_ray);
    translate([0, 0, - thickness_of_coin / 2])
    linear_extrude(height = thickness_of_coin - thickness_of_coin / 4)
    union() {
        circle(d = diameter_of_sun, center = true);
        
        // Triangle rays on outside of circle
        rotation_angle = 360 / number_of_sun_rays;
        last_angle = 360 - rotation_angle;
        for(rotation = [0 : rotation_angle : last_angle])
            rotate([0, 0, rotation])
            translate([diameter_of_sun / 2 + height_sun_ray / 2, 0, 0])
            rotate([0, 0, 135])
            polygon(points=[[0, 0], [side_sun_ray, 0], [0, side_sun_ray]], paths = [[0, 1, 2]]);
    }
}

module maker_coin() {
    union() {
        difference() {
            coin();
            
            inner_circle();
            if (display_text == 1) logo_text();
            if (display_notches == 1) edge_notches();
        }

        if (display_sun == 1) sun();
    }
}

maker_coin();

include <text_on.scad>

