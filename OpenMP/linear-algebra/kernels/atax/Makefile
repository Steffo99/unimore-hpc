-include ../../../utilities/options.mk
-include ../../../utilities/c2.mk

# Do not use EXTRALARGE_DATASET, int will overflow
# -DLARGE_DATASET increases the size of arrays, making everything easier to profile
# -fopenmp enables OpenMP
# -Wall and -Wextra enable more warnings
# -O3 applies all compiler optimization, improving from 800ms to 300ms
# -g3 enables some useful debug things
CFLAGS= -DLARGE_DATASET -fopenmp -Wall -Wextra -O3 -g3
