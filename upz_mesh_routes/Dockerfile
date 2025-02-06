# Use Ubuntu as the base image
FROM ubuntu:20.04

# Set environment variable to avoid interactive prompts
ENV DEBIAN_FRONTEND=noninteractive

# Install necessary packages
RUN apt update && apt install -y \
    mtr \
    cron \
    geoip-bin \
    vnstat \
    --no-install-recommends \
    && apt clean \
    && rm -rf /var/lib/apt/lists/* 

# Set up required directories
RUN mkdir -p /reports /scripts

# Copy test scripts and data
COPY mtr_measurements.sh /scripts/mtr_measurements.sh
COPY IPs_data /scripts/IPs_data
COPY monitor_network_usage.sh /scripts/monitor_network_usage.sh

# Set executable permissions
RUN chmod +x /scripts/mtr_measurements.sh /scripts/monitor_network_usage.sh

# Set up cron jobs dynamically
RUN (crontab -l 2>/dev/null; echo "40 * * * * /scripts/mtr_measurements.sh >> /var/log/cron.log 2>&1") | crontab - \
    && (crontab -l 2>/dev/null; echo "55 23 * * * /scripts/monitor_network_usage.sh >> /var/log/cron.log 2>&1") | crontab -

# Create log file and start vnstatd
RUN touch /var/log/cron.log \
    && service vnstat start

# Command to start vnstat and cron in foreground
CMD ["sh", "-c", "service vnstat start && cron -f"]
