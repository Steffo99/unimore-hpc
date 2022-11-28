# -DPOLYBENCH_TIME makes Polybench output the execution time of the program
CXXFLAGS+= -DPOLYBENCH_TIME
# -O3 applies all compiler optimization, improving from 800ms to 300ms
CXXFLAGS+= -O3
# Extend CFLAGS with command line parameters
CXXFLAGS+= ${EXTRA_CXXFLAGS}

# Select the location of the local CUDA install
CUDA_HOME:=/opt/cuda
# Specify the directory of the nvc compiler
NVCC:=$(CUDA_HOME)/bin/nvcc
# Specify the flags for the nvc compiler
NVCFLAGS:=$(CXXFLAGS) $(NVOPT)


INCPATHS:=-I../../../utilities


# Create an automake definition for .cu files
%.cu.o:
	$(NVCC) $(NVCFLAGS) -c $< -o $@

%.exe: %.cu.o
	$(NVCC) $(NVCFLAGS) $(INCPATHS) $^ -o $@ $(LDFLAGS)

%.elf: %.cu.o
	$(NVCC) $(NVCFLAGS) $(INCPATHS) $^ -o $@ $(LDFLAGS)


.PHONY: bench

bench:
	./.bench.sh
