#!/bin/bash

run_benchmarks() {
    runs=3
    totalt=0.0

    for i in $(seq $runs)
    do
        exet=$(./atax.elf 2> /dev/null)
        totalt=$(awk "BEGIN{print $totalt+$exet}")
        echo -n "*"
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
            cxxflags="$cxxflags -DHPC_INCLUDE_INIT"
        fi 

        if (( $c & 2 ))
        then
            cxxflags="$cxxflags -DHPC_USE_CUDA"
        fi

        echo "Flags: $cxxflags"
        make --silent "clean"
        echo -n "C"
        make --silent "EXTRA_CXXFLAGS=$cxxflags" "atax.elf"
        echo -n "B"

        run_benchmarks
    done
done