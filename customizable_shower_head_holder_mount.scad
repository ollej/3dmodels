// Customizable Shower Head Holder
// Copyright: Olle Johansson 2018
// License: CC BY-SA

//CUSTOMIZER VARIABLES

/* [Fastener] */

type_of_spool = 1; // [1:Spool, 2:Cylinder]

width_of_spool = 31;

diameter_of_spool = 30;

hole_in_spool = 7;

/* [Spool] */

thickness_of_disks = 4;

diameter_of_cylinder = 16;

/* [Pie slice] */

depth_of_slice = 2.4;

angle_of_slice = 75;

position_of_slice = 235;

/* [Holder] */

holder_height = 30;

holder_wall_width = 6;

holder_top_diameter = 24;

holder_bottom_diameter = 21;

holder_angle = 10;

holder_hole_width = 16;

//CUSTOMIZER VARIABLES END

/* [Hidden] */

$fn=100;

module slice(r = 10, deg = 30) {
    degn = (deg % 360 > 0) ? deg % 360 : deg % 360 + 360;
    difference() {
        circle(r);

        if (degn > 180)
            intersection_for(a = [0, 180 - degn])
                rotate(a)
                translate([-r, 0, 0])
                square(r * 2);
        else
            union()
                for(a = [0, 180 - degn])
                    rotate(a)
                    translate([-r, 0, 0])
                    square(r * 2);
    }
}

module pie_slice() {
    rotate([0, 0, position_of_slice])
    translate([0, 0, width_of_spool / 2 - thickness_of_disks / 4])
    linear_extrude(height = depth_of_slice, center = true)
    slice(r = diameter_of_spool / 2 + 1, deg = angle_of_slice);
}

module spool() {
    difference() {
        cylinder(h = width_of_spool, d = diameter_of_spool, center = true);

        // Remove middle part of cylinder
        cylinder(h = width_of_spool - thickness_of_disks * 2, d = diameter_of_spool, center = true);

        pie_slice();
    }

    // Thin center cylinder
    cylinder(h = width_of_spool, d = diameter_of_cylinder, center = true);
}

module fastener() {
    rotate([90, 0, 0])
    difference() {
        spool();
        cylinder(h = width_of_spool, d = hole_in_spool, center = true);
    }
}

module fastener_full() {
    rotate([90, 0, 0])
    difference() {
        cylinder(h = width_of_spool, d = diameter_of_spool, center = true);
        cylinder(h = width_of_spool, d = hole_in_spool, center = true);
        pie_slice();
    }
}

module holder() {
    rotate([0, 0 - holder_angle, 0])
    translate([14.5 + hole_in_spool / 2, 0, 0])
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
        if (type_of_spool == 1) fastener();
        else fastener_full();
        hull() holder();
    }
    holder();
}

shower_holder();
