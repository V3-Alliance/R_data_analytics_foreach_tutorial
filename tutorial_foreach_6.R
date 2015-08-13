# Tutorial 6: High Performance Data Analytics with R (package: foreach)

# This example uses cluster computing.
# It does demonstrated how to benchmark R code for performance
# and report the results. In addition this code shows 
# 1. how to restructure the results using combine.
# 2. report on progress.

# To execute this file:
# $ qsub pbs_test_parallel_6

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

 max_eigenvalue <- function(matrix_dimension, maximum) {
	result_matrix <- matrix(runif(matrix_dimension**2, min = 0, max = maximum), nrow = matrix_dimension)

	# Eigenvalues returned are sorted in decreasing order.
	eigenvalues <- eigen(result_matrix, FALSE, only.values = TRUE)$values
	# So the largest eigenvalue is at index 1 in the vector.
	abs(eigenvalues[1])
}

# ============================================================

# Startup cluster to use 16 processors
# Outfile is set to blank to prevent the slave nodes from dumping output.
# This will allow qpeek <job_id> to show the output from the nodes.
# though the qpeek output will be a mixed up from all the nodes. 
cluster <- makeCluster(16, outfile="")
registerDoParallel(cluster)

# Just to reassure ourselves.
print (getDoParWorkers())
getDoParName()
 
# Benchmark start time.
start_time <- Sys.time()
 
# Push the code to the nodes.
     
# Iteration count for calculation.
iteration_count <- 100

cat("Starting job!\n")
max_eigenvalues <- foreach(iteration_index = 1:iteration_count, .combine='cbind') %dopar% {
    cat("Process ID", Sys.getpid(), "Iteration: ", iteration_index, "\n")
	eigenvalue = max_eigenvalue(iteration_index, 200)
	eigenvalue_pair = c(iteration_index, eigenvalue)
}
 
# Benchmark stop time and report duration.
print(Sys.time() - start_time)

# Shutdown cluster
stopCluster(cluster)

# Report calculation results.
sink("tutorial_foreach_6.result") # Redirect console output to the named file
max_eigenvalues
sink() # Restore output to the console
 
# Time difference typically around 10 mins