# Use Debian slim as the base image                                                                                                     
FROM debian:bullseye-slim                                                                                                               

# Install iPerf3, mtr, and cron
RUN apt-get update && \ 
    apt-get install -y iperf3 mtr cron && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Copy the test script into the container
COPY mobile_tests.sh /mobile_tests.sh

# Make the script executable
RUN chmod +x /mobile_tests.sh

# Create a cron job to run the script three times with a 2-minute gap
RUN echo "*/2 * * * * root /mobile_tests.sh" > /etc/cron.d/run_tests_cron && \
    chmod 0644 /etc/cron.d/run_tests_cron && \
    crontab /etc/cron.d/run_tests_cron && \
    touch /var/log/cron.log


# Run the cron job in the foreground
CMD cron -f                                      
