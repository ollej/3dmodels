//OpenSCAD PuzzleCut Library Demo - by Rich Olson
//http://www.nothinglabs.com
//Tested on build 2015.03-2
//License: http://creativecommons.org/licenses/by/3.0/

//!!!!!
//IMPORTANT NOTE: Puzzlecut only works correctly when RENDERING (F6)!  Preview (F5) will not produce usable results!
//!!!!!

include <libs/puzzlecutlib.scad>
include <sodastream_tube_holder_v6.scad>

stampSize = [100,100,250];		//size of cutting stamp (should cover 1/2 of object)

cutSize = 5;	//size of the puzzle cuts

xCut1 = [-5, 5];	//locations of puzzle cuts relative to X axis center
//yCut1 = [-64, -8, 8, 64];				//for Y axis

kerf = -0.1;		//supports +/- numbers (greater value = tighter fit)
					//using a small negative number may be useful to assure easy fit for 3d printing
					//using positive values useful for lasercutting
					//negative values can also help visualize cuts without seperating pieces

cutInThree(); //cuts in three along x axis

//comment out lines as needed to render individual pieces

module cutInThree()
{
	translate([0,-5,0])
		xMaleCut(offset = 0, cut = xCut1)
            rotatedHolder();

	translate([0,5,0])
		xFemaleCut(offset = 0, cut = xCut1)
            xMaleCut(offset = 70, cut = xCut1)
                rotatedHolder();

 	translate([0,15,0])
		xFemaleCut(offset = 70, cut = xCut1)
            rotatedHolder();

}

module rotatedHolder() {
    translate([0,-100,32.5]) {
        rotate([270, 0, 0]) {
            drawHolderObject();
        }
    }
}
