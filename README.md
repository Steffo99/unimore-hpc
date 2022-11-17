\[ **Stefano Pigozzi** + **Caterina Gazzotti** + **Fabio Zanichelli** | Topic OpenMP | High Performance Computing Laboratory | Unimore \]

# C code optimization using OpenMP

> ### Assignment #1
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
* Created static OpenMP parallelizations to most `for` loops in the program:
    * [First loop of `init_array`](https://github.com/Steffo99/unimore-hpc-1/blob/bffa0502393d97e7cda4ac34c57dd9c3ac9ac9dc/OpenMP/linear-algebra/kernels/atax/atax.c#L29)
    * [Second loop of `init_array`](https://github.com/Steffo99/unimore-hpc-1/blob/bffa0502393d97e7cda4ac34c57dd9c3ac9ac9dc/OpenMP/linear-algebra/kernels/atax/atax.c#L37)
    * [First loop of `kernel_atax`](https://github.com/Steffo99/unimore-hpc-1/blob/bffa0502393d97e7cda4ac34c57dd9c3ac9ac9dc/OpenMP/linear-algebra/kernels/atax/atax.c#L71)
    * [Second loop of `kernel_atax`](https://github.com/Steffo99/unimore-hpc-1/blob/bffa0502393d97e7cda4ac34c57dd9c3ac9ac9dc/OpenMP/linear-algebra/kernels/atax/atax.c#L80)
* Gated parallelizations behind flags, allowing their configurations at compile time:
    * [`TOGGLE_INIT_ARRAY_1` for the first loop of `init_array`](https://github.com/Steffo99/unimore-hpc-1/blob/bffa0502393d97e7cda4ac34c57dd9c3ac9ac9dc/OpenMP/linear-algebra/kernels/atax/atax.c#L28)
    * [`TOGGLE_INIT_ARRAY_2` for the second loop of `init_array`](https://github.com/Steffo99/unimore-hpc-1/blob/bffa0502393d97e7cda4ac34c57dd9c3ac9ac9dc/OpenMP/linear-algebra/kernels/atax/atax.c#L36)
    * [`TOGGLE_KERNEL_ATAX_1` for the first loop of `kernel_atax`](https://github.com/Steffo99/unimore-hpc-1/blob/bffa0502393d97e7cda4ac34c57dd9c3ac9ac9dc/OpenMP/linear-algebra/kernels/atax/atax.c#L70)
    * [`TOGGLE_KERNEL_ATAX_2` for the second loop of `kernel_atax`](https://github.com/Steffo99/unimore-hpc-1/blob/bffa0502393d97e7cda4ac34c57dd9c3ac9ac9dc/OpenMP/linear-algebra/kernels/atax/atax.c#L79)
* [Made the parallelization thread count configurable at compile time](https://github.com/Steffo99/unimore-hpc-1/blob/bffa0502393d97e7cda4ac34c57dd9c3ac9ac9dc/OpenMP/linear-algebra/kernels/atax/Makefile#L11-L12)
* [Allowed the addition of `CFLAGS` from `make` calls](https://github.com/Steffo99/unimore-hpc-1/blob/bffa0502393d97e7cda4ac34c57dd9c3ac9ac9dc/OpenMP/linear-algebra/kernels/atax/Makefile#L13-L14)
* [Disabled `make` output](https://github.com/Steffo99/unimore-hpc-1/commit/f655df0eb7e539b06965de7c79dbc1c7bc6a5950)
* [Created `make bench` target to run](https://github.com/Steffo99/unimore-hpc-1/blob/bffa0502393d97e7cda4ac34c57dd9c3ac9ac9dc/OpenMP/linear-algebra/kernels/atax/Makefile#L20-L23) [a script performing multiple parametrized tests on the code to determine the best optimizations](https://github.com/Steffo99/unimore-hpc-1/blob/master/OpenMP/linear-algebra/kernels/atax/.bench.sh)
* [Moved `polybench_start_instruments` to include the `init_array` function](https://github.com/Steffo99/unimore-hpc-1/commit/0ba75336e60b1cf149684a5f259fa933a36e2c5c)

## Results

```console
$ make bench
Flags: -DMINI_DATASET
.........................  Average of 25 runs:  1.35e-05 seconds
Flags: -DMINI_DATASET -DTOGGLE_INIT_ARRAY_1
.........................  Average of 25 runs:  1.92e-05 seconds
Flags: -DMINI_DATASET -DTOGGLE_INIT_ARRAY_2
.........................  Average of 25 runs:  2.16e-05 seconds
Flags: -DMINI_DATASET -DTOGGLE_INIT_ARRAY_1 -DTOGGLE_INIT_ARRAY_2
.........................  Average of 25 runs:  2.61e-05 seconds
Flags: -DMINI_DATASET -DTOGGLE_KERNEL_ATAX_1
.........................  Average of 25 runs:  1.9e-05 seconds
Flags: -DMINI_DATASET -DTOGGLE_INIT_ARRAY_1 -DTOGGLE_KERNEL_ATAX_1
.........................  Average of 25 runs:  2.12e-05 seconds
Flags: -DMINI_DATASET -DTOGGLE_INIT_ARRAY_2 -DTOGGLE_KERNEL_ATAX_1
.........................  Average of 25 runs:  2.36e-05 seconds
Flags: -DMINI_DATASET -DTOGGLE_INIT_ARRAY_1 -DTOGGLE_INIT_ARRAY_2 -DTOGGLE_KERNEL_ATAX_1
.........................  Average of 25 runs:  2.58e-05 seconds
Flags: -DMINI_DATASET -DTOGGLE_KERNEL_ATAX_2
.........................  Average of 25 runs:  1.72e-05 seconds
Flags: -DMINI_DATASET -DTOGGLE_INIT_ARRAY_1 -DTOGGLE_KERNEL_ATAX_2
.........................  Average of 25 runs:  1.91e-05 seconds
Flags: -DMINI_DATASET -DTOGGLE_INIT_ARRAY_2 -DTOGGLE_KERNEL_ATAX_2
.........................  Average of 25 runs:  2.12e-05 seconds
Flags: -DMINI_DATASET -DTOGGLE_INIT_ARRAY_1 -DTOGGLE_INIT_ARRAY_2 -DTOGGLE_KERNEL_ATAX_2
.........................  Average of 25 runs:  2.32e-05 seconds
Flags: -DMINI_DATASET -DTOGGLE_KERNEL_ATAX_1 -DTOGGLE_KERNEL_ATAX_2
.........................  Average of 25 runs:  1.92e-05 seconds
Flags: -DMINI_DATASET -DTOGGLE_INIT_ARRAY_1 -DTOGGLE_KERNEL_ATAX_1 -DTOGGLE_KERNEL_ATAX_2
.........................  Average of 25 runs:  2.11e-05 seconds
Flags: -DMINI_DATASET -DTOGGLE_INIT_ARRAY_2 -DTOGGLE_KERNEL_ATAX_1 -DTOGGLE_KERNEL_ATAX_2
.........................  Average of 25 runs:  2.3e-05 seconds
Flags: -DMINI_DATASET -DTOGGLE_INIT_ARRAY_1 -DTOGGLE_INIT_ARRAY_2 -DTOGGLE_KERNEL_ATAX_1 -DTOGGLE_KERNEL_ATAX_2
.........................  Average of 25 runs:  2.6e-05 seconds
Flags: -DSMALL_DATASET
.........................  Average of 25 runs:  0.00751 seconds
Flags: -DSMALL_DATASET -DTOGGLE_INIT_ARRAY_1
.........................  Average of 25 runs:  0.00752 seconds
Flags: -DSMALL_DATASET -DTOGGLE_INIT_ARRAY_2
.........................  Average of 25 runs:  0.00279 seconds
Flags: -DSMALL_DATASET -DTOGGLE_INIT_ARRAY_1 -DTOGGLE_INIT_ARRAY_2
.........................  Average of 25 runs:  0.0028 seconds
Flags: -DSMALL_DATASET -DTOGGLE_KERNEL_ATAX_1
.........................  Average of 25 runs:  0.00761 seconds
Flags: -DSMALL_DATASET -DTOGGLE_INIT_ARRAY_1 -DTOGGLE_KERNEL_ATAX_1
.........................  Average of 25 runs:  0.00761 seconds
Flags: -DSMALL_DATASET -DTOGGLE_INIT_ARRAY_2 -DTOGGLE_KERNEL_ATAX_1
.........................  Average of 25 runs:  0.00289 seconds
Flags: -DSMALL_DATASET -DTOGGLE_INIT_ARRAY_1 -DTOGGLE_INIT_ARRAY_2 -DTOGGLE_KERNEL_ATAX_1
.........................  Average of 25 runs:  0.00293 seconds
Flags: -DSMALL_DATASET -DTOGGLE_KERNEL_ATAX_2
.........................  Average of 25 runs:  0.00707 seconds
Flags: -DSMALL_DATASET -DTOGGLE_INIT_ARRAY_1 -DTOGGLE_KERNEL_ATAX_2
.........................  Average of 25 runs:  0.00703 seconds
Flags: -DSMALL_DATASET -DTOGGLE_INIT_ARRAY_2 -DTOGGLE_KERNEL_ATAX_2
.........................  Average of 25 runs:  0.00228 seconds
Flags: -DSMALL_DATASET -DTOGGLE_INIT_ARRAY_1 -DTOGGLE_INIT_ARRAY_2 -DTOGGLE_KERNEL_ATAX_2
.........................  Average of 25 runs:  0.00227 seconds
Flags: -DSMALL_DATASET -DTOGGLE_KERNEL_ATAX_1 -DTOGGLE_KERNEL_ATAX_2
.........................  Average of 25 runs:  0.00707 seconds
Flags: -DSMALL_DATASET -DTOGGLE_INIT_ARRAY_1 -DTOGGLE_KERNEL_ATAX_1 -DTOGGLE_KERNEL_ATAX_2
.........................  Average of 25 runs:  0.00706 seconds
Flags: -DSMALL_DATASET -DTOGGLE_INIT_ARRAY_2 -DTOGGLE_KERNEL_ATAX_1 -DTOGGLE_KERNEL_ATAX_2
.........................  Average of 25 runs:  0.00228 seconds
Flags: -DSMALL_DATASET -DTOGGLE_INIT_ARRAY_1 -DTOGGLE_INIT_ARRAY_2 -DTOGGLE_KERNEL_ATAX_1 -DTOGGLE_KERNEL_ATAX_2
.........................  Average of 25 runs:  0.00228 seconds
Flags: -DSTANDARD_DATASET
.........................  Average of 25 runs:  0.419 seconds
Flags: -DSTANDARD_DATASET -DTOGGLE_INIT_ARRAY_1
.........................  Average of 25 runs:  0.419 seconds
Flags: -DSTANDARD_DATASET -DTOGGLE_INIT_ARRAY_2
.........................  Average of 25 runs:  0.162 seconds
Flags: -DSTANDARD_DATASET -DTOGGLE_INIT_ARRAY_1 -DTOGGLE_INIT_ARRAY_2
.........................  Average of 25 runs:  0.162 seconds
Flags: -DSTANDARD_DATASET -DTOGGLE_KERNEL_ATAX_1
.........................  Average of 25 runs:  0.42 seconds
Flags: -DSTANDARD_DATASET -DTOGGLE_INIT_ARRAY_1 -DTOGGLE_KERNEL_ATAX_1
.........................  Average of 25 runs:  0.42 seconds
Flags: -DSTANDARD_DATASET -DTOGGLE_INIT_ARRAY_2 -DTOGGLE_KERNEL_ATAX_1
.........................  Average of 25 runs:  0.162 seconds
Flags: -DSTANDARD_DATASET -DTOGGLE_INIT_ARRAY_1 -DTOGGLE_INIT_ARRAY_2 -DTOGGLE_KERNEL_ATAX_1
.........................  Average of 25 runs:  0.162 seconds
Flags: -DSTANDARD_DATASET -DTOGGLE_KERNEL_ATAX_2
.........................  Average of 25 runs:  0.386 seconds
Flags: -DSTANDARD_DATASET -DTOGGLE_INIT_ARRAY_1 -DTOGGLE_KERNEL_ATAX_2
.........................  Average of 25 runs:  0.386 seconds
Flags: -DSTANDARD_DATASET -DTOGGLE_INIT_ARRAY_2 -DTOGGLE_KERNEL_ATAX_2
.........................  Average of 25 runs:  0.128 seconds
Flags: -DSTANDARD_DATASET -DTOGGLE_INIT_ARRAY_1 -DTOGGLE_INIT_ARRAY_2 -DTOGGLE_KERNEL_ATAX_2
.........................  Average of 25 runs:  0.128 seconds
Flags: -DSTANDARD_DATASET -DTOGGLE_KERNEL_ATAX_1 -DTOGGLE_KERNEL_ATAX_2
.........................  Average of 25 runs:  0.386 seconds
Flags: -DSTANDARD_DATASET -DTOGGLE_INIT_ARRAY_1 -DTOGGLE_KERNEL_ATAX_1 -DTOGGLE_KERNEL_ATAX_2
.........................  Average of 25 runs:  0.386 seconds
Flags: -DSTANDARD_DATASET -DTOGGLE_INIT_ARRAY_2 -DTOGGLE_KERNEL_ATAX_1 -DTOGGLE_KERNEL_ATAX_2
.........................  Average of 25 runs:  0.128 seconds
Flags: -DSTANDARD_DATASET -DTOGGLE_INIT_ARRAY_1 -DTOGGLE_INIT_ARRAY_2 -DTOGGLE_KERNEL_ATAX_1 -DTOGGLE_KERNEL_ATAX_2
.........................  Average of 25 runs:  0.129 seconds
Flags: -DLARGE_DATASET
.........................  Average of 25 runs:  1.83 seconds
Flags: -DLARGE_DATASET -DTOGGLE_INIT_ARRAY_1
.........................  Average of 25 runs:  1.83 seconds
Flags: -DLARGE_DATASET -DTOGGLE_INIT_ARRAY_2
.........................  Average of 25 runs:  0.707 seconds
Flags: -DLARGE_DATASET -DTOGGLE_INIT_ARRAY_1 -DTOGGLE_INIT_ARRAY_2
.........................  Average of 25 runs:  0.707 seconds
Flags: -DLARGE_DATASET -DTOGGLE_KERNEL_ATAX_1
.........................  Average of 25 runs:  1.82 seconds
Flags: -DLARGE_DATASET -DTOGGLE_INIT_ARRAY_1 -DTOGGLE_KERNEL_ATAX_1
.........................  Average of 25 runs:  1.82 seconds
Flags: -DLARGE_DATASET -DTOGGLE_INIT_ARRAY_2 -DTOGGLE_KERNEL_ATAX_1
.........................  Average of 25 runs:  0.704 seconds
Flags: -DLARGE_DATASET -DTOGGLE_INIT_ARRAY_1 -DTOGGLE_INIT_ARRAY_2 -DTOGGLE_KERNEL_ATAX_1
.........................  Average of 25 runs:  0.703 seconds
Flags: -DLARGE_DATASET -DTOGGLE_KERNEL_ATAX_2
.........................  Average of 25 runs:  1.64 seconds
Flags: -DLARGE_DATASET -DTOGGLE_INIT_ARRAY_1 -DTOGGLE_KERNEL_ATAX_2
.........................  Average of 25 runs:  1.64 seconds
Flags: -DLARGE_DATASET -DTOGGLE_INIT_ARRAY_2 -DTOGGLE_KERNEL_ATAX_2
.........................  Average of 25 runs:  0.527 seconds
Flags: -DLARGE_DATASET -DTOGGLE_INIT_ARRAY_1 -DTOGGLE_INIT_ARRAY_2 -DTOGGLE_KERNEL_ATAX_2
.........................  Average of 25 runs:  0.527 seconds
Flags: -DLARGE_DATASET -DTOGGLE_KERNEL_ATAX_1 -DTOGGLE_KERNEL_ATAX_2
.........................  Average of 25 runs:  1.63 seconds
Flags: -DLARGE_DATASET -DTOGGLE_INIT_ARRAY_1 -DTOGGLE_KERNEL_ATAX_1 -DTOGGLE_KERNEL_ATAX_2
.........................  Average of 25 runs:  1.64 seconds
Flags: -DLARGE_DATASET -DTOGGLE_INIT_ARRAY_2 -DTOGGLE_KERNEL_ATAX_1 -DTOGGLE_KERNEL_ATAX_2
.........................  Average of 25 runs:  0.527 seconds
Flags: -DLARGE_DATASET -DTOGGLE_INIT_ARRAY_1 -DTOGGLE_INIT_ARRAY_2 -DTOGGLE_KERNEL_ATAX_1 -DTOGGLE_KERNEL_ATAX_2
.........................  Average of 25 runs:  0.525 seconds
Flags: -DEXTRALARGE_DATASET
.........................  Average of 25 runs:  4.24 seconds
Flags: -DEXTRALARGE_DATASET -DTOGGLE_INIT_ARRAY_1
.........................  Average of 25 runs:  4.23 seconds
Flags: -DEXTRALARGE_DATASET -DTOGGLE_INIT_ARRAY_2
.........................  Average of 25 runs:  1.65 seconds
Flags: -DEXTRALARGE_DATASET -DTOGGLE_INIT_ARRAY_1 -DTOGGLE_INIT_ARRAY_2
.........................  Average of 25 runs:  1.65 seconds
Flags: -DEXTRALARGE_DATASET -DTOGGLE_KERNEL_ATAX_1
.........................  Average of 25 runs:  4.22 seconds
Flags: -DEXTRALARGE_DATASET -DTOGGLE_INIT_ARRAY_1 -DTOGGLE_KERNEL_ATAX_1
.........................  Average of 25 runs:  4.16 seconds
Flags: -DEXTRALARGE_DATASET -DTOGGLE_INIT_ARRAY_2 -DTOGGLE_KERNEL_ATAX_1
.........................  Average of 25 runs:  1.62 seconds
Flags: -DEXTRALARGE_DATASET -DTOGGLE_INIT_ARRAY_1 -DTOGGLE_INIT_ARRAY_2 -DTOGGLE_KERNEL_ATAX_1
.........................  Average of 25 runs:  1.62 seconds
Flags: -DEXTRALARGE_DATASET -DTOGGLE_KERNEL_ATAX_2
.........................  Average of 25 runs:  3.69 seconds
Flags: -DEXTRALARGE_DATASET -DTOGGLE_INIT_ARRAY_1 -DTOGGLE_KERNEL_ATAX_2
.........................  Average of 25 runs:  3.68 seconds
Flags: -DEXTRALARGE_DATASET -DTOGGLE_INIT_ARRAY_2 -DTOGGLE_KERNEL_ATAX_2
.........................  Average of 25 runs:  1.2 seconds
Flags: -DEXTRALARGE_DATASET -DTOGGLE_INIT_ARRAY_1 -DTOGGLE_INIT_ARRAY_2 -DTOGGLE_KERNEL_ATAX_2
.........................  Average of 25 runs:  1.2 seconds
Flags: -DEXTRALARGE_DATASET -DTOGGLE_KERNEL_ATAX_1 -DTOGGLE_KERNEL_ATAX_2
.........................  Average of 25 runs:  3.67 seconds
Flags: -DEXTRALARGE_DATASET -DTOGGLE_INIT_ARRAY_1 -DTOGGLE_KERNEL_ATAX_1 -DTOGGLE_KERNEL_ATAX_2
.........................  Average of 25 runs:  3.67 seconds
Flags: -DEXTRALARGE_DATASET -DTOGGLE_INIT_ARRAY_2 -DTOGGLE_KERNEL_ATAX_1 -DTOGGLE_KERNEL_ATAX_2
.........................  Average of 25 runs:  1.19 seconds
Flags: -DEXTRALARGE_DATASET -DTOGGLE_INIT_ARRAY_1 -DTOGGLE_INIT_ARRAY_2 -DTOGGLE_KERNEL_ATAX_1 -DTOGGLE_KERNEL_ATAX_2
.........................  Average of 25 runs:  1.19 seconds
```

### Validation

* Compiler used: **gcc**
* Jetson Nano used: `8`

To reproduce the obtained results:

1. Clone the repository on a Jetson Nano:

    ```console
    $ git clone https://github.com/Steffo99/unimore-hpc-1
    ```

2. Access our group's assigned folder:

    ```console
    $ cd unimore-hpc-1/OpenMP/linear-algebra/kernels/atax
    ```

3. Checkout the exact commit the tests were executed on:

    ```console
    $ git checkout 28479dfb4b730fb50a50e6da02b9b1fe4fb298db
    ```

4. Run the benchmarking script:

    ```console
    $ make bench
    ```
