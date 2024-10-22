# Dockerfile for iPerf3 Client
FROM alpine:latest

# Install necessary packages
RUN apk add --no-cache iperf3 busybox-suid

RUN  mkdir -p /reports && \
     mkdir -p /scripts


# Copy the iPerf3 test script into the container
COPY iperf3_test.sh /scripts/iperf3_test.sh
RUN chmod +x /scripts/iperf3_test.sh


# Set up cron job to run the script every 7 minutes
RUN echo "20 * * * * /scripts/iperf3_test.sh >> /var/log/iperf3_test.log 2>&1" > /etc/crontabs/root

# Start cron and keep the container running
CMD ["sh", "-c", "crond -f"]
