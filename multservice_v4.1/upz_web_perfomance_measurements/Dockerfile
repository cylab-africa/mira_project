# Use an official Node runtime as a parent image
FROM node:18-slim

# Install Chromium and other necessary packages
RUN apt-get update && apt-get install -y \
    chromium \
    jq \
    cron \
    --no-install-recommends \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* 

# Set the CHROME_PATH environment variable to the path of the Chromium executable
ENV CHROME_PATH /usr/bin/chromium

# Install Lighthouse globally
RUN npm install -g lighthouse

# Create a directory, add the Lighthouse audit script, and set permissions
RUN  mkdir -p /reports && \
     mkdir -p /scripts

ADD web_perfomance_measuerement.sh scripts/web_perfomance_measuerement.sh
RUN chmod +x /scripts/web_perfomance_measuerement.sh \
    # Creating results explanation file with comment.
    && echo "csv results format\nkey ==> s: second, ms: millisecond\nwebsite,first-contentful-paint(s),largest-contentful-paint(s),speed=index(s),total-blocking-time(ms),time-to-interactive(s),datetime" >/reports/ReadMe.txt \
    # Set up cron job
    && echo "15 * * * * /scripts/web_perfomance_measuerement.sh >> /var/log/cron.log 2>&1" | crontab -

# Start cron in the foreground
CMD ["cron", "-f"]
