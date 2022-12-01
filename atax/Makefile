# Remove all make implicit rules because this is already complex enough as it is
MAKEFLAGS+= -r

# -DPOLYBENCH_TIME makes Polybench output the execution time of the program
CXXFLAGS+= -DPOLYBENCH_TIME
# -O3 applies all compiler optimization, improving from 800ms to 300ms
CXXFLAGS+= -O3
# Extend CFLAGS with command line parameters
CXXFLAGS+= ${EXTRA_CXXFLAGS}

# Select the location of the local CUDA install
CUDA_HOME:=/usr/local/cuda-10.0
# Specify the directory of the nvc compiler
NVCC:=$(CUDA_HOME)/bin/nvcc
# Specify the flags for the nvc compiler
NVCFLAGS:=$(CXXFLAGS) $(NVOPT)


%.elf: %.cu.o polybench.cu.o
	$(NVCC) $(NVCFLAGS) $^ -o $@ $(LDFLAGS)

%.cu.o: %.cu
	$(NVCC) $(NVCFLAGS) -c $< -o $@


.PHONY: bench clean dev

dev: atax.elf
	./atax.elf

bench:
	./.bench.sh

clean:
	rm *.elf *.cu.o
