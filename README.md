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

Results can be read in the ex.txt file where we stored all the 
experiments done.


### Validation

* Compiler used: **nvcc**
* Device used: `JETSON NANO DEVELOPER KIT` 
* Built on: Mon_Mar_11_22:13:24_CDT_2019 Cuda compilation tools, release 10.0, V10.0.326

To reproduce the obtained results:

1. Clone the repository on @Steffo99's computer:

    ```console
    $ git clone https://github.com/Steffo99/unimore-hpc-assignments
    ```

2. Checkout the exact commit the tests were executed on:

    ```console
    $ git checkout d13a9b786a53d5195ae17ef7afa776e2600ce8e0
    ```

3. Access our group's assigned folder:

    ```console
    $ cd unimore-hpc-assignments/atax
    ```

4. Run the benchmarking script:

    ```console
    $ make bench
    ```
