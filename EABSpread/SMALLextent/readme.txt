There are five files that make up the EAB modeling system, compile_EAB_data_Larval.m, RDeq_run_Larval_Algebraic.m, bthfcns.m, RDeq_offseason_Larval_Al.m, and YearlyFigures.m. It takes in the ASCII file provided as input and outputs a result which can be joined back to it.

The first file is responsible for preparation of all data that is static through the entire run and compiles results after the run is complete. this is the file that should be activated first and will call all remaining files to run. The only oddity present in this code that should not be tampered with are lines 120-206 where the immediate inclination is to change this to a loop. However, due to how MATLAB treats parallel loops (parfor) changing this section over to a normal loop will not function.

The second file handles the yearly variables and distributes the data to all workers in the parallel loop (lines 58-76) and saves the annual result and clears working memory for the next iteration (lines 77-91). Notably it also sets the annual parasitism variables (lines 20-46) and stores them for back testing under different seeds (lines 48-50). The seeds, defined on line 18, are how we vary our results while still being able to repeat them, altering the seed with a multiple of 10-160 to garner different results.

The third file is the on-season set of equations and variables that takes the data distributed by the second file. Some variables are simulated algebraically, notably EAB larva growth and crowding, the rest are simulated using ode45 with instantaneous growth for each timestep forward.

The fourth file is the off-season set of equations, similar to the previous file, but only focused around fraxinus growth and crowding.

The fifth file is just the figure code for the results to give basic figures for the run.
