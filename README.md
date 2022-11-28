\[ **Stefano Pigozzi** + **Caterina Gazzotti** + **Fabio Zanichelli** | Topic OpenMP | High Performance Computing Laboratory | Unimore \]

# C code optimization using NVIDIA CUDA

> ### Assignment #2
> 
> Every team is called to optimize (parallellize) the execution time of the assigned applications on multi-processor system.
> 
> #### Expected outcomes
> 
> * Repository of the code (github/gitlab is ok, or .zip )
> * Oral presentation (5 min + 5 min Q&A) of your work
>
> #### Assigned application
> 
> Group 3: `OpenMP/linear-algebra/kernels/atax`

## Developed features

* [Workaround for unavailable `M_PI`](https://github.com/Steffo99/unimore-hpc-1/blob/bffa0502393d97e7cda4ac34c57dd9c3ac9ac9dc/OpenMP/linear-algebra/kernels/atax/atax.c#L13-L18)
* [Enabled `POLYBENCH_TIME` by default](https://github.com/Steffo99/unimore-hpc-1/blob/bffa0502393d97e7cda4ac34c57dd9c3ac9ac9dc/OpenMP/linear-algebra/kernels/atax/Makefile#L4-L5)
* [Enabled extra warnings by default](https://github.com/Steffo99/unimore-hpc-1/blob/bffa0502393d97e7cda4ac34c57dd9c3ac9ac9dc/OpenMP/linear-algebra/kernels/atax/Makefile#L6-L8)
* [Applied the maximum level of compiler optimizations](https://github.com/Steffo99/unimore-hpc-1/blob/bffa0502393d97e7cda4ac34c57dd9c3ac9ac9dc/OpenMP/linear-algebra/kernels/atax/Makefile#L9-L10)
* [Replaced `tmp` array with a iteration-local variable](https://github.com/Steffo99/unimore-hpc-1/commit/7fc2506cc7c6743288a56047cbb44e960abec4fc)
* [Allowed the addition of `CFLAGS` from `make` calls](https://github.com/Steffo99/unimore-hpc-1/blob/bffa0502393d97e7cda4ac34c57dd9c3ac9ac9dc/OpenMP/linear-algebra/kernels/atax/Makefile#L13-L14)
* [Disabled `make` output](https://github.com/Steffo99/unimore-hpc-1/commit/f655df0eb7e539b06965de7c79dbc1c7bc6a5950)
* [Created `make bench` target to run](https://github.com/Steffo99/unimore-hpc-1/blob/bffa0502393d97e7cda4ac34c57dd9c3ac9ac9dc/OpenMP/linear-algebra/kernels/atax/Makefile#L20-L23) [a script performing multiple parametrized tests on the code to determine the best optimizations](https://github.com/Steffo99/unimore-hpc-1/blob/master/OpenMP/linear-algebra/kernels/atax/.bench.sh)
* [Moved `polybench_start_instruments` to include the `init_array` function](https://github.com/Steffo99/unimore-hpc-1/commit/0ba75336e60b1cf149684a5f259fa933a36e2c5c)

## Results

TBD

### Validation

* Compiler used: **nvcc**
* Jetson Nano used: `8`

To reproduce the obtained results:

1. Clone the repository on a Jetson Nano:

    ```console
    $ git clone https://github.com/Steffo99/unimore-hpc-assignments
    ```

2. Access our group's assigned folder:

    ```console
    $ cd unimore-hpc-1/OpenMP/linear-algebra/kernels/atax
    ```

3. Checkout the exact commit the tests were executed on:

    ```console
    $ git checkout TBD
    ```

4. Run the benchmarking script:

    ```console
    $ make bench
    ```
