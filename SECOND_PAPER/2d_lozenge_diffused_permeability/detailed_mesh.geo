cl__1 = 100;
cl__2 = 1;
scaling_factor = 1;
ds_1 = scaling_factor/12;
ds_2 = scaling_factor/12;
ds_3 = scaling_factor/2;
ds_4 = scaling_factor/4;
ds_f= scaling_factor/36;
Point(1) = {2.050*scaling_factor, -1.500*scaling_factor, 0, ds_1};
Point(2) = {3.850*scaling_factor, -1.500*scaling_factor, 0, ds_1};
Point(6) = {3.050*scaling_factor, -3.000*scaling_factor, 0, ds_1};
Point(7) = {1.250*scaling_factor, -3.000*scaling_factor, 0, ds_1};
Point(8) = {1.8181*scaling_factor, -1.25*scaling_factor, 0, ds_2};
Point(9) = {4.3102*scaling_factor, -1.25*scaling_factor, 0, ds_2};
Point(10) = {3.2977*scaling_factor, -3.25*scaling_factor, 0, ds_2};
Point(11) = {0.7898*scaling_factor, -3.25*scaling_factor, 0, ds_2};
Point(22) = {0*scaling_factor, -3.5*scaling_factor, 0*scaling_factor, ds_3};
Point(23) = {0.9*scaling_factor, -3.5*scaling_factor, 0*scaling_factor, ds_2};
Point(24) = {3.4*scaling_factor, -3.5*scaling_factor, 0*scaling_factor, ds_2};
Point(25) = {5.2*scaling_factor, -3.5*scaling_factor, 0*scaling_factor, ds_3};

Point(40) = {0.5*scaling_factor, -3.8*scaling_factor, 0*scaling_factor, ds_4};
Point(41) = {0.61*scaling_factor, -3.5*scaling_factor, 0*scaling_factor, ds_4};
Point(42) = {1.5*scaling_factor, -0.5*scaling_factor, 0*scaling_factor, ds_4};
Point(43) = {3.5*scaling_factor, -3.8*scaling_factor, 0*scaling_factor, ds_4};
Point(44) = {3.61*scaling_factor, -3.5*scaling_factor, 0*scaling_factor, ds_4};
Point(45) = {4.5*scaling_factor, -0.5*scaling_factor, 0*scaling_factor, ds_4};

Line(1) = {1, 2};
Line(2) = {6, 6};
Line(3) = {2, 6};
Line(4) = {6, 7};
Line(5) = {7, 1};
Line(8) = {8, 9};
Line(9) = {9, 24};
Line(10) = {10, 11};
Line(11) = {23, 8};
Line Loop(7) = {1, 3, 4, 5};
Line Loop(12) = {8, 9, 30, 10, -29, 11};
Point(12) = {0, 0, 0, ds_3};
Point(13) = {5.200*scaling_factor, 0*scaling_factor, 0, ds_3};
Point(14) = {5.200*scaling_factor, -5.000*scaling_factor, 0, ds_3};
Point(15) = {0*scaling_factor, -5.000*scaling_factor, 0, ds_3};
Line(14) = {12, 13};
Line(15) = {13, 25};
Line(31) = {25, 14};
Line(16) = {15, 14};
Line(17) = {22, 12};
Line(32) = {15, 22};
Line Loop(18) = {14, 15, -28, 57, -54, -53, -27, 17};
Point(16) = {3.550*scaling_factor, -1.7004*scaling_factor, 0, ds_3};
Point(17) = {1.550*scaling_factor, -2.8008*scaling_factor, 0, ds_3};
Point(30) = {2.9  *scaling_factor, -2.8008*scaling_factor, 0, ds_3};
Point(31) = {2.2  *scaling_factor, -1.7004*scaling_factor, 0, ds_3};
//Printf("-1.7004*scaling_factor = ",-1.7004*scaling_factor);
Line(40) = {16, 31};
Line(41) = {31, 17};
Line(42) = {17, 30};
Line(43) = {30, 16};
Line Loop(21) = {-40,-43,-42,-41};
Plane Surface(22) = {21, 7};
Plane Surface(23) = {21};

Point(18) = {1.9, -1.4, 0, ds_f};
Point(19) = {3.2, -3.1, 0, ds_f};
Point(20) = {1, -3.1, 0, ds_f};
Point(21) = {4.1, -1.4, 0, ds_f};
Line(23) = {18, 21};
Line(24) = {21, 19};
Line(25) = {19, 20};
Line(26) = {20, 18};
Line Loop(27) = {23, 24, 25, 26};

Line(27) = {22, 41};
Line(28) = {44, 25};
Line(29) = {23, 11};
Line(30) = {24, 10};

Line(50) = {41, 23};
Line(51) = {24, 44};
Line(52) = {40, 41};
Line(53) = {41, 42};
Line(54) = {42, 45};
Line(55) = {40, 43};
Line(56) = {43, 44};
Line(57) = {44, 45};

Line Loop(28) = {27, -52, 55, 56, 28, 31, -16, 32};
Line Loop(29) = {50, 29, -10, -30, 51, -56, -55, 52};
Line Loop(30) = {53, 54, -57, -51, -9, -8, -11, -50};
Plane Surface(31) = {28};
Plane Surface(32) = {29};
Plane Surface(13) = {7, 27};
Plane Surface(30) = {27, 12};
Plane Surface(33) = {18};
Plane Surface(34) = {30};

//+
Translate {0, 0.5, 0} {
  Point{8}; Point{9}; Point{21}; Point{2}; Point{1}; Point{18}; Point{16}; Point{31};
}

//+
Translate {0, -0.3, 0} {
  Point{17}; Point{30}; Point{7}; Point{20}; Point{11}; Point{6}; Point{19}; Point{10};
}

//+
Translate {0.09, 0, 0} {
  Point{11}; Point{10}; Point{20}; Point{19}; Point{6}; Point{2};
}
//+
Translate {-0.01, -0.01, 0} {
  Point{42}; Point{45}; Point{8}; Point{9}; Point{18}; Point{21}; Point{1}; Point{2}; Point{31}; Point{16};
}

//+
Line(58) = {11, 20};
//+
Line(59) = {20, 7};
//+
Line(60) = {6, 19};
//+
Line(61) = {19, 10};
//+

//+
Delete {
  Surface{13};
}
//+
Delete {
  Surface{30};
}

//+
Line Loop(31) = {11, 8, 9, 30, -61, -60, -3, -1, -5, -59, -58, -29};
//+
Line Loop(32) = {5, 1, 3, 60, -24, -23, -26, 59};
//+
Plane Surface(35) = {32};
//+
Line Loop(33) = {58, 26, 23, 24, 61, -30, -9, -8, -11, 29};
//+
Plane Surface(36) = {33};
//+
Line Loop(34) = {59, -4, 60, 25};
//+
Plane Surface(37) = {34};
//+
Line Loop(35) = {25, -58, -10, -61};
//+
Plane Surface(38) = {35};


Physical Line(0) = {14};                     // top
Physical Line(1) = {15,31};                  // right
Physical Line(2) = {16};                     // bottom
Physical Line(3) = {17,32};                  // left
Physical Line(4) = {23, 24, 26};             //fault_core
Physical Line(5) = {27,50,29,10,30,51,28};   //basement_heat
Physical Line(6) = {25};                     //fault_bottom
Physical Line(7) = {8, 9, 11, 3, 1, 5, 4};   //fault_bounds_top
Physical Line(8) = {30, 10, 29};             //fault_bounds_bott


Physical Surface(0) = {22,23};              // inside
Physical Surface(1) = {35,36};              // fault_top
Physical Surface(2) = {37,38};              //fault_bottom
Physical Surface(3) = {34,33};              // outside_top
Physical Surface(4) = {32,31};              // outside_bottom
