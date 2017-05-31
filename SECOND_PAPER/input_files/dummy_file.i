[Mesh]
  type = FileMesh
  file = 6000_soultz_mesh.msh
[]

[Variables]
  [./dummy]
  [../]
[]

[BCs]
  [./fault_core]
    type = DirichletBC
    variable = dummy
    boundary = 4
    value = 5.43E+05 # k_fault = 1e-14, k_basement = 1e-20
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
  file_base = dummy_file
  print_linear_residuals = false
[]

[ICs]
  [./background]
    variable = dummy
    type = ConstantIC
    value = 0
  [../]
[]

