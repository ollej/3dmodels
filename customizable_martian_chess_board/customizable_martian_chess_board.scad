// Customizable Martian Chess Board
// Copyright: Olle Wreede 2021
// License: CC BY-SA

// TODO
// * Generate single extruder color version with different heights for colors

//CUSTOMIZER VARIABLES

/* [Board] */

// Width in mm of each square
width_of_square = 28; // [20:0.5:35]

// Thickness in mm of board (excluding bottom)
thickness_of_board = 1; // [0.2:0.2:5]

// Thickness of single color bottom
thickness_of_bottom = 3; // [0:0.2:5]

// Width in mm of line between board sides
width_of_middle_line = 10; // [0:0.5:15]

// Width in mm of edges around squares
width_of_edges = 5; // [0:1:15]

// Radius of corners of board in mm
radius_of_board_corners = 2; // [0:0.2:10]

// Distance between parts of board
distance_between_parts = 5; // [0:1:20]

// Number of squares along width
number_of_squares_width = 4; // [2:2:10]

// Number of squares along length of either side
number_of_squares_length = 4; // [2:1:10]

/* [Displayed parts] */

show_left_board = true;
show_middle_board = true;
show_right_board = true;
show_black_squares = true;
show_white_squares = true;
show_edges = true;
show_bottom = true;

/* [Colors] */

// Color of edges
color_of_edges = "purple";

// Color of black squares
color_of_black = "black";

// Color of white squares
color_of_white = "red";

// Color of board bottom
color_of_bottom = "blue";

// Which color should be in lower right corner
invert_square_colors = false;

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

module board_side(
    side,
    squaresx,
    squaresy,
    thickness,
    col,
    off) {
    for (i = [0 : squaresy - 1]) {
        translate([0, side * i, 0]) {
            black = (i % 2 == 0) ? 1 : 0;
            white = (i % 2 != 0) ? 1 : 0;
            start = off ? black : white;
            for (j = [start : squaresx - 1]) {
                if (((j + start) % 2) == 0) {
                    translate([side * j, 0, 0]) 
                    board_square(side, thickness, col);
                }
            }
        }
    }
}

module board_edge_side(
    side,
    squaresx,
    squaresy,
    thickness,
    edge,
    edge_col,
    radius) {
    color(edge_col, 1.0) {
        difference() {
            translate([-edge, 0, 0])
            cube(size = [
                side * squaresx + edge * 2,
                side * (squaresy - 1) + edge,
                thickness],
                center = false);

            translate([0, -fudge, -fudge])
            cube(size = [
                side * squaresx,
                side * (squaresy - 1) + fudge,
                thickness + fudge * 2],
                center = false);

            // Rounded corners
            translate([
                -edge,
                side * (squaresy - 1) + edge,
                thickness / 2])
            rotate([0, 0, 270])
            fillet(radius * 2, thickness + fudge * 2);
            translate([
                side * squaresx + edge,
                side * (squaresy - 1) + edge,
                thickness / 2])
            rotate([0, 0, 180])
            fillet(radius * 2, thickness + fudge * 2);
        }
    }
}

module board_edge_middle(
    side,
    squaresx,
    thickness,
    middle,
    edge,
    edge_col) {
    color(edge_col, 1.0) {
        difference() {
            translate([-edge, 0, 0])
            cube(size = [
                side * squaresx + edge * 2,
                side * 2 + middle,
                thickness],
                center = false);

            translate([0, -fudge, -fudge])
            cube(size = [
                side * squaresx,
                side * 2 + middle + fudge * 2,
                thickness + fudge * 2],
                center = false);
        }
        
        // Middle line
        translate([0, side, 0])
        color(edge_col, 1.0)
        cube(size = [side * squaresx, middle, thickness], center = false);
    }
}

module board_middle(side, squaresx, thickness, middle, square_col, off) {
    board_side(side, squaresx, 1, thickness, square_col, off);
    translate([0, side + middle, 0])
    board_side(side, squaresx, 1, thickness, square_col, !off);
}

module board_bottom(thickness, squaresx, squaresy, side, edge, middle, radius, col) {
    translate([0, 0, -thickness])
    color(col, 1.0) {
        // Bottom of middle
        translate([-edge, - side * 2 - middle - distance_between_parts, 0])
        cube(size = [
            side * squaresx + edge * 2,
            side * 2 + middle,
            thickness],
            center = false);
        
        // Bottom of left side
        difference() {
            translate([-edge, 0, 0])
            cube(size = [
                side * squaresx + edge * 2,
                side * (squaresy - 1) + edge,
                thickness],
                center = false);

            // Rounded corners
            translate([
                -edge,
                side * (squaresy - 1) + edge,
                thickness / 2])
            rotate([0, 0, 270])
            fillet(radius * 2, thickness + fudge * 2);
            translate([
                side * squaresx + edge,
                side * (squaresy - 1) + edge,
                thickness / 2])
            rotate([0, 0, 180])
            fillet(radius * 2, thickness + fudge * 2);
        }

        // Bottom of right side
        translate([
            -edge,
            - side * (squaresy + 1) - middle - edge - distance_between_parts,
            0])
        difference() {
            cube(size = [
                side * squaresx + edge * 2,
                side * (squaresy - 1) + edge,
                thickness],
                center = false);

            // Rounded corners
            translate([
                0,
                0,
                thickness / 2])
            fillet(radius * 2, thickness + fudge * 2);
            translate([
                side * squaresx + edge * 2,
                0,
                thickness / 2])
            rotate([0, 0, 90])
            fillet(radius * 2, thickness + fudge * 2);
        }
    }
}

module side_board() {
    if (show_edges) {
        board_edge_side(
            width_of_square,
            number_of_squares_width,
            number_of_squares_length,
            thickness_of_board,
            width_of_edges,
            color_of_edges,
            radius_of_board_corners);
    }
    if (show_black_squares) {
        board_side(
            width_of_square,
            number_of_squares_width,
            number_of_squares_length - 1,
            thickness_of_board,
            color_of_black,
            invert_square_colors);
    }
    if (show_white_squares) {
        board_side(
            width_of_square,
            number_of_squares_width,
            number_of_squares_length - 1,
            thickness_of_board,
            color_of_white,
            !invert_square_colors);
    }
}

rotate([0, 0, 90]) {
    // Left board
    if (show_left_board) {
        side_board();
    }

    if (show_middle_board) {
        translate([0, - width_of_square * 2 - width_of_middle_line - distance_between_parts, 0]) {
            if (show_edges) {
                board_edge_middle(
                    width_of_square,
                    number_of_squares_width,
                    thickness_of_board,
                    width_of_middle_line,
                    width_of_edges,
                    color_of_edges);
            }
            if (show_black_squares) {
                board_middle(
                    width_of_square,
                    number_of_squares_width,
                    thickness_of_board,
                    width_of_middle_line,
                    color_of_black,
                    invert_square_colors);
            }
            if (show_white_squares) {
                board_middle(
                    width_of_square,
                    number_of_squares_width,
                    thickness_of_board,
                    width_of_middle_line,
                    color_of_white,
                    !invert_square_colors);
            }
        }
    }

    // Right board
    if (show_right_board) {
        translate([
            width_of_square * number_of_squares_width, 
            - width_of_square * 2
            - width_of_middle_line
            - distance_between_parts * 2, 0])
        rotate([0, 0, 180])
        side_board();
    }

    if (show_bottom) {
        board_bottom(
            thickness_of_bottom,
            number_of_squares_width,
            number_of_squares_length,
            width_of_square,
            width_of_edges,
            width_of_middle_line,
            radius_of_board_corners,
            color_of_bottom);
    }
}
