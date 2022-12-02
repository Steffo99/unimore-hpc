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

## Results

```console
steffo@nitro:/s/D/W/S/u/atax[130]$ make bench
./.bench.sh
Flags: -DMINI_DATASET
CB***  Average of 3 runs:  3.33e-06 seconds
Flags: -DMINI_DATASET -DHPC_INCLUDE_INIT
CB***  Average of 3 runs:  8.33e-06 seconds
Flags: -DMINI_DATASET -DHPC_USE_CUDA
CB***  Average of 3 runs:  6.8e-05 seconds
Flags: -DMINI_DATASET -DHPC_INCLUDE_INIT -DHPC_USE_CUDA
CB***  Average of 3 runs:  7.2e-05 seconds
Flags: -DSMALL_DATASET
CB***  Average of 3 runs:  0.000563 seconds
Flags: -DSMALL_DATASET -DHPC_INCLUDE_INIT
CB***  Average of 3 runs:  0.00139 seconds
Flags: -DSMALL_DATASET -DHPC_USE_CUDA
CB***  Average of 3 runs:  0.000229 seconds
Flags: -DSMALL_DATASET -DHPC_INCLUDE_INIT -DHPC_USE_CUDA
CB***  Average of 3 runs:  0.000309 seconds
Flags: -DSTANDARD_DATASET
CB***  Average of 3 runs:  0.0276 seconds
Flags: -DSTANDARD_DATASET -DHPC_INCLUDE_INIT
CB***  Average of 3 runs:  0.0664 seconds
Flags: -DSTANDARD_DATASET -DHPC_USE_CUDA
CB***  Average of 3 runs:  0.00938 seconds
Flags: -DSTANDARD_DATASET -DHPC_INCLUDE_INIT -DHPC_USE_CUDA
CB***  Average of 3 runs:  0.0128 seconds
Flags: -DLARGE_DATASET
CB***  Average of 3 runs:  0.109 seconds
Flags: -DLARGE_DATASET -DHPC_INCLUDE_INIT
CB***  Average of 3 runs:  0.243 seconds
Flags: -DLARGE_DATASET -DHPC_USE_CUDA
CB***  Average of 3 runs:  0.0449 seconds
Flags: -DLARGE_DATASET -DHPC_INCLUDE_INIT -DHPC_USE_CUDA
CB***  Average of 3 runs:  0.0459 seconds
Flags: -DEXTRALARGE_DATASET
CB***  Average of 3 runs:  0.248 seconds
Flags: -DEXTRALARGE_DATASET -DHPC_INCLUDE_INIT
CB***  Average of 3 runs:  0.584 seconds
Flags: -DEXTRALARGE_DATASET -DHPC_USE_CUDA
CB***  Average of 3 runs:  0.0971 seconds
Flags: -DEXTRALARGE_DATASET -DHPC_INCLUDE_INIT -DHPC_USE_CUDA
CB***  Average of 3 runs:  0.108 seconds
```

### Validation

* Compiler used: **nvcc**
* Device used: `NVIDIA GTX 1070` with `525.60.11` driver

To reproduce the obtained results:

1. Clone the repository on @Steffo99's computer:

    ```console
    $ git clone https://github.com/Steffo99/unimore-hpc-assignments
    ```

2. Checkout the exact commit the tests were executed on:

    ```console
    $ git checkout 2d6448e5aa3707370b837a37db4eb880ca06ddb7
    ```

3. Access our group's assigned folder:

    ```console
    $ cd unimore-hpc-assignments/atax
    ```

4. Run the benchmarking script:

    ```console
    $ make bench
    ```
