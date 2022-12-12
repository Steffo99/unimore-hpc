\[ **Stefano Pigozzi** + **Caterina Gazzotti** + **Fabio Zanichelli** | Topic CUDA | High Performance Computing Laboratory | Unimore \]

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

```
Flags: -DMINI_DATASET
CB***  Average of 3 runs:  1.03e-05 seconds
Flags: -DMINI_DATASET -DHPC_INCLUDE_INIT
CB***  Average of 3 runs:  1.27e-05 seconds
Flags: -DMINI_DATASET -DHPC_USE_CUDA
CB***  Average of 3 runs:  0.00123 seconds
Flags: -DMINI_DATASET -DHPC_INCLUDE_INIT -DHPC_USE_CUDA
CB***  Average of 3 runs:  0.00161 seconds
Flags: -DSMALL_DATASET
CB***  Average of 3 runs:  0.0014 seconds
Flags: -DSMALL_DATASET -DHPC_INCLUDE_INIT
CB***  Average of 3 runs:  0.00344 seconds
Flags: -DSMALL_DATASET -DHPC_USE_CUDA
CB***  Average of 3 runs:  0.00971 seconds
Flags: -DSMALL_DATASET -DHPC_INCLUDE_INIT -DHPC_USE_CUDA
CB***  Average of 3 runs:  0.0112 seconds
Flags: -DSTANDARD_DATASET
CB***  Average of 3 runs:  0.0876 seconds
Flags: -DSTANDARD_DATASET -DHPC_INCLUDE_INIT
CB***  Average of 3 runs:  0.188 seconds
Flags: -DSTANDARD_DATASET -DHPC_USE_CUDA
CB***  Average of 3 runs:  0.201 seconds
Flags: -DSTANDARD_DATASET -DHPC_INCLUDE_INIT -DHPC_USE_CUDA
CB***  Average of 3 runs:  0.0647 seconds
Flags: -DLARGE_DATASET
CB***  Average of 3 runs:  0.35 seconds
Flags: -DLARGE_DATASET -DHPC_INCLUDE_INIT
CB***  Average of 3 runs:  0.746 seconds
Flags: -DLARGE_DATASET -DHPC_USE_CUDA
CB***  Average of 3 runs:  0.26 seconds
Flags: -DLARGE_DATASET -DHPC_INCLUDE_INIT -DHPC_USE_CUDA
CB***  Average of 3 runs:  0.278 seconds
Flags: -DEXTRALARGE_DATASET
CB***  Average of 3 runs:  0.789 seconds
Flags: -DEXTRALARGE_DATASET -DHPC_INCLUDE_INIT
CB***  Average of 3 runs:  1.68 seconds
Flags: -DEXTRALARGE_DATASET -DHPC_USE_CUDA
CB***  Average of 3 runs:  0.647 seconds
Flags: -DEXTRALARGE_DATASET -DHPC_INCLUDE_INIT -DHPC_USE_CUDA
CB***  Average of 3 runs:  0.665 seconds
```

### Validation

> Compiler used: **nvcc**
> ```
> Built on Mon_Mar_11_22:13:24_CDT_2019
> Cuda compilation tools, release 10.0, V10.0.326
> ```
>
> Device used: **Unimore Jetson Nano #8**

To reproduce the obtained results:

1. Load the CUDA module:
    
    ```console
    $ module load cuda
    ```

2. Clone the repository on @Steffo99's computer:

    ```console
    $ git clone https://github.com/Steffo99/unimore-hpc-assignments
    ```

3. Checkout the exact commit the tests were executed on:

    ```console
    $ git checkout d13a9b786a53d5195ae17ef7afa776e2600ce8e0
    ```

4. Access our group's assigned folder:

    ```console
    $ cd unimore-hpc-assignments/atax
    ```

5. Run the benchmarking script:

    ```console
    $ make bench
    ```
