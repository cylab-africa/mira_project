#!/bin/bash

export PATH=/usr/local/bin:/usr/bin:$PATH

IPERF3_TARGET="172.29.108.92" # Specify the target sites for mtr and iperf3
current_datetime=$(date +"%Y-%m-%d_%I-%M%p") # Custom format: Year-Month-Day Hour
IPs_data="/IPs_data" # Specify the input file for the IPs

# Specify the output files
MTR_OUTPUT="/reports/mtr_result_$current_datetime.txt"
IPERF3_OUTPUT="/reports/iperf3_result_$current_datetime.txt"

# Run mtr test.
# Loop through each line in the input file to get the URL and the IP for the mtr
while IFS=, read -r url ip || [[ -n "$url" ]]; do

    ip_country=$(geoiplookup $ip | awk -F: '{print $2}') #Conferming the ip's country location using geoiplookup.
    echo "Running mtr for IP:$ip site:$url country:$ip_country. date:$current_datetime">>$MTR_OUTPUT
    if MTR_RESULTS=$(mtr --report --report-cycles=3 $ip); then
        # If mtr succeeds, append the results to the output file
        echo "$MTR_RESULTS">>$MTR_OUTPUT
    else
        # If mtr fails, log the failure and skip to the next IP
        echo "mtr command failed for IP: $ip">>$MTR_OUTPUT
        continue
    fi

done < "$IPs_data"


 
#IPERF3

# Run iperf3 test tcp 
#upload speed: sending data to the sever
echo "Running iperf3 tcp test to $IPERF3_TARGET date:$current_datetime">>$IPERF3_OUTPUT
IPERF3_RESULTS=$(iperf3 -c $IPERF3_TARGET -t 30 -p 5206) 
echo "$IPERF3_RESULTS" >> $IPERF3_OUTPUT

#download speed: receiving data to the sever
IPERF3_RESULTS=$(iperf3 -c $IPERF3_TARGET -R -t 30 -p 5206) 
echo "$IPERF3_RESULTS" >> $IPERF3_OUTPUT


# Run iperf3 test udp
#upload speed: sending data to the sever
echo "Running iperf3 udp test to $IPERF3_TARGET date:$current_datetime">>$IPERF3_OUTPUT
IPERF3_RESULTS=$(iperf3 -c $IPERF3_TARGET -u -t 30 -b 50M -p 5206)
echo "$IPERF3_RESULTS" >> $IPERF3_OUTPUT


IPERF3_RESULTS=$(iperf3 -c $IPERF3_TARGET -u -R -t 30 -b 50M -p 5206)
echo "$IPERF3_RESULTS" >> $IPERF3_OUTPUT