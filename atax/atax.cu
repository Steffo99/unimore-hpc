#include <stdio.h>
#include <unistd.h>
#include <string.h>
#include <math.h>
#include <iostream>
#include <string>

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


/**
 * Given a `x` and a `y`, compute the relative index of the element in the `A` matrix.
 */
__host__ __device__ inline static unsigned int a_index(unsigned int x, unsigned int y) {
	return x * NY + y;
}

/**
 * Log a debug message.
 */
__host__ inline static void print_debug(std::string txt) {
	#ifdef HPC_DEBUG
		std::cerr << txt << std::endl;
	#endif
}

/**
 * Log an error message.
 */
#ifdef HPC_USE_CUDA
__host__ inline static void print_cudaError(cudaError_t err, std::string txt) {
	#ifdef HPC_DEBUG
		std::cerr << txt;
		fprintf( stderr, ": error in file '%s' in line %i: %s.\n", __FILE__, __LINE__, cudaGetErrorString(err) );
	#endif
}
#endif

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
__host__ static void init_array(DATA_TYPE* A, DATA_TYPE* X, DATA_TYPE* Y)
{
	for (unsigned int y = 0; y < NY; y++) 
	{
		X[y] = y * M_PI;
	}

	for (unsigned int x = 0; x < NX; x++) 
	{
		Y[x] = 0;
	}

	for (unsigned int x = 0; x < NX; x++) 
	{
		for (unsigned int y = 0; y < NY; y++) 
		{
			A[a_index(x, y)] = (DATA_TYPE)(x * (y + 1)) / NX;
		}
	}
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
	unsigned int perThread = NY / threads + 1;

	// Find the index of the current thread, even if threads span multiple blocks
	int blockThreadIdx = blockIdx.x * blockDim.x + threadIdx.x;
	
	// Have each thread perform the previously determined number of iterations
	for(int stride = 0; stride < perThread; stride++)
	{
		// Find the index of the current iteration
		// This is equal to `y` of the init_array function
		unsigned int iterationIdx = threads * stride + blockThreadIdx;

		// Prevent the thread from accessing unallocated memory
		if(iterationIdx < NY)
		{
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
	unsigned int perThread = NX / threads + 1;

	// Find the index of the current thread, even if threads span multiple blocks
	int blockThreadIdx = blockIdx.x * blockDim.x + threadIdx.x;
	
	// Have each thread perform the previously determined number of iterations
	for(int stride = 0; stride < perThread; stride++) 
	{
		// Find the index of the current iteration
		// This is equal to `y` of the init_array function
		unsigned int iterationIdx = threads * stride + blockThreadIdx;

		// Prevent the thread from accessing unallocated memory
		if(iterationIdx < NX) 
		{
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
__device__ static void init_array_cuda_a(DATA_TYPE* A, unsigned int threads)
{
	// Find how many elements should be written in total
	unsigned int elements = NX * NY;

	// Find how many iterations should be performed by each thread
	unsigned int perThread = elements / threads + 1;

	// Find the index of the current thread, even if threads span multiple blocks
	int blockThreadIdx = blockIdx.x * blockDim.x + threadIdx.x;

	// Have each thread perform the previously determined number of iterations
	for(int stride = 0; stride < perThread; stride++) 
	{
		// Find the index of the current iteration
		// This is equal to `y` of the init_array function
		unsigned int iterationIdx = threads * stride + blockThreadIdx;

		// Determine current x and y
		unsigned int y = iterationIdx % NY;
		unsigned int x = iterationIdx / NY;

		// Prevent the thread from accessing unallocated memory
		if(iterationIdx < elements) 
		{
			// Set the array element
			A[iterationIdx] = (DATA_TYPE)(x * (y + 1)) / NX;
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
 * Beware that `A` here is a simple array, it is not a matrix, so elements are accessed via [y * NX + x] (I think?).
 * 
 * It is called by the host, runs on the device, and calls the other init_arrays on the device.
 */
#ifdef HPC_USE_CUDA
__global__ static void init_array_cuda(DATA_TYPE* A, DATA_TYPE* X, DATA_TYPE* Y)
{
	unsigned int threads = gridDim.x * blockDim.x;

	init_array_cuda_x(X, threads);
	init_array_cuda_y(Y, threads);
	init_array_cuda_a(A, threads);
}
#endif

/**
 * Print the given array.
 * 
 * Cannot be parallelized, as the elements of the array should be 
 * 
 * To be called on the CPU (uses the `__host__` qualifier).
 */
#ifdef HPC_DEBUG
__host__ static void print_array(DATA_TYPE* Z, unsigned int size)
{
	for (unsigned int z = 0; z < size; z++) 
	{
		fprintf(stderr, DATA_PRINTF_MODIFIER, Z[z]);
	}
	fprintf(stderr, "\n");
}
#endif


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
 * To be called on the CPU uses the `__host__` qualifier otherwise
 * for the GPU uses the `__global__` qualifier.
 */
#ifndef HPC_USE_CUDA
__host__ static void kernel_atax(DATA_TYPE* A, DATA_TYPE* X, DATA_TYPE* Y)
{
	for (unsigned int x = 0; x < NY; x++) 
	{
		DATA_TYPE tmp = 0;
		
		for (unsigned int y = 0; y < NX; y++) 
		{
			tmp += A[a_index(x, y)] * X[y];
		}
		
		for (unsigned int y = 0; y < NX; y++) 
		{
			Y[x] += A[a_index(x, y)] * tmp;
		}
	}
}
#else

__global__ static void kernel_atax_cuda(DATA_TYPE* A, DATA_TYPE* X, DATA_TYPE* Y)
{
	// Find out how many threads there are
	unsigned int threads = gridDim.x * blockDim.x;

	// Find how many iterations should be performed by each thread
	unsigned int perThread = NX / threads + 1;

	// Find the index of the current thread, even if threads span multiple blocks
	unsigned int blockThreadIdx = blockIdx.x * blockDim.x + threadIdx.x;

	// Have each thread perform the previously determined number of iterations
	for(int stride = 0; stride < perThread; stride++) 
	{
		// Iterate over x; y is not parallelized
		unsigned int x = threads * stride + blockThreadIdx;
		
		// Prevent the thread from accessing unallocated memory
		if(x < NX) 
		{
			// The same tmp as earlier
			DATA_TYPE tmp = 0;

			for (unsigned int y = 0; y < NX; y++) 
			{
				tmp += A[a_index(x, y)] * X[y];
			}

			for (unsigned int y = 0; y < NX; y++) 
			{
				// THIS DOES NOT WORK ON THE NANO, AS IT IS TOO OLD TO SUPPORT ATOMIC ADDITION WITH DOUBLES!
				// If you want to use the Nano, swap this for something else, or change atax.hu to use float instead of double
				atomicAdd(&Y[x], A[a_index(x, y)] * tmp);
			}
		}
	}
}
#endif


/**
 * The main function of the benchmark, which sets up tooling to measure the time spent computing `kernel_atax`.
 * 
 * We should probably avoid editing this.
 */
__host__ int main(int argc, char** argv)
{
	print_debug("[Main] Starting...");
	std::cerr << "[Main] NX is: " << NX << std::endl;
	std::cerr << "[Main] NY is: " << NY << std::endl;

	#ifndef HPC_USE_CUDA

		print_debug("[Mode] Host-only");

		print_debug("[Pointers] Allocating...");

		DATA_TYPE* A = new DATA_TYPE[NX * NY];
		DATA_TYPE* X = new DATA_TYPE[NY];
		volatile DATA_TYPE* Y = new DATA_TYPE[NX];

		print_debug("[Pointers] Allocated!");

		#ifdef HPC_INCLUDE_INIT
			print_debug("[Benchmark] Starting...");
			polybench_start_instruments;
		#endif

		print_debug("[Init] Initializing...");
		init_array(A, X, (DATA_TYPE*) Y);
		print_debug("[Init] Initialized!");

		#ifndef HPC_INCLUDE_INIT
			print_debug("[Benchmark] Starting...");
			polybench_start_instruments;
		#endif

		print_debug("[Kernel] Running...");
		kernel_atax(A, X, (DATA_TYPE*) Y);
		print_debug("[Kernel] Completed!");

		print_debug("[Benchmark] Stopping...");
		polybench_stop_instruments;
		polybench_print_instruments;
		print_debug("[Benchmark] Complete!");

		#ifdef HPC_DEBUG
			print_debug("[Debug] Displaying A:");
			print_array(A, NX * NY);
			print_debug("[Debug] Displaying X:");
			print_array(X, NY);
			print_debug("[Debug] Displaying Y:");
			print_array(Y, NX);
		#endif

	#else
	
		print_debug("[Mode] Host-and-device, CUDA");

		print_debug("[Pointers] Allocating...");
		DATA_TYPE* A;
		DATA_TYPE* X;
		DATA_TYPE* Y;
		#ifdef HPC_DEBUG
			DATA_TYPE* host_A = new DATA_TYPE[NX * NY];
			DATA_TYPE* host_X = new DATA_TYPE[NY];
		#endif
		volatile DATA_TYPE* host_Y = new DATA_TYPE[NX];
		
		print_debug("[CUDA] Allocating A...");
		if(cudaError_t err = cudaMalloc((void**)&A, sizeof(DATA_TYPE) * NX * NY)) 
		{
			print_cudaError(err, "[CUDA] Could not allocate A!");
			return 1;
		}
		print_debug("[CUDA] Allocated A!");
		
		print_debug("[CUDA] Allocating X...");
		if(cudaError_t err = cudaMalloc((void**)&X, sizeof(DATA_TYPE) * NY))
		{
			print_cudaError(err, "[CUDA] Could not allocate X!");
			return 1;
		}
		print_debug("[CUDA] Allocated X!");

		print_debug("[CUDA] Allocating Y...");
		if(cudaError_t err = cudaMalloc((void**)&Y, sizeof(DATA_TYPE) * NX))
		{
			print_cudaError(err, "[CUDA] Could not allocate Y!");
			return 1;
		}
		print_debug("[CUDA] Allocated Y!");

		#ifdef HPC_INCLUDE_INIT
			print_debug("[Benchmark] Starting...");
			polybench_start_instruments;
		#endif

		print_debug("[Init] Initializing...");
		init_array_cuda<<<32, 32>>>((DATA_TYPE*) A, (DATA_TYPE*) X, (DATA_TYPE*) Y);
		if(cudaError_t err = cudaGetLastError())
		{
			print_cudaError(err, "[Init] Failed to execute kernel!");
			return 1;
		}
		print_debug("[Init] Complete!");

		#ifndef HPC_INCLUDE_INIT
			print_debug("[Benchmark] Starting...");
			polybench_start_instruments;
		#endif

		print_debug("[Kernel] Running...");
		kernel_atax_cuda<<<32, 32>>>((DATA_TYPE*) A, (DATA_TYPE*) X, (DATA_TYPE*) Y);
		print_debug("[Kernel] Complete!");

		#ifdef HPC_DEBUG
			print_debug("[CUDA] Copying A back...");
			if(cudaError_t err = cudaMemcpy(host_A, A, sizeof(DATA_TYPE) * NX * NY, cudaMemcpyDeviceToHost)) {
				print_cudaError(err, "[CUDA] Could copy A back!");
				return 1;
			};
			print_debug("[CUDA] Copied A back!");

			print_debug("[CUDA] Copying X back...");
			if(cudaError_t err = cudaMemcpy(host_X, X, sizeof(DATA_TYPE) * NY, cudaMemcpyDeviceToHost)) {
				print_cudaError(err, "[CUDA] Could copy X back!");
				return 1;
			};
			print_debug("[CUDA] Copied X back!");
		#endif

		print_debug("[CUDA] Copying Y back...");
		if(cudaError_t err = cudaMemcpy((void*) host_Y, Y, sizeof(DATA_TYPE) * NX, cudaMemcpyDeviceToHost)) {
			print_cudaError(err, "[CUDA] Could copy Y back!");
			return 1;
		};
		print_debug("[CUDA] Copied Y back!");

		print_debug("[Benchmark] Stopping...");
		polybench_stop_instruments;
		polybench_print_instruments;
		print_debug("[Benchmark] Complete!");

		print_debug("[CUDA] Freeing A...");
		if(cudaError_t err = cudaFree(A)) {
			print_cudaError(err, "[CUDA] Could not free A!");
			return 1;
		}
		print_debug("[CUDA] Freed A!");

		print_debug("[CUDA] Freeing X...");
		if(cudaError_t err = cudaFree(X)) {
			print_cudaError(err, "[CUDA] Could not free X!");
			return 1;
		}
		print_debug("[CUDA] Freed X!");

		print_debug("[CUDA] Freeing Y...");
		if(cudaError_t err = cudaFree(Y)) {
			print_cudaError(err, "[CUDA] Could not free Y!");
			return 1;
		}
		print_debug("[CUDA] Freed Y!");

		#ifdef HPC_DEBUG
			print_debug("[Debug] Displaying A:");
			print_array(host_A, NX * NY);
			print_debug("[Debug] Displaying X:");
			print_array(host_X, NY);
			print_debug("[Debug] Displaying Y:");
			print_array((double*) host_Y, NX);
		#endif
	#endif

	return 0;
}
