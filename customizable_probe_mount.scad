// Customizable Probe Mount
// Copyright: Olle Johansson 2018
// License: CC BY-SA

//CUSTOMIZER VARIABLES

backplate_bracket_width = 28;
backplate_bracket_height = 10;
backplate_height = 20;
backplate_thickness = 3;
backplate_corner_radius = 2;
backplate_holder_width = 18;
backplate_shape = "T shape"; // [T shape, V shape, Rectangle]

probe_hole_diameter = 12;
probe_mount_thickness = 5;
probe_mount_diameter = 22;
mount_hole_diameter = 3;
mount_hole_distance = 10;

//CUSTOMIZER VARIABLES END

/* [Hidden] */

$fn=120;

module cylinder_outer(height, diameter, fn) {
   fudge = 1 / cos(180 / fn);
   cylinder(h=height, r=diameter / 2 * fudge, $fn=fn, center=true);
}

module cube_rounded(width, height, thickness, radius=1) {
	minkowski() {
		cube([width - 2 * radius, height - 2 * radius, thickness/2], center = true);
		cylinder(r = radius, h = thickness/2, center = true);
	}
}

module mount_holes() {
    translate([mount_hole_distance, 0, backplate_height/2 - backplate_bracket_height/2])
        rotate([90, 0, 0])
        cylinder_outer(backplate_thickness, mount_hole_diameter, $fn);
    
    translate([-mount_hole_distance, 0, backplate_height/2 - backplate_bracket_height/2])
        rotate([90, 0, 0])
        cylinder_outer(backplate_thickness, mount_hole_diameter, $fn);
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
            cylinder_outer(probe_mount_thickness, probe_mount_diameter, $fn);
            
            translate([0, -probe_mount_diameter/4, 0])
            cube([backplate_holder_width, probe_mount_diameter/2, probe_mount_thickness], center=true);
        }
        
        translate([0, -probe_mount_diameter/2 - backplate_thickness/2, 0])
        cylinder_outer(probe_mount_thickness, probe_hole_diameter, $fn);
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
