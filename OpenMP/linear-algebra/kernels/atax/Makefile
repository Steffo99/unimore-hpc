-include ../../../utilities/options.mk
-include ../../../utilities/c2.mk

# -DPOLYBENCH_TIME makes Polybench output the execution time of the program
CFLAGS+= -DPOLYBENCH_TIME 
# -DLARGE_DATASET increases the size of arrays, making everything easier to profile
# Do not use EXTRALARGE_DATASET, int will overflow
CFLAGS+= -DLARGE_DATASET
# -Wall and -Wextra enable more warnings
CFLAGS+= -Wall 
CFLAGS+= -Wextra 
# -O3 applies all compiler optimization, improving from 800ms to 300ms
CFLAGS+= -O3 
# -g3 enables some useful debug things
CFLAGS+= -g3
# -DTHREAD_COUNT allows us to alter the number of threads used in the whole file
CFLAGS+= -DTHREAD_COUNT=4
# Extend CFLAGS with command line parameters
CFLAGS+= ${EXTRA_CFLAGS}

# Disable make output
MAKEFLAGS+= --silent


.PHONY: bench

bench:
	./.bench.sh
