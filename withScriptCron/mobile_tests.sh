#!/bin/bash

# Specify the target sites for mtr and iperf3
MTR_TARGET="google.com"
IPERF3_TARGET="127.0.0.1"

# Specify the output files
MTR_OUTPUT="/results/mtr_result.txt"
IPERF3_OUTPUT="/results/iperf3_result.txt"

# Ensure the results directory exists
mkdir -p /results

# Run mtr test
echo "Running mtr test to $MTR_TARGET..."
MTR_RESULTS=$(mtr --report --report-cycles=10 $MTR_TARGET)
echo "$MTR_RESULTS"
echo "$MTR_RESULTS" >> $MTR_OUTPUT


# Run iperf3 test tcp 
echo "Running iperf3 tcp test to $IPERF3_TARGET..."
IPERF3_RESULTS=$(iperf3 -c $IPERF3_TARGET)
echo "$IPERF3_RESULTS"
echo "$IPERF3_RESULTS" >> $IPERF3_OUTPUT


# Run iperf3 test udp
echo "Running iperf3 udp test to $IPERF3_TARGERT..."
IPERF3_RESULTS=$(iperf3 -c $IPERF3_TARGET -u)
echo "$IPERF3_RESULTS"
echo "$IPERF3_RESULTS" >> $IPERF3_OUTPUT
echo "Tests completed. Results saved to /results."
