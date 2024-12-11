FROM alpine:latest

# Set environment variable 
ENV COUNTRY="Rwanda" 
ENV ookla_speedtest=false
ENV iperf3_speedtest=false
ENV iperf3_server="169.150.238.161"
ENV ookla_server="none"

# Installing iperf3
RUN apk add --no-cache iperf3 busybox-suid 

# Install necessary packages (tar for extraction)
RUN apk add --no-cache tar



# Copy the Ookla Speedtest binary tar file from your local folder into the container
COPY ookla-speedtest-1.2.0-linux-aarch64.tgz /tmp/speedtest.tgz

# Extract the tar file and move the binary to /usr/local/bin
RUN tar -xzf /tmp/speedtest.tgz -C /tmp && \
    mv /tmp/speedtest /usr/local/bin/speedtest && \
    chmod +x /usr/local/bin/speedtest && \
    rm -rf /tmp/*

# Create directories for reports and scripts
RUN mkdir -p /reports && mkdir -p /scripts

# Copy the Speedtest test script into the container
COPY speedtest_test.sh /scripts/speedtest_test.sh
RUN chmod +x /scripts/speedtest_test.sh

# Set up cron job to run the script every 7 minutes
RUN echo "25 * * * * /scripts/speedtest_test.sh >> /var/log/speedtest_test.log 2>&1" > /etc/crontabs/root

# Start cron and keep the container running
CMD ["sh", "-c", "crond -f"]
