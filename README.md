# R_data_analytics_foreach_tutorial

Tutorials that exercise the features of the R foreach package for HPC data analytics.

The tutorial use a series of working R scripts arranged as follows:

1. Tutorial 0: an script with simple duration timing output to a file. No HPC.
2. Tutorial 1: a script that runs multiple trials and plots the trial size against duration. Output is a PDF file. No HPC.
3. Tutorial 2: a script that uses the foreach and snow packages to distribute work across a HPC cluster. The timed output goes to a file. The job is placed on the HPC queue via a PBS script.
4. Tutorial 3: a script that uses the foreach and multicore packages to distribute work across a the cores of a single machine. The timed output goes to a file. The job is placed on the HPC queue via a PBS script.
5. Tutorial 4: same as Tutorial 3 but with more cores requiring changes to the R and PBS scripts.
6. Tutorial 5: same as tutorial 2 except for changing the structure of the calculated results using .combine.
7. Tutorial 6: same as tutorial 5 except for changing the function under test and picking up the iteration index.
