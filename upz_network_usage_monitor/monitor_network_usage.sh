#!/bin/sh

# This environment variable can be passed at runtime or set in the Dockerfile
CONTAINERS=$(echo $MONITOR_CONTAINERS | tr "," "\n")

for container in $CONTAINERS
do
    # Get the network interface associated with the container
    interface=$(docker inspect -f '{{.NetworkSettings.Networks.bridge.Interface}}' $container)

    # Check if vnStat is tracking the interface
    if [ -z "$interface" ]; then
        echo "No interface found for $container"
        continue
    fi

    # Log network usage for the past hour
    echo "Network usage for container $container (interface: $interface):"
    vnstat --iface $interface --hour | tail -n 1 >> /var/log/network_usage.log
done
