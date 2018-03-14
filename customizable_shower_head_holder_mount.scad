// Customizable Shower Head Holder
// Copyright: Olle Johansson 2018
// License: CC BY-SA

//CUSTOMIZER VARIABLES

/* [Mount] */

// Choose mounting option
type_of_mount = 1; // [1:Spool, 2:Cylinder]

/* [Holder] */

// Height in mm of shower head holder
holder_height = 30; // [15:40]

// Width in mm of holder wall
holder_wall_width = 6; // [2:12]

// Top inner diameter of holder in mm
holder_top_diameter = 24; // [18:30]

// Bottom inner diameter of holder in mm
holder_bottom_diameter = 21; // [16:30]

// Angle of holder
holder_angle = 10; // [0:30]

// Width in mm of hole in holder wall
holder_hole_width = 16; // [10:20]

/* [Spool/Cylinder] */

// Width in mm of spool/cylinder
width_of_spool = 31; // [20:40]

// Diameter in mm of hole in spool/cylinder
spool_bolt_hole = 7; // [6:10]

// Diameter in mm of spool/cylinder
diameter_of_spool = 30; // [25:40]

// Thickness in mm of disks on spool
thickness_of_disks = 4; // [3:8]

// Diameter in mm of middle of spool
diameter_of_cylinder = 16; // [11:24]

/* [Cutout] */

// Add a cutout notch in the side of the spool/cylinder
cutout_type = 1; // [0:None, 1:Left side, 2:Right side]

// Depth in mm of cutout in mount
depth_of_cutout = 2.4; // [1:4]

// Angle of cutout slice
angle_of_cutout = 75; // [30:90]

// Rotation in degrees of cutout
rotation_of_cutout = 235; // [0:360]

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

module cutout(left_or_right) {
    position = (width_of_spool / 2 - depth_of_cutout / 2);
    mirror([0, 0, left_or_right]) 
    rotate([0, 0, rotation_of_cutout])
    translate([0, 0, position])
    linear_extrude(height = depth_of_cutout, center = true)
    slice(r = diameter_of_spool / 2 + 1, deg = angle_of_cutout);
}

module spool() {
    difference() {
        cylinder(h = width_of_spool, d = diameter_of_spool, center = true);

        // Remove middle part of cylinder
        cylinder(h = width_of_spool - thickness_of_disks * 2, d = diameter_of_spool, center = true);

        // Add a cutout notch in the side of the spool
        if (cutout_type != 0) cutout(cutout_type - 1);
    }

    // Thin center cylinder
    cylinder(h = width_of_spool, d = diameter_of_cylinder, center = true);
}

module spool_mount() {
    rotate([90, 0, 0])
    difference() {
        spool();
        cylinder(h = width_of_spool, d = spool_bolt_hole, center = true);
    }
}

module cylinder_mount() {
    rotate([90, 0, 0])
    difference() {
        cylinder(h = width_of_spool, d = diameter_of_spool, center = true);
        cylinder(h = width_of_spool, d = spool_bolt_hole, center = true);

        // Add a cutout notch in the side of the spool
        if (cutout_type != 0) cutout(cutout_type - 1);
    }
}

module holder() {
    rotate([0, 0 - holder_angle, 0])
    translate([14.5 + spool_bolt_hole / 2, 0, 0])
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
            cube([holder_top_diameter / 2 + holder_wall_width, holder_hole_width, holder_height], center = true);
    }
}

module shower_holder() {
    difference() {
        if (type_of_mount == 1) spool_mount();
        else cylinder_mount();
        hull() holder();
    }
    holder();
}

shower_holder();
