# Dockerfile for iPerf3 Server
FROM alpine:latest

# Install iPerf3
RUN apk add --no-cache iperf3

# Expose the default iPerf3 port (5201)
EXPOSE 5201

# Start the iPerf3 server
CMD ["iperf3", "-s"]

