#!/bin/bash

IPERF3_TARGET="temp_iperf3_server" # Specify the target sites for mtr and iperf3
current_datetime=$(date +"%Y-%m-%d_%I-%M%p") # Custom format: Year-Month-Day Hour
IPs_data="IPs_data" # Specify the input file for the IPs

# Specify the output files
MTR_OUTPUT="/results/mtr_result_$current_datetime.txt"
IPERF3_OUTPUT="/results/iperf3_result_$current_datetime.txt"

exec 3>>"$MTR_OUTPUT" # Open MTR_OUTPUT for writing and assign file descriptor 3 to it

# Run mtr test.
# Loop through each line in the input file to get the URL and the IP for the mtr
while IFS=, read -r url ip
do
    ip_country=$(geoiplookup $ip | awk -F: '{print $2}') #Conferming the ip's country location using geoiplookup.
    echo "Running mtr for IP:$ip site:$url country:$ip_country. date:$current_datetime">>$MTR_OUTPUT
    if MTR_RESULTS=$(mtr --report --report-cycles=10 $ip); then
        # If mtr succeeds, append the results to the output file
        echo "$MTR_RESULTS">&3
    else
        # If mtr fails, log the failure and skip to the next IP
        echo "mtr command failed for IP: $ip">&3
        continue
    fi
done < "$IPs_data"

exec 3>&- # Close file descriptor 3

# Run iperf3 test tcp 
echo "Running iperf3 tcp test to $IPERF3_TARGET date:$current_datetime">>$IPERF3_OUTPUT
IPERF3_RESULTS=$(iperf3 -c $IPERF3_TARGET)
echo "$IPERF3_RESULTS" >> $IPERF3_OUTPUT



# Run iperf3 test udp
echo "Running iperf3 udp test to $IPERF3_TARGET date:$current_datetime">>$IPERF3_OUTPUT
IPERF3_RESULTS=$(iperf3 -c $IPERF3_TARGET -u)
echo "$IPERF3_RESULTS" >> $IPERF3_OUTPUT
