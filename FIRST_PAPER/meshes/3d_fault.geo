/***********************************************/
/* Parameters  */
xmin = 0;
xmax = 2.0;
ymin = -1;
y1 = -0.3; // top of LHS
ymax = 0;
zmin = 0;
zmax = 1;

fault_thickness = 0.01;
slope = -10; // slope of middle layer in degrees

/****** MESH ***********/
nb_cells_x = 40; // nb cells in X dir along fault

nb_cells_y_top = 10;
nb_cells_y_middle = 4;
nb_cells_y_bottom = 10;

nb_cells_z = 5;

mesh_type = 2; // 2=quads (fully regular), 1=quads (non-regular), 0=triangles (wedges)
// if mesh_type == 0
lc1 = 0.4; // mesh characteristic length outside the fault (for triangular mesh)
lc2 = 0.02; // mesh characteristic length in fault (for triangular mesh)
// if mesh_type == 1 or 2
progress_coeff = 0.7; // progression coefficient (for denser regular mesh towards fault)
// if mesh_type == 1
nb_cells_x2 = 4; // nb cells in X dir on the sides 
/***********************************************/

y2 = y1 - fault_thickness/Cos(slope* Pi /180.0); // bottom of LHS
// Applying given slope to find points on the right hand side
test = slope;
delta_y = (xmax - xmin)*Tan(slope* Pi /180.0);
y3 = y1 + delta_y; // top of RHS
y4 = y2 + delta_y; // bottom of RHS

Point(1) = {xmin, ymin, 0, lc1};
Point(2) = {xmax, ymin,  0, lc1};
Point(3) = {xmax, y3, 0, lc2};
Point(4) = {xmin, y1, 0, lc2};
Point(5) = {xmax, y4, 0, lc2};
Point(6) = {xmin, y2, 0, lc2};
Point(7) = {xmax, ymax, 0, lc1};
Point(8) = {xmin, ymax, 0, lc1};

Line(1) = {1,2};
Line(2) = {2,5};
Line(3) = {3,4};
Line(4) = {6,1};
Line(5) = {3,5};
Line(6) = {5,6};
Line(7) = {6,4};
Line(8) = {3,7};
Line(9) = {7,8};
Line(10) = {8,4};

Line Loop(1) = {1,2,6,4};
Line Loop(2) = {5,6,7,-3};
Line Loop(3) = {8,9,10,-3};

If(mesh_type==0)
  Printf("Building non-regular mesh (with triangles)");
  Plane Surface(11) = {1};
  Plane Surface(12) = {2};
  Plane Surface(13) = {3};
EndIf

 If (mesh_type!=0)
  Printf("Buidling regular mesh (with quads)");
  Transfinite Line{2,-4} = nb_cells_y_bottom + 1 Using Progression progress_coeff;
  Transfinite Line{5,7} = nb_cells_y_middle + 1;
  Transfinite Line{-8,10} = nb_cells_y_top + 1 Using Progression progress_coeff;
  
  If (mesh_type==2)
    Printf("Mesh fully regular");
    Transfinite Line{1,3,6,9} = nb_cells_x + 1;
  EndIf
  If (mesh_type==1)
    Printf("Mesh non-fully regular");
    Mesh.Smoothing = 4; // to get a 4 step Laplacian smoothing of the mesh
    Transfinite Line{3,6} = nb_cells_x + 1;
    Transfinite Line{1,9} = Floor(nb_cells_x2 + 1);
  EndIf
  
  Plane Surface(12) = {2};
  Transfinite Surface{12} = {3,5,6,4};
  
  If (mesh_type==1)
    Plane Surface(11) = {1};
    Plane Surface(13) = {3};
  EndIf
  If (mesh_type==2)
    Ruled Surface(11) = {1};
    Ruled Surface(13) = {3};
    Transfinite Surface{11} = {1,2,5,6}; // points indices, ordered
    Transfinite Surface{13} = {4,3,7,8};
  EndIf
  
  Recombine Surface {11};
  Recombine Surface {12};
  Recombine Surface {13};

EndIf

z_total = zmax - zmin;

tmp1[] = Extrude {0.0,0.0,z_total}{ Surface{11}; Layers{nb_cells_z}; Recombine;};
tmp2[] = Extrude {0.0,0.0,z_total}{ Surface{12}; Layers{nb_cells_z}; Recombine;};
tmp3[] = Extrude {0.0,0.0,z_total}{ Surface{13}; Layers{nb_cells_z}; Recombine;};


//Physical Line must start from 0
Physical Surface(0) = {11,12,13};                 // back (min in Z)
Physical Surface(1) = {tmp1[2]};                  // bottom (min in Y)
Physical Surface(2) = {tmp1[3],tmp2[2],tmp3[2]};  // right (max in X)
Physical Surface(3) = {tmp3[3]};                  // top (max in Y)
Physical Surface(4) = {tmp1[5],tmp2[4],tmp3[4]};  // left (min in X)
Physical Surface(5) = {tmp1[0],tmp2[0],tmp3[0]};  // front (max in Z)

Physical Volume(0) = {tmp3[1]}; // top block
Physical Volume(1) = {tmp2[1]}; // middle block
Physical Volume(2) = {tmp1[1]}; // bottom block
