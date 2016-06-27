[Mesh]
  type = FileMesh
  file = ../meshes/3d_fault.msh
  boundary_name = 'back bottom right top left front'
  block_name = 'top_block middle_block bottom_block'
  boundary_id = '0 1 2 3 4 5'
  block_id = '0 1 2'
[]

[Variables]
  [./Temperature]
  [../]
  [./disp_x]
  [../]
  [./disp_y]
  [../]
  [./disp_z]
  [../]
  [./pore_pressure]
  [../]
[]

[Functions]
  [./fault_vel_fct]
    type = ParsedFunction
    value = 1*tanh(1e1*t)
  [../]
  [./x_proj_fct]
    type = ParsedFunction
    value = cos(fault_angle*pi/180.)
    vals = -10.0
    vars = fault_angle
  [../]
  [./y_proj_fct]
    type = ParsedFunction
    value = sin(fault_angle*pi/180.)
    vals = -10.0
    vars = fault_angle
  [../]
  [./top_bc_x_fct]
    type = CompositeFunction
    functions = 'x_proj_fct fault_vel_fct'
  [../]
  [./top_bc_y_fct]
    type = CompositeFunction
    functions = 'y_proj_fct fault_vel_fct'
  [../]
[]

[Kernels]
  [./dT_dt]
    type = TimeDerivative
    variable = Temperature
  [../]
  [./diff_T]
    type = Diffusion
    variable = Temperature
  [../]
  [./dP_dt]
    type = TimeDerivative
    variable = pore_pressure
  [../]
[]

[BCs]
  [./top_bottom_T]
    type = DirichletBC
    variable = Temperature
    boundary = 'top bottom'
    value = 0
  [../]
  [./ux_top]
    type = FunctionDirichletBC
    variable = disp_x
    boundary = top
    function = top_bc_x_fct
  [../]
  [./ux_bottom]
    type = DirichletBC
    variable = disp_x
    boundary = bottom
    value = 0
  [../]
  [./uy_top]
    type = FunctionDirichletBC
    variable = disp_y
    boundary = top
    function = top_bc_y_fct
  [../]
  [./uy_bttom]
    type = DirichletBC
    variable = disp_y
    boundary = bottom
    value = 0
  [../]
  [./uz_bottom]
    type = DirichletBC
    variable = disp_z
    boundary = bottom
    value = 0
  [../]
  [./top_bottom_P]
    type = DirichletBC
    variable = pore_pressure
    boundary = 'top bottom'
    value = 0
  [../]
[]

[Materials]
  [./no_mech]
    type = RedbackMaterial
  [../]
  [./mech_fault]
    type = RedbackMechMaterialDP
    block = middle_block
    disp_z = disp_z
    disp_y = disp_y
    disp_x = disp_x
    pore_pres = pore_pressure
    yield_stress = '0 1 1 1'
    total_porosity = 0.1
    temperature = Temperature
    poisson_ratio = 0.3
    youngs_modulus = 100
  [../]
  [./mech_background]
    type = RedbackMechMaterialElastic
    block = 'bottom_block top_block'
    disp_z = disp_z
    disp_y = disp_y
    disp_x = disp_x
    pore_pres = pore_pressure
    total_porosity = 0.1
    temperature = Temperature
    poisson_ratio = 0.3
    youngs_modulus = 10000
  [../]
[]

[Postprocessors]
  [./dt]
    type = TimestepSize
  [../]
[]

[Preconditioning]
  [./SMP]
    type = SMP
    full = true
    solve_type = PJFNK
    petsc_options_iname = '-ksp_type -pc_type -sub_pc_type -ksp_gmres_restart'
    petsc_options_value = 'gmres asm lu 201'
  [../]
[]

[Executioner]
  type = Transient
  num_steps = 3
  [./TimeStepper]
    type = ConstantDT
    dt = 1e-3
  [../]
[]

[Outputs]
  exodus = true
  file_base = 3d_fault
  csv = true
  print_perf_log = true
[]

[ICs]
  [./T_middle_layer]
    variable = Temperature
    value = 1
    type = ConstantIC
    block = 1
  [../]
[]

[RedbackMechAction]
  [./my_action]
    disp_z = disp_z
    temp = Temperature
    disp_x = disp_x
    pore_pres = pore_pressure
    disp_y = disp_y
  [../]
[]

