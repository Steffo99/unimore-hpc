#include <stdio.h>
#include <unistd.h>
#include <string.h>
#include <math.h>
#include <iostream>

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

// Default if CUDA_NTHREADS is not set
#ifndef CUDA_NTHREADS
	#define CUDA_NTHREADS 128
#endif

// Enable syntax highlighting for the CUDA mode
// TODO: Remove this, as it will be set by .bench.sh
#define HPC_USE_CUDA

// Enable syntax highlighting for the stride mode
// TODO: Remove this, as it will be set by .bench.sh
#define HPC_USE_STRIDE


/**
 * Initialize the arrays to be used in the computation:
 * 
 * - `X` is filled with multiples of `M_PI`;
 * - `Y` is zeroed;
 * - `A` is filled with sample data.
 * 
 * To be called on the CPU (uses the `__host__` qualifier).
 */
#ifndef HPC_USE_CUDA
__host__ static void init_array(DATA_TYPE** A, DATA_TYPE* X, DATA_TYPE* Y)
{
	/* X = [ 3.14, 6.28, 9.42, ... ] */
	for (unsigned int y = 0; y < NY; y++) 
	{
		X[y] = y * M_PI;
	}

	/* Y = [ 0.00, 0.00, 0.00, ... ] */
	for (unsigned int x = 0; x < NY; x++) 
	{
		Y[x] = 0;
	}

	/*
	 *	A = [
	 *	  [       0,       0,       0,       0, ... ],
	 *	  [  1 / NX,  2 / NX,  3 / NX,  4 / NX, ... ],
	 *	  [  2 / NX,  4 / NX,  6 / NX,  8 / NX, ... ],
	 *	  [  3 / NX,  6 / NX,  9 / NX, 12 / NX, ... ],
	 *	  ...
	 *	]
	 */
	for (unsigned int x = 0; x < NX; x++) 
	{
		for (unsigned int y = 0; y < NY; y++) 
		{
			A[x][y] = (DATA_TYPE)(x * (y + 1)) / NX;
		}
	}
}
#endif

/**
 * Initialize the arrays to be used in the computation:
 * 
 * - `X` is filled with multiples of `M_PI`;
 * - `Y` is zeroed;
 * - `A` is filled with sample data.
 * 
 * It is called by the host, runs on the device, and calls the other init_arrays on the device.
 */
#ifdef HPC_USE_CUDA
__global__ static void init_array_cuda(DATA_TYPE** A, DATA_TYPE* X, DATA_TYPE* Y)
{
	unsigned int threads = gridDim.x * blockDim.x;

	init_array_cuda_x(X, threads);
	init_array_cuda_y(Y, threads);
	init_array_cuda_a(A, threads);
}
#endif

/**
 * Initialize the `X` array.
 * 
 * Runs on the device.
 */
#ifdef HPC_USE_CUDA
__device__ static void init_array_cuda_x(DATA_TYPE* X, unsigned int threads)
{
	// Find how many iterations should be performed by each thread
	unsigned int perThread = NY / threads;

	// Find the index of the current thread, even if threads span multiple blocks
	int blockThreadIdx = blockIdx.x * blockDim.x + threadIdx.x;
	
	// Have each thread perform the previously determined number of iterations
	for(int stride = 0; stride < perThread; stride++) {
		// Find the index of the current iteration
		// This is equal to `y` of the init_array function
		int iterationIdx = blockThreadIdx * stride;

		// Prevent the thread from accessing unallocated memory
		if(iterationIdx < NY) {

			// Set the array element
			X[iterationIdx] = iterationIdx * M_PI;
		}
	}
}
#endif

/**
 * Initialize the `Y` array.
 * 
 * Runs on the device.
 */
#ifdef HPC_USE_CUDA
__device__ static void init_array_cuda_y(DATA_TYPE* Y, unsigned int threads)
{
	// Find how many iterations should be performed by each thread
	unsigned int perThread = NX / threads;

	// Find the index of the current thread, even if threads span multiple blocks
	int blockThreadIdx = blockIdx.x * blockDim.x + threadIdx.x;
	
	// Have each thread perform the previously determined number of iterations
	for(int stride = 0; stride < perThread; stride++) {
		// Find the index of the current iteration
		// This is equal to `y` of the init_array function
		int iterationIdx = blockThreadIdx * stride;

		// Prevent the thread from accessing unallocated memory
		if(iterationIdx < NX) {

			// Set the array element
			Y[iterationIdx] = 0;
		}
	}
}
#endif

/**
 * Initialize the `A` array.
 * 
 * Runs on the device.
*/
#ifdef HPC_USE_CUDA
__device__ static void init_array_cuda_a(DATA_TYPE** A, unsigned int threads)
{

}
#endif

/**
 * Print the given array.
 * 
 * Cannot be parallelized, as the elements of the array should be 
 * 
 * To be called on the CPU (uses the `__host__` qualifier).
 */
__host__ static void print_array(DATA_TYPE* Y)
{
	for (unsigned int x = 0; x < NX; x++) 
	{
		fprintf(stderr, DATA_PRINTF_MODIFIER, Y[x]);
	}
	fprintf(stderr, "\n");
}


/**
 * Compute ATAX :
 * - A is the input matrix
 * - X is an input vector
 * - Y is the result vector
 * 
 * In particular:
 * ```
 * A * (A * X) = Y
 * ```
 * Wait, there's no transposition here?!?
 * 
 * Parallelizing this is the goal of the assignment.
 * 
 * Currently to be called on the CPU (uses the `__host__` qualifier), but we may probably want to change that soon.
 */
__host__ static void kernel_atax(DATA_TYPE** A, DATA_TYPE* X, DATA_TYPE* Y)
{
	for (unsigned int x = 0; x < NX; x++) 
	{
		DATA_TYPE tmp = 0;
		
		for (unsigned int y = 0; y < NY; y++) 
		{
			tmp += A[x][y] * X[y];
		}
		
		for (unsigned int y = 0; y < NY; y++) 
		{
			Y[y] += A[x][y] * tmp;
		}
	}
}


/**
 * The main function of the benchmark, which sets up tooling to measure the time spent computing `kernel_atax`.
 * 
 * We should probably avoid editing this.
 */
__host__ int main(int argc, char** argv)
{
	#ifndef HPC_USE_CUDA

		// A[NX][NY]
		DATA_TYPE** A = new DATA_TYPE*[NX] {};
		for(unsigned int x = 0; x < NX; x++)
		{
			A[x] = new DATA_TYPE[NY] {};
		}

		// X[NY]
		DATA_TYPE* X = new DATA_TYPE[NY] {};

		// Y[NX]
		DATA_TYPE* Y = new DATA_TYPE[NX] {};

		#ifdef HPC_INCLUDE_INIT
			polybench_start_instruments;
		#endif

		init_array(A, X, Y);

		#ifndef HPC_INCLUDE_INIT
			polybench_start_instruments;
		#endif

		kernel_atax(A, X, Y);

		polybench_stop_instruments;
		polybench_print_instruments;

		polybench_prevent_dce(
			print_array(Y)
		);

	#else

		DATA_TYPE** A;
		DATA_TYPE* X;
		DATA_TYPE* Y;
		
		if(cudaMalloc(&A, sizeof(DATA_TYPE) * NX * NY)) 
		{
			std::cerr << "Could not allocate A on the device\n";
			return 1;
		}
		
		if(cudaMalloc(&X, sizeof(DATA_TYPE) * NY))
		{
			std::cerr << "Could not allocate X on the device\n";
			return 1;
		}

		if(cudaMalloc(&Y, sizeof(DATA_TYPE) * NX))
		{
			std::cerr << "Could not allocate Y on the device\n";
			return 1;
		}

		#ifdef POLYBENCH_INCLUDE_INIT
			polybench_start_instruments;
		#endif

		init_array_cuda<<<1, 1>>>(A, X, Y);

		#ifndef POLYBENCH_INCLUDE_INIT
			polybench_start_instruments;
		#endif

		// kernel_atax_cuda<<<1, 1>>>();

		polybench_stop_instruments;
		polybench_print_instruments;

		// Y = cudaMemcpy();

		/*
		polybench_prevent_dce(
			print_array(Y)
		);
		*/

	#endif

	return 0;
}
