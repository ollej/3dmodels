// Customizable Martian Chess Board
// Copyright: Olle Wreede 2021
// License: CC BY-SA

//CUSTOMIZER VARIABLES

/* [Board] */

// Width in mm of each square
width_of_square = 28; // [20:0.5:35]

// Thickness in mm of board
thickness_of_board = 4; // [3:1:10]

// Width in mm of line between board sides
width_of_middle_line = 10; // [0:0.5:15]

// Width in mm of edges around squares
width_of_edges = 2; // [0:1:10]

// Radius of corners of board in mm
radius_of_board_corners = 2; // [0:0.2:5]

// Color of edges
color_of_edges = "purple";

// Color of black squares
color_of_black = "black";

// Color of white squares
color_of_white = "red";

// Distance between parts of board
distance_between_parts = 10; // [0:1:20]

/* [Displayed parts] */

show_left_board = true;
show_middle_board = true;
show_right_board = true;
show_black_squares = false;
show_white_squares = true;
show_edges = false;

//CUSTOMIZER VARIABLES END

/* [Hidden] */

$fn = 20;
fudge = 0.01;

module fillet(r, h) {
    translate([r / 2, r / 2, 0])
    difference() {
        cube([r + fudge, r + fudge, h], center = true);

        translate([r/2, r/2, 0])
        cylinder(r = r, h = h + 1, center = true);
    }
}

module board_square(side, thickness, col) {
    color(col, 1.0)
    cube(size = [side, side, thickness], center = false);
}

module board_line(side, thickness, col, off = false) {
    off_distance = off ? side : 0;
    translate([off_distance, 0, 0])    
    board_square(side, thickness, col);
    translate([off_distance + side * 2, 0, 0])    
    board_square(side, thickness, col);
}

module board_4x3(
    side,
    thickness,
    col,
    off) {
    board_line(side, thickness, col, off);

    translate([0, side, 0])
    board_line(side, thickness, col, !off);
    
    translate([0, side * 2, 0])
    board_line(side, thickness, col, off);
}

module board_edge_4x3(
    side,
    thickness,
    edge,
    edge_col,
    radius) {
    color(edge_col, 1.0) {
        difference() {
            translate([-edge, 0, 0])
            cube(size = [
                side * 4 + edge * 2,
                side * 3 + edge,
                thickness],
                center = false);

            translate([0, -fudge, -fudge])
            cube(size = [
                side * 4,
                side * 3 + fudge,
                thickness + fudge * 2],
                center = false);

            // Rounded corners
            translate([
                -edge,
                side * 3 + radius,
                thickness / 2])
            rotate([0, 0, 270])
            fillet(radius*2, thickness + fudge * 2);
            translate([
                side * 4 + radius,
                side * 3 + radius,
                thickness / 2])
            rotate([0, 0, 180])
            fillet(radius, thickness + fudge * 2);
        }
    }
}

module board_edge_middle(
    side,
    thickness,
    middle,
    edge,
    edge_col) {
    color(edge_col, 1.0) {
        difference() {
            translate([-edge, 0, 0])
            cube(size = [
                side * 4 + edge * 2,
                side * 2 + middle,
                thickness],
                center = false);

            translate([0, -fudge, -fudge])
            cube(size = [
                side * 4,
                side * 2 + middle + fudge * 2,
                thickness + fudge * 2],
                center = false);
        }
        
        // Middle line
        translate([0, side, 0])
        color(edge_col, 1.0)
        cube(size = [side * 4, middle, thickness], center = false);
    }
}

module board_middle(side, thickness, middle, square_col, off) {
    board_line(side, thickness, square_col, off);

    translate([0, side + middle, 0])
    board_line(side, thickness, square_col, !off);
}



// Left board
if (show_left_board) {
    if (show_edges) {
        board_edge_4x3(
            width_of_square,
            thickness_of_board,
            width_of_edges,
            color_of_edges,
            radius_of_board_corners);
    }
    if (show_black_squares) {
        board_4x3(
            width_of_square,
            thickness_of_board,
            color_of_black,
            false);
    }
    if (show_white_squares) {
        board_4x3(
            width_of_square,
            thickness_of_board,
            color_of_white,
            true);
    }
}

if (show_middle_board) {
    translate([0, - width_of_square * 2 - width_of_middle_line - distance_between_parts, 0]) {
        if (show_edges) {
            board_edge_middle(
                width_of_square,
                thickness_of_board,
                width_of_middle_line,
                width_of_edges,
                color_of_edges);
        }
        if (show_black_squares) {
            board_middle(
                width_of_square,
                thickness_of_board,
                width_of_middle_line,
                color_of_black,
                false);
        }
        if (show_white_squares) {
            board_middle(
                width_of_square,
                thickness_of_board,
                width_of_middle_line,
                color_of_white,
                true);
        }
    }
}

// Right board
if (show_right_board) {
    translate([0, 
    - width_of_square * 2 - width_of_middle_line - distance_between_parts * 2, thickness_of_board])
    rotate([-180, 0, 0])
    
     {
        if (show_edges) {
            board_edge_4x3(
                width_of_square,
                thickness_of_board,
                width_of_edges,
                color_of_edges,
                radius_of_board_corners);
        }
        if (show_black_squares) {
            board_4x3(
                width_of_square,
                thickness_of_board,
                color_of_black,
                false);
        }
        if (show_white_squares) {
            board_4x3(
                width_of_square,
                thickness_of_board,
                color_of_white,
                true);
        }
    }
}

