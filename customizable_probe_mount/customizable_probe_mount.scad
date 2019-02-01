// Customizable Probe Mount
// Copyright: Olle Wreede 2019
// License: CC BY-SA

//CUSTOMIZER VARIABLES

// Height in mm of backplate
backplate_height = 22; // [16:30]

// Thickness in mm of backplate
backplate_thickness = 3; // [2:0.1:6]

// Width in mm of bracket
backplate_bracket_width = 28; // [20:0.5:30]

// Height in mm of bracket
backplate_bracket_height = 10; // [6:15]

// Radius in mm of bracket corners
backplate_corner_radius = 2; // [0:0.1:4]

// Width in mm of backplate holder
backplate_holder_width = 18; // [10:30]

// Shape of backplate
backplate_shape = "T shape"; // [T shape, V shape, Rectangle]

// Diameter in mm of probe mount hole
probe_hole_diameter = 12; // [10:0.5:20]

// Thickness in mm of probe mount holder
probe_mount_thickness = 5; // [2:0.5:8]

// Diameter in mm of probe mount holder
probe_mount_diameter = 22; // [20:30]

// Shape of mount screw holes
type_of_mount_hole = "Teardrop"; // [Teardrop, Round]

// Diameter in mm of mount screw holes
mount_hole_diameter = 3;

// Distance in mm between mount screw holes
mount_hole_distance = 10;

//CUSTOMIZER VARIABLES END

/* [Hidden] */

$fn=120;

/* From http://www.thingiverse.com/thing:3457
   © 2010 whosawhatsis */
module teardrop(radius, length, angle) {
	rotate([0, angle, 0]) union() {
		linear_extrude(height = length, center = true, convexity = radius, twist = 0)
			circle(r = radius, center = true, $fn = 30);
		linear_extrude(height = length, center = true, convexity = radius, twist = 0)
			projection(cut = false) rotate([0, -angle, 0]) translate([0, 0, radius * sin(45) * 1.5]) cylinder(h = radius * sin(45), r1 = radius * sin(45), r2 = 0, center = true, $fn = 30);
    }
}

module cylinder_outer(diameter, height, fn) {
   fudge = 1 / cos(180 / fn);
   cylinder(h=height, r=diameter / 2 * fudge, $fn=fn, center=true);
}

module cube_rounded(width, height, thickness, radius=1) {
	minkowski() {
		cube([width - 2 * radius, height - 2 * radius, thickness/2], center = true);
		cylinder(r = radius, h = thickness/2, center = true);
	}
}

module round_hole() {
    rotate([90, 0, 0])
    cylinder_outer(mount_hole_diameter, backplate_thickness, $fn);
}

module teardrop_hole() {
    rotate([0, 0, 90])
    teardrop(mount_hole_diameter/2, backplate_thickness, 90);
}

module mount_hole() {
    if (type_of_mount_hole == "Teardrop") {
        teardrop_hole();
    } else {
        round_hole();
    }
}

module mount_holes() {
    translate([mount_hole_distance, 0, backplate_height/2 - backplate_bracket_height/2])
        mount_hole();
    
    translate([-mount_hole_distance, 0, backplate_height/2 - backplate_bracket_height/2])
        mount_hole();
}

module backplate_rectangle() {
    difference() {
        cube([backplate_bracket_width, backplate_thickness, backplate_height], center = true);
        
        mount_holes();
    }
}

module backplate_tshape() {
    difference() {
        union() {
            rotate([90, 0, 0])
            cube([backplate_holder_width, backplate_height, backplate_thickness], center = true);
            
            translate([0, 0, backplate_height/2 - backplate_bracket_height/2])
            rotate([90, 0, 0])
            cube_rounded(backplate_bracket_width, backplate_bracket_height, backplate_thickness, backplate_corner_radius);
        }
        
        mount_holes();
    }
}

module backplate_vshape() {
    difference() {
        hull() {
            rotate([90, 0, 0])
            cube([backplate_holder_width, backplate_height, backplate_thickness], center = true);
            
            translate([0, 0, backplate_height/2 - backplate_bracket_height/2])
            rotate([90, 0, 0])
            cube_rounded(backplate_bracket_width, backplate_bracket_height, backplate_thickness, backplate_corner_radius);
        }
        
        mount_holes();
    }
}


module mount() {
    translate([0, 0, probe_mount_thickness/2 - backplate_height/2])
    difference() {
        union() {
            translate([0, -probe_mount_diameter/2 - backplate_thickness/2, 0])
            cylinder_outer(probe_mount_diameter, probe_mount_thickness, $fn);
            
            translate([0, -probe_mount_diameter/4, 0])
            cube([backplate_holder_width, probe_mount_diameter/2, probe_mount_thickness], center=true);
        }
        
        translate([0, -probe_mount_diameter/2 - backplate_thickness/2, 0])
        cylinder_outer(probe_hole_diameter, probe_mount_thickness, $fn);
    }
}

module probe_mount() {
    translate([0, 0, backplate_height/2]) {
        if (backplate_shape == "T shape") {
            backplate_tshape();
        } else if (backplate_shape == "V shape") {
            backplate_vshape();
        } else {
            backplate_rectangle();
        }
        mount();
    }
}

probe_mount();
