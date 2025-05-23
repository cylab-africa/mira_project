# Use official Node.js base image
FROM node:24-slim

ENV DEBIAN_FRONTEND=noninteractive

# Install Chromium and required tools (wget for dash.js)
RUN apt-get update && apt-get install -y \
    chromium \
    wget \
    ca-certificates \
    cron \
    cron-daemon-common \
    vnstat \ 
    --no-install-recommends && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Set Puppeteer executable path
ENV CHROME_PATH=/usr/bin/chromium
ENV PUPPETEER_EXECUTABLE_PATH=/usr/bin/chromium

# Create working directories
WORKDIR /app
RUN mkdir -p /app/public/lib /app/scripts /app/reports

# Download dash.js into the image during build
RUN wget https://cdn.dashjs.org/latest/dash.all.min.js -O /app/public/lib/dash.all.min.js

# Copy project files
COPY public/index.html /app/public/
COPY puppeteer.js /app/scripts/
COPY monitor_network_usage.sh /app/scripts/monitor_network_usage.sh

# Initialize npm and install Puppeteer locally
RUN npm init -y && npm install puppeteer

RUN chmod +x /app/scripts/monitor_network_usage.sh /app/scripts/puppeteer.js \
    && touch /var/log/cron.log  \
    && (crontab -l 2>/dev/null; echo "35 * * * * /usr/local/bin/node /app/scripts/puppeteer.js >> /var/log/cron.log 2>&1") | crontab -\
    && (crontab -l ; echo "55 23 * * * /app/scripts/monitor_network_usage.sh >> /var/log/cron.log 2>&1") | crontab -

# Start cron in foreground via sh -c
CMD ["sh", "-c", "service vnstat start && cron -f"]

