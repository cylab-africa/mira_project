# Dockerfile for iPerf3 Client
FROM alpine:latest

# Install necessary packages
# Install vnStat, cron, and other required utilities
RUN apk update && apk add vnstat


RUN  mkdir -p /reports && \
     mkdir -p /scripts


# Copy the iPerf3 test script into the container
COPY monitor_network_usage.sh /scripts/monitor_network_usage.sh
RUN chmod +x /scripts/monitor_network_usage.sh


# Set up cron job to run the script every 7 minutes
RUN echo "*/7 * * * * /scripts/monitor_network_usage.sh >> /var/log/iperf3_test.log 2>&1" > /etc/crontabs/root

# Start cron and keep the container running
CMD ["sh", "-c", "crond -f"]
