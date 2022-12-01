# Remove all make implicit rules because this is already complex enough as it is
MAKEFLAGS+= -r

# -DPOLYBENCH_TIME makes Polybench output the execution time of the program
CXXFLAGS+= -DPOLYBENCH_TIME
# -O3 applies all compiler optimization, improving from 800ms to 300ms
CXXFLAGS+= -O3
# Enable this to view the contents of the arrays
CXXFLAGS+= -DHPC_DEBUG
# Enable this to use CUDA
CXXFLAGS+= -DHPC_USE_CUDA
# Extend CFLAGS with command line parameters
CXXFLAGS+= ${EXTRA_CXXFLAGS}

# Select the location of the local CUDA install
# CUDA_HOME:=/usr/local/cuda-10.0
CUDA_HOME:=/opt/cuda
# Specify the directory of the nvc compiler
NVCC:=$(CUDA_HOME)/bin/nvcc
# Specify the flags for the nvc compiler
NVCFLAGS:=$(CXXFLAGS) $(NVOPT)

# Optimize for @Steffo's NVIDIA GTX 1070
NVCFLAGS+= -arch=compute_61
NVCFLAGS+= -code=sm_61


%.elf: %.cu.o polybench.cu.o
	$(NVCC) $(NVCFLAGS) $^ -o $@ $(LDFLAGS)

%.cu.o: %.cu
	$(NVCC) $(NVCFLAGS) -c $< -o $@


all: atax.elf

.PHONY: bench clean

bench:
	./.bench.sh

clean:
	rm *.elf
