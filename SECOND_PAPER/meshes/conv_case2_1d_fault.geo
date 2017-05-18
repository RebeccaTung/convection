// Gmsh project created on Fri May 12 14:32:47 2017
scaling_factor = 1;
ds_out = scaling_factor/2;
ds_seds = scaling_factor/13;
ds_fault = scaling_factor/20;


Point(1) = {0*scaling_factor, 0*scaling_factor, 0, ds_seds};
Point(2) = {7.4*scaling_factor, 0*scaling_factor, 0, ds_seds};
Point(3) = {7.4*scaling_factor, -5*scaling_factor, 0, ds_out};
Point(4) = {0*scaling_factor, -5*scaling_factor, 0, ds_out};
Point(5) = {0*scaling_factor, -0.8*scaling_factor, 0, ds_seds};
Point(6) = {0*scaling_factor, -1.4*scaling_factor, 0, ds_seds};
Point(7) = {7.4*scaling_factor, -0.8*scaling_factor, 0, ds_seds};
Point(8) = {7.4*scaling_factor, -1.4*scaling_factor, 0, ds_seds};
Point(9) = {2.96*scaling_factor, -0.4*scaling_factor, 0, ds_fault};
Point(10) = {1.7*scaling_factor, -4*scaling_factor, 0, ds_out};
Point(11) = {5.6*scaling_factor, -0.4*scaling_factor, 0, ds_seds};
Point(12) = {4.4*scaling_factor, -4.1*scaling_factor, 0, ds_out};
Point(13) = {2.82*scaling_factor, -0.8*scaling_factor, 0, ds_fault};
Point(14) = {2.62*scaling_factor, -1.4*scaling_factor, 0, ds_seds};
Point(15) = {2.75*scaling_factor, -1*scaling_factor, 0, ds_fault};
Point(16) = {5.4*scaling_factor, -1*scaling_factor, 0, ds_fault};
Point(17) = {2.55*scaling_factor, -1.6*scaling_factor, 0, ds_seds};
Point(18) = {5.2*scaling_factor, -1.6*scaling_factor, 0, ds_seds};
Point(19) = {5.47*scaling_factor, -0.8*scaling_factor, 0, ds_fault};
Point(20) = {5.26*scaling_factor, -1.4*scaling_factor, 0, ds_seds};

Line(1) = {1, 2};
Line(2) = {2, 7};
Line(3) = {7, 8};
Line(4) = {8, 3};
Line(5) = {3, 4};
Line(6) = {4, 6};
Line(7) = {6, 5};
Line(8) = {5, 1};
Line(11) = {5, 13};
Line(12) = {6, 14};
Line(13) = {15, 16};
Line(14) = {17, 18};
Line(15) = {19, 7};
Line(16) = {20, 8};
Line(17) = {9, 13};
Line(18) = {13, 15};
Line(19) = {15, 14};
Line(20) = {14, 17};
Line(21) = {17, 10};
Line(22) = {11, 19};
Line(23) = {19, 16};
Line(24) = {16, 20};
Line(25) = {20, 18};
Line(26) = {18, 12};


Line Loop(27) = {8, 1, 2, -15, 23, -13, -18, -11};
Line Loop(50) = {17, -17};
Line Loop(51) = {22, -22};
Plane Surface(28) = {27, 50, 51};
Line Loop(29) = {7, 11, 18, 19, -12};
Line Loop(81) = {14, -25, -24, -13, 19, 20};
Line Loop(31) = {15, 3, -16, -24, -23};
Plane Surface(30) = {29};
Plane Surface(82) = {81};
Plane Surface(32) = {31};
Line Loop(55) = {6, 12, 20, 14, -25, 16, 4, 5};
Line Loop(70) = {21, -21};
Line Loop(71) = {26, -26};
Plane Surface(33) = {55, 70, 71};
Line Loop(83) = {-21, -20, -19, -18, -17};
Plane Surface(84) = {83};


Physical Line(72) = {1};                     // top
Physical Line(73) = {2, 3, 4};               // right
Physical Line(74) = {5};                     // bottom
Physical Line(75) = {6, 7, 8};               // left
Physical Line(76) = {17, 18, 19, 20, 21};    // fault_left
Physical Line(77) = {22, 23, 24, 25, 26};    // fault_right
Physical Surface(78) = {28};                 // graben_fill
Physical Surface(79) = {30, 82, 32};         // musc_and_bunt
Physical Surface(80) = {33};                 // basement
Physical Line(81) = {12, 14, 16};            // musc_bottom
