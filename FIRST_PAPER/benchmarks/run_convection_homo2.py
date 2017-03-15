''' Script to run convection continuation '''

import os, sys, logging, copy

# Add directory containing RedbackContinuation.py to the path
sys.path.append(os.path.join('..','..','..','..','..'))

from Utils import getLogger
from ConvectionUtils import generateSteadyStateConvectionFile,\
  generateTransientConvectionFile, ROOT_FILENAME_REF_SS,\
  ROOT_FILENAME_TRANSIENT
from Utils import runSimulation
from RedbackContinuation import runContinuation

def runWholeConvectionWorkflow(mesh_file, gr_string, nb_threads):
  ''' Run the whole workflow of continuation for convection
      for given mesh and gr
  '''
  output_dir = '.'
  input_dir = os.path.realpath('.')
  mesh_short_name = os.path.splitext(os.path.split(mesh_file)[1])[0]
  running_tmp_dir = os.path.join(input_dir, 'Benchmark_Case2_{mesh}' .\
    format(gr=gr_string, mesh=mesh_short_name))
  parameters = {
    'continuation_variable':'Lewis', # in ['Gruntfest', 'Lewis']
    'materials_affected':['redback_materialA'],#['*'],
    'lambda_initial_1':4.0,
    'lambda_initial_2':4.1,
    'ds_initial':0.1,
    's_max':100,
    # Rescaling factor
    'rescaling_factor':1e-08, # to multiply continuation parameter
    # Numerical parameters
    'exec_loc':'~/projects/redback/redback-opt',
    'nb_threads':4,
    'input_file':os.path.join(input_dir, 'transient_case2.i'), # '2D_Gr_9e-3_LE6e-08.i' transient file name
    'starting_from_exodus':'will be set automatically', # exodus file with solution of transient simuation for Initial Guess 1
    'running_dir':os.path.realpath(running_tmp_dir),
    'result_curve_csv':os.path.join(os.path.realpath(running_tmp_dir), 'LSA_Benchmark_Case2_mesh_{mesh}.csv' .\
      format(gr=gr_string, mesh=mesh_short_name)),
    'error_filename':'error_output.txt',
    'plot_s_curve':True,
    'non_blocking':True,
    'plot_post_processor':'Nusselt2', # post-processor to plot. If empty, then norm is used.
    'plot_norm':'L2', # in ['L2', 'L_inf']
    'plot_solution_index':1, # index of solution to plot
    'ref_s_curve':'',
    'postprocessors_exported':['Nusselt2'],
    # overwriting parameters
    'overwriting_params':{
      'Mesh/file':os.path.realpath(mesh_file),
      'Materials/redback_materialA/gr':gr_string,
      }
  }
  logger = getLogger('sim', os.path.join(output_dir, 'log.txt'), logging.INFO)
  # Reference steady-state file
  ok = generateSteadyStateConvectionFile(parameters, logger)
  if not ok:
    sys.exit()
  sim_filename = os.path.join(parameters['running_dir'], ROOT_FILENAME_REF_SS+'.i')
  runSimulation(sim_filename, parameters, logger) # run steady state for diffusion
  # Transient file
  ok = generateTransientConvectionFile(parameters, logger)
  if not ok:
    sys.exit()
  sim_filename = os.path.join(parameters['running_dir'], ROOT_FILENAME_TRANSIENT+'.i')
  runSimulation(sim_filename, parameters, logger) # run transient
  # make a copy (to keep) that transient.e file
  dot_e_file = sim_filename[0:-2] + '.e'
  dot_e_file2 = sim_filename[0:-2] + '_original.e'
  shutil.copyfile(dot_e_file, dot_e_file2)
  # Continuation
  parameters['starting_from_exodus'] = os.path.join(parameters['running_dir'], ROOT_FILENAME_TRANSIENT+'.e')
  parameters['overwriting_params']['UserObjects/temp_ref_uo/mesh'] = ROOT_FILENAME_REF_SS+'.e'
  results = runContinuation(parameters, logger)
  print 'Finished workflow for gr={gr}, mesh={mesh}'.\
    format(gr=gr_string, mesh=os.path.splitext(os.path.split(mesh_file)[1])[0])

if __name__ == "__main__":
  # User input

  runWholeConvectionWorkflow('2d.msh', '0', '4')


  print 'Finished'


'''This python file was used to run the whole workflow for the first case scenario with impermeable (Neumann) pressure on the bottom, and fixed (Dirichlet) pressure on the top. The temperature boundary conditions are both fixed (Dirichlet) on the top and bottom of the model.
The input file runs a Lewis of 4e-08 in Material A, and CONVECTS. The critical Lewis is 4.95e-08.
The mesh has dimensions [-0.5,1], and is named 2d.msh.'''


