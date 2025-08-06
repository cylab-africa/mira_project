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

#Setting Working Directory
WORKDIR /upz_probe 


# Install Puppeteer and puppeteer-har
RUN npm install puppeteer puppeteer-har


# Create a directory, add the Lighthouse audit script, and set permissions
RUN mkdir -p /upz_probe/reports && \
    mkdir -p /upz_probe/scripts

# Add scripts and websites
COPY web_perfomance_measuerement.sh /upz_probe/scripts/web_perfomance_measuerement.sh
COPY websites /upz_probe/scripts/websites
COPY monitor_network_usage.sh /upz_probe/scripts/monitor_network_usage.sh
COPY dns_lookup.js /upz_probe/scripts/dns_lookup.js
COPY generate_har.js /upz_probe/scripts/

# Set executable permission for the scripts and create results explanation file
RUN chmod +x /upz_probe/scripts/web_perfomance_measuerement.sh /upz_probe/scripts/monitor_network_usage.sh /upz_probe/scripts/dns_lookup.js /upz_probe/scripts/generate_har.js \
    && echo "csv results format\nkey ==> s: second, ms: millisecond\nwebsite,first-contentful-paint(s),largest-contentful-paint(s),speed=index(s),total-blocking-time(ms),time-to-interactive(s),datetime" >/upz_probe/reports/ReadMe.txt \
    # Set up cron jobs
    && (crontab -l ; echo "15 * * * * /upz_probe/scripts/web_perfomance_measuerement.sh >> /var/log/cron.log 2>&1") | crontab -\
    && (crontab -l ; echo "55 23 * * * /upz_probe/scripts/monitor_network_usage.sh >> /var/log/cron.log 2>&1") | crontab -\
    && (crontab -l ; echo "15 * * * * /usr/local/bin/node /upz_probe/scripts/dns_lookup.js >> /var/log/cron.log 2>&1") | crontab -\
    && (crontab -l ; echo "15 * * * * /usr/local/bin/node /upz_probe/scripts/generate_har.js >> /var/log/cron.log 2>&1") | crontab -


# Create the cron log file and start vnstatd
RUN touch /var/log/cron.log \
    && service vnstat start

# Command to start cron service and vnstatd
CMD ["sh", "-c", "service vnstat start && cron -f"]