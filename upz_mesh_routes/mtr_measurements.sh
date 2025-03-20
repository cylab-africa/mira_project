#!/bin/bash

export PATH=/usr/local/bin:/usr/bin:$PATH

current_datetime=$(date +"%Y-%m-%d_%I-%M%p") # Custom format: Year-Month-Day Hour

# Specify the output file
MTR_OUTPUT="/reports/mtr_result_$current_datetime.txt"

# Check if IP_LIST is set and not empty
if [ -z "$IP_LIST" ]; then
    echo "IP addresses are not set. Please set the IP_LIST environment variable for the test to run. For more information, read the documentation." >> $MTR_OUTPUT
    exit 1
fi

# Read IP addresses from the environment variable
IFS=';' read -ra IP_ARRAY <<< "$IP_LIST"

# Run mtr test for each IP address
for entry in "${IP_ARRAY[@]}"; do
    IFS=',' read -ra ADDR <<< "$entry"
    device_name=${ADDR[0]}
    ip=${ADDR[1]}
    
    ip_country=$(geoiplookup $ip | awk -F: '{print $2}') # Confirming the IP's country location using geoiplookup.
    echo "Running mtr for device:$device_name IP:$ip country:$ip_country. date:$current_datetime" >> $MTR_OUTPUT
    if MTR_RESULTS=$(mtr --report --report-cycles=3 $ip); then
        # If mtr succeeds, append the results to the output file
        echo "$MTR_RESULTS" >> $MTR_OUTPUT
    else
        # If mtr fails, log the failure and skip to the next IP
        echo "mtr command failed for device:$device_name IP: $ip" >> $MTR_OUTPUT
        continue
    fi
done
