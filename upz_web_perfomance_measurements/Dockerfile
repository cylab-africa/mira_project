# Use an official Node runtime as a parent image
FROM node:24-slim

# Set environment variable to avoid interactive prompts
ENV DEBIAN_FRONTEND=noninteractive

# Install Chromium and other necessary packages
RUN apt-get update && apt-get install -y \
    chromium \
    jq \
    cron \
    vnstat \  
    --no-install-recommends \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* 

# Set the CHROME_PATH environment variable to the path of the Chromium executable
ENV CHROME_PATH=/usr/bin/chromium

# Install Lighthouse globally
RUN npm install -g lighthouse

# Create a directory, add the Lighthouse audit script, and set permissions
RUN mkdir -p /reports && \
    mkdir -p /scripts

# Add scripts and websites
COPY web_perfomance_measuerement.sh /scripts/web_perfomance_measuerement.sh
COPY websites /scripts/websites
COPY monitor_network_usage.sh /scripts/monitor_network_usage.sh
COPY dns_lookup.js /scripts/dns_lookup.js

# Set executable permission for the scripts and create results explanation file
RUN chmod +x /scripts/web_perfomance_measuerement.sh /scripts/monitor_network_usage.sh /scripts/dns_lookup.js \
    && echo "csv results format\nkey ==> s: second, ms: millisecond\nwebsite,first-contentful-paint(s),largest-contentful-paint(s),speed=index(s),total-blocking-time(ms),time-to-interactive(s),datetime" >/reports/ReadMe.txt \
    # Set up cron jobs
    && (crontab -l ; echo "15 * * * * /scripts/web_perfomance_measuerement.sh >> /var/log/cron.log 2>&1") | crontab - \
    && (crontab -l ; echo "55 23 * * * /scripts/monitor_network_usage.sh >> /var/log/cron.log 2>&1") | crontab -\
    && (crontab -l ; echo "15 * * * * /usr/local/bin/node /scripts/dns_lookup.js >> /var/log/cron.log 2>&1") | crontab - 

# Create the cron log file and start vnstatd
RUN touch /var/log/cron.log \
    && service vnstat start

# Command to start cron service and vnstatd
CMD ["sh", "-c", "service vnstat start && cron -f"]