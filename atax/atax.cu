#include <stdio.h>
#include <unistd.h>
#include <string.h>
#include <math.h>

/* Include polybench common header. */
#include "polybench.hu"

/* Include benchmark-specific header. */
/* Default data type is double, default size is 4000. */
#include "atax.hu"

// Workaround for the editor not finding M_PI
// It is exclusive to the GNU C compiler
// https://www.gnu.org/software/libc/manual/html_node/Mathematical-Constants.html
#ifndef M_PI
	#define M_PI 3.141
#endif

/**
 * Initialize the arrays to be used in the computation:
 * 
 * - `x` is filled with multiples of `M_PI`;
 * - `A` is filled with sample data.
 * 
 * To be called on the CPU (uses the `__host__` qualifier).
 */
__host__ static void init_array(DATA_TYPE** A, DATA_TYPE* X)
{
	/* X = [ 3.14, 6.28, 9.42, ... ] */
	for (int y = 0; y < NY; y++) 
	{
		X[y] = y * M_PI;
	}

	/*
	 *	A = [
	 *		[       0,       0,       0,       0, ... ],
	 *		[  1 / NX,  2 / NX,  3 / NX,  4 / NX, ... ],
	 *		[  2 / NX,  4 / NX,  6 / NX,  8 / NX, ... ],
	 *		[  3 / NX,  6 / NX,  9 / NX, 12 / NX, ... ],
	 *		...
	 *	]
	 */
	for (int x = 0; x < NX; x++) 
	{
		for (int y = 0; y < NY; y++) 
		{
			A[x][y] = ((DATA_TYPE)x * (y + 1)) / NX;
		}
	}
}


/**
 * Print the given array.
 * 
 * Cannot be parallelized, as the elements of the array should be 
 * 
 * To be called on the CPU (uses the `__host__` qualifier).
 */
__host__ static void print_array(DATA_TYPE* Y)
{
	for (int x = 0; x < NX; x++) 
	{
		fprintf(stderr, DATA_PRINTF_MODIFIER, Y[x]);
	}
	fprintf(stderr, "\n");
}


/**
 * Compute ATAX.
 * 
 * Parallelizing this is the goal of the assignment.
 * 
 * Currently to be called on the CPU (uses the `__host__` qualifier), but we may probably want to change that soon.
 */
__host__ static void kernel_atax(DATA_TYPE** A, DATA_TYPE* X, DATA_TYPE* Y)
{
	for (int x = 0; x < NY; x++) 
	{
		Y[i] = 0;
	}
	
	for (int i = 0; i < NX; i++) 
	{
		DATA_TYPE tmp = 0;
		
		for (int j = 0; j < NY; j++) 
		{
			tmp += A[i][j] * X[j];
		}
		
		for (int j = 0; j < NY; j++) 
		{
			Y[j] = Y[j] + A[i][j] * tmp;
		}
	}
}


/**
 * The main function of the benchmark, which sets up tooling to measure the time spent computing `kernel_atax`.
 * 
 * We should probably avoid editing this.
 */
__host__ int main(int argc, char **argv)
{
	// A[NY][NX]
	DATA_TYPE** A = new DATA_TYPE*[NX] {};
	for(int i = 0; i < NX; i++)
	{
		A[i] = new DATA_TYPE[NY];
	}

	DATA_TYPE* x = new DATA_TYPE[NY] {};
	DATA_TYPE* y = new DATA_TYPE[NX] {};

	#ifdef POLYBENCH_INCLUDE_INIT
		polybench_start_instruments;
	#endif

	init_array(A, x);

	#ifndef POLYBENCH_INCLUDE_INIT
		polybench_start_instruments;
	#endif

	kernel_atax(A, x, y);

	polybench_stop_instruments;
	polybench_print_instruments;

	/* Prevent dead-code elimination. All live-out data must be printed by the function call in argument. */
	polybench_prevent_dce(print_array(y));

	return 0;
}
