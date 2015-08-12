# Tutorial 5: High Performance Data Analytics with R (package: foreach)

# This example uses cluster computing.
# It does demonstrated how to benchmark R code for performance
# and report the results. In addition this code shows how to
# restructure the results using combine.

# To execute this file:
# $ qsub pbs_test_parallel_5

# To monitor progress
# $ qstat -u your_user_name

# To terminate the job prematurely:
# $ qsig -s SIGINT 466569.trifid-m

# ============================================================

# Use the foreach package to spread the load of a calculation 
# across multiple nodes of the cluster.

# Import R packages
# Make sure these are installed beforehand using the PBS commands:
# module load R
# module module list
# echo 'installed.packages()' |  R --vanilla
# if not the .packages='doParallel' parameter will install the package on the nodes.

library(foreach)
library(doParallel)

# ============================================================
 
# Startup cluster to use 16 processors
cluster <- makeCluster(16)
registerDoParallel(cluster)

# Just to reassure ourselves.
print (getDoParWorkers())
getDoParName()
 
# Benchmark start time.
start_time <- Sys.time()
 
# Push the code to the nodes.
     
# Iteration count for calculation.
iteration_count <- 1000

# Uncomment this fragment if the package doParallel is NOT already installed on the cluster nodes.
#summaries <- foreach(1:iteration_count, .packages='doParallel') %dopar% {

summaries <- foreach(1:iteration_count, .combine='rbind') %dopar% {
    # Code to be executed on nodes.
    random_numbers <- runif(1000000, 0, 1)
    summary_result <- summary(random_numbers)
    summary_result
}
 
# Benchmark stop time and report duration.
print(Sys.time() - start_time)

# Shutdown cluster
stopCluster(cluster)

# Report calculation results.
sink("tutorial_foreach_5.out") # Redirect console output to the named file
summaries
sink() # Restore output to the console
 
# Time difference typically around 10 mins