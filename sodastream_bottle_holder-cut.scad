include <libs/hugo_dovetail.scad>
include <sodastream_tube_holder.scad>

//CUTS = [[0, 150, 0], [0, 260, 0], [0, 290, 0]];
CUTS = [[0, 150, 0], [0, 290, 0]];
DOVETAIL_CLEAR = 0.3;
DOVETAIL_TEETH = [3, 4, DOVETAIL_CLEAR];

//CUT_CUBE_DIM = [OUTER_DIAMETER + 10, 250, OUTER_DIAMETER + 10];
CUT_CUBE_DIM = [89, 150, 160];

module cutHolder() {
    // Base
    intersection() {
        rotatedHolder();
        cutter(CUTS[0], CUT_CUBE_DIM, DOVETAIL_TEETH, true);
    }
    
    // Collar
    intersection() {
        rotatedHolder();
        cutter(CUTS[0], CUT_CUBE_DIM, DOVETAIL_TEETH, false);
        cutter(CUTS[1], CUT_CUBE_DIM, DOVETAIL_TEETH, true);
    }
    
    // Hook
    intersection() {
        rotatedHolder();
        cutter(CUTS[1], CUT_CUBE_DIM, DOVETAIL_TEETH, false);
    }
    
}

cutHolder();