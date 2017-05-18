For this paper, we want to introduce a function of diffused permeability around a fault core, and apply it to a 'realistic' conceptual model, like the Soultz.

--Input Files--
   *diffused permeability
To achieve the diffused permeability around a fault core, it is computed in input files dummy_file.i and k_diff_2faults_file.i. A variable 'dummy' was solved using the diffusion kernel, computed by (k_fault-k_basement)/alpha, where k is the permeability and alpha the constant of the Lewis number (i.e. mu_fo*c_th*beta_star_m/sigma_ref). The solution (at specified timestep, depending on the width of the diffusion zone) is then extracted and used as an initial solution for a transient simulation.
	For example, if the fault has a permeability of 10e-14 and the basement 10e-20, a bell curve of diffusion will be seen with k_f at the highest in the fault core and diffusing away to 10e-20.
  * at the moment we only assign background permeability to be a constant everywhere, and also background = 0 in the IC.

*** dummy_file.i feeds 2d_soultz_inv_k.i, and
*** k_diff_2faults_file.i feeds 2d_soultz_2dfault_withdiff.i.


   *convection in faults
*2d_soultz_inv_k.i: lozenge/diamond shaped fault zone in a background rock (2 materials).
*case2_conv.i: 2 planar faults (lines in a 2D mesh) with graben fill, musc_and_bunt, and basement layers.
*case2_conv_2d_fault.i: 2 meshed faults with graben fill, musc_and_bunt, and basement layers.
*2d_soultz_2dfault_withdiff.i: 2 meshed faults with graben fill, musc_and_bunt, altered_granite, and basement layers.


--Meshes--
   *lozenges
*soultz_mesh.geo
*2000soultz_mesh_5x5pt2.msh
*4400soultz_mesh_5x5pt2.msh
*4566_soultz_mesh.msh
*5000_soultz_mesh.msh
*5200_soultz_mesh.msh
*6000_soultz_mesh.msh
*8000_soultz_mesh.msh

  *1D faults with sediments
*conv_case2_1d_fault.geo
*conv_case2.msh

  *2D faults with sediments
*conv_case2_2d_fault.geo
*8640_fault_conv_case2.msh
*9000_fault_conv_case2.msh
*13025_conv_case2_2d_fault.msh



