# Tutorial 0: High Performance Data Analytics with R (package: foreach) 

# This example is the baseline for a series of HPC/R tutorials.
# It does not use cluster computing.
# It does demonstrated how to benchmark R code for performance.

# ============================================================

# Measure how a calculation's duration scales with calculation complexity.
# The results are output to the R console.

# ============================================================
 
# Benchmark start time.
start_time <- Sys.time()
 
# Trial size
iteration_count <- 10

# Allocate space for summary objects to be returned.
# Storage is generally allocated in one go to improve performance.
summaries <- vector('list', length = iteration_count)

cat("Starting job!\n")
# Generate some random numbers, derive a summary object and collect the summary objects.
for (iteration_index in 1:iteration_count) { 
    cat("Iteration: ", iteration_index,'\n') 
	# 1 million uniform random numbers in the range 0 to 1
	random_numbers <- runif(1000000, 0, 1)
	summary_result <- summary(random_numbers)
	# Collect the summary objects
	summaries[[iteration_index]] <- summary_result         
}
 
# Benchmark stop time and record duration as a function of iteration count.
cat("Duration/sec: ", Sys.time() - start_time)

# Report summary results.
sink("tutorial_foreach_0.result") # Redirect console output to the named file
summaries
sink() # Restore output to the console
