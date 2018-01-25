/*********************************************************************
 *
 *  meshing from image (PostView), starting from Gmsh tutorials 1 and 7
 *  Workflow:
 *   1) load image in gmsh and export as .pos
 *   2) edit script below to set width and height appropriately
 *   3) mesh it
 * Seems to work, but I don't fully understand it yet...
 * See http://onelab.info/pipermail/gmsh/2013/thread.html#8445 and http://onelab.info/pipermail/gmsh/2013/008445.html 
 *********************************************************************/

lc = 10;
width  = 121; // pixels of picture to match
height = 67; // pixels of picture to match

Point(1) = {0, 0, 0, lc};
Point(2) = {width, 0,  0, lc} ;
Point(3) = {width, height, 0, lc} ;
Point(4) = {0, height, 0, lc} ;

Line(1) = {1,2} ;
Line(2) = {3,2} ;
Line(3) = {3,4} ;
Line(4) = {4,1} ;

Line Loop(1) = {4,1,-2,3} ;

Plane Surface(1) = {1} ;

Physical Point(1) = {1,2} ;

MY_LINE = 2;
Physical Line(MY_LINE) = {1,2} ;
Physical Line("My second line (automatic physical id)") = {3} ;
Physical Line("My third line (physical id 5)", 5) = {4} ;
Physical Surface("My surface") = {1} ;


// Merge a post-processing view containing the target mesh sizes
Merge "test.pos"; // pos file (see comments at the top of this file)

// Apply the view as the current background mesh
Background Mesh View[0];
