#!/bin/sh

# List of container names
CONTAINERS="nifty_bhaskara strange_keldysh"

for container in $CONTAINERS
do
    # Fetch the network mode or IP for the container
    network_mode=$(docker inspect -f '{{.HostConfig.NetworkMode}}' $container)
    container_ip=$(docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' $container)

    if [ "$network_mode" = "host" ]; then
        echo "Container $container is using host network mode. No specific interface."
    elif [ -n "$container_ip" ]; then
        echo "Container: $container, IP Address: $container_ip"
    else
        echo "No network interface or IP found for container: $container"
    fi
done
