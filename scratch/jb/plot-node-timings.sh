#! /bin/bash

set -eu

GNUPLOT=${GNUPLOT:-gnuplot}
# GNNUPLOT=cat

# 1st argument: data file
NAME=${1?"Input file required"}
shift

$GNUPLOT <<EOF
set terminal png size 1600,900

# https://psy.swansea.ac.uk/staff/carter/gnuplot/gnuplot_time_histograms.htm

# If we don't use columnhead, the first line of the data file
# will confuse gnuplot, which will leave gaps in the plot.
set key top left outside horizontal autotitle columnhead

set xtics out nomirror
set ytics out nomirror

set style fill solid border -1

# Make the histogram boxes half the width of their slots.
set boxwidth 0.5 relative

# Select histogram mode.
set style data histograms

# Select a row-stacked histogram.
set style histogram rowstacked

set output "${NAME}.png"

plot "$NAME" using 3:xticlabels(1) lc rgb 'green' title "Abstract", \
	"" using 4 lc rgb 'red' title "Extend",  \
	"" using 5 lc rgb 'yellow' title "Concretize", \
        "" using 6 lc rgb 'blue' title "Stack Change", \
        "" using 7 lc rgb 'cyan' title "Check Final"
EOF
