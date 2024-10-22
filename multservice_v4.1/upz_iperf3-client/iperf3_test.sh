#!/bin/sh

IPERF3_TARGET="172.29.108.129"  # Replace with the public link from the Balena Cloud device
current_datetime=$(date +"%Y-%m-%d_%I-%M%p") # Custom format: Year-Month-Day Hour
IPERF3_OUTPUT="/reports/iperf3_result_$current_datetime.txt"

# Run iperf3 test TCP
echo "*************************************************************************" >> $IPERF3_OUTPUT
echo "Running iperf3 TCP test at $current_datetime" >> $IPERF3_OUTPUT
echo "*************************************************************************" >> $IPERF3_OUTPUT
echo "" >> $IPERF3_OUTPUT

IPERF3_RESULTS=$(iperf3 -c $IPERF3_TARGET -p 5201)
echo "$IPERF3_RESULTS" >> $IPERF3_OUTPUT

# Run iperf3 test UDP
echo "*************************************************************************" >> $IPERF3_OUTPUT
echo "Running iperf3 UDP test at $current_datetime" >> $IPERF3_OUTPUT
echo "*************************************************************************" >> $IPERF3_OUTPUT
echo "" >> $IPERF3_OUTPUT

IPERF3_RESULTS=$(iperf3 -c $IPERF3_TARGET -u -b 50M -p 5201)
echo "$IPERF3_RESULTS" >> $IPERF3_OUTPUT

echo "Tests completed. Results saved to $IPERF3_OUTPUT."
