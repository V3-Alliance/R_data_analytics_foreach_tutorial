# Tutorial 4: High Performance Data Analytics with R (package: foreach)

# This example uses cluster computing.
# It does demonstrated how to benchmark R code for performance
# and report the results.

# This tutorial shows to how to run code on multiple cores of one cluster node.
# This example uses 8 cores.

# To execute this file:
# $ qsub pbs_test_parallel_4

# To monitor progress
# $ qstat -u your_user_name

# To terminate the job prematurely:
# $ qsig -s SIGINT 466569.trifid-m

# ============================================================

# Use the foreach package to spread the load of a calculation 
# across multiple cores of a single node.

# Import R packages
# Make sure these are installed beforehand using the PBS commands:
# module load R
# module module list
# echo 'installed.packages()' |  R --vanilla
# if not the .packages='doParallel' parameter will install the package on the nodes.

library(foreach)
library(doMC)
 
# ============================================================
 
# Tell node to use 8 cores.
registerDoMC(8)

# Just to reassure ourselves.
print (getDoParWorkers())
getDoParName()
 
# Benchmark start time.
start_time <- Sys.time()
 
# Push the code to the cores.
     
# Iteration count for calculation.
iteration_count <- 1000

# Ensure package doMC is loaded.
summaries <- foreach(1:iteration_count, .packages='doMC') %dopar% {
    # Code to be executed on cores
    random_numbers <- runif(1000000, 0, 1)
    summary_result <- summary(random_numbers)
    summary_result         
}
 
# Benchmark stop time and report duration.
print(Sys.time() - start_time)
 
# Time difference typically around 10 mins

# Report calculation results.
sink("tutorial_foreach_4.result") # Redirect console output to the named file
summaries
sink() # Restore output to the console
