# upz_mesh_routes

## Overview  
This container performs traceroute measurements using the `mtr` tool to other devices in the experiment.

## Setup  
1. Clone the repository and navigate to the container directory.  
2. Ensure the `IPs_data` file is available in the container directory.  

## Configuration  
To add a specific device or IP:  
1. Obtain the IP address and name of the device.  
2. Add the device details to the `IPs_data` file in the following format:  


**Example**:  
ispAPi,127.1.1.2


## Usage  
1. Start the container using your preferred Docker setup or deployment platform (e.g., Balena).  
2. The service is scheduled to run at **40 minutes past the hour** to maximize pod efficiency.  
3. You can configure the timing in the Docker scheduler as needed.  
4. The traceroute results will be logged or saved based on your container's configuration(/reports/mtr_result_$current_datetime.txt").
