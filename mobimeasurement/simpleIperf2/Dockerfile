# Use Alpine Linux as the base image
FROM alpine:latest

# Install iPerf3 and mtr
RUN apk add --no-cache iperf3 mtr

# Expose the default iPerf3 server port
EXPOSE 5201

# By default, run a shell. Users can override this to run iPerf3, mtr, or any other command.
CMD ["/bin/sh"]
