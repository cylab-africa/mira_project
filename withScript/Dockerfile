# Use Debian slim as the base image
FROM debian:bullseye-slim

# Install iPerf3 and mtr
RUN apt-get update && \
    apt-get install -y iperf3 mtr && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Copy the test script into the container
COPY mobile_test.sh /mobile_test.sh

# Make the script executable
RUN chmod +x /mobile_test.sh

# Set the script as the entry point
ENTRYPOINT ["/mobile_test.sh"]
