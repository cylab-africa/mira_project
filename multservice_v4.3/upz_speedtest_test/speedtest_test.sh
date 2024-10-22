#!/bin/sh
# Run ookla speed test 
speedtest --format=json > "/reports/speedtest_result_$(date +%Y%m%d%H%M%S).json"