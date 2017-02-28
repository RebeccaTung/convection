// Gmsh project created on Tue Mar 22 09:44:33 2016

/***********************************************/
/* Parameters  */
scale = 1;
xmin = 0*scale;
xmax = 2*scale;
ymin = -1*scale;
y1 = -0.6*scale; // bottom of middle layer
y2 = -0.3*scale; // top of middle layer
amplitude = 0.05*scale;
ymax = 0*scale;

/****** MESH ***********/
nb_cells_x = 60; // nb cells in X dir along fault

nb_cells_y_top = 20;
nb_cells_y_middle = 26; // must be even
nb_cells_y_bottom = 20;

mesh_type = 2; // 2=quads (fully regular), 1=quads (non-regular), 0=triangles
// if mesh_type == 0
lc1 = 0.4*scale; // mesh characteristic length outside the fault (for triangular mesh)
lc2 = 0.02*scale; // mesh characteristic length in fault (for triangular mesh)
// if mesh_type == 1 or 2
progress_coeff = 1; // progression coefficient (for denser regular mesh towards fault)
// if mesh_type == 1
nb_cells_x2 = 4; // nb cells in X dir on the sides
/***********************************************/


Point(1) = {xmin, ymin, 0, lc1};
Point(2) = {xmax, ymin,  0, lc1};
Point(3) = {xmax, y1, 0, lc2};
Point(4) = {xmin, y1, 0, lc2};
Point(5) = {xmax, y2, 0, lc2};
Point(6) = {xmin, y2, 0, lc2};
Point(7) = {xmax, ymax, 0, lc1};
Point(8) = {xmin, ymax, 0, lc1};
Point(9) = {xmin+(xmax-xmin)/2, y2, 0, lc2};
Point(10) = {xmin+(xmax-xmin)/2, y1, 0, lc2};
Point(13) = {xmin+(xmax-xmin)/4, y1+amplitude, 0, lc2};
Point(14) = {xmin+3*(xmax-xmin)/4, y1-amplitude, 0, lc2};
Point(15) = {xmin+(xmax-xmin)/4, y2+amplitude, 0, lc2};
Point(16) = {xmin+3*(xmax-xmin)/4, y2-amplitude, 0, lc2};

Line(1) = {1,2};
Line(2) = {2,3};
Spline(3) = {4,13,10,14,3};
Line(4) = {4,1};
Line(52) = {5,3};
Spline(6) = {6,15,9,16,5};
Line(71) = {6,4};
Line(8) = {5,7};
Line(9) = {7,8};
Line(10) = {8,6};

Line Loop(1) = {1,2,-3,4};
Line Loop(21) = {71, 3, -52, -6};
Line Loop(3) = {9, 10, 6, 8};

If(mesh_type==0)
  Printf("Building non-regular mesh (with triangles)");
  Plane Surface(11) = {1};
  Plane Surface(121) = {21};      
  Plane Surface(13) = {3};
EndIf

If (mesh_type!=0)
  Printf("Buidling regular mesh (with quads)");
  Transfinite Line{2,-4} = nb_cells_y_bottom + 1 Using Progression progress_coeff;
  Transfinite Line{52,71} = nb_cells_y_middle/2 + 1;
  Transfinite Line{-8,10} = nb_cells_y_top + 1 Using Progression progress_coeff;

  If (mesh_type==2)
    Printf("Mesh fully regular");
    Transfinite Line{1,3,6,9} = nb_cells_x + 1;
  EndIf
  If (mesh_type==1)
    Printf("Mesh non-fully regular");
    Mesh.Smoothing = 4; // to get a 4 step Laplacian smoothing of the mesh
    Transfinite Line{3,6,11} = nb_cells_x + 1;
    Transfinite Line{1,9} = Floor(nb_cells_x2 + 1);
  EndIf

  Plane Surface(121) = {21};
  Transfinite Surface{121} = {3,5,6,4};

  If (mesh_type==1)
    Plane Surface(11) = {1};
    Plane Surface(13) = {3};
  EndIf
  If (mesh_type==2)
    Ruled Surface(11) = {1};
    Ruled Surface(13) = {3};
    Transfinite Surface{11} = {1,2,3,4}; // points indices, ordered
    Transfinite Surface{13} = {5,7,8,6};
  EndIf

  Recombine Surface {11};
  Recombine Surface {121};
  Recombine Surface {13};


EndIf

//Physical Line must start from 0
Physical Line(0) = {9}; // bottom
Physical Line(1) = {2,51,52,8,51,52}; // right hand side
Physical Line(2) = {1};  // top
Physical Line(3) = {10,71,72,4,71,72}; // left hand side
Physical Line(4) = {6}; // top contact line between layer and matrix
Physical Line(5) = {3}; // bottom contact line between layer and matrix

Physical Surface(0) = {11}; // bottom block
Physical Surface(1) = {121,122}; // middle block
Physical Surface(2) = {13}; // top block

Physical Point(6) = {11,12}; // middle points on LHS and RHS boundaries
Physical Point(7) = {7,8}; // top corners
Physical Point(8) = {1,2}; // bottom corners


Coherence;
Coherence;
Coherence;
