#!/bin/bash

run_benchmarks() {
    runs=25
    totalt=0.0

    for i in $(seq $runs)
    do
        exet=$(./atax_acc)
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
        cflags="-D$dataset"

        if (( $c & 1 ))
        then
            cflags="$cflags -DTOGGLE_INIT_ARRAY_1"
        fi 

        if (( $c & 2 ))
        then
            cflags="$cflags -DTOGGLE_INIT_ARRAY_2"
        fi 

        if (( $c & 4 ))
        then
            cflags="$cflags -DTOGGLE_KERNEL_ATAX_1"
        fi 

        if (( $c & 8 ))
        then
            cflags="$cflags -DTOGGLE_KERNEL_ATAX_2"
        fi 

        echo "Flags: $cflags"
        make "EXTRA_CFLAGS=$cflags" clean all

        run_benchmarks
    done
done