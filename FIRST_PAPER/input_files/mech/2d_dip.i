[GlobalParams]
  time_factor = 1.e-3
[]

[Mesh]
  type = FileMesh
  file = 2d_fault.msh
  dim = 2
  block_name = 'bottom fault top'
  block_id = '0 1 2'
  boundary_name = 'top bottom left right fault_upper fault_lower'
  boundary_id = '0 1 2 3 4 5'
[]

[Variables]
  [./temp]
  [../]
  [./pore_pressure]
  [../]
[]

[Materials]
  [./redback_materialA]
    type = RedbackMaterial
    block = 'bottom top'
    temperature = temp
    pore_pres = pore_pressure
    Aphi = 1
    ar = 10
    ar_F = 1
    ar_R = 1
    are_convective_terms_on = true
    delta = 0.0333333333333
    eta1 = 1e3
    fluid_compressibility = 0.002
    fluid_thermal_expansion = 0.0007
    gravity = '0 -1.96 0'
    Peclet_number = 1.0
    phi0 = 0.3
    pressurization_coefficient = 0.166923076923
    ref_lewis_nb = 8.0e-08
    solid_compressibility = 0.001
    solid_thermal_expansion = 1e-05
    total_porosity = total_porosity
    gr = 0
  [../]
  [./redback_materialB]
    type = RedbackMaterial
    block = 'fault'
    temperature = temp
    pore_pres = pore_pressure
    Aphi = 1
    ar = 10
    ar_F = 1
    ar_R = 1
    are_convective_terms_on = true
    delta = 0.0333333333333
    eta1 = 1e3
    fluid_compressibility = 0.002
    fluid_thermal_expansion = 0.0007
    gravity = '0 -1.96 0'
    Peclet_number = 1.0
    phi0 = 0.3
    pressurization_coefficient = 0.166923076923
    ref_lewis_nb = 8.0e-08
    solid_compressibility = 0.001
    solid_thermal_expansion = 1e-05
    total_porosity = total_porosity
    inverse_lewis_number_tilde = inv_Le_perturb
    gr = 0
  [../]
[]

[Functions]
  [./init_gradient_T]
    # (0.0-y*(1.0-0.0)*1000/500) + 0.2*1/2*(cos(pi*(2*y-(-0.5)-0)/(0-(-0.5)))+1)*cos(pi*(2*x-0-1)/(1-0))
    # T_max + (y-y_min)*(T_min-T_max)/(y_max-y_min)
    # + amplitude*1/2*(cos(pi*(2*y-y_min-y_max)/(y_max-y_min))+1)*cos(pi*(2*x-x_min-x_max)/(x_max-x_min))
    type = ParsedFunction
    value = 'T_max + (y-y_min)*(T_min-T_max)/(y_max-y_min)+amplitude*1/2*(cos(pi*(2*y-y_min-y_max)/(y_max-y_min))+1)*cos(pi*(2*x-x_min-x_max)/(x_max-x_min))'
    vals = '-1           0           0           2           0           1           0.2'
    vars = 'y_min y_max x_min x_max  T_min T_max amplitude'
  [../]
  [./init_gradient_P]
    type = ParsedFunction
    value = (0.02-1.96*y)
  [../]
  [./timestep_function]
    type = ParsedFunction
    value = 'min(max(1e-15, dt*max(0.2, 1-0.05*(n_li-50))), (1e-1)*50.0/max(abs(v_max), abs(v_min)))'
    vals = 'num_li num_nli min_fluid_vel_y max_fluid_vel_y dt'
    vars = 'n_li n_nli v_min v_max dt'
  [../]
  [./grad_for_Nusselt]
    # old Nusselt calc: sqrt(max(abs(x_max),abs(x_min))^2+max(abs(y_max),abs(y_min))^2)
    # max_gradT_x max_gradT_y
    type = ParsedFunction
    value = (max_norm_grad_T)/((T_bottom-T_top)/height)
    vals = 'max_norm_grad_T  1               0        0.5'
    vars = 'max_norm_grad_T T_bottom T_top height'
  [../]
  [./Nusselt2]
    type = ParsedFunction
    value = 1.00+max_norm_gradT_conv/max_norm_gradT_ref
    vals = 'max_norm_gradT_ref max_norm_gradT_conv'
    vars = 'max_norm_gradT_ref max_norm_gradT_conv'
  [../]
[]

[BCs]
  [./temperature_top]
    type = DirichletBC
    variable = temp
    boundary = top
    value = 0.0
  [../]
  [./temperature_bottom]
    type = DirichletBC
    variable = temp
    boundary = bottom
    value = 1.0
  [../]
  [./pore_pressure_top]
    type = DirichletBC
    variable = pore_pressure
    boundary = top
    value = 0.02
  [../]
[]

[AuxVariables]
  [./total_porosity]
    family = MONOMIAL
  [../]
  [./Lewis_number]
    order = CONSTANT
    family = MONOMIAL
  [../]
  [./fluid_vel_x]
    order = CONSTANT
    family = MONOMIAL
  [../]
  [./fluid_vel_y]
    order = CONSTANT
    family = MONOMIAL
  [../]
  [./fluid_vel_z]
    order = CONSTANT
    family = MONOMIAL
  [../]
  [./grad_temp_x_var]
    order = CONSTANT
    family = MONOMIAL
  [../]
  [./grad_temp_y_var]
    order = CONSTANT
    family = MONOMIAL
  [../]
  [./grad_temp_z_var]
    order = CONSTANT
    family = MONOMIAL
  [../]
  [./inv_Le_perturb]
    order = CONSTANT
    family = MONOMIAL
  [../]
  [./norm_grad_T]
    order = CONSTANT
    family = MONOMIAL
  [../]
  [./norm_gradT_conv]
    order = CONSTANT
    family = MONOMIAL
  [../]
  [./norm_gradT_ref]
    order = CONSTANT
    family = MONOMIAL
  [../]
  [./temp_ref]
  [../]
  [./temp_conv]
  [../]
  [./grad_temp_conv_x_var]
    order = CONSTANT
    family = MONOMIAL
  [../]
  [./grad_temp_conv_y_var]
    order = CONSTANT
    family = MONOMIAL
  [../]
  [./grad_temp_conv_z_var]
    order = CONSTANT
    family = MONOMIAL
  [../]
  [./grad_temp_ref_x_var]
    order = CONSTANT
    family = MONOMIAL
  [../]
  [./grad_temp_ref_y_var]
    order = CONSTANT
    family = MONOMIAL
  [../]
  [./grad_temp_ref_z_var]
    order = CONSTANT
    family = MONOMIAL
  [../]
[]

[Kernels]
  active = 'pres_conv press_td temp_diff temp_dissip temp_td temp_conv press_diff'
  [./temp_td]
    type = TimeDerivative
    variable = temp
  [../]
  [./temp_diff]
    type = RedbackThermalDiffusion
    variable = temp
  [../]
  [./temp_conv]
    type = RedbackThermalConvection
    variable = temp
  [../]
  [./press_td]
    type = TimeDerivative
    variable = pore_pressure
  [../]
  [./press_diff]
    type = RedbackMassDiffusion
    variable = pore_pressure
  [../]
  [./pres_conv]
    type = RedbackMassConvection
    variable = pore_pressure
    temperature = temp
  [../]
  [./press_thermPress]
    type = RedbackThermalPressurization
    variable = pore_pressure
    temperature = temp
  [../]
  [./temp_dissip]
    type = RedbackMechDissip
    variable = temp
  [../]
[]

[AuxKernels]
  [./total_porosity]
    type = RedbackTotalPorosityAux
    variable = total_porosity
    mechanical_porosity = 0
    execute_on = linear
  [../]
  [./Lewis_number]
    type = MaterialRealAux
    variable = Lewis_number
    property = lewis_number
  [../]
  [./fluid_vel_x]
    type = MaterialRealVectorValueAux
    component = 0
    variable = fluid_vel_x
    property = fluid_velocity
  [../]
  [./fluid_vel_y]
    type = MaterialRealVectorValueAux
    component = 1
    variable = fluid_vel_y
    property = fluid_velocity
  [../]
  [./fluid_vel_z]
    type = MaterialRealVectorValueAux
    component = 2
    variable = fluid_vel_z
    property = fluid_velocity
  [../]
  [./grad_temp_x_kernel]
    type = VariableGradientComponent
    variable = grad_temp_x_var
    component = x
    gradient_variable = temp
  [../]
  [./grad_temp_y_kernel]
    type = VariableGradientComponent
    variable = grad_temp_y_var
    component = y
    gradient_variable = temp
  [../]
  [./grad_temp_z_kernel]
    type = VariableGradientComponent
    variable = grad_temp_z_var
    component = z
    gradient_variable = temp
  [../]
  [./grad_temp_conv_x_kernel]
    type = VariableGradientComponent
    variable = grad_temp_conv_x_var
    component = x
    gradient_variable = temp_conv
  [../]
  [./grad_temp_conv_y_kernel]
    type = VariableGradientComponent
    variable = grad_temp_conv_y_var
    component = y
    gradient_variable = temp_conv
  [../]
  [./grad_temp_conv_z_kernel]
    type = VariableGradientComponent
    variable = grad_temp_conv_z_var
    component = z
    gradient_variable = temp_conv
  [../]
  [./grad_temp_ref_x_kernel]
    type = VariableGradientComponent
    variable = grad_temp_ref_x_var
    component = x
    gradient_variable = temp_ref
  [../]
  [./grad_temp_ref_y_kernel]
    type = VariableGradientComponent
    variable = grad_temp_ref_y_var
    component = y
    gradient_variable = temp_ref
  [../]
  [./grad_temp_ref_z_kernel]
    type = VariableGradientComponent
    variable = grad_temp_ref_z_var
    component = z
    gradient_variable = temp_ref
  [../]
  [./norm_grad_T]
    type = VectorMagnitudeAux
    variable = norm_grad_T
    y = grad_temp_y_var
    x = grad_temp_x_var
    z = grad_temp_z_var
  [../]
  [./norm_gradT_conv]
    type = VectorMagnitudeAux
    variable = norm_gradT_conv
    y = grad_temp_conv_y_var
    x = grad_temp_conv_x_var
    z = grad_temp_conv_z_var
  [../]
  [./norm_gradT_ref]
    type = VectorMagnitudeAux
    variable = norm_gradT_ref
    y = grad_temp_ref_y_var
    x = grad_temp_ref_x_var
    z = grad_temp_ref_z_var
  [../]
  [./convection_temp_auxkernel]
    type = RedbackDiffVarsAux
    variable = temp_conv
    variable_2 = temp_ref
    variable_1 = temp
    execute_on = timestep_end
  [../]
  [./temp_ref_auxkernel]
    type = SolutionAux
    variable = temp_ref
    solution = temp_ref_uo
  [../]
[]

[Preconditioning]
  # active = ''
  [./SMP]
    type = SMP
    full = true
  [../]
[]

[Postprocessors]
  [./dt]
    type = TimestepSize
  [../]
  [./num_li]
    type = NumLinearIterations
  [../]
  [./num_nli]
    type = NumNonlinearIterations
  [../]
  [./new_timestep]
    type = FunctionValuePostprocessor
    function = timestep_function
  [../]
  [./max_fluid_vel_y]
    type = ElementExtremeValue
    variable = fluid_vel_y
    execute_on = nonlinear
    value_type = max
  [../]
  [./min_fluid_vel_y]
    type = ElementExtremeValue
    variable = fluid_vel_y
    execute_on = nonlinear
    value_type = min
  [../]
  [./max_norm_grad_T]
    type = ElementExtremeValue
    variable = norm_grad_T
  [../]
  [./max_norm_gradT_conv]
    type = ElementExtremeValue
    variable = norm_gradT_conv
  [../]
  [./max_norm_gradT_ref]
    type = ElementExtremeValue
    variable = norm_gradT_ref
  [../]
  [./Nusselt_number]
    type = FunctionValuePostprocessor
    function = grad_for_Nusselt
  [../]
  [./Nusselt2]
    type = FunctionValuePostprocessor
    function = Nusselt2
  [../]
[]

[Executioner]
  type = Transient
  num_steps = 1000
  l_max_its = 200
  nl_max_its = 10
  solve_type = PJFNK
  petsc_options_iname = '-ksp_type -pc_type -sub_pc_type -ksp_gmres_restart '
  petsc_options_value = 'gmres asm lu 201'
  nl_abs_tol = 1e-09 # 1e-10 to begin with
  nl_rel_tol = 1e-07 # 1e-10 to begin with
  line_search = basic
[]

[Outputs]
  file_base = transient
  print_linear_residuals = false
  csv = true
  [./console]
    type = Console
    perf_log = true
    output_linear = true
  [../]
  [./curve_exo]
    output_material_properties = true
    file_base = transient
    type = Exodus
    elemental_as_nodal = true
  [../]
[]

[ICs]
  active = 'IC_temp IC_pressure'
  [./IC_temp]
    function = init_gradient_T
    variable = temp
    type = FunctionIC
  [../]
  [./IC_pressure]
    function = init_gradient_P
    variable = pore_pressure
    type = FunctionIC
  [../]
  [./inv_Le_randomIC]
    # Inverse of Lewis number perturbation such that
    # 1/Le = 1/Le + 1/Le_perturb
    variable = inv_Le_perturb
    standard_deviation = 0.5
    type = FunctionLogNormalDistributionIC
    mean = 2e+07
  [../]
[]

[UserObjects]
  [./temp_ref_uo]
    type = SolutionUserObject
    timestep = LATEST
    system_variables = temp
    mesh = reference_diffusion.e
    execute_on = initial
  [../]
[]

