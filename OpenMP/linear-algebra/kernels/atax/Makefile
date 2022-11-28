-include ../../../utilities/options.mk
-include ../../../utilities/c2.mk


# Disable make output
MAKEFLAGS+= --silent

# -DPOLYBENCH_TIME makes Polybench output the execution time of the program
CXXFLAGS+= -DPOLYBENCH_TIME 
# -Wall and -Wextra enable more warnings
CXXFLAGS+= -Wall 
CXXFLAGS+= -Wextra 
# -O3 applies all compiler optimization, improving from 800ms to 300ms
CXXFLAGS+= -O3 
# Extend CFLAGS with command line parameters
CXXFLAGS+= ${EXTRA_CXXFLAGS}

# Select the location of the local CUDA install
CUDA_HOME:=/opt/cuda
# Specify the directory of the nvc compiler
NVCC=$(CUDA_HOME)/bin/nvcc
# Specify the flags for the nvc compiler
NVCFLAGS:=$(CXXFLAGS) $(NVOPT)


# Create an automake definition for .cu files
$(BUILD_DIR)/%.cu.o: %.cu
	$(MKDIR_P) $(dir $@)
	$(NVCC) $(NVCFLAGS) -c $< -o $@

.PHONY: bench

bench:
	./.bench.sh
