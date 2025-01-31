# Use Debian slim as the base image
FROM debian:bullseye-slim

# Install iPerf3, mtr, cron, and geoiplookup >>>removed iPerf3
RUN apt update && \ 
    apt install -y mtr cron geoip-bin && \
    apt clean && \
    rm -rf /var/lib/apt/lists/* && \
    mkdir -p /reports && \
    mkdir /scripts

# Copy the test script and IP address data into the container
COPY mtr_measurements.sh /scripts/mtr_measurements.sh
COPY IPs_data /scripts/IPs_data

# Make the script executable and set up the cron job
RUN chmod +x /scripts/mtr_measurements.sh && \
    echo "0 * * * * root  /scripts/mtr_measurements.sh" > /etc/cron.d/run_tests_cron && \
    chmod 0644 /etc/cron.d/run_tests_cron && \
    crontab /etc/cron.d/run_tests_cron && \
    touch /var/log/cron.log

# Run the cron job in the foreground
CMD ["cron", "-f"]
