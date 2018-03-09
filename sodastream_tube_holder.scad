//include <libs/randy_lib.scad>
//include <libs/dovetail.scad>
include <libs/hugo_dovetail.scad>

$fn=100;

BASE_WIDTH = 61;
BASE_HEIGHT = 20;

THICKNESS_BASE = 5;
THICKNESS_WALL = 5;
BASE_SUPPORT_WIDTH = 10;
CUT_SPACING = 10;
HOLE_DIAMETER = BASE_HEIGHT - THICKNESS_WALL;

HOOK_DEPTH = 25;
HOOK_HEIGHT = 20;

HOLDER_THICKNESS = 8;
HOLDER_HEIGHT = 280 + THICKNESS_BASE + HOLDER_THICKNESS + HOOK_HEIGHT + CUT_SPACING;
//HOLDER_HEIGHT = 240;
HOLDER_WIDTH = 30;
HOLDER_POSITION = BASE_WIDTH / 2 + HOLDER_THICKNESS / 2;

KEG_RADIUS = 110;

COLLAR_HEIGHT = 20;


STRAP_WIDTH = 25;
STRAP_THICKNESS = 3;
STRAP_BUCKLE_WALL = 5;
STRAP_BUCKLE_WIDTH = HOLDER_WIDTH + STRAP_THICKNESS * 2 + STRAP_BUCKLE_WALL;
STRAP_BUCKLE_HEIGHT = STRAP_WIDTH + STRAP_BUCKLE_WALL;
//LOWER_BUCKLE_POSITION = HOLDER_HEIGHT / 2;
LOWER_BUCKLE_POSITION = BASE_HEIGHT + THICKNESS_BASE + STRAP_BUCKLE_HEIGHT / 2 + CUT_SPACING;
UPPER_BUCKLE_POSITION = HOLDER_HEIGHT - HOLDER_THICKNESS - HOOK_HEIGHT - COLLAR_HEIGHT - STRAP_BUCKLE_HEIGHT / 2 - CUT_SPACING * 2;

//CUTS = [[0, 150, 0], [0, 260, 0], [0, 290, 0]];
CUTS = [[0, 150, 0], [0, 290, 0]];
DOVETAIL_CLEAR = 0.3;
DOVETAIL_TEETH = [3, 4, DOVETAIL_CLEAR];

OUTER_DIAMETER = BASE_WIDTH + THICKNESS_WALL * 2;
//CUT_CUBE_DIM = [OUTER_DIAMETER + 10, 250, OUTER_DIAMETER + 10];
CUT_CUBE_DIM = [89, 150, 160];

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
    translate([0, 0, HOLDER_HEIGHT - COLLAR_HEIGHT - HOOK_HEIGHT - THICKNESS_WALL - CUT_SPACING]) {
        
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
            cube([STRAP_BUCKLE_WALL, 2, STRAP_WIDTH], center = true);
        }
        translate([0 - (HOLDER_WIDTH / 2 + STRAP_THICKNESS), strap_hole_pos, 0]) {
            cube([STRAP_BUCKLE_WALL, 2, STRAP_WIDTH], center = true);
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
    /*
    difference() {
        hanger();
        
        // Strap groove for lower buckle
        translate([0, BASE_WIDTH / 2 + 1, LOWER_BUCKLE_POSITION]) {
            cube([HOLDER_WIDTH, 2, STRAP_WIDTH], center = true);
        }

        // Strap groove for upper buckle
        translate([0, BASE_WIDTH / 2 + 1, UPPER_BUCKLE_POSITION]) {
            cube([HOLDER_WIDTH, 2, STRAP_WIDTH], center = true);
        }

    }
    */
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
    //
    //translate([50,50,50]) {
    //    strap_buckle();
    //}
    
}

// Cut with dovetail
module addCut() {
    translate([0, HOLDER_POSITION, CUT_HEIGHT])
    rotate([-90,-90,0]) {
        dovetail(DOVETAIL_WIDTH, HOLDER_THICKNESS, true);
        //dovetail(HOLDER_WIDTH, 10, false);
    }
}
//addCut();


module rotatedHolder() {
    //translate([0, 0, - OUTER_DIAMETER / 2])
        rotate([-90, 0, 0])
            drawHolder();
}

module cutHolder() {
    // Base
//    intersection() {
//        rotatedHolder();
//        cutter(CUTS[0], CUT_CUBE_DIM, DOVETAIL_TEETH, true);
//    }
    
    // Collar
//    intersection() {
//        rotatedHolder();
//        cutter(CUTS[0], CUT_CUBE_DIM, DOVETAIL_TEETH, false);
//        cutter(CUTS[1], CUT_CUBE_DIM, DOVETAIL_TEETH, true);
//    }
    
    // Hook
    intersection() {
        rotatedHolder();
        cutter(CUTS[1], CUT_CUBE_DIM, DOVETAIL_TEETH, false);
        //cutter(CUTS[2], CUT_CUBE_DIM, DOVETAIL_TEETH, true);
    }
    
    // Third cut
    //intersection() {
    //    rotatedHolder();
    //    cutter(CUTS[2], CUT_CUBE_DIM, DOVETAIL_TEETH, false);
    //}
}

//cutHolder();
rotatedHolder();
//drawHolder();
