#!/bin/bash

runs=9
totalt=0.0

for i in $(seq $runs)
do
    exet=$(./atax_acc)
    totalt=$(awk "BEGIN{print $totalt+$exet}")
    echo "Run #$i: " $(awk "BEGIN{printf(\"%.3g\", $exet)}") "seconds"
done

avgt=$(awk "BEGIN{print $totalt/$runs}")
echo "Average: " $(awk "BEGIN{printf(\"%.3g\", $avgt)}") "seconds"
