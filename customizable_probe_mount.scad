// Customizable Probe Mount
// Copyright: Olle Johansson 2018
// License: CC BY-SA

//CUSTOMIZER VARIABLES

width = 28;
height = 20;
thickness = 2;
probe_hole_diameter = 12.5;
probe_mount_thickness = 5;
probe_mount_diameter = 22;
distance_to_probe_hole_center = 10;
mount_hole_diameter = 3;
mount_hole_distance = 5;

//CUSTOMIZER VARIABLES END

/* [Hidden] */

$fn=120;

module cylinder_outer(height, diameter, fn) {
   fudge = 1 / cos(180 / fn);
   cylinder(h=height, r=diameter / 2 * fudge, $fn=fn, center=true);
}

module rectangle_rounded(width, height, radius=1) {
	minkowski() {
		circle(r = radius);
		square([width - 2 * radius, height - 2 * radius], center = true);
	}
}

module mount_holes() {
    #translate([width/2 - mount_hole_distance, 0, height/2 - mount_hole_distance])
        rotate([90, 0, 0])
        cylinder_outer(thickness, mount_hole_diameter, $fn);
    #translate([- width/2 + mount_hole_distance, 0, height/2 - mount_hole_distance])
        rotate([90, 0, 0])
        cylinder_outer(thickness, mount_hole_diameter, $fn);
}

module backplate() {
    difference() {
        cube([width, thickness, height], center = true);
        
        mount_holes();
    }
}

module mount() {
    translate([0, 0, probe_mount_thickness/2 - height/2])
    difference() {
        union() {
            translate([0, -probe_mount_diameter/2, 0])
            cylinder_outer(probe_mount_thickness, probe_mount_diameter, $fn);
            
            translate([0, -probe_mount_diameter/4, 0])
            cube([probe_mount_diameter, probe_mount_diameter/2, probe_mount_thickness], center=true);
        }
        
        #translate([0, -probe_mount_diameter/2, 0])
        cylinder_outer(probe_mount_thickness, probe_hole_diameter, $fn);
    }
}

module probe_mount() {
    backplate();
    mount();
}

probe_mount();
