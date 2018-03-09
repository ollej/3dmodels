// Copyright: Olle Johansson 2018
// License: CC BY-SA

//CUSTOMIZER VARIABLES

// This is the total height of the holder
height_of_holder = 325;

// Width of the Sodastream bottle
inner_width_of_collars = 60;

// The height of each collar around the Sodastream bottle
height_of_collars = 20; // [10:50]

// Thickness of collar walls
thickness_of_collars = 5; // [1:10]

// Thickness of the cross at the bottom of the base collar
thickness_of_bottom = 5; // [1:10]

// Detpth of the hook at the top
depth_of_hook = 25; // [10:40]

// Height of the hook from the top
height_of_hook = 20; // [5:30]

// Thickness of the holder connecting the collars
thickness_of_holder = 8; // [5:10]

// Width of the holder connecting the collars
width_of_holder = 30; // [10:50]

// Height of the strap buckles
height_of_buckle = 30; // [20:50]

//CUSTOMIZER VARIABLES END

$fn=100;

BASE_WIDTH = inner_width_of_collars + 1; // Adding some tolerance
BASE_HEIGHT = height_of_collars;

THICKNESS_WALL = thickness_of_collars;
THICKNESS_BASE = thickness_of_bottom;

OUTER_DIAMETER = BASE_WIDTH + THICKNESS_WALL * 2;

BASE_SUPPORT_WIDTH = 10;
CUT_SPACING = 10;

HOOK_DEPTH = depth_of_hook;
HOOK_HEIGHT = height_of_hook;

HOLDER_THICKNESS = thickness_of_holder;
HOLDER_HEIGHT = height_of_holder;
//HOLDER_HEIGHT = 280 + THICKNESS_BASE + HOLDER_THICKNESS + HOOK_HEIGHT + CUT_SPACING;
HOLDER_WIDTH = width_of_holder;
HOLDER_POSITION = BASE_WIDTH / 2 + HOLDER_THICKNESS / 2;

KEG_RADIUS = 110;

COLLAR_HEIGHT = height_of_collars;

STRAP_BUCKLE_HEIGHT = height_of_buckle;
STRAP_BUCKLE_WALL = 3;
STRAP_THICKNESS = 3;
STRAP_WIDTH = STRAP_BUCKLE_HEIGHT - STRAP_BUCKLE_WALL * 2;
STRAP_BUCKLE_WIDTH = HOLDER_WIDTH + STRAP_THICKNESS * 2 + STRAP_BUCKLE_WALL * 2;
LOWER_BUCKLE_POSITION = BASE_HEIGHT + THICKNESS_BASE + STRAP_BUCKLE_HEIGHT / 2 + CUT_SPACING;
UPPER_BUCKLE_POSITION = HOLDER_HEIGHT - HOLDER_THICKNESS - HOOK_HEIGHT - COLLAR_HEIGHT - STRAP_BUCKLE_HEIGHT / 2 - CUT_SPACING * 2;

// Hanger
module hanger() {
    translate([0, HOLDER_POSITION, HOLDER_HEIGHT / 2]) {
        cube(size = [HOLDER_WIDTH, HOLDER_THICKNESS, HOLDER_HEIGHT], center = true);
    }
    
    // Lower strap buckle
    translate([0, HOLDER_POSITION, LOWER_BUCKLE_POSITION]) {
        strap_buckle();
    }

    // Upper strap buckle
    translate([0, HOLDER_POSITION, UPPER_BUCKLE_POSITION]) {
        strap_buckle();
    }
}

module base() {
    // Collar
    difference() {
        cylinder(h=THICKNESS_BASE + BASE_HEIGHT, d=OUTER_DIAMETER);
        
        cylinder(h=BASE_HEIGHT + BASE_HEIGHT, d=BASE_WIDTH);
     }
    
    // Base supports
    translate([0, 0, THICKNESS_BASE / 2]) {
        cube([BASE_SUPPORT_WIDTH, BASE_WIDTH + THICKNESS_WALL, THICKNESS_BASE], center=true);
        rotate([0, 0, 90])
            cube([BASE_SUPPORT_WIDTH, BASE_WIDTH + THICKNESS_WALL, THICKNESS_BASE], center=true);
    }
}

module collar() {
    translate([0, 0, HOLDER_HEIGHT - COLLAR_HEIGHT - HOOK_HEIGHT - HOLDER_THICKNESS - CUT_SPACING]) {
        
        difference() {
            cylinder(h=COLLAR_HEIGHT, d=OUTER_DIAMETER);
            
            cylinder(h=COLLAR_HEIGHT, d=BASE_WIDTH);
        }
    }    
}

module strap_buckle() {
    difference() {
        cube([STRAP_BUCKLE_WIDTH, HOLDER_THICKNESS, STRAP_BUCKLE_HEIGHT], center=true);

        // Strap holes
        translate([HOLDER_WIDTH / 2 + STRAP_THICKNESS / 2, 0, 0]) {
            cube([STRAP_THICKNESS, HOLDER_THICKNESS, STRAP_WIDTH], center = true);
        }
        translate([0 - (HOLDER_WIDTH / 2 + STRAP_THICKNESS / 2), 0, 0 ]) {
            cube([STRAP_THICKNESS, HOLDER_THICKNESS, STRAP_WIDTH], center = true);
        }
        
        // Make room for straps behind buckle
        strap_hole_pos = HOLDER_THICKNESS / 2 - STRAP_THICKNESS / 2 + 1;
        translate([HOLDER_WIDTH / 2 + STRAP_THICKNESS, strap_hole_pos, 0]) {
            cube([STRAP_BUCKLE_WALL * 2, 2, STRAP_WIDTH], center = true);
        }
        translate([0 - (HOLDER_WIDTH / 2 + STRAP_THICKNESS), strap_hole_pos, 0]) {
            cube([STRAP_BUCKLE_WALL * 2, 2, STRAP_WIDTH], center = true);
        }
    }
}

module hook() {
    // Horizontal lip
    translate([0, (BASE_WIDTH + HOOK_DEPTH) / 2 + HOLDER_THICKNESS, HOLDER_HEIGHT - HOLDER_THICKNESS / 2]) {
        cube([HOLDER_WIDTH, HOOK_DEPTH, HOLDER_THICKNESS], center = true);
    }
    
    // Vertical hook
    translate([0, BASE_WIDTH / 2 + HOOK_DEPTH + HOLDER_THICKNESS * 1.5, HOLDER_HEIGHT - HOOK_HEIGHT / 2 - HOLDER_THICKNESS / 2]) {
        cube([HOLDER_WIDTH, HOLDER_THICKNESS, HOOK_HEIGHT + HOLDER_THICKNESS], true);
    } 
}

module holder() {
    hanger();
    translate([0, -1, 0]) base();
    translate([0, -1, 0]) collar();
}

module drawHolder() {
    // Curved back of holder
    difference() {
        holder();
        
        // Make back rounded to fit keg
        translate([0, BASE_WIDTH / 2 + HOLDER_THICKNESS + KEG_RADIUS - 0.5, 0]) {
            cylinder(h=HOLDER_HEIGHT - HOLDER_THICKNESS, r=KEG_RADIUS, center=false);
        }
    }

    // Add hook (outside of holder, to not be in the way for the curved back)
    hook();
}

module rotatedHolder() {
    //translate([0, 0, - OUTER_DIAMETER / 2])
        rotate([-90, 0, 0])
            drawHolder();
}

rotatedHolder();
//drawHolder();
