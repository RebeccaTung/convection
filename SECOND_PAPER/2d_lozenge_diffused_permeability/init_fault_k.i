[Mesh]
  type = FileMesh
  file = detailed_mesh.msh
  boundary_name = 'top right bottom left fault_core basement fault_bottom'
  block_name = 'inside fault_top fault_bottom outside_top outside_bottom'
  allow_renumbering = false
  boundary_id = '0 1 2 3 4 5 6'
  block_id = '0 1 2 3 4 '
[]

[Variables]
  [./core_k]
  [../]
[]

[AuxVariables]
  [./aux_var_perm]
  [../]
  [./aux_var_bounds]
  [../]
[]

[BCs]
  [./fault_core]
    type = DirichletBC
    variable = core_k
    boundary = 'fault_core fault_bottom'
    value = 1 # k_fault = 2.3e-15, k_basement = 1.84e-17
  [../]
[]

[Kernels]
  [./diff]
    type = Diffusion
    variable = core_k
  [../]
  [./td]
    type = TimeDerivative
    variable = core_k
  [../]
[]

[AuxKernels]
  active = 'aux_ker_bounds'
  [./aux_ker_perm]
    type = ParsedAux
    variable = aux_var_perm
    function = 1.84e-20*aux_var_bounds
    args = aux_var_bounds
  [../]
  [./aux_ker_bounds]
    type = ParsedAux
    variable = aux_var_bounds
    function = max(core_k,0)
    args = core_k
    block = 'fault_bottom fault_top'
  [../]
[]

[Executioner]
  type = Transient
  num_steps = 1000000
  dt = 1e-7
  end_time = 1e-1
  [./TimeStepper]
    type = SolutionTimeAdaptiveDT
    percent_change = 0.2
    dt = 1e-07
  [../]
[]

[Outputs]
  exodus = true
  file_base = init_fault_k2
  print_linear_residuals = false
[]

[ICs]
  [./background]
    variable = core_k
    type = ConstantIC
    value = 0
  [../]
[]

