# Use Debian slim as the base image
FROM debian:bullseye-slim

# Install iPerf3, mtr, cron, and geoiplookup
RUN apt-get update && \ 
    apt-get install -y iperf3 mtr cron geoip-bin && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*


RUN mkdir -p /results


# Copy the test script into the container
COPY iperf3_mtr_measurements.sh /iperf3_mtr_measurements.sh

# Copy IP address for the mtr measurement.
COPY IPs_data /IPs_data

# Make the script executable
RUN chmod +x /iperf3_mtr_measurements.sh

# Create a cron job to run the script 
RUN echo "*/4 * * * * root /iperf3_mtr_measurements.sh" > /etc/cron.d/run_tests_cron && \
    chmod 0644 /etc/cron.d/run_tests_cron && \
    crontab /etc/cron.d/run_tests_cron && \
    touch /var/log/cron.log


# Run the cron job in the foreground
CMD cron -f                                      
