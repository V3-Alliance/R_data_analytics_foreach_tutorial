# Tutorial 1: High Performance Data Analytics with R (package: foreach)

# This example is the baseline for a series of HPC/R tutorials.
# It does not use cluster computing.
# It does demonstrated how to benchmark R code for performance
# and plot the results.

# ============================================================

# Plot how a calculation's duration scales with calculation complexity.
# The results are rendered as a PDF file on the cluster.

# May need to run install.packages('ggplot2') beforehand.
library(ggplot2)

# ============================================================

# Define a function to benchmark.
calculation_under_test <- function(iteration_count) {

	cat("Starting job: ", iteration_count, "\n")

    # Allocate space for summary objects to be returned - not actually used.
    # Storage is generally allocated in one go to improve performance.
    summaries <- vector('list', length = iteration_count)
    
    # Generate some random numbers then derive a summary object.
    for(iteration_index in 1:iteration_count) {

        cat("Iteration: ", iteration_index,'\n') 
     
        # 1 million uniform random numbers in the range 0 to 1
        random_numbers <- runif(1000000, 0, 1)
        summary_result <- summary(random_numbers)
        # Collect the summary objects
        summaries[[iteration_index]] <- summary_result         
	}
	return(summaries)
}

# ============================================================
# Perform the benchmark.

# Trial size
trial_count = 10
iteration_scale = 10

# Allocate storage for count results.
iteration_counts <- numeric(trial_count)
 
# Allocate storage for timing results.
durations <- numeric(trial_count)
 
# Iterate the trial while varying the trial parameters.
for(trial_index in 1:trial_count) {
          
    # Benchmark start time.
    start_time <- Sys.time()
    
    # Exercise the function we are benchmarking.
    iteration_count <- trial_index * iteration_scale     
 	calculation_under_test(iteration_count)
 	
    # Benchmark stop time and record duration as a function of iteration count.
	iteration_counts [trial_index] <-  iteration_count  
    durations [trial_index] <- Sys.time() - start_time
}
 
# Organise the results in a form suitable for potting 
plot_data <- data.frame(iteration_counts, durations)

# Plot the results with each "addition" adding a layer to the plot.
# The result is a scatter plot with individual points 
# superimposed on a smoothed line and some axis labels.
#
ggplot(plot_data, aes(x = iteration_counts, y = durations)) + 
    geom_point() +
    geom_smooth() + 
    theme_bw() + 
    scale_x_continuous('Iteration count') + 
    scale_y_continuous ('Duration/sec') +
    ggtitle("Tutorial 1: R foreach")