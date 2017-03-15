''' Script to run convection continuation '''

import os, sys, logging, copy, time, shutil

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
  input_dir = os.path.realpath('../2D_simulations')
  mesh_short_name = os.path.splitext(os.path.split(mesh_file)[1])[0]
  running_tmp_dir = os.path.join(input_dir, '2D_Gr_{gr}_{mesh}' .\
    format(gr=gr_string, mesh=mesh_short_name))
  parameters = {
    'continuation_variable':'Lewis', # in ['Gruntfest', 'Lewis']
    'materials_affected':['redback_materialA', 'redback_materialB'],#['*'],
    'lambda_initial_1':4.0,
    'lambda_initial_2':4.1,
    'ds_initial':0.05,
    's_max':30,
    # Rescaling factor
    'rescaling_factor':1e-08, # to multiply continuation parameter
    # Numerical parameters
    'exec_loc':'~/projects/redback/redback-opt',
    'nb_threads':8,
    'input_file':os.path.join(input_dir, '2d_horz_thin.i'), # '2D_Gr_9e-3_LE6e-08.i' transient file name
    'starting_from_exodus':'will be set automatically', # exodus file with solution of transient simuation for Initial Guess 1
    'running_dir':os.path.realpath(running_tmp_dir),
    'result_curve_csv':os.path.join(os.path.realpath(running_tmp_dir), 'LSA_Gr_{gr}_{mesh}.csv' .\
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
      'Materials/redback_materialB/gr':gr_string,
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
  # time.sleep(10) # delays for 10 seconds to allow time to write to disk
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
  runWholeConvectionWorkflow('2d_horz_thin.msh', '0', '8')
  runWholeConvectionWorkflow('2d_horz_thin.msh', '1e-04', '8')
  runWholeConvectionWorkflow('2d_horz_thin.msh', '2e-03', '8')
  runWholeConvectionWorkflow('2d_horz_thin.msh', '1e-03', '8')
  runWholeConvectionWorkflow('2d_horz_thin.msh', '3e-03', '8')
  runWholeConvectionWorkflow('2d_horz_thin.msh', '5e-03', '8')
  runWholeConvectionWorkflow('2d_horz_thin.msh', '1e-02', '8')

  print 'Finished'


'''This python file was used to run the whole workflow for the cases of a HORIZONTAL fault, with mesh '2d_horz_thin.msh', and dimensions being [1,-0.5]. The boundary conditions are identical to the second 'benchmark' case, with Neumann pressure on the bottom, Dirichlet pressure on top, and Dirichlet temperature on both top and bottom.'''


