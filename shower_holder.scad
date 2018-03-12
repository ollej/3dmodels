// Customizable Shower Holder
// Copyright: Olle Johansson 2018
// License: CC BY-SA

//CUSTOMIZER VARIABLES

/* [Fastener] */

width_of_cylinder = 31;

diameter_of_cylinder = 16;

diameter_of_disks = 30;

thickness_of_disks = 4;

hole_in_cylinder = 6;

/* [Holder] */

holder_height = 30;

holder_wall_width = 6;

holder_top_diameter = 24;

holder_bottom_diameter = 21;

holder_angle = 10;

holder_hole_width = 16;

//CUSTOMIZER VARIABLES END

/* [Hidden] */

$fn=30;

module spool() {
    difference() {
        cylinder(h = width_of_cylinder, d = diameter_of_disks, center = true);
        cylinder(h = width_of_cylinder - thickness_of_disks * 2, d = diameter_of_disks, center = true);
    }
    cylinder(h = width_of_cylinder, d = diameter_of_cylinder, center = true);
}

module fastener() {
    rotate([90, 0, 0])
    difference() {
        spool();
        cylinder(h = width_of_cylinder, d = hole_in_cylinder, center = true);
    }
}

module fastener_full() {
    rotate([90, 0, 0])
    difference() {
        cylinder(h = width_of_cylinder, d = diameter_of_disks, center = true);
        cylinder(h = width_of_cylinder, d = diameter_of_disks, center = true);
        cylinder(h = width_of_cylinder, d = hole_in_cylinder, center = true);
    }
}

module holder() {
    rotate([0, 0 - holder_angle, 0])
    translate([17, 0, 0])
    difference() {
        cylinder(h = holder_height, d1 = holder_bottom_diameter + holder_wall_width, d2 = holder_top_diameter + holder_wall_width, center = true);
        cylinder(h = holder_height, d1 = holder_bottom_diameter, d2 = holder_top_diameter, center = true);

        // Chamfer on top edge
        translate([holder_top_diameter / 2 + holder_wall_width / 2, 0, holder_height / 2])
        rotate([0, 40, 0])
        cube([holder_top_diameter, holder_top_diameter * 1.5, 10], center=true);

        // Chamfer on bottom edge
        translate([holder_top_diameter / 2 + holder_wall_width / 2, 0, 0 - holder_height / 2])
        rotate([0, -40, 0])
        cube([holder_top_diameter, holder_top_diameter * 1.5, 10], center=true);

        // Front hole
        translate([holder_top_diameter / 2.5, 0, 0])
            cube([holder_top_diameter / 2, holder_hole_width, holder_height], center = true);
    }
}

module shower_holder() {
    difference() {
        fastener();
        hull() holder();
    }
    holder();
}

shower_holder();
