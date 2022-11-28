#!/bin/bash

run_benchmarks() {
    runs=25
    totalt=0.0

    for i in $(seq $runs)
    do
        exet=$(./atax.elf)
        totalt=$(awk "BEGIN{print $totalt+$exet}")
        echo -n "."
        # echo "Run #$i: " $(awk "BEGIN{printf(\"%.3g\", $exet)}") "seconds"
    done

    avgt=$(awk "BEGIN{print $totalt/$runs}")
    echo "  Average of $runs runs: " $(awk "BEGIN{printf(\"%.3g\", $avgt)}") "seconds"
}

for dataset in MINI_DATASET SMALL_DATASET STANDARD_DATASET LARGE_DATASET EXTRALARGE_DATASET
do
    for c in $(seq 0 15)
    do
        cxxflags="-D$dataset"

        if (( $c & 1 ))
        then
            cxxflags="$cxxflags -DTOGGLE_INIT_ARRAY_1"
        fi 

        if (( $c & 2 ))
        then
            cxxflags="$cxxflags -DTOGGLE_INIT_ARRAY_2"
        fi 

        if (( $c & 4 ))
        then
            cxxflags="$cxxflags -DTOGGLE_KERNEL_ATAX_1"
        fi 

        if (( $c & 8 ))
        then
            cxxflags="$cxxflags -DTOGGLE_KERNEL_ATAX_2"
        fi 

        echo "Flags: $cxxflags"
        make --silent "EXTRA_CXXFLAGS=$cxxflags" "atax.elf"

        run_benchmarks
    done
done