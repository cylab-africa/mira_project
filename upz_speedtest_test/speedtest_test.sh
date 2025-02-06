#!/bin/bash


# Check if Ookla Speedtest or iPerf3 Speedtest should run
if [ "$ookla_speedtest" = "true" ] || [ "$iperf3_speedtest" = "true" ]; then
    if [ "$ookla_speedtest" = "true" ]; then
        echo "Running Ookla Speedtest..."
        if [ "$ookla_server" = "none" ]; then
            # Run speedtest without the server argument
            speedtest --accept-license --accept-gdpr --format=json > "/reports/speedtest_result_$(date +"%Y-%m-%d_%I-%M%p").json"
        else
            # Run speedtest with the server argument SERVER ID
            speedtest -s $ookla_server --accept-license --accept-gdpr --format=json > "/reports/speedtest_result_$(date +"%Y-%m-%d_%I-%M%p").json"
        fi
    fi

    if [ "$iperf3_speedtest" = "true" ]; then
        echo "Running iPerf3 Speedtest..."
        current_datetime=$(date +"%Y-%m-%d_%I-%M%p") # Custom format: Year-Month-Day Hour
        IPERF3_OUTPUT="/reports/iperf3_result_$current_datetime.txt"

        # Run iperf3 test TCP
        echo "*************************************************************************" >> $IPERF3_OUTPUT
        echo "Running iperf3 TCP test at $current_datetime" >> $IPERF3_OUTPUT
        echo "*************************************************************************" >> $IPERF3_OUTPUT
        echo "" >> $IPERF3_OUTPUT

        IPERF3_RESULTS=$(iperf3 -c $iperf3_server -p 5201)
        echo "$IPERF3_RESULTS" >> $IPERF3_OUTPUT

        # Run iperf3 test UDP
        echo "*************************************************************************" >> $IPERF3_OUTPUT
        echo "Running iperf3 UDP test at $current_datetime" >> $IPERF3_OUTPUT
        echo "*************************************************************************" >> $IPERF3_OUTPUT
        echo "" >> $IPERF3_OUTPUT

        IPERF3_RESULTS=$(iperf3 -c $iperf3_server -u -b 50M -p 5201)
        echo "$IPERF3_RESULTS" >> $IPERF3_OUTPUT

        echo "Tests completed. Results saved to $IPERF3_OUTPUT."
    fi
else
    echo "Both Ookla speedtest and iperf3 set not to run. To enable modify the device variable ookla_speedtest and iperf3_speedtest to true"
fi
