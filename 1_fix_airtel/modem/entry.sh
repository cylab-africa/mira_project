#!/bin/bash

# Start Dbus

modprobe qcserial
modprobe usb_wwan

# Keep the container running
tail -f /dev/null

service dbus start

# Start ModemManager directly
ModemManager --debug &

# Start NetworkManager directly
NetworkManager -n &

# Sleep for a few seconds to ensure services are up
sleep 5

# Now you can add commands to configure or use the modem
# Example: mmcli to check modem status


mmcli -L

# Keep the container running
tail -f /dev/null
