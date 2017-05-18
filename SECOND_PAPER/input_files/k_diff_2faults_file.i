[Mesh]
  type = FileMesh
  file = 13025_conv_case2_2d_fault.msh
  block_name = 'fault_left fault_right graben musc altered_granite basement'
  block_id = '76 77 78 79 80 90'
  boundary_name = 'top right bottom left musc_bottom fault_left_boundary fault_right_boundary'
  boundary_id = '72 73 74 75 81 90 91'
[]

[Variables]
  [./dummy]
  [../]
[]

[BCs]
  [./fault_core]
    type = DirichletBC
    variable = dummy
    boundary = 'fault_left_boundary fault_right_boundary'
    value = 5.43E+05
  [../]
[]

[Kernels]
  [./diff]
    type = Diffusion
    variable = dummy
  [../]
  [./td]
    type = TimeDerivative
    variable = dummy
  [../]
[]

[Executioner]
  type = Transient
  num_steps = 1000000000
  dt = 5e-5
  end_time = 5e-3
[]

[Outputs]
  exodus = true
  file_base = k_diff_2faults
  print_linear_residuals = false
[]

[ICs]
  [./background]
    variable = dummy
    value = 0
    type = ConstantIC
    block = 'basement graben musc'
  [../]
  [./faults]
    variable = dummy
    value = 5.43E+05
    type = ConstantIC
    block = 'fault_left fault_right'
  [../]
[]

