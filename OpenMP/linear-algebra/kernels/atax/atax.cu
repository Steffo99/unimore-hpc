#include <stdio.h>
#include <unistd.h>
#include <string.h>
#include <math.h>

/* Include polybench common header. */
#include <polybench.h>

/* Include benchmark-specific header. */
/* Default data type is double, default size is 4000. */
#include "atax.hu"

// Workaround for the editor not finding M_PI
// It is exclusive to the GNU C compiler
// https://www.gnu.org/software/libc/manual/html_node/Mathematical-Constants.html
#ifndef M_PI
	#define M_PI 3.141
#endif

/* Array initialization. */
static void init_array(int nx, int ny, DATA_TYPE POLYBENCH_2D(A, NX, NY, nx, ny), DATA_TYPE POLYBENCH_1D(x, NY, ny))
{
	int i, j;

	/// Initialize the `x` array with PI and its multiples.
	for (i = 0; i < ny; i++) {
		x[i] = i * M_PI;
	}

	/// Initialize the `A` matrix
	for (i = 0; i < nx; i++) {
		for (j = 0; j < ny; j++) {
			A[i][j] = ((DATA_TYPE)i * (j + 1)) / nx;
		}
	}
}

/* DCE code. Must scan the entire live-out data.
	 Can be used also to check the correctness of the output. */
static void print_array(int nx, DATA_TYPE POLYBENCH_1D(y, NX, nx))
{
	int i;

	/// Print all numbers in the array sequentially.
	// Cannot parallelize this: prints have to be sequential to make sense!
	for (i = 0; i < nx; i++) {
		fprintf(stderr, DATA_PRINTF_MODIFIER, y[i]);
	}
	fprintf(stderr, "\n");
}

/* Main computational kernel. The whole function will be timed,
	 including the call and return. */
static void kernel_atax(int nx, int ny, DATA_TYPE POLYBENCH_2D(A, NX, NY, nx, ny), DATA_TYPE POLYBENCH_1D(x, NY, ny), DATA_TYPE POLYBENCH_1D(y, NY, ny))
{
	int i, j;

	for (i = 0; i < _PB_NY; i++)
		y[i] = 0;
	
	/// This computes... something? I guess whatever ATAX is?
	// Now this gives a nice speedup, especially with a lot more threads than the count!
	// THREAD_COUNT * 4 seems to be the best on my local computer. What's the best for the Jetson Nano?
	for (i = 0; i < _PB_NX; i++)
	{
		/// Every iteration has its own tmp variable
		DATA_TYPE tmp = 0;
		
		for (j = 0; j < _PB_NY; j++) {
			/// Which gets increased by a bit on every iteration
			tmp += A[i][j] * x[j];
		}
		
		for (j = 0; j < _PB_NY; j++) {
			/// Which is later used for to compute ATAX
			y[j] = y[j] + A[i][j] * tmp;
		}
	}
}

int main(int argc, char **argv)
{
	/* Retrieve problem size. */
	int nx = NX;
	int ny = NY;

	/* Variable declaration/allocation. */
	POLYBENCH_2D_ARRAY_DECL(A, DATA_TYPE, NX, NY, nx, ny);
	POLYBENCH_1D_ARRAY_DECL(x, DATA_TYPE, NY, ny);
	POLYBENCH_1D_ARRAY_DECL(y, DATA_TYPE, NY, ny);
	
	/* Start timer. */
	polybench_start_instruments;

	/* Initialize array(s). */
	init_array(nx, ny, POLYBENCH_ARRAY(A), POLYBENCH_ARRAY(x));

	/* Run kernel. */
	kernel_atax(nx, ny, POLYBENCH_ARRAY(A), POLYBENCH_ARRAY(x), POLYBENCH_ARRAY(y));

	/* Stop and print timer. */
	polybench_stop_instruments;
	polybench_print_instruments;

	/* Prevent dead-code elimination. All live-out data must be printed
		 by the function call in argument. */
	polybench_prevent_dce(print_array(nx, POLYBENCH_ARRAY(y)));
	
	/* Be clean. */
	POLYBENCH_FREE_ARRAY(A);
	POLYBENCH_FREE_ARRAY(x);
	POLYBENCH_FREE_ARRAY(y);

	return 0;
}
