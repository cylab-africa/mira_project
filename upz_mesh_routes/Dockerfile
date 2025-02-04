# Use Ubuntu as the base image
FROM ubuntu:20.04

# Set environment variable to avoid interactive prompts
ENV DEBIAN_FRONTEND=noninteractive

# Install mtr, cron, geoiplookup, and vnstat
RUN apt update && \
    apt install -y mtr cron geoip-bin vnstat && \
    apt clean && \
    rm -rf /var/lib/apt/lists/* && \
    mkdir -p /reports && \
    mkdir /scripts

# Start vnstatd service
RUN service vnstat start

# Copy the test script and IP address data into the container
COPY mtr_measurements.sh /scripts/mtr_measurements.sh
COPY IPs_data /scripts/IPs_data

# Copy the monitor network usage script into the container
COPY monitor_network_usage.sh /scripts/monitor_network_usage.sh
RUN chmod +x /scripts/monitor_network_usage.sh

# Make the script executable and set up the cron job
RUN chmod +x /scripts/mtr_measurements.sh && \
    echo "40 * * * * root  /scripts/mtr_measurements.sh" > /etc/cron.d/run_tests_cron && \
    chmod 0644 /etc/cron.d/run_tests_cron && \
    crontab /etc/cron.d/run_tests_cron && \
    touch /var/log/cron.log

# Set up cron job to run the network usage script daily at 23:55
RUN echo "55 23 * * * root /scripts/monitor_network_usage.sh >> /var/log/cron.log 2>&1" >> /etc/cron.d/run_tests_cron

# Run the cron job in the foreground
CMD ["cron", "-f"]
