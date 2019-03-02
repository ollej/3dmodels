include <libs/hugo_dovetail.scad>
include <sodastream_bottle_holder.scad>

//CUTS = [[0, 150, 0], [0, 260, 0], [0, 290, 0]];
CUTS = [[0, 150, 0], [0, 290, 0]];
DOVETAIL_CLEAR = 0.8;
DOVETAIL_TEETH = [3, 4, DOVETAIL_CLEAR];

//CUT_CUBE_DIM = [OUTER_DIAMETER + 10, 250, OUTER_DIAMETER + 10];
CUT_CUBE_DIM = [89, 150, 120];

module cut_base() {
    intersection() {
        rotatedHolder();

        translate([0, 0, -15])
        cutter(CUTS[0], CUT_CUBE_DIM, DOVETAIL_TEETH, true);
    }
}

module cut_collar() {
    intersection() {
        rotatedHolder();

        translate([0, 0, -15])
        cutter(CUTS[0], CUT_CUBE_DIM, DOVETAIL_TEETH, false);

        translate([0, 0, -15])
        cutter(CUTS[1], CUT_CUBE_DIM, DOVETAIL_TEETH, true);
    }
}

module cut_hook() {
    intersection() {
        rotatedHolder();

        translate([0, 0, -15])
        cutter(CUTS[1], CUT_CUBE_DIM, DOVETAIL_TEETH, false);
    }
}

module cutHolder() {
    cut_base();
    cut_collar();
    cut_hook();
}

cutHolder();
//cut_base();
//cut_collar();
//cut_hook();
