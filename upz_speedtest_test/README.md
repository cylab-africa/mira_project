# upz_speed_test

## Overview  
This container performs performance tests using `ookla speedtest` and `iperf3`.  

## Setup  
1. Clone the repository and navigate to the container directory.  
2. Deploy the container to your target device using Docker or Balena.  

## Configuration  
Environmental variables can be modified in Balena Cloud:  
- **Ookla Speedtest**:  
  - `ENV ookla_speedtest=false` to enable Ookla Speedtest.  
  - `ENV ookla_server="none"` to specify an Ookla server (optional).  
- **iPerf3 Speedtest**:  
  - `ENV iperf3_speedtest=false` to enable iPerf3 Speedtest.  
  - `ENV iperf3_server="169.150.238.161"` to set the iPerf3 server.  

You can change the server IP or enable/disable specific speed tests by modifying these variables.  

## Usage  
1. The service is scheduled to run at **25 minutes past the hour** to maximize pod efficiency.  
2. You can modify the scheduling in the Docker configuration if necessary.  
3. After deployment, the container will run the configured performance tests.  
4. Logs and results will be stored in the specified output directory.
