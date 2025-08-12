# Use Ubuntu as the base image
FROM ubuntu:20.04

# Set environment variable to avoid interactive prompts
# Replace with actual IP addresses
ENV IP_LIST="" 
ENV DEBIAN_FRONTEND=noninteractive

# Install necessary packages
RUN apt update && apt install -y \
    mtr \
    cron \
    geoip-bin \
    geoip-database \
    vnstat \
    --no-install-recommends \
    && apt clean \
    && rm -rf /var/lib/apt/lists/* 

#Setting Working Directory
WORKDIR /upz_probe 

# Set up required directories
RUN mkdir -p /upz_probe/reports /upz_probe/scripts

# Copy test scripts and data
COPY mtr_measurements.sh /upz_probe/scripts/mtr_measurements.sh
COPY monitor_network_usage.sh /upz_probe/scripts/monitor_network_usage.sh

# Set executable permissions
RUN chmod +x /upz_probe/scripts/mtr_measurements.sh /upz_probe/scripts/monitor_network_usage.sh

# Export environment variables so cron jobs can access them
RUN printenv | grep -E 'IP_LIST' >> /etc/environment

# Set up cron jobs dynamically
RUN (crontab -l 2>/dev/null; echo "*40 * * * *  /bin/bash -c '. /etc/environment && /upz_probe/scripts/mtr_measurements.sh' >> /var/log/cron.log 2>&1" ) | crontab - \
    && (crontab -l 2>/dev/null; echo "55 23 * * * /upz_probe/scripts/monitor_network_usage.sh >> /var/log/cron.log 2>&1") | crontab -

# Create log file and start vnstatd
RUN touch /var/log/cron.log \
    && service vnstat start

# Command to start vnstat and cron in foreground
CMD ["sh", "-c", "printenv | grep -E '^IP_LIST=' >> /etc/environment && service vnstat start && cron -f"]
