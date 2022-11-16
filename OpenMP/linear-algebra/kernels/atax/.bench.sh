#!/bin/bash

runs=9
totalt=0.0

for i in $(seq $runs)
do
    exet=$(./atax_acc)
    totalt=$(awk "BEGIN{print $totalt+$exet}")
    echo " Run #$i: $exet seconds"
done

avgt=$(awk "BEGIN{print $totalt/$runs}")
echo "Average: $avgt seconds"
