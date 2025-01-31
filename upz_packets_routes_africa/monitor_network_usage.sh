#!/bin/bash

# Interface to monitor
INTERFACE="eth0"

# Log file location
LOG_FILE="/reports/network_usage.log"

# Check if vnStat is installed
if ! command -v vnstat &> /dev/null; then
    echo "vnStat is not installed. Please ensure it is installed in the container."
    exit 1
fi

# Initialize vnStat database for the interface if not already initialized
if ! vnstat --iflist | grep -q "$INTERFACE"; then
    vnstat  -i $INTERFACE
    vnstat -i $INTERFACE --create
fi

# Update vnStat database
vnstat -i $INTERFACE

# Record the current network usage
echo "$(date): Network usage for interface $INTERFACE" >> $LOG_FILE
vnstat -i $INTERFACE -d >> $LOG_FILE
echo "---------------------------------" >> $LOG_FILE