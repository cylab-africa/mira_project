# Use an official lightweight Python base image
FROM python:3.9-slim

# Install iPerf3
RUN apt-get update && \
    apt-get install -y iperf3 && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Expose the default iPerf3 server port
EXPOSE 5201

# Run iPerf3 in server mode
# CMD ["iperf3", "-s"]

# Run iPerf3 in client mode to connect to my local host

CMD ["iperf3", "-c", "host.docker.internal", "-p", "5201"]
