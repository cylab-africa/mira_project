FROM ubuntu:latest
# Install necessary packages

RUN apt update && \ 
    apt install -y  mtr cron geoip-bin usbutils modemmanager network-manager  dbus screen minicom nano   usb-modeswitch ppp kmod libusb-1.0-0-dev  && \
    apt clean && \
    rm -rf /var/lib/apt/lists/* && \
    mkdir -p /reports



# Set up non-root user
# Check if groups exist and add them if they don't
RUN groupadd -f dialout
RUN groupadd -f dialup

# Add the root user to necessary groups
RUN usermod -a -G dialout,dialup root

# Add custom entry script
COPY entry.sh /usr/bin/entry.sh
RUN chmod +x /usr/bin/entry.sh

CMD ["/usr/bin/entry.sh"]