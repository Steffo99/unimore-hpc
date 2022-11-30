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
    for c in $(seq 0 3)
    do
        cxxflags="-D$dataset"

        if (( $c & 1 ))
        then
            cxxflags="$cxxflags -DPOLYBENCH_INCLUDE_INIT"
        fi 

        if (( $c & 2 ))
        then
            cxxflags="$cxxflags -DPOLYBENCH_USE_CUDA"
        fi

        echo "Flags: $cxxflags"
        make --silent "EXTRA_CXXFLAGS=$cxxflags" "atax.elf"

        run_benchmarks
    done
done