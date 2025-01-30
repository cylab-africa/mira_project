# Dockerfile for Network Usage Monitor
FROM alpine:latest

# Install necessary packages
RUN apk update && apk add vnstat

# Create directories for reports and scripts
RUN mkdir -p /reports && \
    mkdir -p /scripts

# Copy the network usage monitoring script into the container
COPY monitor_network_usage.sh /scripts/monitor_network_usage.sh
RUN chmod +x /scripts/monitor_network_usage.sh

# Set up cron job to run the script every 10 minutes
RUN echo "*/10 * * * * /scripts/monitor_network_usage.sh >> /var/log/network_usage.log 2>&1" > /etc/crontabs/root

# Start cron and keep the container running
CMD ["sh", "-c", "crond -f"]
