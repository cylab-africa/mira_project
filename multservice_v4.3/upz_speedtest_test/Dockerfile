FROM ubuntu:latest

# Update the package list and install curl
RUN apt-get update && apt-get install -y curl

# Add the Ookla repository and install Speedtest CLI
RUN curl -s https://packagecloud.io/install/repositories/ookla/speedtest-cli/script.deb.sh -o install_speedtest.sh && \
    bash install_speedtest.sh && \
    apt-get install -y speedtest

# Cleanup to reduce image size
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

# Create directories for reports and scripts
RUN mkdir -p /reports && mkdir -p /scripts

# Copy the Speedtest test script into the container
COPY speedtest_test.sh /scripts/speedtest_test.sh
RUN chmod +x /scripts/speedtest_test.sh

# Set up cron job to run the script every 7 minutes
# RUN echo "*/7 * * * * /scripts/speedtest_test.sh >> /var/log/speedtest_test.log 2>&1" > /etc/crontabs/root

# Start cron and keep the container running
CMD ["sh", "-c", "cron -f"]
