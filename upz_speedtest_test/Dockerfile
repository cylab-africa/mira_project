# Use Ubuntu as the base image
FROM ubuntu:20.04

# Set environment variable 
ENV COUNTRY="" 
ENV ookla_speedtest="true"
ENV iperf3_speedtest="true"
ENV iperf3_server="169.150.238.161"
ENV ookla_server=7310
ENV DEBIAN_FRONTEND=noninteractive

# Install required packages
RUN apt update && apt install -y \
    iperf3 \
    cron \
    vnstat \
    tar \
    && apt clean \
    && rm -rf /var/lib/apt/lists/* 
# Update package list and install curl
RUN apt-get update && apt-get install -y curl

# Add Ookla Speedtest repository and install speedtest
RUN curl -s https://packagecloud.io/install/repositories/ookla/speedtest-cli/script.deb.sh | bash && \
    apt-get update && \
    apt-get install -y speedtest




# Create directories for reports and scripts
RUN mkdir -p /reports && mkdir -p /scripts

# Copy the Speedtest test script into the container
# Copy the monitor network usage script into the container
COPY speedtest_test.sh /scripts/speedtest_test.sh
COPY monitor_network_usage.sh /scripts/monitor_network_usage.sh

RUN chmod +x /scripts/speedtest_test.sh /scripts/monitor_network_usage.sh

# Export environment variables to a file so cron jobs can access them
RUN printenv | grep -E 'ookla_speedtest|iperf3_speedtest|iperf3_server|ookla_server' >> /etc/environment


# Set up cron jobs dynamically
RUN (crontab -l 2>/dev/null; echo "25 * * * * /bin/bash -c 'source /etc/environment && /scripts/speedtest_test.sh' >> /var/log/cron.log 2>&1") | crontab -\
    && (crontab -l 2>/dev/null; echo "55 23 * * * source /etc/environment && /scripts/monitor_network_usage.sh >> /var/log/cron.log 2>&1") | crontab -

# Create the cron log file and start vnstatd
RUN touch /var/log/cron.log \
    && service vnstat start

# Command to start vnstat and cron in foreground
CMD ["sh", "-c", "service vnstat start && cron -f"]

