// Customizable Maker Coin
// Copyright: Olle Johansson 2018
// License: CC BY-SA

//CUSTOMIZER VARIABLES

/* [Coin] */

// Diameter of coin in mm
diameter_of_coin = 50; // [20:100]

// Thickness of coin in mm
thickness_of_coin = 10; // [5:20]

diameter_of_inner_circle = diameter_of_coin - 15;

diameter_of_ridges = 10;

diameter_of_sun = 20;

text_around_coin = "Exalted Printing";

font_on_text = "Gotham";

//CUSTOMIZER VARIABLES END

/* [Hidden] */

$fn=100;

include <text_on.scad>

module logo_text() {
    translate([0, 0, thickness_of_coin / 4])
    text_on_circle(
        t = text_around_coin,
        r = diameter_of_inner_circle / 2 - 3,
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

module edge_ridges() {
    for(rotation = [0 : 30 : 330])
        rotate([0, 0, rotation])
        edge_ridge();
}

module edge_ridge() {
    translate([diameter_of_coin / 2, 0, - thickness_of_coin / 2])
    scale([0.9, 1, 1])
    linear_extrude(height = thickness_of_coin, convexity = 1, twist = 180, slices = 100)
    circle(d = diameter_of_ridges, $fn = 6);
}

module sun() {
    len = 2;
    h = sqrt(len * len + len/2 * len/2);
    linear_extrude(height = thickness_of_coin / 4)
    union() {
        circle(d = diameter_of_sun, center = true);
        
        for(rotation = [0 : 10 : 350])
            rotate([0, 0, rotation])
            translate([diameter_of_sun / 2 + h / 2, 0, 0])
            rotate([0, 0, 135])
            polygon(points=[[0, 0], [len, 0], [0, len]], paths = [[0, 1, 2]]);
    }
}

module maker_coin() {
    union() {
        difference() {
            coin();
            
            inner_circle();
            logo_text();
            edge_ridges();
        }
        sun();
        }
}

maker_coin();

