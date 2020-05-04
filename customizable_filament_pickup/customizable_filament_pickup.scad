// Customizable Filament Pickup for the E3D Tool Changer
// Copyright: Olle Wreede 2020
// License: CC BY-SA

//CUSTOMIZER VARIABLES

// TODO: Add bowden coupling to simple filament hole version

/* [Base values] */

// Height in mm of pickup
height_of_pickup = 60; // [30:5:100]

// Width in mm of pickup base
width_of_pickup = 15; // [15:30]

// Depth in mm of pickup base
depth_of_pickup = 9; // [5:0.5:15]

// Type of filament pickup
filament_filter = 20; // [0:Simple filament hole, 15:15mm filament filter, 20:20mm filament filter]

// Use teardrops on holes?
teardrop_holes = 90; // [0:Round holes, 90:Teardrop holes]

/* [Filament filter] */

// Length in mm of filament filter
filament_filter_length = 15; // [10:1:20]

// Thickness in mm of filament filter cylinder wall
filament_filter_thickness = 2; // [1:0.1:4]

// Width in mm of lip of the filament filter hole
filament_filter_lip = 1; // [0.0:0.1:3.0]

/* [Simple bowden hole] */

// Width in mm of pickup top (not used for filter)
width_top = 15; // [10:20]

// Depth in mm of pickup top (not used for filter)
depth_top = 9; // [5:0.5:15]

// Diameter in mm of filament hole (not used for filter)
filament_hole_diameter = 2.4; // [1.8:0.1:4]

// Diameter in mm of bowden tube hole (not used for filter)
bowden_hole_diameter = 4.2; // [4:0.1:8]

/* [Mount holes] */

// Diameter in mm of mount screw holes
mount_hole_diameter = 2.5; // [0:None, 2.5:M2.5, 3:M3, 4:M4, 5:M5, 6:M6]

// Distance in mm of mount holes from edge
mount_hole_distance = 15; // [10:0.5:20]

// Depth in mm of mount holes
mount_hole_depth = 8.5; // [5:0.5:10]

//CUSTOMIZER VARIABLES END

/* [Hidden] */

$fn=120;
fudge = 0.1;
bowden_coupling_hole_diameter = 12;
bowden_coupling_hole_depth = 7;
filter_bottom_thickness = 12;

/* Helper modules */

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

module hole(diameter, length) {
    if (teardrop_holes > 0) {
        rotate([teardrop_holes, teardrop_holes, 0])
        teardrop(diameter / 2, length + fudge, teardrop_holes);
    } else {
        cylinder_outer(
            diameter,
            length + fudge,   
            $fn);
    }
}

module cube_rounded(width, height, thickness, radius=1) {
	minkowski() {
		cube([width - 2 * radius, height - 2 * radius, thickness/2], center = true);
		cylinder(r = radius, h = thickness/2, center = true);
	}
}

/* Mount */

module mount_holes(hole_diameter, hole_distance, hole_depth) {
    translate([hole_distance / 2, 0, -fudge])
    hole(hole_diameter, hole_depth);
    
    translate([-hole_distance / 2, 0, -fudge])
    hole(hole_diameter, hole_depth);
}

module filament_pickup_base(width, depth) {
    base_height = 1;
    
    translate([0, 0, base_height/2])
    difference() {
        union() {
            translate([-width/2, 0, 0])
            cylinder_outer(depth, base_height, $fn);

            cube([width, depth, base_height], center=true);

            translate([width/2, 0, 0])
            cylinder_outer(depth, base_height, $fn);
        }
    }
}

module filament_pickup_top(width, depth, height, filament_hole_diameter, bowden_hole_diameter) {
    translate([0, 0, height])
    rotate([0, 90, 0])
    cylinder_outer(depth, width, $fn);
}

module filament_filter_cylinder(height, filter_size, filter_length, filter_thickness, bottom_thickness) {
    translate([0, 0, height])
    rotate([0, 90, 0])
    cylinder_outer(
        filter_size,
        filter_length + bottom_thickness + filter_thickness,  
        $fn);
}

module filament_filter_hole(height, filter_size, filter_length, filter_thickness, bottom_thickness, filter_lip) {
    translate([-bottom_thickness / 2, 0, height])
    rotate([0, 90, 0])
    cylinder_outer(
        filter_size - filter_thickness * 2,
        filter_length,
        $fn);
    translate([-bottom_thickness / 2 - filter_thickness / 2 - fudge, 0, height])
    rotate([0, 90, 0])
    cylinder_outer(
        filter_size - filter_thickness * 2 - filter_lip + fudge,
        filter_length,
        $fn);        
}

module filament_pickup_filter(width, height, depth, 
    filament_hole_diameter, bowden_hole_diameter, 
    mount_hole_diameter, mount_hole_distance,
    filter_size, filter_length, filter_thickness,
    filter_lip) {

    difference() {
        hull() {
            filament_pickup_base(width, depth);
            filament_filter_cylinder(
                height,
                filter_size,
                filter_length,
                filter_thickness,
                filter_bottom_thickness);
        }
        
        filament_filter_hole(
            height,
            filter_size,
            filter_length,
            filter_thickness,
            filter_bottom_thickness,
            filter_lip);
    
        // Filament hole
        translate([0, 0, height])
        rotate([0, 90, 0]) {
            filter_width = filter_length + filter_bottom_thickness + filter_thickness;
            filament_hole_length = filter_bottom_thickness - bowden_coupling_hole_depth;
//            translate([0, 0, (filter_bottom_thickness - bowden_coupling_hole_depth) / 2])
            translate([0, 0, filter_width / 2 - bowden_coupling_hole_depth - filament_hole_length / 2 - 0.5])
            {
                hole(filament_hole_diameter, filament_hole_length + 2);
                
                // Outer filament hole fillet
                translate([0, 0, filament_hole_length / 2 - 0.5 + fudge])
                #cylinder(h=2, d1=filament_hole_diameter, d2=filament_hole_diameter + 2, center=true);

                // Inner filament hole fillet
                translate([0, 0, -filament_hole_length / 2 - filter_thickness / 2 + 1.5 - fudge])
                #cylinder(h=2, d1=filament_hole_diameter + 2, d2=filament_hole_diameter, center=true);
            }
            
            // Bowden coupling hole
            translate([0, 0, filter_width / 2 - bowden_coupling_hole_depth / 2 + fudge])
            cylinder_outer(
                bowden_coupling_hole_diameter,
                bowden_coupling_hole_depth + fudge,
                $fn);
        }
    }
}

module filament_pickup_simple(width, height, depth, 
    filament_hole_diameter, bowden_hole_diameter, 
    mount_hole_diameter, mount_hole_distance, 
    width_top, depth_top) {

    difference() {
        hull() {
            filament_pickup_base(width, depth);
            filament_pickup_top(width_top, depth_top, height, filament_hole_diameter, bowden_hole_diameter);
        }
    
        // Filament hole
        translate([0, 0, height])
        rotate([0, 90, 0]) {
            translate([0, 0, -width/2])
            cylinder_outer(filament_hole_diameter, width, $fn);
            
            // Inner filament hole fillet
            cylinder(h=1, d1=filament_hole_diameter, d2=filament_hole_diameter + 1, center=true);
            
            // Outer filament hole fillet
            translate([0, 0, -width_top/2 - 0.35])
            #cylinder(h=2, d1=filament_hole_diameter + 1, d2=filament_hole_diameter, center=true);

            // Bowden hole
            translate([0, 0, width/2])
            cylinder_outer(bowden_hole_diameter, width, $fn);

            // Outer bowden hole fillet
            translate([0, 0, width_top/2 + 0.35])
            #cylinder(h=2, d1=bowden_hole_diameter, d2=bowden_hole_diameter + 1, center=true);
        }
    }
}

module filament_pickup(width, height, depth, 
    filament_hole_diameter, bowden_hole_diameter, 
    mount_hole_diameter, mount_hole_distance, mount_hole_depth,
    width_top, depth_top, filter_size, filter_length,
    filter_thickness, filter_lip) {
    difference() {
        if (filter_size == 0) {
            filament_pickup_simple(
                width,
                height,
                depth, 
                filament_hole_diameter,
                bowden_hole_diameter,
                mount_hole_diameter,
                mount_hole_distance,
                width_top,
                depth_top);
        } else {
            filament_pickup_filter(
                width,
                height,
                depth, 
                filament_hole_diameter,
                bowden_hole_diameter, 
                mount_hole_diameter,
                mount_hole_distance,
                filter_size,
                filter_length,
                filter_thickness,
                filter_lip);
        }

        // Mount holes
        translate([0, 0, mount_hole_depth / 2])
        mount_holes(mount_hole_diameter, mount_hole_distance, mount_hole_depth);
    }
}

filament_pickup(
    width_of_pickup,
    height_of_pickup,
    depth_of_pickup,
    filament_hole_diameter,
    bowden_hole_diameter,
    mount_hole_diameter,
    mount_hole_distance,
    mount_hole_depth,
    width_top,
    depth_top,
    filament_filter,
    filament_filter_length,
    filament_filter_thickness,
    filament_filter_lip);